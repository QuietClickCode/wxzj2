package com.yaltec.wxzj2.biz.compositeQuery.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.comon.core.entity.ReqPamars;
import com.yaltec.comon.log.LogUtil;
import com.yaltec.comon.log.entity.Log;
import com.yaltec.comon.utils.JsonUtil;
import com.yaltec.comon.utils.Urlencryption;
import com.yaltec.wxzj2.biz.compositeQuery.entity.QueryPaymentS;
import com.yaltec.wxzj2.biz.compositeQuery.service.QueryPaymentSService;
import com.yaltec.wxzj2.biz.compositeQuery.service.export.DataExport;
import com.yaltec.wxzj2.biz.compositeQuery.service.print.QueryPaymentSPrint;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 
 * @ClassName: QueryPaymentSAction
 * @Description: TODO汇缴清册查询实现类
 * 
 * @author moqian
 * @date 2016-8-25 上午09:12:03
 */

@Controller
public class QueryPaymentSAction {
	
	@Autowired
	private QueryPaymentSService queryPaymentSService;	
	
	/**
	 * 查询汇缴清册列表
	 */
	@RequestMapping("/queryPaymentS/index")
	public String index(Model model){
		model.addAttribute("communitys", DataHolder.communityMap);
		return "/compositeQuery/queryPaymentS/index";
	}
	
	/**
	 * 查询汇缴清册列表
	 * @param request 
	 */
	@RequestMapping("/queryPaymentS/list")
	public void list(@RequestBody ReqPamars<QueryPaymentS> req, HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		// 添加操作日志
		LogUtil.write(new Log("汇缴清册", "查询", "QueryPaymentSAction.list", req.toString()));
		//获取查询条件
		Map<String, Object> paramMap = req.getParams();
		paramMap.put("result", "-1");	
		Page<QueryPaymentS> page = new Page<QueryPaymentS>(req.getEntity(), req.getPageNo(), req.getPageSize());
		queryPaymentSService.queryQueryPaymentS(page, paramMap);
		//返回数据
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 返回结果
		pw.print(page.toJson());				
	}	
	
	/**
	 *汇缴清册的导出数据
	 */
	@RequestMapping("/queryPaymentS/exportQueryPaymentS")
	public void export(HttpServletRequest request, HttpServletResponse response) {
		try {
			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("begindate",request.getParameter("begindate"));
			paramMap.put("enddate",request.getParameter("enddate"));
			paramMap.put("lybh",request.getParameter("lybh"));
			paramMap.put("xqbh",request.getParameter("xqbh"));
			// 添加操作日志
			LogUtil.write(new Log("汇缴清册", "导出", "QueryPaymentSAction.export", paramMap.toString()));
			List<QueryPaymentS> resultList = queryPaymentSService.findQueryPaymentS(paramMap);
			
			DataExport.exportQueryPaymentS(resultList, response);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * 汇缴清册打印
	 */
	@RequestMapping("/queryPaymentS/pdfQueryPaymentS")
	public ModelAndView pdfQueryPaymentS(HttpServletRequest request, HttpServletResponse response) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("begindate", request.getParameter("begindate"));
		map.put("enddate", request.getParameter("enddate"));
		map.put("lybh", request.getParameter("lybh"));
		map.put("xqbh", request.getParameter("xqbh"));
		map.put("result", "");
		// 添加操作日志
		LogUtil.write(new Log("汇缴清册", "打印", "QueryPaymentSAction.pdfQueryPaymentS", map.toString()));
		List<QueryPaymentS> list = queryPaymentSService.findQueryPaymentS(map);
		String xqmc = Urlencryption.unescape(request.getParameter("xqmc"));
		// 传参容器
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("list", list);
		QueryPaymentSPrint view = new QueryPaymentSPrint();
		// 设置参数
		view.setAttributesMap(paramMap);
		// 返回视图
		return new ModelAndView(view);
	}
	
}

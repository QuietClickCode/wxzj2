package com.yaltec.wxzj2.biz.bill.action;

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

import com.yaltec.comon.auth.TokenHolder;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.comon.core.entity.ReqPamars;
import com.yaltec.comon.log.LogUtil;
import com.yaltec.comon.log.entity.Log;
import com.yaltec.comon.utils.JsonUtil;
import com.yaltec.comon.utils.Urlencryption;
import com.yaltec.wxzj2.biz.bill.entity.QueryBill;
import com.yaltec.wxzj2.biz.bill.entity.print.QueryBillPrintPdf;
import com.yaltec.wxzj2.biz.bill.service.QueryBillService;
import com.yaltec.wxzj2.biz.bill.service.export.DataExportBill;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 
 * @ClassName: QueryBillAction
 * @Description: TODO票据查询实现类
 * 
 * @author moqian
 * @date 2016-7-18 下午15:12:03
 */

@Controller
public class QueryBillAction {
	
	@Autowired
	private QueryBillService queryBillService;	
	
	/**
	 * 票据查询页面的查询列表
	 */
	@RequestMapping("/queryBill/index")
	public String index(Model model){
		model.addAttribute("banks", DataHolder.dataMap.get("bank"));
		model.addAttribute("user", TokenHolder.getUser());
		return "/bill/queryBill/index";
	}
	
	/**
	 * 票据查询页面的查询列表
	 */
	@RequestMapping("/queryBill/list")
	public void list(@RequestBody ReqPamars<QueryBill> req, HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		// 添加操作日志
		LogUtil.write(new Log("票据查询", "查询", "QueryBillAction.list", req.toString()));
		//获取查询条件
		Map<String, Object> paramMap = req.getParams();
		paramMap.put("result", "-1");	
		Page<QueryBill> page = new Page<QueryBill>(req.getEntity(), req.getPageNo(), req.getPageSize());
		queryBillService.findAll(page, paramMap);
		//返回数据
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 返回结果
		pw.print(page.toJson());
	}
	
	/**
	 * 导出票据信息
	 */
	@RequestMapping("/queryBill/exportQueryBill")
	public void exportQueryBill(HttpServletRequest request, HttpServletResponse response) {
		try {
			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("bank",request.getParameter("bank"));
			paramMap.put("type",request.getParameter("type"));
			paramMap.put("qsh",request.getParameter("qsh"));
			paramMap.put("zzh",request.getParameter("zzh"));
			paramMap.put("begindate",request.getParameter("begindate"));
			paramMap.put("enddate",request.getParameter("enddate"));
			paramMap.put("min_je",request.getParameter("min_je"));
			paramMap.put("max_je",request.getParameter("max_je"));
			paramMap.put("h001",request.getParameter("h001"));
			paramMap.put("regNo",request.getParameter("regNo"));
			paramMap.put("ifonly",request.getParameter("ifonly"));
			// 添加操作日志
			LogUtil.write(new Log("票据查询", "导出", "QueryBillAction.exportQueryBill", paramMap.toString()));
			List<QueryBill> resultList = queryBillService.findQueryBill(paramMap);
			
			DataExportBill.exportQueryBill(resultList, response);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * 查询票据页面的查询票据统计信息
	 */
	@RequestMapping("/queryBill/getQueryBillInfoSumBySearch")
	public void getQueryBillInfoSumBySearch(HttpServletRequest request,
			Model model,HttpServletResponse response)throws IOException {
		//获取参数
		Map<String, String> paramMap=new HashMap<String, String>();		
		paramMap.put("qsh",request.getParameter("qsh"));
		paramMap.put("zzh",request.getParameter("zzh"));
		paramMap.put("begindate",request.getParameter("begindate"));
		paramMap.put("enddate",request.getParameter("enddate"));
		paramMap.put("min_je",request.getParameter("min_je"));
		paramMap.put("max_je",request.getParameter("max_je"));
		paramMap.put("h001",request.getParameter("h001"));
		paramMap.put("bank",request.getParameter("bank"));
		paramMap.put("type",request.getParameter("type"));
		paramMap.put("ifonly",request.getParameter("ifonly"));
		paramMap.put("regNo",request.getParameter("regNo"));
		paramMap.put("result", "-1");	
		// 添加操作日志
		LogUtil.write(new Log("票据查询", "票据统计", "QueryBillAction.getQueryBillInfoSumBySearch", paramMap.toString()));
		QueryBill count= queryBillService.getQueryBillInfoSum(paramMap);
		//返回数据
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		pw.print(JsonUtil.toJson(count));
	}
	
	/**
	 * 打印证明
	 * @param request
	 * @param response
	 * @return 
	 * @throws IOException
	 */
	@RequestMapping("/queryBill/printBillPdf")
	public ModelAndView printBillPdf(HttpServletRequest request,HttpServletResponse response)throws IOException{
		Map<String, Object> paramMap = new HashMap<String, Object>();
		if(request.getParameter("bank")==""||request.getParameter("bank")==null) {
			paramMap.put("bank","");
		}else {
			paramMap.put("bank",request.getParameter("bank"));
		}
		paramMap.put("type",request.getParameter("type"));
		paramMap.put("qsh",request.getParameter("qsh"));
		paramMap.put("zzh",request.getParameter("zzh"));
		paramMap.put("begindate",request.getParameter("begindate"));
		paramMap.put("enddate",request.getParameter("enddate"));
		paramMap.put("min_je",request.getParameter("min_je"));
		paramMap.put("max_je",request.getParameter("max_je"));
		paramMap.put("h001",request.getParameter("h001"));
		paramMap.put("regNo",request.getParameter("regNo"));
		paramMap.put("ifonly",request.getParameter("ifonly"));
		paramMap.put("total",Urlencryption.unescape(request.getParameter("total")));
		// 添加操作日志
		LogUtil.write(new Log("票据查询", "打印", "ByBuildingForBAction.print", paramMap.toString()));
		List<QueryBill> resultList = queryBillService.findQueryBill(paramMap);
		paramMap.put("resultList", resultList);
		QueryBillPrintPdf view = new QueryBillPrintPdf();
		// 设置参数
		view.setAttributesMap(paramMap);
		// 返回视图
		return new ModelAndView(view);
	}
	
}

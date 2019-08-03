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
import com.yaltec.comon.utils.Urlencryption;
import com.yaltec.wxzj2.biz.compositeQuery.entity.ByCommunityForB;
import com.yaltec.wxzj2.biz.compositeQuery.entity.ByProjectForB;
import com.yaltec.wxzj2.biz.compositeQuery.service.ByProjectForBService;
import com.yaltec.wxzj2.biz.compositeQuery.service.export.DataExport;
import com.yaltec.wxzj2.biz.compositeQuery.service.print.ByProjectForBPrint;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 
 * @ClassName: ByProjectForBAction
 * @Description: TODO项目余额查询实现类
 * @author moqian
 * @date 2016-8-19 下午13:12:03
 */

@Controller
public class ByProjectForBAction {
	
	@Autowired
	private ByProjectForBService byProjectForBService;	
	
	/**
	 * 查询项目余额信息列表
	 */
	@RequestMapping("/byProjectForB/index")
	public String index(Model model){
		model.addAttribute("banks", DataHolder.dataMap.get("bank"));
		model.addAttribute("projects", DataHolder.dataMap.get("project"));
		return "/compositeQuery/byProjectForB/index";
	}
	
	/**
	 * 查询项目余额信息列表
	 */
	@RequestMapping("/byProjectForB/list")
	public void list(@RequestBody ReqPamars<ByCommunityForB> req, HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		// 添加操作日志
		LogUtil.write(new Log("项目余额信息", "查询", "ByProjectForBAction.list", req.toString()));
		//获取查询条件
		Map<String, Object> paramMap = req.getParams();
		paramMap.put("result", "-1");	
		Page<ByCommunityForB> page = new Page<ByCommunityForB>(req.getEntity(), req.getPageNo(), req.getPageSize());
		byProjectForBService.queryByProjectForB(page, paramMap);
		//返回数据
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 返回结果
		pw.print(page.toJson());				
	}
	
	/**
	 *打印项目余额查询的结果
	 * */
	@RequestMapping("/byProjectForB/pdfByProjectForB")
	public ModelAndView print(HttpServletRequest request, HttpServletResponse response) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("yhbh",request.getParameter("yhbh"));
		map.put("mc",Urlencryption.unescape(request.getParameter("mc")));
		map.put("enddate",request.getParameter("enddate"));
		map.put("pzsh",request.getParameter("pzsh"));
		map.put("xssy",request.getParameter("xssy"));
		// 添加操作日志
		LogUtil.write(new Log("项目余额信息", "打印", "ByProjectForBAction.print", map.toString()));
		List<ByProjectForB> list = byProjectForBService.findByProjectForB(map);
		// 传参容器
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("list", list);
		ByProjectForBPrint view = new ByProjectForBPrint();
		// 设置参数
		view.setAttributesMap(paramMap);
		// 返回视图
		return new ModelAndView(view);
	}
	
	/**
	 *项目余额的导出数据
	 */
	@RequestMapping("/byProjectForB/exportByProjectForB")
	public void export(HttpServletRequest request, HttpServletResponse response) {
		try {
			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("yhbh",request.getParameter("yhbh"));
			paramMap.put("mc",Urlencryption.unescape(request.getParameter("mc")));
			paramMap.put("enddate",request.getParameter("enddate"));
			paramMap.put("pzsh",request.getParameter("pzsh"));
			paramMap.put("xssy",request.getParameter("xssy"));
			// 添加操作日志
			LogUtil.write(new Log("项目余额信息", "导出", "ByProjectForBAction.export", paramMap.toString()));
			List<ByProjectForB> resultList = byProjectForBService.findByProjectForB(paramMap);
			
			DataExport.exportByProjectForB(resultList, response);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
}

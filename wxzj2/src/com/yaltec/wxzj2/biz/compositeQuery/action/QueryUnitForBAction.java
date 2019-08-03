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
import com.yaltec.wxzj2.biz.compositeQuery.entity.QueryUnitForB;
import com.yaltec.wxzj2.biz.compositeQuery.service.ByCommunityForBService;
import com.yaltec.wxzj2.biz.compositeQuery.service.QueryUnitForBService;
import com.yaltec.wxzj2.biz.compositeQuery.service.export.QueryUnitForBExport;
import com.yaltec.wxzj2.biz.compositeQuery.service.print.QueryUnitForBPrint;
import com.yaltec.wxzj2.biz.draw.entity.CodeName;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 
 * @ClassName: QueryUnitForBAction
 * @Description: TODO单元余额查询实现类
 * 
 * @author moqian
 * @date 2016-8-23 上午09:12:03
 */

@Controller
public class QueryUnitForBAction {
	
	@Autowired
	private QueryUnitForBService queryUnitForBService;	
	
	@Autowired
	private ByCommunityForBService byCommunityForBService;
	
	/**
	 * 查询单元余额信息列表
	 */
	@RequestMapping("/queryUnitForB/index")
	public String index(Model model){
		model.addAttribute("projects", DataHolder.dataMap.get("project"));
		model.addAttribute("communitys", DataHolder.communityMap);
		model.addAttribute("banks", DataHolder.dataMap.get("bank"));
		return "/compositeQuery/queryUnitForB/index";
	}
	
	/**
	 * 查询单元余额信息列表
	 * @param request 
	 */
	@RequestMapping("/queryUnitForB/list")
	public void list(@RequestBody ReqPamars<QueryUnitForB> req, HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		// 添加操作日志
		LogUtil.write(new Log("单元余额", "查询", "QueryUnitForBAction.list", req.toString()));
		//获取查询条件
		Map<String, Object> paramMap = req.getParams();
		paramMap.put("result", "-1");	
		Page<QueryUnitForB> page = new Page<QueryUnitForB>(req.getEntity(), req.getPageNo(), req.getPageSize());
		queryUnitForBService.queryQueryUnitForB(page, paramMap);
		//返回数据
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 返回结果
		pw.print(page.toJson());				
	}
	
	/**
	 * 根据银行编号查询项目信息
	 * @param request 
	 * @throws Exception 
	 */
	@RequestMapping("/queryUnitForB/getProject")
	public void getProject(String yhbh, HttpServletRequest request,Model model,
			HttpServletResponse response) throws Exception  {
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
//		Map<String, String> map = new HashMap<String, String>();
//		map.put("yhbh", yhbh);
//		map.put("mc", "");
		// 根据银行编号获取对应的小区信息
		//List<CodeName> list=byCommunityForBService.queryOpenCommunityByBank(map);
		List<CodeName> list = queryUnitForBService.queryProjectByBank(yhbh);
		// 返回结果
		pw.print(JsonUtil.toJson(list));					
	}
	
	/**
	 * 根据银行编号查询小区信息
	 * @param request 
	 * @throws Exception 
	 */
	@RequestMapping("/queryUnitForB/getCommunity")
	public void getCommunity(String yhbh, HttpServletRequest request,Model model,
			HttpServletResponse response) throws Exception  {
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
//		Map<String, String> map = new HashMap<String, String>();
//		map.put("yhbh", yhbh);
//		map.put("mc", "");
		// 根据银行编号获取对应的小区信息
		//List<CodeName> list=byCommunityForBService.queryOpenCommunityByBank(map);
		List<CodeName> list = queryUnitForBService.queryCommunityByBank(yhbh);
		// 返回结果
		pw.print(JsonUtil.toJson(list));					
	}
	
	/**
	 *单元余额的导出数据
	 */
	@RequestMapping("/queryUnitForB/exportQueryUnitForB")
	public void export(HttpServletRequest request, HttpServletResponse response) {
		try {
			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("xmbm",request.getParameter("xmbm"));
			paramMap.put("yhbh",request.getParameter("yhbh"));
			paramMap.put("xqbh",request.getParameter("xqbh"));
			paramMap.put("enddate",request.getParameter("enddate"));
			paramMap.put("lybh",request.getParameter("lybh"));
			paramMap.put("pzsh",request.getParameter("pzsh"));
			paramMap.put("xssy",request.getParameter("xssy"));
			// 添加操作日志
			LogUtil.write(new Log("单元余额", "导出", "QueryUnitForBAction.export", paramMap.toString()));
			List<QueryUnitForB> resultList = queryUnitForBService.findQueryUnitForB(paramMap);
			
			QueryUnitForBExport.exportQueryUnitForB(resultList, response);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * 打印单元余额查询的结果
	 */
	@RequestMapping("/queryUnitForB/printQueryUnitForB")
	public ModelAndView print(HttpServletRequest request, HttpServletResponse response) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("xmbm",request.getParameter("xmbm"));
		map.put("yhbh",request.getParameter("yhbh"));
		map.put("xqbh",request.getParameter("xqbh"));
		map.put("enddate",request.getParameter("enddate"));
		map.put("lybh",request.getParameter("lybh"));
		map.put("pzsh",request.getParameter("pzsh"));
		map.put("xssy",request.getParameter("xssy"));
		// 添加操作日志
		LogUtil.write(new Log("单元余额", "打印", "QueryUnitForBAction.print", map.toString()));
		List<QueryUnitForB> list = queryUnitForBService.findQueryUnitForB(map);
		// 传参容器
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("list", list);
		QueryUnitForBPrint view = new QueryUnitForBPrint();
		// 设置参数
		view.setAttributesMap(paramMap);
		// 返回视图
		return new ModelAndView(view);
	}
	
}

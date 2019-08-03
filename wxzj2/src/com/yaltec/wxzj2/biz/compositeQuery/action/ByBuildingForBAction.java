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
import com.yaltec.wxzj2.biz.compositeQuery.entity.ByCommunityForB;
import com.yaltec.wxzj2.biz.compositeQuery.service.ByBuildingForBService;
import com.yaltec.wxzj2.biz.compositeQuery.service.ByCommunityForBService;
import com.yaltec.wxzj2.biz.compositeQuery.service.export.DataExport;
import com.yaltec.wxzj2.biz.compositeQuery.service.print.ByBuildingForBPrint;
import com.yaltec.wxzj2.biz.draw.entity.CodeName;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 
 * @ClassName: ByBuildingForBAction
 * @Description: TODO楼宇余额查询实现类
 * 
 * @author moqian
 * @date 2016-8-9 下午16:12:03
 */

@Controller
public class ByBuildingForBAction {
	
	@Autowired
	private ByBuildingForBService byBuildingForBService;	
	
	@Autowired
	private ByCommunityForBService byCommunityForBService;
	
	/**
	 * 查询楼宇余额信息列表
	 */
	@RequestMapping("/byBuildingForB/index")
	public String index(Model model){
		model.addAttribute("projects", DataHolder.dataMap.get("project"));
		model.addAttribute("communitys", DataHolder.communityMap);
		model.addAttribute("banks", DataHolder.dataMap.get("bank"));
		return "/compositeQuery/byBuildingForB/index";
	}
	
	/**
	 * 查询楼宇余额信息列表
	 * @param request 
	 */
	@RequestMapping("/byBuildingForB/list")
	public void list(@RequestBody ReqPamars<ByCommunityForB> req, HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		// 添加操作日志
		LogUtil.write(new Log("楼宇余额", "查询", "ByBuildingForBAction.list", req.toString()));
		//获取查询条件
		Map<String, Object> paramMap = req.getParams();
		paramMap.put("result", "-1");	
		Page<ByCommunityForB> page = new Page<ByCommunityForB>(req.getEntity(), req.getPageNo(), req.getPageSize());
		byBuildingForBService.queryByBuildingForB(page, paramMap);
		//返回数据
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 返回结果
		pw.print(page.toJson());				
	}
	
	/**
	 * 根据银行编号查询小区信息
	 * @param request 
	 * @throws Exception 
	 */
	@RequestMapping("/byBuildingForB/getCommunity")
	public void getCommunity(String yhbh, HttpServletRequest request,Model model,
			HttpServletResponse response) throws Exception  {
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		Map<String, String> map = new HashMap<String, String>();
		map.put("yhbh", yhbh);
		map.put("mc", "");
		// 根据银行编号获取对应的小区信息
		List<CodeName> list=byCommunityForBService.queryOpenCommunityByBank(map);
		// 返回结果
		pw.print(JsonUtil.toJson(list));				
	}
	
	/**
	 *楼宇余额的导出数据
	 */
	@RequestMapping("/byBuildingForB/exportByBuildingForB")
	public void export(HttpServletRequest request, HttpServletResponse response) {
		try {
			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("yhbh",request.getParameter("yhbh"));
			paramMap.put("xmbm",request.getParameter("xmbm"));
			paramMap.put("xqbh",request.getParameter("xqbh"));
			paramMap.put("lybh",request.getParameter("lybh"));
			paramMap.put("enddate",request.getParameter("enddate"));
			paramMap.put("pzsh",request.getParameter("pzsh"));
			paramMap.put("xssy",request.getParameter("xssy"));
			// 添加操作日志
			LogUtil.write(new Log("楼宇余额", "导出", "ByBuildingForBAction.export", paramMap.toString()));
			List<ByCommunityForB> resultList = byBuildingForBService.findByBuildingForB(paramMap);
			
			DataExport.exportBuildingForB(resultList, response);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * 打印楼宇余额查询的结果
	 */
	@RequestMapping("/byBuildingForB/pdfByBuildingForB")
	public ModelAndView print(HttpServletRequest request, HttpServletResponse response) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("yhbh",request.getParameter("yhbh"));
		map.put("xmbm",request.getParameter("xmbm"));
		map.put("xqbh",request.getParameter("xqbh"));
		map.put("lybh",request.getParameter("lybh"));
		map.put("enddate",request.getParameter("enddate"));
		map.put("pzsh",request.getParameter("pzsh"));
		map.put("xssy",request.getParameter("xssy"));
		// 添加操作日志
		LogUtil.write(new Log("楼宇余额", "打印", "ByBuildingForBAction.print", map.toString()));
		List<ByCommunityForB> list = byBuildingForBService.findByBuildingForB(map);
		// 传参容器
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("list", list);
		ByBuildingForBPrint view = new ByBuildingForBPrint();
		// 设置参数
		view.setAttributesMap(paramMap);
		// 返回视图
		return new ModelAndView(view);
	}
	
}

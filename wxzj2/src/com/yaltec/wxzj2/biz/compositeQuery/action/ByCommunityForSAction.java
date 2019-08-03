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
import com.yaltec.comon.core.entity.Page;
import com.yaltec.comon.core.entity.ReqPamars;
import com.yaltec.comon.log.LogUtil;
import com.yaltec.comon.log.entity.Log;
import com.yaltec.comon.utils.JsonUtil;
import com.yaltec.wxzj2.biz.compositeQuery.entity.ByBuildingForC1;
import com.yaltec.wxzj2.biz.compositeQuery.service.ByCommunityForBService;
import com.yaltec.wxzj2.biz.compositeQuery.service.ByCommunityForSService;
import com.yaltec.wxzj2.biz.compositeQuery.service.export.DataExport;
import com.yaltec.wxzj2.biz.draw.entity.CodeName;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 
 * @ClassName: ByCommunityForSAction
 * @Description: TODO小区台账查询实现类
 * 
 * @author moqian
 * @date 2016-8-4 下午14:12:03
 */

@Controller
public class ByCommunityForSAction {
	
	@Autowired
	private ByCommunityForSService byCommunityForSService;
	
	@Autowired
	private ByCommunityForBService byCommunityForBService;	
	
	/**
	 * 查询小区台账信息列表
	 */
	@RequestMapping("/byCommunityForS/index")
	public String index(Model model){
		model.addAttribute("communitys", DataHolder.communityMap);
		model.addAttribute("banks", DataHolder.dataMap.get("bank"));
		model.addAttribute("projects", DataHolder.dataMap.get("project"));
		return "/compositeQuery/byCommunityForS/index";
	}
	
	/**
	 * 查询小区台账信息列表
	 * @param request 
	 */
	@RequestMapping("/byCommunityForS/list")
	public void list(@RequestBody ReqPamars<ByBuildingForC1> req, HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		// 添加操作日志
		LogUtil.write(new Log("小区台账", "查询", "ByCommunityForSAction.list", req.toString()));
		//获取查询条件
		Map<String, Object> paramMap = req.getParams();
		paramMap.put("result", "-1");	
		Page<ByBuildingForC1> page = new Page<ByBuildingForC1>(req.getEntity(), req.getPageNo(), req.getPageSize());
		byCommunityForSService.queryByCommunityForS_BS(page, paramMap);
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
	@RequestMapping("/byCommunityForS/getCommunity")
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
	 *小区台账的导出数据
	 */
	@RequestMapping("/byCommunityForS/exportByCommunityForS")
	public void export(HttpServletRequest request, HttpServletResponse response) {
		try {
			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("xqbh",request.getParameter("xqbh"));
			paramMap.put("begindate",request.getParameter("begindate"));
			paramMap.put("enddate",request.getParameter("enddate"));
			paramMap.put("pzsh",request.getParameter("pzsh"));
			paramMap.put("cxlb",request.getParameter("cxlb"));
			paramMap.put("yhbh",request.getParameter("yhbh"));
			paramMap.put("xssy",request.getParameter("xssy"));
			// 添加操作日志
			LogUtil.write(new Log("小区台账", "导出", "ByCommunityForSAction.export", paramMap.toString()));
			List<ByBuildingForC1> resultList = byCommunityForSService.findByCommunityForS(paramMap);
			
			DataExport.exportByCommunityForS(resultList, response);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
}

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
import com.yaltec.comon.utils.Urlencryption;
import com.yaltec.wxzj2.biz.compositeQuery.entity.BuildingInterestF;
import com.yaltec.wxzj2.biz.compositeQuery.service.ByCommunityForBService;
import com.yaltec.wxzj2.biz.compositeQuery.service.CommunityInterestFService;
import com.yaltec.wxzj2.biz.compositeQuery.service.ProjectInterestFService;
import com.yaltec.wxzj2.biz.compositeQuery.service.export.DataExport;
import com.yaltec.wxzj2.biz.draw.entity.CodeName;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 
 * @ClassName: CommunityInterestFAction
 * @Description: TODO小区利息查询实现类
 * 
 * @author moqian
 * @date 2016-8-23 下午14:12:03
 */

@Controller
public class CommunityInterestFAction {
	
	@Autowired
	private CommunityInterestFService communityInterestFService;
	
	@Autowired
	private ByCommunityForBService byCommunityForBService;	
	
	@Autowired
	private ProjectInterestFService projectInterestFService;
	
	/**
	 * 查询小区利息单信息列表
	 */
	@RequestMapping("/communityInterestF/index")
	public String index(Model model){
		model.addAttribute("communitys", DataHolder.communityMap);
		model.addAttribute("banks", DataHolder.dataMap.get("bank"));
		model.addAttribute("projects", DataHolder.dataMap.get("project"));
		//获取所有年度
		List<String> list = projectInterestFService.getReviewNd();
		model.addAttribute("nds", list);
		return "/compositeQuery/communityInterestF/index";
	}
	
	/**
	 * 查询小区利息单信息列表
	 * @param request 
	 */
	@RequestMapping("/communityInterestF/list")
	public void list(@RequestBody ReqPamars<BuildingInterestF> req, HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		// 添加操作日志
		LogUtil.write(new Log("小区利息单", "查询", "CommunityInterestFAction.list", req.toString()));
		//获取查询条件
		Map<String, Object> paramMap = req.getParams();
		paramMap.put("result", "-1");	
		Page<BuildingInterestF> page = new Page<BuildingInterestF>(req.getEntity(), req.getPageNo(), req.getPageSize());
		communityInterestFService.queryCommunityInterestF(page, paramMap);
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
	@RequestMapping("/communityInterestF/getCommunity")
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
	 *小区利息单的导出数据
	 */
	@RequestMapping("/communityInterestF/exportCommunityInterestF")
	public void export(HttpServletRequest request, HttpServletResponse response) {
		try {
			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("bm",request.getParameter("bm"));
			paramMap.put("yhbh",request.getParameter("yhbh"));
			paramMap.put("lsnd",Urlencryption.unescape(request.getParameter("lsnd")));
			// 添加操作日志
			LogUtil.write(new Log("小区利息单", "导出", "CommunityInterestFAction.export", paramMap.toString()));
			List<BuildingInterestF> resultList = communityInterestFService.findCommunityInterestF(paramMap);
			
			DataExport.exportCommunityInterestF(resultList, response);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
}

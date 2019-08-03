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
import com.yaltec.wxzj2.biz.compositeQuery.entity.ByBuildingForC1;
import com.yaltec.wxzj2.biz.compositeQuery.service.ByBuildingForSService;
import com.yaltec.wxzj2.biz.compositeQuery.service.export.DataExport;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 
 * @ClassName: ByBuildingForSAction
 * @Description: TODO楼宇台账查询实现类
 * 
 * @author moqian
 * @date 2016-8-4 上午09:12:03
 */

@Controller
public class ByBuildingForSAction {
	
	@Autowired
	private ByBuildingForSService byBuildingForSService;	
	
	/**
	 * 查询楼宇台账信息列表
	 */
	@RequestMapping("/byBuildingForS/index")
	public String index(Model model){
		model.addAttribute("communitys", DataHolder.communityMap);
		model.addAttribute("projects", DataHolder.dataMap.get("project"));
		return "/compositeQuery/byBuildingForS/index";
	}
	
	/**
	 * 弹出选择打印金额页面
	 * 
	 * @param house
	 */
	@RequestMapping("/byBuildingForS/open/choosePrint")
	public String choosePrint(Model model) {
		return "/compositeQuery/byBuildingForS/choosePrint";
	}
	
	/**
	 * 查询楼宇台账信息列表
	 * @param request 
	 */
	@RequestMapping("/byBuildingForS/list")
	public void list(@RequestBody ReqPamars<ByBuildingForC1> req, HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		// 添加操作日志
		LogUtil.write(new Log("楼宇台账", "查询", "ByBuildingForSAction.list", req.toString()));
		//获取查询条件
		Map<String, Object> paramMap = req.getParams();
		paramMap.put("result", "-1");	
		Page<ByBuildingForC1> page = new Page<ByBuildingForC1>(req.getEntity(), req.getPageNo(), req.getPageSize());
		byBuildingForSService.queryByBuildingForS(page, paramMap);
		//返回数据
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 返回结果
		pw.print(page.toJson());				
	}
	
	/**
	 *楼宇台账的导出数据
	 */
	@RequestMapping("/byBuildingForS/exportByBuildingForS")
	public void export(HttpServletRequest request, HttpServletResponse response) {
		try {
			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("lybh",request.getParameter("lybh"));
			paramMap.put("begindate",request.getParameter("begindate"));
			paramMap.put("enddate",request.getParameter("enddate"));
			paramMap.put("pzsh",request.getParameter("pzsh"));
			paramMap.put("cxlb",request.getParameter("cxlb"));
			paramMap.put("xssy",request.getParameter("xssy"));
			String lymc=Urlencryption.unescape(request.getParameter("lymc"));
			String items = request.getParameter("items");
			// 添加操作日志
			LogUtil.write(new Log("楼宇台账", "导出", "ByBuildingForSAction.export", paramMap.toString()));
			List<ByBuildingForC1> resultList = byBuildingForSService.findByBuildingForS(paramMap);
			
			DataExport.exportByBuildingForS(lymc, resultList, response, items);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}

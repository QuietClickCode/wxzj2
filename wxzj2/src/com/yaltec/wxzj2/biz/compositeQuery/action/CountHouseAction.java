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
import com.yaltec.wxzj2.biz.compositeQuery.entity.CountHouse;
import com.yaltec.wxzj2.biz.compositeQuery.service.CountHouseService;
import com.yaltec.wxzj2.biz.compositeQuery.service.export.DataExport;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 
 * @ClassName: CountHouseAction
 * @Description: TODO户数统计查询实现类
 * 
 * @author moqian
 * @date 2016-8-25 上午09:12:03
 */

@Controller
public class CountHouseAction {
	
	@Autowired
	private CountHouseService countHouseService;	
	
	/**
	 * 查询户数统计信息列表
	 */
	@RequestMapping("/countHouse/index")
	public String index(Model model){
		model.addAttribute("communitys", DataHolder.communityMap);
		model.addAttribute("projects", DataHolder.dataMap.get("project"));
		return "/compositeQuery/countHouse/index";
	}
	
	/**
	 * 查询户数统计信息列表
	 * @param request 
	 */
	@RequestMapping("/countHouse/list")
	public void list(@RequestBody ReqPamars<CountHouse> req, HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		// 添加操作日志
		LogUtil.write(new Log("户数统计", "查询", "CountHouseAction.list", req.toString()));
		//获取查询条件
		Map<String, Object> paramMap = req.getParams();
		paramMap.put("result", "-1");	
		Page<CountHouse> page = new Page<CountHouse>(req.getEntity(), req.getPageNo(), req.getPageSize());
		countHouseService.queryCountHouse(page, paramMap);
		//返回数据
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 返回结果
		pw.print(page.toJson());				
	}	
	
	/**
	 *户数统计的导出数据
	 */
	@RequestMapping("/countHouse/exportCountHouse")
	public void export(HttpServletRequest request, HttpServletResponse response) {
		try {
			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("begindate",request.getParameter("begindate"));
			paramMap.put("enddate",request.getParameter("enddate"));
			paramMap.put("xqbh",request.getParameter("xqbh"));
			paramMap.put("xmbm",request.getParameter("xmbm"));
			paramMap.put("flag",request.getParameter("flag"));
			// 添加操作日志
			LogUtil.write(new Log("户数统计", "导出", "CountHouseAction.export", paramMap.toString()));
			List<CountHouse> resultList = countHouseService.findCountHouse(paramMap);
			
			DataExport.exportCountHouse(resultList, response);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}

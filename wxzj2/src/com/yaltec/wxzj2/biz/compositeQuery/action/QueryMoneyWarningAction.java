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
import com.yaltec.wxzj2.biz.compositeQuery.service.QueryMoneyWarningService;
import com.yaltec.wxzj2.biz.compositeQuery.service.export.DataExport;
import com.yaltec.wxzj2.biz.property.entity.House;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 
 * @ClassName: QueryMoneyWarningAction
 * @Description: TODO资金预警查询实现类
 * 
 * @author moqian
 * @date 2016-8-29 上午09:12:03
 */

@Controller
public class QueryMoneyWarningAction {
	
	@Autowired
	private QueryMoneyWarningService queryMoneyWarningService;	
	
	/**
	 * 查询资金预警信息列表
	 */
	@RequestMapping("/queryMoneyWarning/index")
	public String index(Model model){
		model.addAttribute("communitys", DataHolder.communityMap);
		return "/compositeQuery/queryMoneyWarning/index";
	}
	
	/**
	 * 查询资金预警信息列表
	 * @param request 
	 */
	@RequestMapping("/queryMoneyWarning/list")
	public void list(@RequestBody ReqPamars<House> req, HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		// 添加操作日志
		LogUtil.write(new Log("资金预警", "查询", "QueryMoneyWarningAction.list", req.toString()));
		//获取查询条件
		Map<String, Object> paramMap = req.getParams();
		paramMap.put("result", "-1");	
		Page<House> page = new Page<House>(req.getEntity(), req.getPageNo(), req.getPageSize());
		queryMoneyWarningService.QueryMoneyWarning(page, paramMap);
		//返回数据
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 返回结果
		pw.print(page.toJson());				
	}	
	
	/**
	 * 导出资金预警信息
	 */
	@RequestMapping("/queryMoneyWarning/toExport")
	public void Export(HttpServletRequest request, HttpServletResponse response) {
		// 获取页面传入的参数，并以逗号(,)分割，存入数组中
		String paras = request.getParameter("str");
		String[] strs = paras.split(",");
		try {
			Map<String, String> map = new HashMap<String, String>();
			map.put("xqbh", strs[0]);
			map.put("lybh", strs[1]);
			map.put("bltype", strs[3]);
			map.put("bl", strs[4]);
			map.put("enddate", strs[2]);
			// 添加操作日志
			LogUtil.write(new Log("资金预警", "导出", "QueryMoneyWarningAction.Export", map.toString()));
			List<House> resultList = queryMoneyWarningService.findMoneyWarning(map);
			
			DataExport.exportMoneyWarning(resultList, response);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}

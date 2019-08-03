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
import com.yaltec.wxzj2.biz.compositeQuery.entity.MonthReportOfBank;
import com.yaltec.wxzj2.biz.compositeQuery.service.CalBYAreaService;
import com.yaltec.wxzj2.biz.compositeQuery.service.export.CalBYAreaExport;
import com.yaltec.wxzj2.biz.compositeQuery.service.print.CalBYAreaPrint;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 
 * @ClassName: CalBYAreaAction
 * @Description: TODO面积户数统计查询实现类
 * 
 * @author moqian
 * @date 2016-8-25 上午10:12:03
 */

@Controller
public class CalBYAreaAction {

	@Autowired
	private CalBYAreaService calBYAreaService;

	/**
	 * 查询面积户数统计信息列表
	 */
	@RequestMapping("/calBYArea/index")
	public String index(Model model) {
		model.addAttribute("projects", DataHolder.dataMap.get("project"));
		model.addAttribute("communitys", DataHolder.communityMap);
		return "/compositeQuery/calBYArea/index";
	}

	/**
	 * 查询面积户数统计信息列表
	 * 
	 * @param request
	 */
	@RequestMapping("/calBYArea/list")
	public void list(@RequestBody ReqPamars<MonthReportOfBank> req, HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		// 添加操作日志
		LogUtil.write(new Log("面积户数统计信息", "查询", "CalBYAreaAction.list", req.toString()));
		// 获取查询条件
		Map<String, Object> paramMap = req.getParams();
		paramMap.put("result", "-1");
		List<MonthReportOfBank> list = calBYAreaService.queryCalBYArea(paramMap);
		// 返回数据
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 返回结果
		pw.print(JsonUtil.toJson(list));
	}
	
	/**
	 * 导出面积户数统计信息
	 */
	@RequestMapping("/calBYArea/toExport")
	public void export(HttpServletRequest request, HttpServletResponse response) {
		// 获取页面传入的参数，并以逗号(,)分割，存入数组中
		String paras = request.getParameter("str");
		String[] strs = paras.split(",");
		try {
			Map<String, String> map = new HashMap<String, String>();
			map.put("xqbh", strs[0]);
			map.put("begindate", strs[1]);
			map.put("enddate", strs[2]);
			map.put("xssy", strs[3]);
			map.put("cxlb", strs[4]);
			map.put("pzsh", strs[5]);
			
			List<MonthReportOfBank> resultList = calBYAreaService.findCalBYArea(map);
			// 添加操作日志
			LogUtil.write(new Log("面积户数统计信息", "导出", "CalBYAreaAction.export", map.toString()));
			CalBYAreaExport.exportCalBYArea(resultList, response);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * 打印面积户数统计信息
	 */
	@RequestMapping("/calBYArea/toPrint")
	public ModelAndView listPrint(HttpServletRequest request, HttpServletResponse response) {
		// 获取页面传入的参数，并以逗号(,)分割，存入数组中
		String paras = request.getParameter("str");
		String[] strs = paras.split(",");
		Map<String, String> map = new HashMap<String, String>();
		map.put("xqbh", strs[0]);
		map.put("begindate", strs[1]);
		map.put("enddate", strs[2]);
		map.put("xssy", strs[3]);
		map.put("cxlb", strs[4]);
		map.put("pzsh", strs[5]);
		// 添加操作日志
		LogUtil.write(new Log("面积户数统计信息", "打印", "CalBYAreaAction.listPrint", map.toString()));
		List<MonthReportOfBank> list = calBYAreaService.findCalBYArea(map);
		
		// 传参容器
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("list", list);
		CalBYAreaPrint view = new CalBYAreaPrint();
		// 设置参数
		view.setAttributesMap(paramMap);
		// 返回视图
		return new ModelAndView(view);
	}
}

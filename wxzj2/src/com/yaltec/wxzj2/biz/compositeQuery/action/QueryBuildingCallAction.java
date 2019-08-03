package com.yaltec.wxzj2.biz.compositeQuery.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
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
import com.yaltec.wxzj2.biz.compositeQuery.entity.BuildingCall;
import com.yaltec.wxzj2.biz.compositeQuery.service.QueryBuildingCallService;
import com.yaltec.wxzj2.biz.compositeQuery.service.export.DataExport;
import com.yaltec.wxzj2.biz.compositeQuery.service.print.QueryBuildingCallPrint;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 
 * @ClassName: QueryBuildingCallAction
 * @Description: TODO楼宇催交查询实现类
 * 
 * @author moqian
 * @date 2016-8-26 下午14:12:03
 */

@Controller
public class QueryBuildingCallAction {

	@Autowired
	private QueryBuildingCallService queryBuildingCallService;

	/**
	 * 查询楼宇催交信息列表
	 */
	@RequestMapping("/queryBuildingCall/index")
	public String index(Model model) {
		model.addAttribute("communitys", DataHolder.communityMap);
		return "/compositeQuery/queryBuildingCall/index";
	}

	/**
	 * 查询楼宇催交信息列表
	 * 
	 * @param request
	 */
	@RequestMapping("/queryBuildingCall/list")
	public void list(@RequestBody ReqPamars<BuildingCall> req,
			HttpServletRequest request, HttpServletResponse response)
			throws IOException {
		// 添加操作日志
		LogUtil.write(new Log("楼宇催交", "查询", "QueryBuildingCallAction.list", req.toString()));
		// 获取查询条件
		Map<String, Object> paramMap = req.getParams();
		paramMap.put("result", "-1");
		Page<BuildingCall> page = new Page<BuildingCall>(req.getEntity(), req
				.getPageNo(), req.getPageSize());
		queryBuildingCallService.queryBuildingCall(page, paramMap);
		// 返回数据
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 返回结果
		pw.print(page.toJson());
	}

	/**
	 * 导出楼宇催交信息
	 */
	@RequestMapping("/queryBuildingCall/toExport")
	public void Export(HttpServletRequest request, HttpServletResponse response) {
		// 获取页面传入的参数，并以逗号(,)分割，存入数组中
		String paras = request.getParameter("str");
		String[] strs = paras.split(",");
		try {
			Map<String, String> map = new HashMap<String, String>();
			map.put("xqbh", strs[0]);
			map.put("lybh", strs[1]);
			map.put("sfsh", strs[3]);
			map.put("enddate", strs[2]);
			// 添加操作日志
			LogUtil.write(new Log("楼宇催交", "导出", "QueryBuildingCallAction.Export", map.toString()));
			List<BuildingCall> resultList = queryBuildingCallService
					.findBuildingCall(map);
			DataExport.exportBuildingCall(resultList, response);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 打印楼宇催交信息
	 */
	@RequestMapping("/queryBuildingCall/toPrint")
	public ModelAndView listPrint(HttpServletRequest request,
			HttpServletResponse response) {
		// 获取页面传入的参数，并以逗号(,)分割，存入数组中
		String paras = request.getParameter("str");
		String[] strs = paras.split(",");
		String[] lybhs = request.getParameter("lybhs").toString().split(",");
		Map<String, String> map = new HashMap<String, String>();
		map.put("xqbh", strs[0]);
		map.put("lybh", strs[1]);
		map.put("sfsh", strs[3]);
		map.put("enddate", strs[2]);
		// 添加操作日志
		LogUtil.write(new Log("楼宇催交", "打印", "QueryBuildingCallAction.listPrint", map.toString()));
		List<BuildingCall> resultList = queryBuildingCallService.findBuildingCall(map);
		resultList.remove(resultList.size() - 1);
		if (!lybhs[0].toString().trim().equals("")) {
			List<BuildingCall> tempList = new ArrayList<BuildingCall>();
			for (String lybh : lybhs) {
				if (lybh.trim().equals("")) {
					continue;
				}
				for (BuildingCall bc : resultList) {
					if (bc.getLybh().trim().equals(lybh)) {
						tempList.add(bc);
					}
				}
			}
			resultList = tempList;
		}
		// 传参容器
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("list", resultList);
		QueryBuildingCallPrint view = new QueryBuildingCallPrint();
		// 设置参数
		view.setAttributesMap(paramMap);
		// 返回视图
		return new ModelAndView(view);
	}
}

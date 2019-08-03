package com.yaltec.wxzj2.biz.propertyport.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

import com.yaltec.comon.auth.TokenHolder;
import com.yaltec.comon.core.entity.ReqPamars;
import com.yaltec.comon.log.LogUtil;
import com.yaltec.comon.log.entity.Log;
import com.yaltec.comon.utils.JsonUtil;
import com.yaltec.wxzj2.biz.propertyport.service.CheckDataService;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 产权接口 房屋审核 
 * @author 亚亮科技有限公司.YL
 *
 * @version: 2016-9-13 上午10:58:56
 */
@Controller
public class CheckDataAction {
	/**
	 * 日志记录器.
	 */
	private static final Logger logger = Logger.getLogger("CheckDataAction");
	
	@Autowired
	private CheckDataService checkDataService;
	
	/**
	 * 跳转到首页 产权接口 房屋同步
	 */
	@RequestMapping("/propertyport/check/index")
	public String hIndex(Model model) {
		model.addAttribute("communitys", DataHolder.communityMap);
		model.addAttribute("assignments", DataHolder.dataMap.get("assignment"));
		model.addAttribute("deposits", DataHolder.dataMap.get("deposit"));
		model.addAttribute("housepropertys", DataHolder.dataMap.get("houseproperty"));
		model.addAttribute("housetypes", DataHolder.dataMap.get("housetype"));
		model.addAttribute("houseuses", DataHolder.dataMap.get("houseuse"));
		return "/propertyport/check/index";
	}
	
	/**
	 * 房屋查询列表(ajax调用)
	 * 
	 * @param req 从第几条数据库开始算(+每页显示的条数)
	 * @param limit 每页显示的条数，相当于pageSize
	 * @param ApplyDraw 查询条件
	 * @throws IOException
	 */
	@RequestMapping("/propertyport/check/list")
	public void hlist(@RequestBody ReqPamars req, HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		// 添加操作日志
		LogUtil.write(new Log("产权接口_房屋审核", "查询", "CheckDataAction.hlist",req.toString()));
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		List<Map<String,String>> list = checkDataService.query(req.getParams());
		// 返回结果
		pw.print(JsonUtil.toJson(list));
	}


	/**
	 * 审核新增房屋
	 * @param request
	 * @param response
	 * @throws IOException
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping("/propertyport/check/checkFW")
	public void receiveFW(HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		response.setCharacterEncoding("utf-8");
		Map<String, Object> map = new HashMap<String, Object>();
		map = JsonUtil.toObject(request.getParameter("data"), HashMap.class);
		map.put("userid", TokenHolder.getUser().getUserid());
		map.put("username", TokenHolder.getUser().getUsername());
		// 添加操作日志
		LogUtil.write(new Log("产权接口_房屋审核", "审核", "CheckDataAction.receiveFW",map.toString()));
		PrintWriter pw = response.getWriter();
		int r = -1;
		try {
			r = checkDataService.checkFW(map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		// 返回结果
		pw.print(JsonUtil.toJson(r));
	}
	
	/**
	 * 退回新增房屋
	 * @param request
	 * @param response
	 * @throws IOException
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping("/propertyport/return/returnFW")
	public void returnFW(HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		response.setCharacterEncoding("utf-8");
		Map<String, Object> map = new HashMap<String, Object>();
		map = JsonUtil.toObject(request.getParameter("data"), HashMap.class);
		map.put("userid", TokenHolder.getUser().getUserid());
		map.put("username", TokenHolder.getUser().getUsername());
		// 添加操作日志
		LogUtil.write(new Log("产权接口_房屋审核", "退回", "CheckDataAction.returnFW",map.toString()));
		PrintWriter pw = response.getWriter();
		int r = -1;
		try {
			r = checkDataService.returnFW(map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		// 返回结果
		pw.print(JsonUtil.toJson(r));
	}
	
}

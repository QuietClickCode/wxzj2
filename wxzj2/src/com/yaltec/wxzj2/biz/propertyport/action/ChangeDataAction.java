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
import com.yaltec.wxzj2.biz.propertyport.service.ChangeDataService;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 产权接口  房屋变更
 * @author 亚亮科技有限公司.YL
 *
 * @version: 2016-9-13 上午10:58:56
 */
@Controller
public class ChangeDataAction {
	/**
	 * 日志记录器.
	 */
	private static final Logger logger = Logger.getLogger("ChangeDataAction");
	
	@Autowired
	private ChangeDataService changeDataService;
	
	/**
	 * 跳转到首页 产权接口 房屋变更
	 */
	@RequestMapping("/propertyport/change/index")
	public String index(Model model) {
		return "/propertyport/change/index";
	}

	/**
	 * 跳转到首页 产权接口 房屋变更_查询变更后的房屋
	 */
	@RequestMapping("/propertyport/change/overindex")
	public String overindex(Model model) {
		return "/propertyport/change/overindex";
	}

	/**
	 * 跳转到首页 产权接口 房屋变更结果查询
	 */
	@RequestMapping("/propertyport/changequery/index")
	public String queryindex(Model model) {
		model.addAttribute("communitys", DataHolder.communityMap);
		return "/propertyport/changequery/index";
	}
	
	/**
	 * 房屋查询列表(ajax调用)
	 * 
	 * @param req 从第几条数据库开始算(+每页显示的条数)
	 * @param limit 每页显示的条数，相当于pageSize
	 * @param ApplyDraw 查询条件
	 * @throws IOException
	 */
	@RequestMapping("/propertyport/change/list")
	public void hlist(@RequestBody ReqPamars req, HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		// 添加操作日志
		LogUtil.write(new Log("产权接口_房屋变更", "查询", "ChangeDataAction.hlist",req.toString()));
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		List<Map<String,String>> list = changeDataService.query(req.getParams());
		// 返回结果
		pw.print(JsonUtil.toJson(list));
	}

	
	/**
	 * 房屋查询列表(ajax调用)
	 * 
	 * @param req 从第几条数据库开始算(+每页显示的条数)
	 * @param limit 每页显示的条数，相当于pageSize
	 * @param ApplyDraw 查询条件
	 * @throws IOException
	 */
	@RequestMapping("/propertyport/changequery/list")
	public void changequery(@RequestBody ReqPamars req, HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		// 添加操作日志
		LogUtil.write(new Log("产权接口_变更查询", "查询", "ChangeDataAction.changequery",req.toString()));
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		List<Map<String,String>> list = changeDataService.changeQuery(req.getParams());
		// 返回结果
		pw.print(JsonUtil.toJson(list));
	}

	/**
	 * 按回备业务进行房屋变更操作
	 * @param request
	 * @param response
	 * @throws IOException
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping("/propertyport/change/change")
	public void change(HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		response.setCharacterEncoding("utf-8");
		Map<String, Object> map = new HashMap<String, Object>();
		map = JsonUtil.toObject(request.getParameter("data"), HashMap.class);
		map.put("userid", TokenHolder.getUser().getUserid());
		map.put("username", TokenHolder.getUser().getUsername());
		// 添加操作日志
		LogUtil.write(new Log("产权接口_房屋变更", "执行", "ChangeDataAction.change",map.toString()));
		PrintWriter pw = response.getWriter();
		int r = -1;
		String msg = "操作成功！";
		try {
			String[] iid = map.get("iids").toString().split(",");
			for (int i = 0; i < iid.length; i++) {
				if (iid[i] == null || "".equals(iid[i]))
					continue;
				map.put("iid", iid[i]);
				r = changeDataService.change(map);
				if (r != 0) {
					if (r==-2) {
						msg = "业务编号为：" + iid[i] + "的业务，有变更前的房屋未获取到本地!";
					} else if (r==-3) {
						msg = "业务编号为：" + iid[i] + "的业务，有变更后的房屋未获取到本地!";
					} else if (r==-4) {
						msg = "业务编号为：" + iid[i] + "<br/>的业务，变更前的房屋大修资金未交齐，请交齐后重试!";
					} else if (r==-5) {
						msg = "业务编号为：" + iid[i] + "<br/>的业务，变更前的房屋存在未入账业务，不能执行分割操作，请处理完成后重试!";
					} else if (r==-6) {
						msg = "业务编号为：" + iid[i] + "<br/>的业务，变更前的房屋关联信息存在问题，请联系开发人员检查数据！";
					} else if (r==-7) {
						msg = "业务编号为：" + iid[i] + "<br/>的业务，变更前的房屋关联信息存在问题，请联系开发人员检查数据！";
					} else {
						msg = "处理失败，请稍候重试!";
					}
					pw.print(JsonUtil.toJson(msg));
					return;
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		// 返回结果
		pw.print(JsonUtil.toJson(msg));
	}
	
}

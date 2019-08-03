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
import com.yaltec.wxzj2.biz.property.entity.Building;
import com.yaltec.wxzj2.biz.property.entity.Community;
import com.yaltec.wxzj2.biz.property.entity.Project;
import com.yaltec.wxzj2.biz.property.service.ProjectService;
import com.yaltec.wxzj2.biz.propertyport.service.ReceiveDataService;
import com.yaltec.wxzj2.comon.data.DataHolder;
import com.yaltec.wxzj2.comon.data.service.ProjectDataService;

/**
 * 产权接口 数据接收
 * @author 亚亮科技有限公司.YL
 *
 * @version: 2016-9-13 上午10:58:56
 */
@Controller
public class ReceiveDataAction {
	/**
	 * 日志记录器.
	 */
	private static final Logger logger = Logger.getLogger("ReceiveDataAction");
	
	@Autowired
	private ReceiveDataService receiveDataService;
	@Autowired
	private ProjectService projectService;

	/**
	 * 跳转到首页 产权接口 项目同步
	 */
	@RequestMapping("/propertyport/receive/pIndex")
	public String pIndex(Model model) {
		return "/propertyport/receive/pIndex";
	}
	
	/**
	 * 跳转到首页 产权接口 小区同步
	 */
	@RequestMapping("/propertyport/receive/nIndex")
	public String nIndex(Model model) {
		return "/propertyport/receive/nIndex";
	}
	
	/**
	 * 跳转到首页 产权接口 楼宇同步
	 */
	@RequestMapping("/propertyport/receive/bIndex")
	public String bIndex(Model model) {
		model.addAttribute("communitys", DataHolder.communityMap);
		return "/propertyport/receive/bIndex";
	}
	
	/**
	 * 跳转到首页 产权接口 房屋同步
	 */
	@RequestMapping("/propertyport/receive/hIndex")
	public String hIndex(Model model) {
		model.addAttribute("communitys", DataHolder.communityMap);
		model.addAttribute("assignments", DataHolder.dataMap.get("assignment"));
		model.addAttribute("deposits", DataHolder.dataMap.get("deposit"));
		model.addAttribute("housepropertys", DataHolder.dataMap.get("houseproperty"));
		model.addAttribute("housetypes", DataHolder.dataMap.get("housetype"));
		model.addAttribute("houseuses", DataHolder.dataMap.get("houseuse"));
		return "/propertyport/receive/hIndex";
	}
	
	/**
	 * 项目查询列表(ajax调用)
	 * 
	 * @param req 从第几条数据库开始算(+每页显示的条数)
	 * @param limit 每页显示的条数，相当于pageSize
	 * @param ApplyDraw 查询条件
	 * @throws IOException
	 */
	@RequestMapping("/propertyport/receive/plist")
	public void plist(@RequestBody ReqPamars req, HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		// 添加操作日志
		LogUtil.write(new Log("产权接口_项目同步", "查询", "ReceiveDataAction.plist", req.toString()));
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		List<Map<String,String>> list = receiveDataService.queryPortReceiveDataP(req.getParams());
		//System.out.println(JsonUtil.toJson(list));
		// 返回结果
		pw.print(JsonUtil.toJson(list));
	}
	
	/**
	 * 小区查询列表(ajax调用)
	 * 
	 * @param req 从第几条数据库开始算(+每页显示的条数)
	 * @param limit 每页显示的条数，相当于pageSize
	 * @param ApplyDraw 查询条件
	 * @throws IOException
	 */
	@RequestMapping("/propertyport/receive/nlist")
	public void nlist(@RequestBody ReqPamars req, HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		// 添加操作日志
		LogUtil.write(new Log("产权接口_小区同步", "查询", "ReceiveDataAction.nlist", req.toString()));
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		
		long begin = System.currentTimeMillis();
//		System.out.println("开始："+System.currentTimeMillis());
		
		List<Map<String,String>> list = receiveDataService.queryPortReceiveDataN(req.getParams());
		
//		long time = System.currentTimeMillis() - begin;
//		System.out.println("time："+time);
		
		//System.out.println(JsonUtil.toJson(list));
		// 返回结果
		pw.print(JsonUtil.toJson(list));
	}
	
	/**
	 * 楼宇查询列表(ajax调用)
	 * 
	 * @param req 从第几条数据库开始算(+每页显示的条数)
	 * @param limit 每页显示的条数，相当于pageSize
	 * @param ApplyDraw 查询条件
	 * @throws IOException
	 */
	@RequestMapping("/propertyport/receive/blist")
	public void blist(@RequestBody ReqPamars req, HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		// 添加操作日志
		LogUtil.write(new Log("产权接口_楼宇同步", "查询", "ReceiveDataAction.blist", req.toString()));
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		List<Map<String,String>> list = receiveDataService.queryPortReceiveDataB(req.getParams());
//		System.out.println(JsonUtil.toJson(list));
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
	@RequestMapping("/propertyport/receive/hlist")
	public void hlist(@RequestBody ReqPamars req, HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		// 添加操作日志
		LogUtil.write(new Log("产权接口_房屋同步", "查询", "ReceiveDataAction.hlist", req.toString()));
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		List<Map<String,String>> list = receiveDataService.queryPortReceiveDataH(req.getParams());
		// 返回结果
		pw.print(JsonUtil.toJson(list));
	}
	
	/**
	 * 小区关联
	 * @param request
	 * @param response
	 * @throws IOException
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping("/propertyport/receive/mergeXQ")
	public void mergeXQ(HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		response.setCharacterEncoding("utf-8");
		Map<String, Object> map = new HashMap<String, Object>();
		map = JsonUtil.toObject(request.getParameter("data"), HashMap.class);
		map.put("userid", TokenHolder.getUser().getUserid());
		map.put("username", TokenHolder.getUser().getUsername());
		// 添加操作日志
		LogUtil.write(new Log("产权接口_小区同步", "关联", "ReceiveDataAction.mergeXQ", map.toString()));
		PrintWriter pw = response.getWriter();
		int r = -1;
		
		try {
			String[] xh = map.get("xhs").toString().split(",");
			for (int i = 0; i < xh.length; i++) {
				map.put("xh", xh[i]);
				r = receiveDataService.mergeXQ(map);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		// 返回结果
		pw.print(JsonUtil.toJson(r));
	}

	/**
	 * 楼宇关联
	 * @param request
	 * @param response
	 * @throws IOException
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping("/propertyport/receive/mergeLY")
	public void mergeLY(HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		response.setCharacterEncoding("utf-8");
		Map<String, Object> map = new HashMap<String, Object>();
		map = JsonUtil.toObject(request.getParameter("data"), HashMap.class);
		map.put("userid", TokenHolder.getUser().getUserid());
		map.put("username", TokenHolder.getUser().getUsername());
		// 添加操作日志
		LogUtil.write(new Log("产权接口_楼宇同步", "关联", "ReceiveDataAction.mergeLY", map.toString()));
		PrintWriter pw = response.getWriter();
		int r = -1;
		
		try {
			String[] xh = map.get("xhs").toString().split(",");
			for (int i = 0; i < xh.length; i++) {
				map.put("xh", xh[i]);
				r = receiveDataService.mergeLY(map);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		// 返回结果
		pw.print(JsonUtil.toJson(r));
	}
	/**
	 * 项目新建
	 * @param request
	 * @param response
	 * @throws IOException
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping("/propertyport/receive/addXM")
	public void addXM(HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		response.setCharacterEncoding("utf-8");
		Map<String, Object> map = new HashMap<String, Object>();
		map = JsonUtil.toObject(request.getParameter("data"), HashMap.class);
		map.put("userid", TokenHolder.getUser().getUserid());
		map.put("username", TokenHolder.getUser().getUsername());

		Project project = new Project();
		project.setBm(map.get("bm").toString());
		project.setMc(map.get("mc").toString());
		String msg = "新建成功";
		PrintWriter pw = response.getWriter();
		if(projectService.findByMc(project) != null) {
			msg = "项目名称已存在，请检查后重试！";
		}else{
			// 添加操作日志
			LogUtil.write(new Log("产权接口_项目同步", "新建", "ReceiveDataAction.addXM", map.toString()));
			
			int r = -1;
			try {
				//根据归集中心、区域编号获取对应value值
				map.put("unitName", DataHolder.dataMap.get("assignment").get(map.get("unitCode")));
				int result = receiveDataService.addXM(map);
				if (result > 0) {
					// 更新缓存
					DataHolder.updateDataMap(ProjectDataService.KEY, map.get("bm").toString(), map.get("mc").toString());
					msg = "新建成功";
				} else if(result == 3) {
					msg = "项目名称已存在，请检查后重试！";
		        } else {
					msg = "项目新建操作失败！";
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		// 返回结果
		pw.print(JsonUtil.toJson(msg));
	}
	
	/**
	 * 小区新建
	 * @param request
	 * @param response
	 * @throws IOException
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping("/propertyport/receive/addXQ")
	public void addXQ(HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		response.setCharacterEncoding("utf-8");
		Map<String, Object> map = new HashMap<String, Object>();
		map = JsonUtil.toObject(request.getParameter("data"), HashMap.class);
		map.put("userid", TokenHolder.getUser().getUserid());
		map.put("username", TokenHolder.getUser().getUsername());
		// 添加操作日志
		LogUtil.write(new Log("产权接口_小区同步", "新建", "ReceiveDataAction.addXQ", map.toString()));
		
		PrintWriter pw = response.getWriter();
		int r = -1;
		String msg = "新建成功";
		try {
			r = receiveDataService.addXQ(map);
			if(r == 0){
				msg = "新建成功";
				Community c = new Community(map.get("bm").toString(), map.get("mc").toString());
				//更新小区缓存 
				DataHolder.updateCommunityDataMap(c);
			} else if(r == 3) {
				msg = "小区已获取到本地!";
			} else if (r == 4) {
				msg = "本地存在相同名称的小区!";
			} else {
				msg = "小区新建操作失败！";
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		// 返回结果
		pw.print(JsonUtil.toJson(msg));
	}

	/**
	 * 楼宇新建
	 * @param request
	 * @param response
	 * @throws IOException
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping("/propertyport/receive/addLY")
	public void addLY(HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		response.setCharacterEncoding("utf-8");
		Map<String, Object> map = new HashMap<String, Object>();
		map = JsonUtil.toObject(request.getParameter("data"), HashMap.class);
		map.put("userid", TokenHolder.getUser().getUserid());
		map.put("username", TokenHolder.getUser().getUsername());
		// 添加操作日志
		LogUtil.write(new Log("产权接口_楼宇同步", "新建", "ReceiveDataAction.addLY", map.toString()));
		
		PrintWriter pw = response.getWriter();
		int r = -1;
		String msg = "新建成功";
		try {
			r = receiveDataService.addLY(map);
			if(r == 0){
				msg = "新建成功";
				Building building = new Building(map.get("xqbh").toString(),map.get("xqmc").toString(), map.get("lybh").toString(), map.get("lymc").toString());
				//更新楼宇缓存 
				DataHolder.updateBuildingDataMap(building);
			} else if (r == 3) {
				msg = "本地存在相同名称的楼宇!";
			} else {
				msg = "楼宇新建操作失败！";
			}
		} catch (Exception e) {
			msg = "楼宇新建操作失败！";
			e.printStackTrace();
		}
		// 返回结果
		pw.print(JsonUtil.toJson(msg));
	}


	/**
	 * 提交新增房屋数据到临时表
	 * @param request
	 * @param response
	 * @throws IOException
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping("/propertyport/receive/receiveFW")
	public void receiveFW(HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		response.setCharacterEncoding("utf-8");
		Map<String, Object> map = new HashMap<String, Object>();
		map = JsonUtil.toObject(request.getParameter("data"), HashMap.class);
		map.put("userid", TokenHolder.getUser().getUserid());
		map.put("username", TokenHolder.getUser().getUsername());
		// 添加操作日志
		LogUtil.write(new Log("产权接口_房屋同步", "提交", "ReceiveDataAction.receiveFW", map.toString()));
		PrintWriter pw = response.getWriter();
		int r = -1;
		try {
			r = receiveDataService.receiveFW(map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		// 返回结果
		pw.print(JsonUtil.toJson(r));
	}
	
	/**
	 * 同步产权接口变更的房屋
	 * @param request
	 * @param response
	 * @throws IOException
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping("/propertyport/receive/syncFW")
	public void syncFW(HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		response.setCharacterEncoding("utf-8");
		Map<String, Object> map = new HashMap<String, Object>();
		map = JsonUtil.toObject(request.getParameter("data"), HashMap.class);
		map.put("userid", TokenHolder.getUser().getUserid());
		map.put("username", TokenHolder.getUser().getUsername());
		// 添加操作日志
		LogUtil.write(new Log("产权接口_房屋同步", "同步", "ReceiveDataAction.syncFW", map.toString()));
		
		PrintWriter pw = response.getWriter();
		int r = -1;
		try {
			r = receiveDataService.syncFW(map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		// 返回结果
		pw.print(JsonUtil.toJson(r));
	}
	
	/**
	 * 跳转到首页 房屋对照（本地与回备）
	 */
	@RequestMapping("/propertyport/receive/toContrast")
	public String toContrast(Model model,String tbid) {
		model.addAttribute("contrastInfo", receiveDataService.queryContrast(tbid));
		return "/propertyport/receive/contrast";
	}
	
	/**
	 * 保存房屋变更数据（单个、手动）
	 * @param request
	 * @param response
	 * @throws IOException
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping("/propertyport/receive/saveContrast")
	public void saveContrast(HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		response.setCharacterEncoding("utf-8");
		Map<String, Object> map = new HashMap<String, Object>();
		map = JsonUtil.toObject(request.getParameter("data"), HashMap.class);
		map.put("userid", TokenHolder.getUser().getUserid());
		map.put("username", TokenHolder.getUser().getUsername());
		// 添加操作日志
		LogUtil.write(new Log("产权接口_房屋对照", "保存", "ReceiveDataAction.saveContrast", map.toString()));
		
		String sqlstr = "update Port_House set F_UNIT='"+map.get("h002")+"',F_FLOOR='"+map.get("h003")+"',F_ROOM_NO='"+map.get("h005")+"',F_BUILD_AREA='"+map.get("h006")+"',F_OWNER='"+map.get("h013")+"',F_CARD_NO='"+map.get("h015")+"',"
		+"F_TOTAL='"+map.get("h010")+"',F_LOCATION='"+map.get("h047")+"',h062='"+map.get("h052")+"',h063='"+map.get("h053")+"' where h001='"+map.get("h001")+"' ";
		
		PrintWriter pw = response.getWriter();
		int r = -1;
		try {
			Map<String, Object> parasMap = new HashMap<String, Object>();
			parasMap.put("sqlstr", sqlstr);
			receiveDataService.exec(parasMap);
			r = 1;
		} catch (Exception e) {
			e.printStackTrace();
		}
		// 返回结果
		pw.print(JsonUtil.toJson(r));
	}
}

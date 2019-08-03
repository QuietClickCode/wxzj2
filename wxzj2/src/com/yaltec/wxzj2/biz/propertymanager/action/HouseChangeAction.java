package com.yaltec.wxzj2.biz.propertymanager.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
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
import com.yaltec.wxzj2.biz.propertymanager.service.HouseChangeService;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 产权管理 房屋变更 
 * @author 亚亮科技有限公司.YL
 *
 * @version: 2016-9-13 上午10:58:56
 */
@Controller
public class HouseChangeAction {
	/**
	 * 日志记录器.
	 */
	private static final Logger logger = Logger.getLogger("HouseChangeAction");
	
	@Autowired
	private HouseChangeService houseChangeService;
	
	/**
	 * 跳转到首页 产权管理 房屋变更
	 */
	@RequestMapping("/houseChange/index")
	public String queryindex(Model model) {
		return "/propertymanager/housechange/index";
	}
	
	/**
	 * 房屋查询列表(ajax调用)
	 * 
	 * @param req 从第几条数据库开始算(+每页显示的条数)
	 * @param limit 每页显示的条数，相当于pageSize
	 * @param ApplyDraw 查询条件
	 * @throws IOException
	 */
	@RequestMapping("/houseChange/list")
	public void list(@RequestBody ReqPamars req, HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		req.getParams().put("userid", TokenHolder.getUser().getUserid());
		// 添加操作日志
		LogUtil.write(new Log("产权管理_房屋变更", "查询", "HouseChangeAction.list",req.toString()));
		List<Map<String,String>> list = houseChangeService.query(req.getParams());
		// 返回结果
		pw.print(JsonUtil.toJson(list));
	}
	
	/**
	 * 添加被变更的房屋
	 * @param request
	 * @param response
	 * @throws IOException
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping("/houseChange/addMany")
	public void addMany(HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		response.setCharacterEncoding("utf-8");
		Map<String, String> map = new HashMap<String, String>();
		map = JsonUtil.toObject(request.getParameter("data"), HashMap.class);
		String[] level = map.get("str").split("@");
		String lybh = "";
		String h002 = "";
		String h003 = "";
		String h001 = "";
		String deleteStr = " delete from temp_houseChange ";
		String insertStr = " insert into temp_houseChange " +
				"select '"+map.get("type")+"',h001,lybh,lymc,h002,h003,h005,h006,h013,h015,h021,h030,h031,'" +
				TokenHolder.getUser().getUserid()+"','"+TokenHolder.getUser().getUsername()+"' from house ";
		String whereStr = "";
		if (level.length <= 3) {
			lybh = level[1];
			whereStr = " where lybh='"+lybh+"' ";
		} else if (level.length == 4) {
			lybh = level[1];
			h002 = level[2];
			whereStr = " where lybh='"+lybh+"' and h002='"+h002+"' ";
		} else if (level.length == 5) {
			lybh = level[1];
			h002 = level[2];
			h003 = level[3];
			whereStr = " where lybh='"+lybh+"' and h002='"+h002+"' and h003='"+h003+"' ";
			if(!"0".equals(level[4])){
				h001 = level[4];
				whereStr = " where h001='"+h001+"' ";
			}
		}
		
		//房屋不能同时存在变更前和变更后
		String endWhere  = "";
		if("2".equals(map.get("type"))){
			endWhere = " and h030=0 and h031=0 and h001 not in (select h001 from temp_houseChange where lybh='"+lybh+"' and type='1') and isnull(h035,'')='正常' ";
		}else{
			endWhere = " and h001 not in (select h001 from temp_houseChange where lybh='"+lybh+"' and type='2') and isnull(h035,'')='正常' ";
		}
		//存在未到账业务的房屋不能作业务
		whereStr = whereStr + " and h001 not in (select h001 from SordinePayToStore where isnull(w007,'')='' )" +
				" and h001 not in (select h001 from SordineDrawForRe where isnull(z007,'')='') ";
		String sqlstr = deleteStr + whereStr+" and type='"+map.get("type")+"' " + insertStr + whereStr + endWhere;
		PrintWriter pw = response.getWriter();
		int r = -1;
		try {
			Map<String, String> parasMap = new HashMap<String, String>();
			parasMap.put("sqlstr", sqlstr);
			// 添加操作日志
			LogUtil.write(new Log("产权管理_房屋变更", "添加被变更的房屋", "HouseChangeAction.addMany",parasMap.toString()));
			houseChangeService.execUpdate(parasMap);
		} catch (Exception e) {
			e.printStackTrace();
		}
		// 返回结果
		pw.print(JsonUtil.toJson(r));
	}

	/**
	 * 清空临时表
	 * @param request
	 * @param response
	 * @throws IOException
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping("/houseChange/clear")
	public void clear(HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		response.setCharacterEncoding("utf-8");
		String deleteStr = " delete from temp_houseChange ";
		String sqlstr = deleteStr;
		PrintWriter pw = response.getWriter();
		int r = -1;
		try {
			Map<String, String> parasMap = new HashMap<String, String>();
			parasMap.put("sqlstr", sqlstr);
			// 添加操作日志
			LogUtil.write(new Log("产权管理_房屋变更", "清空临时表", "HouseChangeAction.clear",parasMap.toString()));
			houseChangeService.execUpdate(parasMap);
		} catch (Exception e) {
			e.printStackTrace();
		}
		// 返回结果
		pw.print(JsonUtil.toJson(r));
	}

	/**
	 * 删除临时表中对应的房屋数据
	 * @param request
	 * @param response
	 * @throws IOException
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping("/houseChange/delete")
	public void delete(HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		response.setCharacterEncoding("utf-8");
		Map<String, String> map = new HashMap<String, String>();
		map = JsonUtil.toObject(request.getParameter("data"), HashMap.class);
		String deleteStr = " delete from temp_houseChange where type='"+map.get("type")+"' and h001 in ("+map.get("h001s")+")";
		String sqlstr = deleteStr;
		PrintWriter pw = response.getWriter();
		String msg = "删除成功！";
		try {
			Map<String, String> parasMap = new HashMap<String, String>();
			parasMap.put("sqlstr", sqlstr);
			// 添加操作日志
			LogUtil.write(new Log("产权管理_房屋变更", "删除临时表中对应的房屋数据", "HouseChangeAction.delete",parasMap.toString()));
			int r = houseChangeService.execUpdate(parasMap);
			if(r<=0){
				msg = "删除失败！";
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		// 返回结果
		pw.print(JsonUtil.toJson(msg));
	}

	/**
	 * 修改临时表中对应的房屋分摊本金
	 * @param request
	 * @param response
	 * @throws IOException
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping("/houseChange/updateMoney")
	public void updateMoney(HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		response.setCharacterEncoding("utf-8");
		Map<String, String> map = JsonUtil.toObject(request.getParameter("data"), HashMap.class);
		String sqlstr = " update temp_houseChange set h030='"+map.get("h030")+"' where h001='"+map.get("h001")+"' and type='2' ";
		PrintWriter pw = response.getWriter();
		String msg = "修改成功！";
		try {
			Map<String, String> parasMap = new HashMap<String, String>();
			parasMap.put("sqlstr", sqlstr);
			// 添加操作日志
			LogUtil.write(new Log("产权管理_房屋变更", "修改临时表中对应的房屋分摊本金", "HouseChangeAction.updateMoney",parasMap.toString()));
			int r = houseChangeService.execUpdate(parasMap);
			if(r<=0){
				msg = "修改失败！";
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		// 返回结果
		pw.print(JsonUtil.toJson(msg));
	}

	/**
	 * 查询房屋变更前后的数据统计信息
	 * @param request
	 * @param response
	 * @throws IOException
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping("/houseChange/queryCount")
	public void queryCount(HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		response.setCharacterEncoding("utf-8");
		String lybh = request.getParameter("lybh");
		String sqlstr = "select ISNULL(a.sl,0) qsl,ISNULL(a.h006,0) qh006,ISNULL(a.h021,0) qh021,ISNULL(a.h030,0) qh030,ISNULL(a.h031,0) qh031,"
			+" ISNULL(b.sl,0) hsl,ISNULL(b.h006,0) hh006,ISNULL(b.h021,0) hh021,ISNULL(b.h030,0) hh030,ISNULL(b.h031,0) hh031"
			+" from ("
				+" select COUNT(id) sl,SUM(h006) h006,SUM(h021) h021,SUM(h030) h030,SUM(h031) h031 "
				+" from temp_houseChange where lybh='"+lybh+"' and type='1'"
			+" ) a,("
				+" select COUNT(id) sl,SUM(h006) h006,SUM(h021) h021,SUM(h030) h030,SUM(h031) h031 "
				+" from temp_houseChange where lybh='"+lybh+"' and type='2'"
			+" ) b ";;
		PrintWriter pw = response.getWriter();
		List<Map<String,String>> list = new ArrayList<Map<String,String>>();
		try {
			Map<String, String> parasMap = new HashMap<String, String>();
			parasMap.put("sqlstr", sqlstr);
			// 添加操作日志
			LogUtil.write(new Log("产权管理_房屋变更", "查询数据统计信息", "HouseChangeAction.queryCount",parasMap.toString()));
			list = houseChangeService.execQuery(parasMap);
		} catch (Exception e) {
			e.printStackTrace();
		}
		// 返回结果
		if(list.size()==1){
			pw.print(JsonUtil.toJson(list.get(0)));
		}else{
			pw.print("");
		}
	}
	
	/**
	 * 资金分摊 
	 * @param request
	 * @param response
	 * @throws IOException
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping("/houseChange/share")
	public void share(HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		response.setCharacterEncoding("utf-8");
		Map<String, String> map = new HashMap<String, String>();
		map = JsonUtil.toObject(request.getParameter("data"), HashMap.class);
		PrintWriter pw = response.getWriter();
		int r = -1;
		try {
			r = houseChangeService.share(map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		// 返回结果
		pw.print(r);
	}

	
	/**
	 * 保存
	 * @param request
	 * @param response
	 * @throws IOException
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping("/houseChange/save")
	public void save(HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		response.setCharacterEncoding("utf-8");
		Map<String, String> map = new HashMap<String, String>();
		map = JsonUtil.toObject(request.getParameter("data"), HashMap.class);
		map.put("userid", TokenHolder.getUser().getUserid());
		map.put("username", TokenHolder.getUser().getUsername());
		PrintWriter pw = response.getWriter();
		int r = -1;
		try {
			// 添加操作日志
			LogUtil.write(new Log("产权管理_房屋变更", "保存", "HouseChangeAction.save",map.toString()));
			r = houseChangeService.executeChange(map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		// 返回结果
		pw.print(r);
	}

	/**
	 * 跳转到首页 产权变更 房屋变更结果查询
	 */
	@RequestMapping("/houseChange/queryIndex")
	public String toQuery(Model model) {
		model.addAttribute("communitys", DataHolder.communityMap);
		return "/propertymanager/housechange/queryIndex";
	}
	
	/**
	 * 房屋变更查询列表(ajax调用)
	 * 
	 * @param req 从第几条数据库开始算(+每页显示的条数)
	 * @param limit 每页显示的条数，相当于pageSize
	 * @param ApplyDraw 查询条件
	 * @throws IOException
	 */
	@RequestMapping("/houseChange/querylist")
	public void changequery(@RequestBody ReqPamars req, HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 添加操作日志
		LogUtil.write(new Log("产权管理_房屋变更", "房屋变更查询列表", "HouseChangeAction.changequery",req.toString()));
		List<Map<String,String>> list = houseChangeService.queryHouseChange(req.getParams());
		// 返回结果
		pw.print(JsonUtil.toJson(list));
	}
	/**
	 * 房屋变更查询导出
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping("/houseChange/toExport")
	public void toExport(HttpServletRequest request,HttpServletResponse response) {
		Map<String, Object> map = JsonUtil.toObject(request.getParameter("data"), HashMap.class);
		map.put("result", "-1");	
		// 添加操作日志
		LogUtil.write(new Log("产权管理_房屋变更查询", "导出", "HouseChangeAction.toExport",map.toString()));
		try {
			houseChangeService.export(map, response);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * 按业务编号删除房屋变更业务
	 * @param p004
	 * @param request
	 * @param response
	 * @throws IOException
	 */
	@RequestMapping("/houseChange/delBusiness")
	public void delBusiness(String p004, HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 添加操作日志
		LogUtil.write(new Log("产权管理_房屋变更查询", "删除", "HouseChangeAction.delBusiness",p004));
		Integer r = 0;
		Map<String, String> map = new HashMap<String, String>();
		map.put("p004", p004);
		r = houseChangeService.delBusinessByP004(map);
		// 返回结果
		pw.print(JsonUtil.toJson(r));
	}
}

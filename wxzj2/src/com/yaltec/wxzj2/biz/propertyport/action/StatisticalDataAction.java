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

import com.yaltec.comon.core.entity.ReqPamars;
import com.yaltec.comon.log.LogUtil;
import com.yaltec.comon.log.entity.Log;
import com.yaltec.comon.utils.JsonUtil;
import com.yaltec.wxzj2.biz.draw.service.export.NormalExport;
import com.yaltec.wxzj2.biz.propertyport.service.StatisticalDataService;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 产权接口  统计查询
 * @author 亚亮科技有限公司.YL
 *
 * @version: 2016-9-13 上午10:58:56
 */
@Controller
public class StatisticalDataAction {
	/**
	 * 日志记录器.
	 */
	private static final Logger logger = Logger.getLogger("StatisticalDataAction");
	
	@Autowired
	private StatisticalDataService statisticalDataService;
	
	/**
	 * 跳转到首页 产权接口 统计查询
	 */
	@RequestMapping("/propertyport/statistical/index")
	public String queryindex(Model model) {
		model.addAttribute("communitys", DataHolder.communityMap);
		return "/propertyport/statisticalquery/index";
	}
	
	
	/**
	 * 产权接口 统计查询列表(ajax调用)
	 * 
	 * @param req 从第几条数据库开始算(+每页显示的条数)
	 * @param limit 每页显示的条数，相当于pageSize
	 * @param ApplyDraw 查询条件
	 * @throws IOException
	 */
	@RequestMapping("/propertyport/statistical/list")
	public void query(@RequestBody ReqPamars req, HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		// 添加操作日志
		LogUtil.write(new Log("产权接口_统计查询", "查询", "StatisticalDataAction.query",req.toString()));
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		List<Map<String,String>> list = statisticalDataService.query(req.getParams());
		// 返回结果
		pw.print(JsonUtil.toJson(list));
	}

	/**
	 * 产权接口 统计查询导出(按楼宇)
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping("/propertyport/statistical/toExport1")
	public void toExport1(HttpServletRequest request,HttpServletResponse response) {
		response.setCharacterEncoding("utf-8");
		Map<String, Object> map = new HashMap<String, Object>();
		map = JsonUtil.toObject(request.getParameter("data"), HashMap.class);
		// 添加操作日志
		LogUtil.write(new Log("产权接口_统计查询", "按楼宇导出", "StatisticalDataAction.toExport1",map.toString()));
		String title = "产权接口数据统计";
		String[] ZHT = { "开发公司", "小区名称", "楼宇名称", "房屋数量","建筑面积","获取日期"};
		String[] ENT = { "kfgsmc", "xqmc", "lymc", "sl","h006","registdate"};// 输出例
		List<Map<String,String>> list = null;
		try {
			list = statisticalDataService.query(map);
			if (list.size() == 0) {
				exeException("获取数据失败！",response);
				return;
			}
			NormalExport.export(response, list, title, ZHT, ENT);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 产权接口 统计明细查询导出（按房屋）
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping("/propertyport/statistical/toExport2")
	public void toExport2(HttpServletRequest request,HttpServletResponse response) {
		response.setCharacterEncoding("utf-8");
		Map<String, Object> map = new HashMap<String, Object>();
		map = JsonUtil.toObject(request.getParameter("data"), HashMap.class);
		// 添加操作日志
		LogUtil.write(new Log("产权接口_统计查询", "按房屋导出", "StatisticalDataAction.toExport2",map.toString()));
		String title = "产权接口数据明细";
		String[] ZHT = { "楼宇名称", "房屋编号", "单元", "层","房号","业主姓名","建筑面积"};
		String[] ENT = { "lymc", "h001", "h002", "h003","h005","h013","h006"};// 输出例
		List<Map<String,String>> list = null;
		try {
			list = statisticalDataService.query(map);
			if (list.size() == 0) {
				exeException("获取数据失败！",response);
				return;
			}
			NormalExport.export(response, list, title, ZHT, ENT);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	

	// 异常提示
	public void exeException(String message, HttpServletResponse response) {
		PrintWriter out = null;
		try {
			response.setContentType("text/html;charset=utf-8");
			out = response.getWriter();
			out.print("<script language='javaScript'>alert('" + message + "');" + "self.close();</script>");
		} catch (Exception e) {
			logger.error(e.getMessage());
		} finally {
			out.flush();
			out.close();
		}
	}
}

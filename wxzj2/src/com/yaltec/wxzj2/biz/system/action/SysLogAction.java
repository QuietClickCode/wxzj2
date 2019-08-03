package com.yaltec.wxzj2.biz.system.action;

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
import com.yaltec.wxzj2.biz.compositeQuery.service.export.DataExport;
import com.yaltec.wxzj2.biz.system.service.SysLogService;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 
 * @ClassName: SysLogAction
 * @Description: TODO 系统日志查询信息实现类
 * 
 * @author jiangyong
 * @date 2016-8-20 上午09:50:41
 */
@Controller
public class SysLogAction {

	@Autowired
	private SysLogService sysLogService;
	
	/**
	 * 查询系统日志列表
	 * 
	 * @return 跳转的JSP页面
	 */
	@RequestMapping("/syslog/index")
	public String index(Model model) {
		model.addAttribute("operators", DataHolder.dataMap.get("user"));
		// 跳转的JSP页面
		return "/system/syslog/index";
	}

	/**
	 * 查询系统日志列表
	 * 
	 */
	@RequestMapping("/syslog/list")
	public void list(@RequestBody ReqPamars<Log> req, HttpServletRequest request, HttpServletResponse response)
			throws IOException {
		LogUtil.write(new Log("系统日志查询信息", "查询", "SysLogAction.list", req.toString()));
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();

		Page<Log> page = new Page<Log>(new Log(), req.getPageNo(), req.getPageSize());
		sysLogService.findAll(page, req.getParams());
		// 返回结果
		pw.print(page.toJson());
	}
	
	/**
	 * 跳转到日志详情页面
	 * 
	 * @return 跳转的JSP页面
	 */
	@RequestMapping("/syslog/toDetail")
	public String toDetail(String id, Model model) {
		model.addAttribute("log", sysLogService.find(id));
		// 跳转的JSP页面
		return "/system/syslog/detail";
	}
	
	/**
	 * 导出日志详情
	 * @param <log>
	 */
	@RequestMapping("/syslog/export")
	public void  export(HttpServletRequest request,HttpServletResponse response) {
		try {
			Map<String, Object> paramMap = new HashMap<String, Object>();			
			paramMap.put("begindate",request.getParameter("begindate"));
			paramMap.put("enddate",request.getParameter("enddate"));
			paramMap.put("userid",request.getParameter("userid"));
			// 添加操作日志	
			LogUtil.write(new Log("系统日志查询信息", "导出", "SysLogAction.export", paramMap.toString()));	
			List<Log> resultList  = sysLogService.findAll2(paramMap);
			
			DataExport.exportSysLog(resultList, response);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}
	
}

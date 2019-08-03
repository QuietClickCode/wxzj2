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
import com.yaltec.wxzj2.biz.system.entity.BankLog;
import com.yaltec.wxzj2.biz.system.service.BankLogService;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 
 * @ClassName: BankLogAction
 * @Description: TODO 银行日志信息实现类
 * 
 * @author jiangyong
 * @date 2016-10-9 下午03:08:41
 */
@Controller
public class BankLogAction {

	@Autowired
	private BankLogService bankLogService;
	
	/**
	 * 查询银行日志列表
	 * 
	 * @return 跳转的JSP页面
	 */
	@RequestMapping("/banklog/index")
	public String index(Model model) {
		model.addAttribute("assignment", DataHolder.dataMap.get("assignment"));
		// 跳转的JSP页面
		return "/system/banklog/index";
	}

	/**
	 * 查询银行日志列表
	 * 
	 */
	@RequestMapping("/banklog/list")
	public void list(@RequestBody ReqPamars<BankLog> req, HttpServletRequest request, HttpServletResponse response)
			throws IOException {
		LogUtil.write(new Log("银行日志信息", "查询", "BankLogAction.list", req.toString()));
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();

		Page<BankLog> page = new Page<BankLog>(req.getEntity(), req.getPageNo(), req.getPageSize());
		bankLogService.findAll(page, req.getParams());
		// 返回结果
		pw.print(page.toJson());
	}
	
	/**
	 *银行日志导出数据
	 */
	@RequestMapping("/banklog/export")
	public void export(HttpServletRequest request, HttpServletResponse response) {
		try {
			Map<String, Object> paramMap = new HashMap<String, Object>();			
			paramMap.put("begindate",request.getParameter("begindate"));
			paramMap.put("enddate",request.getParameter("enddate"));
			paramMap.put("source",request.getParameter("source"));
			// 添加操作日志	
			LogUtil.write(new Log("银行日志查询信息", "导出", "BankLogAction.export", paramMap.toString()));	
			List<BankLog> resultList  = bankLogService.findAll2(paramMap);
			
			DataExport.exportBankLog(resultList, response);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}

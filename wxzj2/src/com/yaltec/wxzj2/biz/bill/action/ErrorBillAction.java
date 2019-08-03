package com.yaltec.wxzj2.biz.bill.action;


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
import com.yaltec.wxzj2.biz.bill.entity.ErrorBill;
import com.yaltec.wxzj2.biz.bill.service.ErrorBillService;
import com.yaltec.wxzj2.biz.bill.service.export.DataExportBill;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 
 * @ClassName: ErrorBillAction
 * @Description: TODO错误票据实现类
 * 
 * @author moqian
 * @date 2016-7-18 下午15:12:03
 */

@Controller
public class ErrorBillAction {
	
	@Autowired
	private ErrorBillService errorBillService;	
	
	/**
	 * 查询错误票据列表
	 */
	@RequestMapping("/errorBill/index")
	public String index(Model model){
		model.addAttribute("banks", DataHolder.dataMap.get("bank"));
		return "/bill/errorBill/index";
	}
		
	/**
	 * 查询错误票据列表
	 */
	@RequestMapping("/errorBill/list")
	public void list(@RequestBody ReqPamars<ErrorBill> req, HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		// 添加操作日志
		LogUtil.write(new Log("错误票据", "查询", "ErrorBillAction.list", req.toString()));
		//获取查询条件
		Map<String, Object> paramMap = req.getParams();
		paramMap.put("result", "-1");		
		Page<ErrorBill> page = new Page<ErrorBill>(req.getEntity(), req.getPageNo(), req.getPageSize());
		errorBillService.findAll(page, paramMap);
		//返回数据
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 返回结果
		pw.print(page.toJson());
	}
	
	/**
	 * 错误票据的导出数据
	 */
	@RequestMapping("/errorBill/exportErrorBill")
	public void exportErrorBill(HttpServletRequest request, HttpServletResponse response) {
		try {
			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("yhbh",request.getParameter("yhbh"));
			paramMap.put("begindate",request.getParameter("begindate"));
			paramMap.put("enddate",request.getParameter("enddate"));
			paramMap.put("qsh",request.getParameter("qsh"));
			paramMap.put("zzh",request.getParameter("zzh"));
			paramMap.put("type",request.getParameter("type"));
			// 添加操作日志
			LogUtil.write(new Log("错误票据", "导出", "ErrorBillAction.exportErrorBill", paramMap.toString()));
			List<ErrorBill> resultList = errorBillService.findErrorBill(paramMap);
			
			DataExportBill.exportErrorBill(resultList, response);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	
	/**
	 * 修改交款信息的票据号
	 */
	@RequestMapping("/errorBill/eidtW011PaymentReg")
	public void eidtW011PaymentReg(HttpServletRequest request,
			Model model,HttpServletResponse response)throws IOException {
		//获取参数
		Map<String, String> paramMap=new HashMap<String, String>();		
		paramMap.put("h001", request.getParameter("h001"));
		paramMap.put("w008", request.getParameter("w008"));
		paramMap.put("w013", request.getParameter("w013"));
		paramMap.put("w011", request.getParameter("w011"));
		paramMap.put("regNo", "");
		paramMap.put("result", "-1");	
		int result = errorBillService.eidtW011PaymentReg(paramMap);
		//返回数据
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		pw.print(result);
	}
	
}

package com.yaltec.wxzj2.biz.voucher.action;

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
import com.yaltec.comon.core.entity.ReqPamars;
import com.yaltec.comon.log.LogUtil;
import com.yaltec.comon.log.entity.Log;
import com.yaltec.comon.utils.JsonUtil;
import com.yaltec.wxzj2.biz.voucher.entity.SummaryCertificate;
import com.yaltec.wxzj2.biz.voucher.service.SummaryCertificateService;
import com.yaltec.wxzj2.biz.voucher.service.export.SummaryCertificateExport;

/**
 * @ClassName: SummaryCertificateAction
 * @Description: 凭证汇总ACTION
 * 
 * @author moqian
 * @date 2016-9-5 下午14:04:38
 */
@Controller
public class SummaryCertificateAction {

	@Autowired
	private SummaryCertificateService summaryCertificateService;

	/**
	 * 查询凭证汇总信息列表
	 * 
	 */
	@RequestMapping("/summaryCertificate/index")
	public String index(Model model) {
		return "/voucher/summaryCertificate/index";
	}

	/**
	 * 查询凭证汇总信息列表
	 * 
	 */
	@RequestMapping("/summaryCertificate/list")
	public void list(@RequestBody ReqPamars<SummaryCertificate> req, HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		// 添加操作日志
		LogUtil.write(new Log("凭证汇总", "查询", "SummaryCertificateAction.list", req.toString()));
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();

		List<SummaryCertificate> list = summaryCertificateService.findAll(req.getParams());
		// 返回结果
		pw.print(JsonUtil.toJson(list));
	}
	
	/**
	 *凭证汇总的导出数据
	 */
	@RequestMapping("/summaryCertificate/exportSummaryCertificate")
	public void exportSummaryCertificate(HttpServletRequest request, HttpServletResponse response) {
		try {
			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("begindate",request.getParameter("begindate"));
			paramMap.put("enddate",request.getParameter("enddate"));
			paramMap.put("hzlb",request.getParameter("hzlb"));
			// 添加操作日志
			LogUtil.write(new Log("凭证汇总", "导出", "SummaryCertificateAction.exportSummaryCertificate",paramMap.toString()));
			List<SummaryCertificate> resultList = summaryCertificateService.findSummaryCertificate(paramMap);
			
			SummaryCertificateExport.exportSummaryCertificate(resultList, response);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}

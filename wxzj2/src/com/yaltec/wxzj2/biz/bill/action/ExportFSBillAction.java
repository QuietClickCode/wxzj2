package com.yaltec.wxzj2.biz.bill.action;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

import com.github.pagehelper.StringUtil;
import com.yaltec.comon.core.entity.ReqPamars;
import com.yaltec.comon.core.entity.Result;
import com.yaltec.comon.log.LogUtil;
import com.yaltec.comon.log.entity.Log;
import com.yaltec.comon.utils.JsonUtil;
import com.yaltec.wxzj2.biz.bill.entity.BatchInvResult;
import com.yaltec.wxzj2.biz.bill.entity.BatchInvStatus;
import com.yaltec.wxzj2.biz.bill.entity.ReceiptInfoM;
import com.yaltec.wxzj2.biz.bill.service.ExportFSBillService;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * <p>
 * ClassName: ExportFSBillAction
 * </p>
 * <p>
 * Description: 非税票据导出ACTION
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author jiangyong
 * @date 2016-8-30 下午02:17:13
 */
@Controller
public class ExportFSBillAction {

	@Autowired
	private ExportFSBillService exportFSBillService;

	/**
	 * 非税票据导出首页
	 * 
	 * @return 跳转的JSP页面
	 */
	@RequestMapping("/exportfsbill/index")
	public String index(Model model) {
		model.addAttribute("isExport", DataHolder.getParameter("28"));
		// 跳转的JSP页面
		return "/bill/exportfsbill/index";
	}

	/**
	 * 查询票据信息列表
	 * 
	 */
	@RequestMapping("/exportfsbill/billList")
	public void billList(@RequestBody ReqPamars<ReceiptInfoM> req,
			HttpServletRequest request, HttpServletResponse response)
			throws IOException {
		LogUtil.write(new Log("上报非税票据", "票据查询", "ExportFSBillAction.billList", req.getParams().toString()));
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		List<ReceiptInfoM> list = exportFSBillService.findBill(req.getParams());
		// 返回结果
		pw.print(JsonUtil.toJson(list));
	}

	/**
	 * 上报非税票据(导出数据到MYsql非税数据库)
	 * 
	 */
	@RequestMapping("/exportfsbill/exportData")
	public void exportData(HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("type", request.getParameter("type"));
		map.put("beginDate", request.getParameter("beginDate"));
		map.put("endDate", request.getParameter("endDate"));
		map.put("billNoS", request.getParameter("billNoS"));
		map.put("billNoE", request.getParameter("billNoE"));
		String regNo = request.getParameter("regNo").toString();
		map.put("regNo", regNo);
		LogUtil.write(new Log("上报非税票据", "票据上报", "ExportFSBillAction.exportData", map.toString()));
		// 记录上次导出的票据批次号
		DataHolder.customerInfo.setRegNo(regNo);

		Result result = exportFSBillService.exportData(map);
		// 返回结果
		pw.print(JsonUtil.toJson(result));
	}

	/**
	 * 查询非税上报结果列表
	 * 
	 */
	@RequestMapping("/exportfsbill/exportList")
	public void exportList(@RequestBody ReqPamars<Object> req,
			HttpServletRequest request, HttpServletResponse response)
			throws IOException {
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		LogUtil.write(new Log("上报非税票据", "查询非税上报结果列表", "ExportFSBillAction.exportList", req
				.getParams().toString()));
		
		List<BatchInvStatus> list = exportFSBillService.findBatchInvStatus(req
				.getParams());
		// 返回结果
		pw.print(JsonUtil.toJson(list));
	}

	/**
	 * 查询非税上报票据总数量
	 * 
	 */
	@RequestMapping("/exportfsbill/exportCount")
	public void exportCount(String beginDate,String endDate,String status,String batchNo,
			HttpServletRequest request, HttpServletResponse response)
			throws IOException {
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("beginDate", beginDate);
		map.put("endDate", endDate);
		map.put("status", status);
		map.put("batchNo", batchNo);
		LogUtil.write(new Log("上报非税票据", "查询非税上报票据总数量", "ExportFSBillAction.exportCount", map.toString()));
		
		List<BatchInvStatus> list = exportFSBillService.findBatchInvStatus(map);
		int total = 0;
		for (BatchInvStatus batchInvStatus : list) {
			total += batchInvStatus.getTotal();
		}
		// 返回结果
		pw.print(total);
	}
	
	/**
	 * 重新上报非税票据
	 * 
	 */
	@RequestMapping("/exportfsbill/repeatExportData")
	public void repeatExportData(HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		String batchNo = request.getParameter("batchNo");
		LogUtil.write(new Log("上报非税票据", "重新上报非税票据", "ExportFSBillAction.repeatExportData", batchNo));
		Result result = exportFSBillService.repeatExportData(batchNo);
		// 返回结果
		pw.print(JsonUtil.toJson(result));
	}

	/**
	 * 非税票据上报结果详情首页
	 * 
	 * @return 跳转的JSP页面
	 */
	@RequestMapping("/exportfsbill/detail/index")
	public String detailIndex(Model model, HttpServletRequest request) {
		String batchNo = request.getParameter("batchNo");
		model.addAttribute("batchNo", batchNo);
		return "/bill/exportfsbill/detail/index";
	}

	/**
	 * 查询非税上报结果明细列表
	 * 
	 */
	@RequestMapping("/exportfsbill/detail/list")
	public void exportDetailList(@RequestBody ReqPamars<Object> req,
			HttpServletRequest request, HttpServletResponse response)
			throws IOException {
		response.setCharacterEncoding("utf-8");
		String batchNo = req.getParams().get("batchNo").toString();
		LogUtil.write(new Log("上报非税票据", "上报明细", "ExportFSBillAction.exportDetailList", batchNo));
		List<BatchInvResult> list = exportFSBillService
				.findBatchInvResult(batchNo);
		// 返回结果
		PrintWriter pw = response.getWriter();
		pw.print(JsonUtil.toJson(list));
	}

	/**
	 * 同步非税上传状态（和非税状态进行对比更新）
	 */
	@RequestMapping("/exportfsbill/syncStatus")
	public void syncStatus(HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		String batchNo = request.getParameter("batchNo");
		LogUtil.write(new Log("上报非税票据", "同步状态", "ExportFSBillAction.syncStatus", batchNo));
		if (exportFSBillService.syncStatus(batchNo)) {
			// 成功
			pw.print("1");
		} else {
			// 失败
			pw.print("0");
		}
	}

	/**
	 * 导出上报文件
	 */
	@RequestMapping("/exportfsbill/exportFile")
	public void exportFile(HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("type", request.getParameter("type"));
		map.put("beginDate", request.getParameter("beginDate"));
		map.put("endDate", request.getParameter("endDate"));
		map.put("billNoS", request.getParameter("billNoS"));
		map.put("billNoE", request.getParameter("billNoE"));
		String regNo = request.getParameter("regNo").toString();
		map.put("regNo", regNo);
		// 记录上次导出的票据批次号
		DataHolder.customerInfo.setRegNo(regNo);
		LogUtil.write(new Log("上报非税票据", "导出上报文件", "ExportFSBillAction.exportFile", map.toString()));
		Result result = exportFSBillService.exportFile(map);
		// 返回结果
		pw.print(JsonUtil.toJson(result));
	}

	/**
	 * 下载非税数据文件
	 * 
	 * @param request
	 * @param response
	 * @param dataPath
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/exportfsbill/download")
	public ResponseEntity<byte[]> download(HttpServletRequest request,
			HttpServletResponse response, String dataPath) throws Exception {
		response.setCharacterEncoding("utf-8");

		if (StringUtil.isEmpty(dataPath) || !dataPath.endsWith(".csv")) {
			throw new Exception("下载数据失败,传入参数错误！");
		}
		LogUtil.write(new Log("上报非税票据", "下载非税数据文件", "ExportFSBillAction.download", dataPath));
		File file = new File(dataPath);
		if (!file.exists()) {
			throw new Exception("下载数据失败,文件不存在！");
		}
		if (file.exists()) {
			HttpHeaders headers = new HttpHeaders();
			headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
			headers.setContentDispositionFormData("attachment", file.getName());
			return new ResponseEntity<byte[]>(FileUtils
					.readFileToByteArray(file), headers, HttpStatus.OK);
		}
		return null;
	}

	/**
	 * 重新导出非税票据文件
	 * 
	 */
	@RequestMapping("/exportfsbill/repeatExportFile")
	public void repeatExportFile(HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		String batchNo = request.getParameter("batchNo");
		LogUtil.write(new Log("上报非税票据", "重新导出非税票据文件", "ExportFSBillAction.repeatExportFile", batchNo));
		Result result = exportFSBillService.repeatExportFile(batchNo);
		// 返回结果
		pw.print(JsonUtil.toJson(result));
	}

}

package com.yaltec.wxzj2.biz.bill.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.github.pagehelper.StringUtil;
import com.yaltec.comon.auth.TokenHolder;
import com.yaltec.comon.log.LogUtil;
import com.yaltec.comon.log.entity.Log;
import com.yaltec.comon.utils.crypt.MD5Util;
import com.yaltec.wxzj2.biz.bill.service.ReceiptInfoMService;
import com.yaltec.wxzj2.biz.payment.service.QueryPaymentService;
import com.yaltec.wxzj2.biz.system.entity.User;

/**
 * 
 * @ClassName: ReceiptInfoMAction
 * @Description: 票据明细管理ACTION
 * @author jiangyong
 * @date 2016-8-20 下午16:12:03
 */
@Controller
public class ReceiptInfoMAction {

	@Autowired
	private ReceiptInfoMService receiptInfoMService;
	
	@Autowired
	private QueryPaymentService queryPaymentService;

	/**
	 * 获取下一张有效票据号，根据归集中心+用户
	 */
	@RequestMapping("/receiptinfom/getNextBillNo")
	public void getNextBillNo(HttpServletResponse response, String w008) throws IOException {
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		Map<String, String> paramMap = new HashMap<String, String>();
		// 获取当前用户
		User user = TokenHolder.getUser();
		if (user.getUnitcode().equals("00") && !StringUtil.isEmpty(w008)) {
			paramMap.put("userid", user.getUserid());
			String yhbh = queryPaymentService.getBankIdByW008(w008);
			paramMap.put("yhbh", yhbh);
		} else {
			paramMap.put("userid", user.getUserid());
			paramMap.put("yhbh", user.getBankId());
		}
		// 添加操作日志
		LogUtil.write(new Log("票据信息", "获取下一张有效票据号", "ReceiptInfoMAction.getNextBillNo", paramMap.toString()));
		String result = receiptInfoMService.getNextBillNo(paramMap);
		// 返回结果
		pw.print(result);
	}

	/**
	 * 保存票据信息
	 */
	@RequestMapping("/receiptinfom/saveBillNo")
	public void saveBillNo(HttpServletRequest request, HttpServletResponse response) throws IOException {
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 接受请求参数
		String w011 = request.getParameter("w011");
		String h001 = request.getParameter("h001");
		String w008 = request.getParameter("w008");
		String w013 = request.getParameter("w013");
		Map<String, String> param = new HashMap<String, String>();
		param.put("w011", w011);
		param.put("h001", h001);
		param.put("w008", w008);
		if (!StringUtil.isEmpty(w013) && w013.length() >= 10) {
			param.put("w013", w013.substring(0, 10));
		} else {
			param.put("w013", w013);
		}

		User user = TokenHolder.getUser();
		param.put("username", user.getUsername());
		// 不走非税，生成数据指纹
		if (!param.containsKey("fingerprintData") || param.get("fingerprintData").equals("")) {
			String fingerprintData = buildFingerprintData(h001, w011);
			param.put("fingerprintData", fingerprintData);
		}
		param.put("result", "");
		// 添加操作日志
		LogUtil.write(new Log("票据信息", "保存票据信息", "ReceiptInfoMAction.saveBillNo", param.toString()));
		receiptInfoMService.saveBillNo(param);
		int result = Integer.valueOf(param.get("result").toString());
		// 返回结果
		pw.print(result);
	}

	/**
	 * 批量保存票据信息
	 */
	@RequestMapping("/receiptinfom/batchSaveBillNo")
	public void batchSaveBillNo(HttpServletRequest request, HttpServletResponse response) throws Exception {
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 接受请求参数
		String billNo = request.getParameter("billNo");
		String h001s = request.getParameter("h001s");
		String w008s = request.getParameter("w008s");
		String w013s = request.getParameter("w013s");
		Map<String, String> param = new HashMap<String, String>();
		param.put("billNo", billNo);
		param.put("h001s", h001s);
		param.put("w008s", w008s);
		param.put("w013s", w013s);
		param.put("result", "");
		// 添加操作日志
		LogUtil.write(new Log("票据信息", "批量保存票据信息", "ReceiptInfoMAction.batchSaveBillNo", param.toString()));
		try {
			receiptInfoMService.batchSaveBillNo(param);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
		int result = Integer.valueOf(param.get("result").toString());
		// 返回结果
		pw.print(result);
	}

	/**
	 * 根据房屋编号、票据号生成18位数字指纹
	 * 
	 * @param h001
	 * @param w011
	 * @return
	 */
	public static String buildFingerprintData(String h001, String w011) {
		String fingerprintData = h001 + w011;
		fingerprintData = MD5Util.encrypt(fingerprintData);
		fingerprintData = fingerprintData.substring(26).toUpperCase();
		return fingerprintData;
	}
}

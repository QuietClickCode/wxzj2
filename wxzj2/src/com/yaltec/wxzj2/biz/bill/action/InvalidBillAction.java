package com.yaltec.wxzj2.biz.bill.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletRequest;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.yaltec.comon.auth.TokenHolder;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.comon.core.entity.ReqPamars;
import com.yaltec.comon.log.LogUtil;
import com.yaltec.comon.log.entity.Log;
import com.yaltec.comon.utils.JsonUtil;
import com.yaltec.comon.utils.ObjectUtil;
import com.yaltec.comon.utils.StringUtil;
import com.yaltec.wxzj2.biz.bill.entity.ReceiptInfoM;
import com.yaltec.wxzj2.biz.bill.service.InvalidBillService;

/**
 * 
 * @ClassName: InvalidBillAction
 * @Description: TODO票据作废实现类
 * 
 * @author moqian
 * @date 2016-7-18 下午15:12:03
 */

@Controller
public class InvalidBillAction {

	@Autowired
	private InvalidBillService invalidBillService;

	/**
	 * 查询票据作废列表
	 */
	@RequestMapping("/invalidBill/index")
	public String index(Model model) {
		return "/bill/invalidBill/index";
	}

	/**
	 * 查询票据作废列表
	 */
	@RequestMapping("/invalidBill/list")
	public void list(@RequestBody ReqPamars<ReceiptInfoM> req, HttpServletRequest request, HttpServletResponse response)
			throws IOException {
		// 添加操作日志
		LogUtil.write(new Log("票据作废", "查询", "InvalidBillAction.list", req.toString()));
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 获取页面传入的查询条件，并存入map集合
		Map<String, Object> paramMap = req.getParams();
		paramMap.put("unitcode", TokenHolder.getUser().getUnitcode());
		Page<ReceiptInfoM> page = new Page<ReceiptInfoM>(req.getEntity(), req.getPageNo(), req.getPageSize());
		invalidBillService.find(page, paramMap);
		// 返回结果
		pw.print(page.toJson());
	}

	/**
	 * 跳转到票据作废编辑界面
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/invalidBill/toUpdate")
	public String toUpdate(String bm, String pjh, Model model, ServletRequest request) {
		ReceiptInfoM receiptInfoM = new ReceiptInfoM();
		receiptInfoM.setBm(bm);
		receiptInfoM.setPjh(pjh);
		receiptInfoM = invalidBillService.findByBmPjh(receiptInfoM);
		String w013 = receiptInfoM.getW013().startsWith("1900")? "": receiptInfoM.getW013();
		if (StringUtil.hasLength(w013) && w013.length() >= 10) {
			w013 = w013.substring(0, 10);
		}
		model.addAttribute("receiptInfoM", receiptInfoM);
		model.addAttribute("w013", w013);
		return "/bill/invalidBill/update";
	}

	/**
	 * 修改票据作废信息
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/invalidBill/update")
	public void update(HttpServletRequest request,RedirectAttributes redirectAttributes, HttpServletResponse response) {
		Map<String, String> map = JsonUtil.toObject(request.getParameter("data"), HashMap.class);
		// 添加操作日志
		LogUtil.write(new Log("票据作废", "修改", "InvalidBillAction.update", map.toString()));
		try {
			int result = invalidBillService.update(map);
			PrintWriter pw = response.getWriter();
			// 返回结果
			pw.print(JsonUtil.toJson(result));
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	/**
	 * 重新启用作废票据(批量启用)
	 */
	@RequestMapping("/invalidBill/do_ReUse")
	public void reUseInvalidBill(String bms, String pjhs, HttpServletResponse response) throws Exception {
		response.setCharacterEncoding("utf-8");
		// 添加操作日志
		LogUtil.write(new Log("票据作废", "批量启用", "InvalidBillAction.reUseInvalidBill", bms+";"+pjhs));
		PrintWriter pw = response.getWriter();
		try {
			// 将页面传入的参数以逗号(,)分割，并将分割结果存入数组中
			String[] bm = bms.split(",");
			String[] pjh = pjhs.split(",");
			int result = -1;
			if (ObjectUtil.isEmpty(bm) || StringUtil.isBlank(bm[0]) || ObjectUtil.isEmpty(pjh) || StringUtil.isBlank(pjh[0])) {
				pw.print(JsonUtil.toJson(result));
				return;
			}			
			for (int i = 0; i < bm.length; i++) {
				Map<String, String> map = new HashMap<String, String>();
				map.put("bm", bm[i]);
				map.put("pjh", pjh[i]);
				map.put("result", "1");
				invalidBillService.reUseInvalidBill(map);
				int re = Integer.valueOf(map.get("result").toString());
				pw.print(JsonUtil.toJson(re));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	
	/**
	 * 批量作废
	 */
	@RequestMapping("/invalidBill/batchInvalid")
	public void batchInvalid(String pjhs, String regNo, HttpServletResponse response) throws Exception {
		response.setCharacterEncoding("utf-8");
		// 添加操作日志
		LogUtil.write(new Log("票据作废", "批量作废", "InvalidBillAction.batchInvalid", pjhs+";"+regNo));
		PrintWriter pw = response.getWriter();
		try {
			// 将页面传入的参数以逗号(,)分割，并将分割结果存入数组中
			Map<String, String> map = new HashMap<String, String>();
			if (pjhs.length() >= 1) {
				pjhs = pjhs.substring(0, pjhs.length() - 1);
			}
			pjhs = "'"+pjhs.replaceAll(",", "','")+"'";
			map.put("pjh", pjhs);
			map.put("regNo", regNo);
			int result = invalidBillService.batchInvalid(map);
			pw.print(result);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
}

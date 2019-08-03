package com.yaltec.wxzj2.biz.voucher.action;

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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.github.pagehelper.StringUtil;
import com.yaltec.comon.auth.TokenHolder;
import com.yaltec.comon.core.entity.ReqPamars;
import com.yaltec.comon.log.LogUtil;
import com.yaltec.comon.log.entity.Log;
import com.yaltec.comon.utils.JsonUtil;
import com.yaltec.comon.utils.ObjectUtil;
import com.yaltec.comon.utils.Urlencryption;
import com.yaltec.wxzj2.biz.compositeQuery.service.ByCommunityForBService;
import com.yaltec.wxzj2.biz.draw.entity.CodeName;
import com.yaltec.wxzj2.biz.voucher.entity.BankDepositReceipt;
import com.yaltec.wxzj2.biz.voucher.service.BankDepositReceiptService;
import com.yaltec.wxzj2.biz.voucher.service.export.BankDepositReceiptExport;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * @ClassName: BankDepositReceiptAction
 * @Description: 银行进账单ACTION
 * 
 * @author moqian
 * @date 2016-9-5 下午16:04:38
 */
@Controller
public class BankDepositReceiptAction {

	@Autowired
	private BankDepositReceiptService bankDepositReceiptService;
	
	@Autowired
	private ByCommunityForBService byCommunityForBService;
	/**
	 * 日志记录器.
	 */
	private static final Logger logger = Logger.getLogger("bankDepositReceipt");

	/**
	 * 银行进账单首页
	 * 
	 * @return 跳转的JSP页面
	 */
	@RequestMapping("/bankDepositReceipt/index")
	public String index(Model model) {
		model.addAttribute("communitys", DataHolder.communityMap);
		model.addAttribute("banks", DataHolder.dataMap.get("bank"));
		model.addAttribute("assignment", DataHolder.dataMap.get("assignment"));
		model.addAttribute("user", TokenHolder.getUser());
		// 跳转的JSP页面
		return "/voucher/bankDepositReceipt/index";
	}

	/**
	 * 银行进账单查询列表
	 * 
	 */
	@RequestMapping("/bankDepositReceipt/list")
	public void list(@RequestBody ReqPamars<BankDepositReceipt> req, HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		// 添加操作日志
		LogUtil.write(new Log("银行进账单", "查询", "BankDepositReceiptAction.list",req.toString()));
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();

		List<BankDepositReceipt> list = bankDepositReceiptService.findAll(req.getParams());
		// 返回结果
		pw.print(JsonUtil.toJson(list));
	}
	
	/**
	 * 批量取消对账
	 * @param ids
	 *
	 */
	@RequestMapping("/bankDepositReceipt/batchDelete")
	public String delete(String ids, HttpServletResponse response, RedirectAttributes redirectAttributes) throws Exception  {
		response.setCharacterEncoding("utf-8");
		// 添加操作日志
		LogUtil.write(new Log("银行进账单", "批量取消对账", "BankDepositReceiptAction.delete",ids.toString()));
		try {
		// 将页面传入的参数以逗号(,)分割，并将分割结果存入数组中
		String[] id = ids.split(",");
		if (ObjectUtil.isEmpty(id) || StringUtil.isEmpty(id[0])) {
			redirectAttributes.addFlashAttribute("msg","获取数据异常，请请检查重试！");
        	return  "redirect:/bankDepositReceipt/index";
		}
		for (int i = 0; i < id.length; i++) {
			// 判断是否是九龙坡,1为九龙坡
			String isJLP = bankDepositReceiptService.isJLP();
			if (isJLP.equals("1")) {
				Map<String, String> map = new HashMap<String, String>();
				map.put("id", id[i]);
				map.put("result", "");
				bankDepositReceiptService.update_sql1(map);
			} else {
				Map<String, String> map = new HashMap<String, String>();
				map.put("id", id[i]);
				map.put("result", "");
				bankDepositReceiptService.update_sql2(map);
			   }
			redirectAttributes.addFlashAttribute("msg", "取消对账成功！");
			}
		}catch (Exception e) {
			e.printStackTrace();
			logger.error(e.getMessage());
		}
		// 跳转的JSP页面
		return "redirect:/bankDepositReceipt/index";
	}
	
	/**
	 * 根据银行编号查询小区信息
	 * @param request 
	 */
	@RequestMapping("/bankDepositReceipt/getCommunity")
	public void getCommunity(String yhbh, HttpServletRequest request,Model model,
			HttpServletResponse response) throws Exception  {
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		Map<String, String> map = new HashMap<String, String>();
		map.put("yhbh", yhbh);
		map.put("mc", "");
		// 根据银行编号获取对应的小区信息
		List<CodeName> list=byCommunityForBService.queryOpenCommunityByBank(map);
		// 返回结果
		pw.print(JsonUtil.toJson(list));				
	}
	
	/**
	 * 银行进账单的导出数据
	 */
	@RequestMapping("/bankDepositReceipt/exportBankDepositReceipt")
	public void exportBankDepositReceipt(HttpServletRequest request, HttpServletResponse response) {
		try {
			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("begindate", request.getParameter("begindate"));
			paramMap.put("enddate", request.getParameter("enddate"));
			paramMap.put("bank", request.getParameter("bank"));
			paramMap.put("ywbh", request.getParameter("ywbh"));
			paramMap.put("xqbh", request.getParameter("xqbh"));
			paramMap.put("xqmc", Urlencryption.unescape(request.getParameter("xqmc")));
			// 添加操作日志
			LogUtil.write(new Log("银行进账单", "导出", "BankDepositReceiptAction.exportBankDepositReceipt",paramMap.toString()));
			List<BankDepositReceipt> resultList = bankDepositReceiptService.findBankDepositReceipt(paramMap);
			
			BankDepositReceiptExport.exportBankDepositReceipt(resultList, response);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
}



package com.yaltec.wxzj2.biz.voucher.action;

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
import com.yaltec.comon.auth.TokenHolder;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.comon.core.entity.ReqPamars;
import com.yaltec.comon.utils.JsonUtil;
import com.yaltec.comon.utils.ObjectUtil;
import com.yaltec.comon.utils.StringUtil;
import com.yaltec.wxzj2.biz.voucher.entity.ReviewCertificate;
import com.yaltec.wxzj2.biz.voucher.entity.VoucherCheck;
import com.yaltec.wxzj2.biz.voucher.service.CancelAuditService;
import com.yaltec.wxzj2.biz.voucher.service.VoucherCheckService;
import com.yaltec.wxzj2.biz.voucher.service.export.CancelAuditExport;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 
 * @ClassName: CancelAuditAction
 * @Description: 撤销审核实现类
 * 
 * @author yangshanping
 * @date 2016-9-12 上午11:32:35
 */
@Controller
public class CancelAuditAction {

	@Autowired
	private CancelAuditService cancelAuditService;
	@Autowired
	private VoucherCheckService voucherCheckService;
	/**
	 * 日志记录器.
	 */
	private static final Logger logger = Logger.getLogger("CancelAudit");

	/**
	 * 撤销审核首页
	 * 
	 * @return 跳转的JSP页面
	 */
	@RequestMapping("/cancelaudit/index")
	public String index(Model model) {
		model.addAttribute("banks", DataHolder.dataMap.get("bank"));
		model.addAttribute("communitys", DataHolder.communityMap);
		model.addAttribute("user", TokenHolder.getUser());
		// 跳转的JSP页面
		return "/voucher/cancelaudit/index";
	}

	/**
	 * 凭证查询列表
	 * 
	 * @throws Exception
	 */
	@RequestMapping("/cancelaudit/list")
	public void list(@RequestBody ReqPamars<ReviewCertificate> req, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		Map<String, Object> paramMap = req.getParams();
		paramMap.put("unitcode", "");
		paramMap.put("lsnd", "");
		paramMap.put("amount", "0");
		// req.getParams().put("unitcode", TokenHolder.getUser().getUnitcode());
		paramMap.put("result", "0");
		Page<ReviewCertificate> page = new Page<ReviewCertificate>(req.getEntity(), req.getPageNo(), req.getPageSize());
		cancelAuditService.find(page, paramMap);
		// 返回结果
		pw.print(page.toJson());
	}

	/**
	 * 修改银行
	 * 
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping("/cancelaudit/updateBank")
	public void modifyBank(String bms, String yhbh, String yhmc, HttpServletResponse response) throws Exception {
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		String[] p005 = bms.split(",");
		String IsThereRecord = "";
		String result = "-1";
		Map<String, String> map = new HashMap<String, String>();
		map.put("yhbh", yhbh);
		map.put("yhmc", yhmc);
		
		if (ObjectUtil.isEmpty(p005) || StringUtil.isEmpty(p005[0])) {
			pw.print(JsonUtil.toJson(result));
			return;
		}
		try {
			for (int i = 0; i < p005.length; i++) {
				// 判断是否存在记录
				IsThereRecord = cancelAuditService.IsThereRecord(p005[i]);
				if (IsThereRecord.equals("0")) {
					result = "-2";
					pw.print(JsonUtil.toJson(result));
					throw new Exception("凭证编号有误（目前只支持一般的交款和支取），请重新选择！");
				}
				map.put("p005", p005[i]);
				map.put("result", result);
				int re = cancelAuditService.updateBank(map);
				pw.print(JsonUtil.toJson(re));
			}
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}

	/**
	 * 撤销审核数据导出
	 */

	@RequestMapping("/cancelaudit/export")
	public void exportReviewCertificate(HttpServletRequest request, HttpServletResponse response,
			RedirectAttributes redirectAttributes) {
		// 接收页面传参，并判断
		String strs = request.getParameter("str");
		if (strs == null || strs.equals("")) {
			redirectAttributes.addFlashAttribute("msg", "获取数据失败，请稍后重试！");
			return;
		}
		// 将页面传入的参数以逗号(,)分割，并将分割结果存入数组paras中
		String[] paras = strs.split(",");
		try {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("begindate", paras[0]);
			map.put("enddate", paras[1]);
			map.put("lsnd", "");
			map.put("bank", paras[4]);
			map.put("xqbh", paras[5]);
			map.put("sfrz", paras[2]);
			map.put("pzlx", paras[3]);
			map.put("cxlb", paras[6]);
			map.put("unitcode", "");
			map.put("result", "");
			// 查询导出数据
			List<ReviewCertificate> resultList = cancelAuditService.queryReviewCertificate(map);
			// 调用导出模版方法
			CancelAuditExport.exportReviewCertificate(resultList, response);
		} catch (Exception e) {
			logger.error(e.getMessage());
		}
	}

	/**
	 * 弹出凭证审核信息
	 * 
	 * @throws Exception
	 */
	@RequestMapping("/cancelaudit/toCheck")
	public String toCheck(Model model, HttpServletRequest request) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("cxnd", "0");
		map.put("p004", request.getParameter("p004"));
		map.put("lsnd", "当年");
		map.put("cxlb", request.getParameter("cxlb"));
		List<VoucherCheck> list = voucherCheckService.get(map);
		// 获取审核日期
		String checkDate = voucherCheckService.getCheckDate();
		// 获取起息日期
		String interestDate = voucherCheckService.getInterestDate(request.getParameter("p004"));
		// 获取财务日期
		String financeMonth = DataHolder.customerInfo.getFinanceMonth();
		if (StringUtil.hasLength(financeMonth) && financeMonth.length() >= 10) {
			financeMonth = financeMonth.substring(0, 8) + "01";
		}
		model.addAttribute("checkDate", checkDate);
		model.addAttribute("interestDate", interestDate);
		model.addAttribute("financeMonth", financeMonth);
		model.addAttribute("voucherChecks", JsonUtil.toJson(list));
		model.addAttribute("cxnd", "0");// 查询年度
		model.addAttribute("lsnd", "当年");// 历史年度
		model.addAttribute("bm", request.getParameter("bm"));
		model.addAttribute("cxlb", request.getParameter("cxlb"));
		model.addAttribute("p004", request.getParameter("p004"));
		model.addAttribute("user", TokenHolder.getUser());
		// 跳转的JSP页面
		return "/voucher/comon/opencheck/index";
	}

	/**
	 * 凭证审核_撤消审核_撤消审核
	 * 
	 * @throws Exception
	 */
	@RequestMapping("/cancelaudit/cancel")
	public void cancel(String p004s, String p005s, HttpServletResponse response) throws Exception {
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		try {
			// 将页面传入的参数以逗号(,)分割，并将分割结果存入数组中
			String[] p005 = p005s.split(",");
			String[] p004 = p004s.split(",");
			int result = -1;
			if (ObjectUtil.isEmpty(p005) || StringUtil.isEmpty(p005[0])) {
				pw.print(result);
				return;
			}
			cancelAuditService.cancelAudit(p004, p005);
			pw.print(0);
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e.getMessage());
			throw e;
		}
	}

}

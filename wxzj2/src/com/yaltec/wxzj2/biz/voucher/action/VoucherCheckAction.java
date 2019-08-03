package com.yaltec.wxzj2.biz.voucher.action;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
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
import org.springframework.web.servlet.ModelAndView;

import com.yaltec.comon.auth.TokenHolder;
import com.yaltec.comon.core.entity.ReqPamars;
import com.yaltec.comon.utils.ChangeRMB;
import com.yaltec.comon.utils.JsonUtil;
import com.yaltec.comon.utils.StringUtil;
import com.yaltec.wxzj2.biz.property.service.HouseService;
import com.yaltec.wxzj2.biz.voucher.entity.QueryVoucherCheck;
import com.yaltec.wxzj2.biz.voucher.entity.VoucherAnnex;
import com.yaltec.wxzj2.biz.voucher.entity.VoucherCheck;
import com.yaltec.wxzj2.biz.voucher.service.VoucherCheckService;
import com.yaltec.wxzj2.biz.voucher.service.print.VoucherAnnexPDF;
import com.yaltec.wxzj2.biz.voucher.service.print.VoucherCheckPDF;
import com.yaltec.wxzj2.biz.voucher.service.print.VoucherCheckPrint;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * @ClassName: VoucherCheckAction
 * @Description: 凭证审核ACTION
 * 
 * @author jiangyong
 * @date 2016-7-7 上午10:04:38
 */
@Controller
public class VoucherCheckAction {

	@Autowired
	private VoucherCheckService voucherCheckService;
	@Autowired
	private HouseService houseService;

	/**
	 * 凭证审核首页
	 * 
	 * @return 跳转的JSP页面
	 */
	@RequestMapping("/vouchercheck/index")
	public String index(Model model) {
		model.addAttribute("banks", DataHolder.dataMap.get("bank"));
		model.addAttribute("communitys", DataHolder.communityMap);
		model.addAttribute("user", TokenHolder.getUser());
		// 跳转的JSP页面
		return "/voucher/vouchercheck/index";
	}

	/**
	 * 凭证查询列表
	 * 
	 * @throws Exception
	 */
	@RequestMapping("/vouchercheck/list")
	public void list(@RequestBody ReqPamars<QueryVoucherCheck> req, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();

		req.getParams().put("unitcode", "");
		// req.getParams().put("unitcode", TokenHolder.getUser().getUnitcode());
		req.getParams().put("result", "0");

		List<QueryVoucherCheck> list = voucherCheckService.findAll(req.getParams());
		// 返回结果
		pw.print(JsonUtil.toJson(list));
	}

	/**
	 * 弹出凭证审核信息
	 * 
	 * @throws Exception
	 */
	@RequestMapping("/vouchercheck/toCheck")
	public String toCheck(Model model, HttpServletRequest request) throws Exception {
		
		String lsnd = request.getParameter("lsnd");
		String cxnd = "1";
		if (StringUtil.isEmpty(lsnd)) {
			lsnd = "当年";
			cxnd = "0";
		}
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("cxnd", cxnd);
		map.put("lsnd", lsnd);
		map.put("p004", request.getParameter("bm"));
		map.put("cxlb", request.getParameter("cxlb"));
		
		List<VoucherCheck> list = voucherCheckService.get(map);
		// 获取审核日期
		String checkDate = voucherCheckService.getCheckDate();
		// 获取起息日期
		String interestDate = voucherCheckService.getInterestDate(request.getParameter("p004"));
		// 获取财务日期
		String financeMonth = DataHolder.customerInfo.getFinanceMonth();
		if (DataHolder.customerInfo.isJLP()) {
			financeMonth = interestDate;
		} else {
			if (StringUtil.hasLength(financeMonth) && financeMonth.length() >= 10) {
				financeMonth = financeMonth.substring(0, 8) + "01";
			}
		}
		
		model.addAttribute("checkDate", checkDate);
		model.addAttribute("interestDate", interestDate);
		model.addAttribute("financeMonth", financeMonth);
		
		String result = JsonUtil.toJson(list);
		// 转义换行符
		result = result.replaceAll("\\\\n", "、");
		model.addAttribute("voucherChecks", result);
		model.addAttribute("cxnd", cxnd);// 查询年度
		model.addAttribute("lsnd", lsnd);// 历史年度
		model.addAttribute("bm", request.getParameter("bm"));
		model.addAttribute("cxlb", request.getParameter("cxlb"));
		model.addAttribute("p004", request.getParameter("p004"));
		model.addAttribute("user", TokenHolder.getUser());
		// 跳转的JSP页面
		return "/voucher/comon/opencheck/index";
	}

	/**
	 * 保存凭证审核
	 * 
	 * @throws IOException
	 * 
	 * @throws Exception
	 */
	@RequestMapping("/vouchercheck/save")
	public void save(HttpServletRequest request, HttpServletResponse response) throws IOException {
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();

		Map<String, Object> map = new HashMap<String, Object>();
		String p004 = request.getParameter("p004");
		String fhsj = request.getParameter("fhsj");
		String qxsj = request.getParameter("qxsj");
		String p022 = request.getParameter("p022");
		String fhr = TokenHolder.getUser().getUsername();
		map.put("p004", p004);
		map.put("fhsj", fhsj);
		map.put("qxsj", qxsj);
		map.put("qxsj", qxsj);
		map.put("p022", p022);
		map.put("fhr", fhr);
		map.put("result", "-1");
		voucherCheckService.save(map);
		int result = Integer.valueOf(map.get("result").toString());
		// 返回结果
		pw.print(result);
	}

	/**
	 * 打印预览
	 * 
	 * @throws Exception
	 */
	@RequestMapping("/vouchercheck/print")
	public ModelAndView print(HttpServletRequest request, HttpServletResponse response) throws Exception {
		// 查询条件
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("cxlb", request.getParameter("cxlb"));
		paramMap.put("p004", request.getParameter("p004"));
		paramMap.put("current", request.getParameter("current"));
		paramMap.put("p022", request.getParameter("p022"));
		paramMap.put("cxnd", request.getParameter("cxnd"));
		paramMap.put("lsnd", request.getParameter("lsnd"));
		List<VoucherCheck> list = voucherCheckService.get(paramMap);
		if (list.size() >= 1) {
			list.get(list.size() - 1).setDxhj(ChangeRMB.doChangeRMB(list.get(list.size() - 1).getP008()));
		}
		// 传参容器
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("list", list);
		map.putAll(paramMap);
		VoucherCheckPDF view = new VoucherCheckPDF();
		// 设置参数
		view.setAttributesMap(map);
		// 返回视图
		return new ModelAndView(view);
	}
	
	/**
	 * 弹出凭证附件页面
	 * 
	 * @throws Exception
	 */
	@RequestMapping("/vouchercheck/toVoucherAnnex")
	public String toVoucherAnnex(Model model, HttpServletRequest request) throws Exception {
		model.addAttribute("nd", request.getParameter("nd"));// 历史年度
		model.addAttribute("bm", request.getParameter("bm"));
		model.addAttribute("user", TokenHolder.getUser());
		// 跳转的JSP页面
		return "/voucher/comon/annex/index";
	}
	
	/**
	 * 凭证附件列表
	 * 
	 * @throws Exception
	 */
	@RequestMapping("/vouchercheck/voucherannex/list")
	public void voucherAnnexList(@RequestBody ReqPamars<QueryVoucherCheck> req, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		List<VoucherAnnex> list = voucherCheckService.findVoucherAnnex(req.getParams());
		// 返回结果
		pw.print(JsonUtil.toJson(list));
	}
	
	/**
	 * 交款查询-打印清册
	 */
	@RequestMapping("/vouchercheck/voucherannex/listPrint")
	public ModelAndView listPrint(HttpServletRequest request, HttpServletResponse response) {
		// 查询条件
		Map<String, Object> paramMap = new HashMap<String, Object>();
    	paramMap.put("bm", request.getParameter("bm"));
    	paramMap.put("nd", request.getParameter("nd"));
    	List<VoucherAnnex> list = voucherCheckService.findVoucherAnnex(paramMap);
    	// 凭证摘要
    	String summary = voucherCheckService.GetSummaryByP004(paramMap);
		// 传参容器
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("list", list);
		map.put("summary", summary);
		
		VoucherAnnexPDF view = new VoucherAnnexPDF();
		// 设置参数
		view.setAttributesMap(map);
		// 返回视图
		return new ModelAndView(view);
	}
	
	/**
	 * 打印凭证(可实现批量打印)
	 * 
	 * @throws Exception
	 */
	@RequestMapping("/vouchercheck/toPrint")
	public ByteArrayOutputStream toPrint(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ByteArrayOutputStream ops = null;
		try {
			// 获取p004，并去掉字符串中末尾的逗号
			String strs = request.getParameter("p004s");
			String[] p004s = strs.substring(0, strs.length()-1).split(",");
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("cxlb", "0");
			map.put("cxnd", "0");
			map.put("lsnd", "当年");
			map.put("p022", "1");
			map.put("current", 1);
			String p022 = "1";// 附件张数
			int current = 1;
			List<List> list = new ArrayList<List>();
			List<VoucherCheck> resultList = null;
			for (String p004 : p004s) {
				if (p004.trim().equals(""))
					continue;
				map.put("p004", p004);
				resultList = voucherCheckService.get(map);
				if (resultList.size() >= 1) {
					resultList.get(resultList.size() - 1).setDxhj(
							ChangeRMB.doChangeRMB(resultList.get(resultList.size() - 1).getP008()));
				}
				// 将查询出来的数据，放入list集合
				list.add(resultList);
			}
			// 打印模版
			VoucherCheckPrint pdf = new VoucherCheckPrint();
			ops = pdf.creatManyPDF(list, current);
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
		// 打印
		if (ops != null) {
			houseService.output(ops, response);
		}
		return ops;
	}

}

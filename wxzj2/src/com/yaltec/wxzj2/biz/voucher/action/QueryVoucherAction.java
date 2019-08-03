package com.yaltec.wxzj2.biz.voucher.action;

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
import com.yaltec.comon.auth.TokenHolder;
import com.yaltec.comon.core.entity.ReqPamars;
import com.yaltec.comon.utils.JsonUtil;
import com.yaltec.comon.utils.Urlencryption;
import com.yaltec.wxzj2.biz.voucher.entity.QueryVoucherCheck;
import com.yaltec.wxzj2.biz.voucher.service.QueryVoucherService;
import com.yaltec.wxzj2.biz.voucher.service.VoucherCheckService;
import com.yaltec.wxzj2.biz.voucher.service.export.QueryVoucherExport;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * @ClassName: EntryVoucherAction
 * @Description: 凭证审核ACTION
 * 
 * @author jiangyong
 * @date 2016-7-7 上午10:04:38
 */
@Controller
public class QueryVoucherAction {

	@Autowired
	private VoucherCheckService voucherCheckService;
	
	@Autowired
	private QueryVoucherService queryVoucherService;

	/**
	 * 凭证审核首页
	 * 
	 * @return 跳转的JSP页面
	 */
	@RequestMapping("/queryvoucher/index")
	public String index(Model model) {
		// 历史年度
		List<String> list = queryVoucherService.getHistoryYear();
		model.addAttribute("historyYear", list);
//		model.addAttribute("assignment", DataHolder.dataMap.get("assignment"));
		model.addAttribute("banks", DataHolder.dataMap.get("bank"));
		model.addAttribute("communitys", DataHolder.communityMap);
		model.addAttribute("user", TokenHolder.getUser());
		// 跳转的JSP页面
		return "/voucher/queryvoucher/index";
	}

	/**
	 * 凭证查询列表
	 * 
	 * @throws Exception
	 */
	@RequestMapping("/queryvoucher/list")
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
	 * 导出待审核数据
	 * @param request
	 * @param response
	 */
	@RequestMapping("/queryvoucher/exportDataP")
	public void exportDataP(HttpServletRequest request, HttpServletResponse response) {
		// 获取页面传入的参数，并以逗号(,)分割，存入数组中
		String paras = request.getParameter("str");
		String[] strs = paras.split(",");
		try {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("begindate", strs[0]);
			map.put("enddate", strs[1]);
			map.put("sfrz", strs[2]);
			map.put("pzlx", strs[3]);
			map.put("bank", strs[4]);
			map.put("xqbh", strs[5]);
			map.put("lsnd", Urlencryption.unescape(strs[6]));
			map.put("dateType", strs[7]);
			map.put("cxlb", "1");
			map.put("unitcode", "");
			map.put("result", "0");
			List<QueryVoucherCheck> list = voucherCheckService.findAll(map);
			QueryVoucherExport.exportQueryVoucherP(list, response);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 导出已审核数据
	 * @param request
	 * @param response
	 */
	@RequestMapping("/queryvoucher/exportDataC")
	public void exportDataC(HttpServletRequest request, HttpServletResponse response) {
		// 获取页面传入的参数，并以逗号(,)分割，存入数组中
		String paras = request.getParameter("str");
		String[] strs = paras.split(",");
		try {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("begindate", strs[0]);
			map.put("enddate", strs[1]);
			map.put("sfrz", strs[2]);
			map.put("pzlx", strs[3]);
			map.put("bank", strs[4]);
			map.put("xqbh", strs[5]);
			map.put("lsnd", Urlencryption.unescape(strs[6]));
			map.put("dateType", strs[7]);
			map.put("cxlb", "2");
			map.put("unitcode", "");
			map.put("result", "0");
			List<QueryVoucherCheck> list = voucherCheckService.findAll(map);
			QueryVoucherExport.exportQueryVoucherC(list, response);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}

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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.yaltec.comon.auth.TokenHolder;
import com.yaltec.comon.core.entity.ReqPamars;
import com.yaltec.comon.log.LogUtil;
import com.yaltec.comon.log.entity.Log;
import com.yaltec.comon.utils.JsonUtil;
import com.yaltec.comon.utils.StringUtil;
import com.yaltec.wxzj2.biz.voucher.entity.ReviewCertificate;
import com.yaltec.wxzj2.biz.voucher.entity.Subject;
import com.yaltec.wxzj2.biz.voucher.entity.VoucherCheck;
import com.yaltec.wxzj2.biz.voucher.service.EntryVoucherService;
import com.yaltec.wxzj2.biz.voucher.service.SubjectService;
import com.yaltec.wxzj2.biz.voucher.service.VoucherCheckService;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * @ClassName: EntryVoucherAction
 * @Description: 凭证录入ACTION
 * 
 * @author jiangyong
 * @date 2016-7-7 上午10:04:38
 */
@Controller
public class EntryVoucherAction {

	@Autowired
	private EntryVoucherService entryVoucherService;

	@Autowired
	private SubjectService subjectService;

	@Autowired
	private VoucherCheckService voucherCheckService;

	/**
	 * 凭证录入首页
	 * 
	 * @return 跳转的JSP页面
	 */
	@RequestMapping("/entryvoucher/index")
	public String index(Model model) {
		model.addAttribute("assignment", DataHolder.dataMap.get("assignment"));
		model.addAttribute("user", TokenHolder.getUser());
		// 跳转的JSP页面
		return "/voucher/entryvoucher/index";
	}

	/**
	 * 查询凭证录入信息
	 * 
	 */
	@RequestMapping("/entryvoucher/list")
	public void list(@RequestBody ReqPamars<ReviewCertificate> req, HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();

		List<ReviewCertificate> list = entryVoucherService.findAll(req.getParams());
		// 返回结果
		pw.print(JsonUtil.toJson(list));
	}

	/**
	 * 跳转到凭证信息新增页面
	 * 
	 * @throws Exception
	 */
	@RequestMapping("/entryvoucher/toAdd")
	public String toAdd(Model model, HttpServletRequest request) throws Exception {
		model.addAttribute("cxnd", "0");
		model.addAttribute("lsnd", "当年");
		model.addAttribute("cxlb", "0");
		String bm = request.getParameter("bm");
		if (!StringUtil.isEmpty(bm)) {
			model.addAttribute("bm", bm);
			model.addAttribute("p004", bm);
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("cxnd", "0");
			map.put("p004", bm);
			map.put("lsnd", "当年");
			map.put("cxlb", "0");
			List<VoucherCheck> list = voucherCheckService.get(map);
			model.addAttribute("voucherChecks", JsonUtil.toJson(list));
		}
		// 凭证摘要
		model.addAttribute("voucher", DataHolder.dataMap.get("voucher"));
		// 用户
		model.addAttribute("user", TokenHolder.getUser());
		return "/voucher/entryvoucher/add";
	}

	/**
	 * 保存凭证录入信息
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/entryvoucher/add")
	public String add(VoucherCheck voucherCheck, HttpServletRequest request, Model model,
			RedirectAttributes redirectAttributes) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("p005", request.getParameter("fp005"));
		map.put("p006", request.getParameter("fp006"));
		map.put("p007", request.getParameter("fp007"));
		map.put("p008", request.getParameter("fp008"));
		map.put("p009", request.getParameter("fp009"));
		map.put("p018", request.getParameter("fp018"));
		map.put("p019", request.getParameter("fp019"));
		map.put("p021", request.getParameter("fp021"));
		map.put("user", TokenHolder.getUser().getUsername());
		map.put("p022", request.getParameter("fp022"));
		map.put("result", "0");
		map.put("userid", TokenHolder.getUser().getUserid());
		map.put("username", TokenHolder.getUser().getUsername());
		try {
			int result = entryVoucherService.add(map);
			if (result == 0) {
				redirectAttributes.addFlashAttribute("msg", "添加凭证成功");
			} else {
				if (result == -1) {
					redirectAttributes.addFlashAttribute("msg", "删除原凭证信息失败");
				} else {
					redirectAttributes.addFlashAttribute("msg", "保存凭证信息失败");
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			redirectAttributes.addFlashAttribute("msg", "保存凭证信息异常");
		}
		return "redirect:/entryvoucher/index";
	}
	
	/**
	 * 批量删除
	 * 
	 * @param bm
	 * @param request
	 * @param model
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping("/entryvoucher/batchDelete")
	public String batchDelete(String p004s, HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
		LogUtil.write(new Log("凭证录入", "批量删除", "EntryVoucherAction.batchDelete", p004s));
		// 按特定的分隔符把字符串转成List集合
		List<String> p004List = StringUtil.tokenize(p004s, ",");
		int result = entryVoucherService.batchDelete(p004List);
		if (result > 0) {
			redirectAttributes.addFlashAttribute("msg", "删除成功");
		} else {
			redirectAttributes.addFlashAttribute("msg", "删除失败");
		}
		return "redirect:/entryvoucher/index";
	}

	/**
	 * 弹出科目信息页面
	 */
	@RequestMapping("/entryvoucher/openSubject/index")
	public String openSubjectIndex(Model model) {
		// 科目类别
		model.addAttribute("subjectItem", subjectService.findSubjectItem());
		return "/voucher/entryvoucher/opensubject/index";
	}

	/**
	 * 查询科目信息列表
	 */
	@RequestMapping("/entryvoucher/openSubject/list")
	public void openSubjectList(@RequestBody ReqPamars<ReviewCertificate> req, HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();

		String itemId = req.getParams().get("itemId").toString();
		List<Subject> list = subjectService.findByItemId(itemId);
		// 返回结果
		pw.print(JsonUtil.toJson(list));
	}

}

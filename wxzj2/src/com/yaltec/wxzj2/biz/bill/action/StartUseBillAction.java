package com.yaltec.wxzj2.biz.bill.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
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
import com.yaltec.comon.utils.JsonUtil;
import com.yaltec.comon.log.LogUtil;
import com.yaltec.comon.log.entity.Log;
import com.yaltec.wxzj2.biz.bill.entity.BillM;
import com.yaltec.wxzj2.biz.bill.entity.ReceiptInfoM;
import com.yaltec.wxzj2.biz.bill.service.BillMService;
import com.yaltec.wxzj2.biz.bill.service.StartUseBillService;
import com.yaltec.wxzj2.biz.draw.entity.CodeName;
import com.yaltec.wxzj2.biz.system.service.UserService;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 
 * @ClassName: StartUseBillAction
 * @Description: TODO票据领用实现类
 * 
 * @author moqian
 * @date 2016-7-18 下午15:12:03
 */

@Controller
public class StartUseBillAction {
	@Autowired
	private StartUseBillService startUseBillService;

	@Autowired
	private BillMService billMService;

	@Autowired
	private UserService userService;

	/**
	 * 查询票据信息列表
	 */
	@RequestMapping("/startUseBill/index")
	public String index(Model model) {
		model.addAttribute("banks", DataHolder.dataMap.get("bank"));
		model.addAttribute("user", TokenHolder.getUser());
		return "/bill/startUseBill/index";
	}

	/**
	 * 查询票据领用信息列表
	 * 
	 * @param paramMap
	 */
	@RequestMapping("/startUseBill/list")
	public void list(@RequestBody ReqPamars<ReceiptInfoM> req, HttpServletRequest request, HttpServletResponse response)
			throws IOException {
		// 添加操作日志
		LogUtil.write(new Log("票据领用", "查询", "StartUseBillAction.list", req.toString()));
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 获取页面传入的查询条件，并存入map集合
		Map<String, Object> paramMap = req.getParams();

		Page<ReceiptInfoM> page = new Page<ReceiptInfoM>(req.getEntity(), req.getPageNo(), req.getPageSize());
		startUseBillService.find(page, paramMap);
		// 返回结果
		pw.print(page.toJson());
	}

	/**
	 *跳转到添加票据领用页面
	 */
	@RequestMapping("/startUseBill/toAdd")
	public String toAdd(HttpServletRequest request, Model model) {
		model.addAttribute("pjlbmcs", DataHolder.billTypeMap);
		model.addAttribute("user", TokenHolder.getUser());
		return "/bill/startUseBill/add";
	}

	/**
	 * 查询编码【弹出界面】
	 */
	@RequestMapping("/startUseBill/showBm")
	public String openlist(Integer pageNo, Integer pageSize, BillM billM, String bankId, Model model) {
		billM.setYhbh(bankId);
		Page<BillM> page = new Page<BillM>(billM, pageNo, pageSize);
		billMService.findAll(page);
		model.addAttribute("page", page);
		model.addAttribute("billM", billM);
		return "/bill/startUseBill/bmSearch";
	}

	/**
	 * 保存添加票据领用
	 * 
	 * @param request
	 * @param request
	 * @return
	 */
	@RequestMapping("/startUseBill/add")
	public String add(String bm, String qsh, String zzh, String userid, ServletRequest request, Model model,
			RedirectAttributes redirectAttributes) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("bm", bm);
		map.put("qsh", qsh);
		map.put("zzh", zzh);
		map.put("userid", userid);
		// 添加操作日志
		LogUtil.write(new Log("票据领用", "添加", "StartUseBillAction.add", map.toString()));
		int result = startUseBillService.save(map);
		if (result > 0) {
			redirectAttributes.addFlashAttribute("msg", "添加成功！");
			return "redirect:/startUseBill/index";
		} else {
			request.setAttribute("msg", "添加失败！");
			model.addAttribute("pjlbmcs", DataHolder.billTypeMap);
			return "/bill/startUseBill/add";
		}
	}

	/**
	 * 检查票据是否已领用
	 */
	@RequestMapping("/startUseBill/check")
	public void check(HttpServletRequest request, Model model, HttpServletResponse response) throws IOException {
		// 获取参数
		Map<String, String> paramMap = new HashMap<String, String>();
		paramMap.put("bm", request.getParameter("bm"));
		paramMap.put("beginBillNo", request.getParameter("beginBillNo"));
		paramMap.put("endBillNo", request.getParameter("endBillNo"));
		String result = startUseBillService.check(paramMap);
		result = result.equals("") ? "0" : result;
		// 返回数据
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		pw.print(Integer.valueOf(result));
	}

	/**
	 * 根据银行编号查询用户信息
	 * 
	 * @param request
	 * @throws Exception
	 */
	@RequestMapping("/startUseBill/getUsernames")
	public void getUsernames(String yhbh, HttpServletRequest request, Model model, HttpServletResponse response)
			throws Exception {
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 根据银行编号获取对应的小区信息
		List<CodeName> list = userService.getUserByBank(yhbh);
		// 返回结果
		pw.print(JsonUtil.toJson(list));
	}

	/**
	 * 清除票据领用人
	 */
	@RequestMapping("/startUseBill/clearOwner")
	public void clearOwner(HttpServletRequest request, Model model, HttpServletResponse response) throws IOException {
		// 获取参数
		Map<String, String> paramMap = new HashMap<String, String>();
		paramMap.put("xsqy", request.getParameter("xsqy"));
		paramMap.put("yhbh", request.getParameter("yhbh"));
		paramMap.put("pjh", request.getParameter("pjh"));
		paramMap.put("usepart", request.getParameter("usepart"));
		paramMap.put("qsh", request.getParameter("qsh"));
		paramMap.put("zzh", request.getParameter("zzh"));
		int result = startUseBillService.clearOwner(paramMap);
		// 返回数据
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		pw.print(Integer.valueOf(result));
	}
	
}

package com.yaltec.wxzj2.biz.propertymanager.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.yaltec.comon.auth.TokenHolder;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.comon.core.entity.ReqPamars;
import com.yaltec.comon.log.LogUtil;
import com.yaltec.comon.log.entity.Log;
import com.yaltec.wxzj2.biz.propertymanager.entity.MoneyTransfer;
import com.yaltec.wxzj2.biz.propertymanager.service.MoneyTransferService;
import com.yaltec.wxzj2.biz.system.entity.User;
import com.yaltec.wxzj2.comon.data.DataHolder;

@Controller
public class MoneyTransferAction {

	@Autowired
	private MoneyTransferService moneyTransferservice;

	/**
	 * 跳转到首页
	 */
	@RequestMapping("/moneyTransfer/index")
	public String index(Model model) {
		return "/propertymanager/moneyTransfer/index";
	}

	/**
	 * 查询交款转移信息
	 * 
	 * @param req
	 * @param request
	 * @param response
	 * @param model
	 * @throws IOException
	 */
	@RequestMapping("/moneyTransfer/list")
	public void list(@RequestBody ReqPamars<MoneyTransfer> req, HttpServletRequest request,
			HttpServletResponse response, ModelMap model) throws IOException {
		response.setCharacterEncoding("utf-8");
		Map<String, Object> paramMap = req.getParams();
		paramMap.put("nret", "");
		Page<MoneyTransfer> page = new Page<MoneyTransfer>(req.getEntity(), req.getPageNo(), req.getPageSize());
		moneyTransferservice.findAll(page, paramMap);
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 返回结果
		pw.print(page.toJson());
	}

	/**
	 * 跳转添加页面
	 * 
	 * @param request
	 * @param model
	 * @param user
	 * @return
	 */
	@RequestMapping("/moneyTransfer/add")
	public String toPrintSet(HttpServletRequest request, Model model, User user) {
		model.addAttribute("h012", DataHolder.dataMap.get("houseproperty"));
		model.addAttribute("h023", DataHolder.dataMap.get("deposit"));
		return "/propertymanager/moneyTransfer/add";
	}

	/**
	 * 保存交款转移
	 * 
	 * @param request
	 * @param model
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping("/moneyTransfer/save")
	public String delBuildingTransfer(HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
		String paras = request.getParameter("str");
		if (paras.isEmpty()) {
			redirectAttributes.addFlashAttribute("msg", "获取数据异常，请请检查重试！");
			return "redirect:/moneyTransfer/index";
		}
		if (paras.isEmpty()) {
			redirectAttributes.addFlashAttribute("msg", "获取数据异常，请请检查重试！");
			return "redirect:/moneyTransfer/index";
		}
		String[] str = paras.split(";");
		Map<String, String> paramMap = new HashMap<String, String>();
		paramMap.put("jfh001", str[0]);
		paramMap.put("dfh001", str[1]);
		paramMap.put("lybha", str[2]);
		paramMap.put("lybhb", str[3]);
		paramMap.put("ywrq", str[4]);
		paramMap.put("zybj", str[5]);
		paramMap.put("zylx", str[6]);
		paramMap.put("userid", TokenHolder.getUser().getUserid());
		paramMap.put("username", TokenHolder.getUser().getUsername());
		paramMap.put("result", "0");
		moneyTransferservice.save(paramMap);
		int result = Integer.valueOf(paramMap.get("result"));
		redirectAttributes.addFlashAttribute("result", result);
		return "redirect:/moneyTransfer/index";
	}

	/**
	 * 交款调整， 交款转移 【删除】
	 * 
	 * @param w008
	 * @param request
	 * @param model
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping("/moneyTransfer/delete")
	public String delete(String w008, HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
		// 添加操作日志
		LogUtil.write(new Log("交款转移信息", "删除", "HouseAction.delete", w008));
		Map<String, String> paramMap = new HashMap<String, String>();
		paramMap.put("w008", w008);
		moneyTransferservice.delete(paramMap);
		int result = 0;
		if (result == 0) {
			redirectAttributes.addFlashAttribute("msg", "删除成功！");
		}
		return "redirect:/moneyTransfer/index";
	}

}

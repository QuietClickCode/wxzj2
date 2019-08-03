package com.yaltec.wxzj2.biz.system.action;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.comon.core.entity.ReqPamars;
import com.yaltec.comon.log.LogUtil;
import com.yaltec.comon.log.entity.Log;
import com.yaltec.wxzj2.biz.system.entity.Bank;
import com.yaltec.wxzj2.biz.system.service.BankService;
import com.yaltec.wxzj2.comon.data.DataHolder;
import com.yaltec.wxzj2.comon.data.service.BankDataService;

/**
 * 
 * @ClassName: BankAction
 * @Description: TODO 银行设置信息实现类
 * 
 * @author hequanxin
 * @date 2016-7-13 上午10:08:41
 */
@Controller
public class BankAction {

	@Autowired
	private BankService bankService;
	
	/**
	 * 查询银行设置列表
	 * 
	 * @return 跳转的JSP页面
	 */
	@RequestMapping("/bank/index")
	public String index() {
		// 跳转的JSP页面
		return "/system/bank/index";
	}

	/**
	 * 查询银行设置列表
	 * 
	 */
	@RequestMapping("/bank/list")
	public void list(@RequestBody ReqPamars<Bank> req, HttpServletRequest request, HttpServletResponse response)
			throws IOException {
		LogUtil.write(new Log("银行设置信息", "查询", "BankAction.list", req.toString()));
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();

		Page<Bank> page = new Page<Bank>(req.getEntity(), req.getPageNo(), req.getPageSize());
		bankService.findAll(page);
		// 返回结果
		pw.print(page.toJson());
	}
	
	/**
	 * 银行添加页面
	 */
	@RequestMapping("/bank/toAdd")
	public String toAdd(HttpServletRequest request){
		return "/system/bank/add";
	}
	
	/**
	 * 保存银行信息
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/bank/add")
	public String add(Bank bank, HttpServletRequest request, Model model,
			RedirectAttributes redirectAttributes) {
		if(bankService.findByMc(bank) != null) {
			request.setAttribute("msg", "添加失败，银行名称已存在，请检查！");
			return "/system/bank/add";
		}
		LogUtil.write(new Log("银行设置信息", "添加", "BankAction.add", bank.toString()));
		int result = bankService.add(bank);
		if (result > 0) {
			// 更新缓存
			DataHolder.updateDataMap(BankDataService.KEY, bank.getBm(), bank.getMc());
			redirectAttributes.addFlashAttribute("msg", "添加成功");
			return "redirect:/bank/index";
		} else {
			request.setAttribute("msg", "添加失败");
			return "/system/bank/add";
		}
	}
	
	/**
	 * 跳转到银行管理信息编辑界面
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/bank/toUpdate")
	public String toUpdate(String bm, Model model) {
		Bank bank = bankService.findByBm(bm);
		model.addAttribute("bank", bank);
		return "/system/bank/update";
	}
	
	/**
	 * 修改银行管理信息
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/bank/update")
	public String update(Bank bank, HttpServletRequest request, Model model,
			RedirectAttributes redirectAttributes) {
		if(bankService.findByMc(bank) != null) {
			request.setAttribute("msg", "修改失败，银行名称已存在，请检查！");
			return "/system/bank/update";
		}
		LogUtil.write(new Log("银行设置信息", "修改", "BankAction.update", bank.toString()));
		int result = bankService.update(bank);
		if (result > 0) {
			// 更新缓存
			DataHolder.updateDataMap(BankDataService.KEY, bank.getBm(), bank.getMc());
			redirectAttributes.addFlashAttribute("msg", "修改成功");
			return "redirect:/bank/index";
		} else {
			request.setAttribute("msg", "修改失败");
			return "/system/bank/update";
		}
	}
}

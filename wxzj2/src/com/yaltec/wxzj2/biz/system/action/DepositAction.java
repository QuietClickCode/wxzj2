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
import com.yaltec.wxzj2.biz.comon.service.IdUtilService;
import com.yaltec.wxzj2.biz.system.entity.Deposit;
import com.yaltec.wxzj2.biz.system.service.DepositService;
import com.yaltec.wxzj2.comon.data.DataHolder;
import com.yaltec.wxzj2.comon.data.service.DepositDataService;

/**
 * 
 * @ClassName: DepositAction
 * @Description: TODO 交存标准实现类
 * 
 * @author jiangyong
 * @date 2016-7-13 上午10:08:41
 */
@Controller
public class DepositAction {

	@Autowired
	private DepositService depositService;
	
	@Autowired
	private IdUtilService idUtilService;
	
	/**
	 * 查询交存标准设置列表
	 * 
	 * @return 跳转的JSP页面
	 */
	@RequestMapping("/deposit/index")
	public String index(Model model) {
		// 跳转的JSP页面
		return "/system/deposit/index";
	}

	/**
	 * 查询交存标准设置列表
	 * 
	 */
	@RequestMapping("/deposit/list")
	public void list(@RequestBody ReqPamars<Deposit> req, HttpServletRequest request, HttpServletResponse response)
			throws IOException {
		LogUtil.write(new Log("交存标准设置信息", "查询", "DepositAction.list", req.toString()));
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();

		Page<Deposit> page = new Page<Deposit>(req.getEntity(), req.getPageNo(), req.getPageSize());
		depositService.findAll(page);
		// 返回结果
		pw.print(page.toJson());
	}
	
	/**
	 * 交存标准设置添加页面
	 */
	@RequestMapping("/deposit/toAdd")
	public String toAdd(HttpServletRequest request, Model model){
		String bm = "";
		try {
			bm = idUtilService.getNextBm("Deposit");
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("bm", bm);
		return "/system/deposit/add";
	}
	
	/**
	 * 保存交存标准设置信息
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/deposit/add")
	public String add(Deposit deposit, HttpServletRequest request, Model model,
			RedirectAttributes redirectAttributes) {
		LogUtil.write(new Log("交存标准设置信息", "添加", "DepositAction.add", deposit.toString()));
		int result = depositService.add(deposit);
		if (result >= 1) {
			// 更新缓存
			DataHolder.updateDataMap(DepositDataService.KEY, deposit.getBm(), deposit.getMc());
			redirectAttributes.addFlashAttribute("msg", "添加成功");
			return "redirect:/deposit/index";
		} else {
			request.setAttribute("msg", "添加失败");
			return "/system/deposit/add";
		}
	}
	
	/**
	 * 跳转到交存标准设置信息编辑界面
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/deposit/toUpdate")
	public String toUpdate(String bm, Model model) {
		Deposit deposit = depositService.findByBm(bm);
		model.addAttribute("deposit", deposit);
		return "/system/deposit/update";
	}
	
	/**
	 * 修改交存标准设置信息
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/deposit/update")
	public String update(Deposit deposit, HttpServletRequest request, Model model,
			RedirectAttributes redirectAttributes) {
		LogUtil.write(new Log("交存标准设置信息", "修改", "DepositAction.update", deposit.toString()));
		int result = depositService.update(deposit);
		if (result >= 1) {
			// 更新缓存
			DataHolder.updateDataMap(DepositDataService.KEY, deposit.getBm(), deposit.getMc());
			redirectAttributes.addFlashAttribute("msg", "修改成功");
			return "redirect:/deposit/index";
		} else {
			request.setAttribute("msg", "修改失败");
			return "/system/deposit/update";
		}
	}
}

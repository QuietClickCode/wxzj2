package com.yaltec.wxzj2.biz.fixedDeposit.action;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.yaltec.wxzj2.biz.fixedDeposit.entity.Deposits;
import com.yaltec.wxzj2.biz.fixedDeposit.service.DepositsService;
import com.yaltec.wxzj2.biz.system.entity.Role;

/**
 * 演算
 * @ClassName: CalculusAction 
 * @author 重庆亚亮科技有限公司 hqx 
 * @date 2017-9-6 下午02:18:15
 */
@Controller
public class CalculusAction {
	@Autowired
	private DepositsService depositsService;

	/**
	 * 跳转到首页
	 */
	@RequestMapping("/calculus/index")
	public String index(Model model) {
		return "/fixedDeposit/calculus/index";
	}
	
	@RequestMapping("/calculus/toShow")
	public String toShow(String id, Model model) {
		Deposits deposits = depositsService.findById(id);
		model.addAttribute("deposits", deposits);
		return "/fixedDeposit/calculus/show";
	}
}





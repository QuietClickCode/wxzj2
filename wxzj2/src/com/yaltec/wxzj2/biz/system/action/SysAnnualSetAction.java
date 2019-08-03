package com.yaltec.wxzj2.biz.system.action;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.yaltec.comon.log.LogUtil;
import com.yaltec.comon.log.entity.Log;
import com.yaltec.wxzj2.biz.system.entity.SysAnnualSet;
import com.yaltec.wxzj2.biz.system.service.SysAnnualSetService;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 
 * @ClassName: SysAnnualSetAction
 * @Description: TODO系统年度设置实现类
 * 
 * @author jiangyong
 * @date 2016-8-1 下午04:40:38
 */
@Controller
public class SysAnnualSetAction {
	@Autowired
	private SysAnnualSetService sysAnnualSetService;

	/**
	 * 查询
	 */
	@RequestMapping("/sysannualset/index")
	public String list(Model model) {
		LogUtil.write(new Log("系统年度设置信息", "查询", "SysAnnualSetAction.list", ""));
		SysAnnualSet sysAnnualSet = sysAnnualSetService.find();
		model.addAttribute("sysAnnualSet", sysAnnualSet);
		return "/system/sysannualset/index";
	}

	/**
	 * 保存系统年度设置
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/sysannualset/update")
	public String update(SysAnnualSet sysAnnualSet, HttpServletRequest request,
			Model model, RedirectAttributes redirectAttributes) {
		LogUtil.write(new Log("系统年度设置信息", "修改", "SysAnnualSetAction.update", sysAnnualSet.toString()));
		Map<String, String> map = new HashMap<String, String>();
		map.put("bdate", sysAnnualSet.getBegindate());
		map.put("edate", sysAnnualSet.getEnddate());
		map.put("cwdate", sysAnnualSet.getZwdate());
		map.put("result", "-1");
		// 调用service执行update方法
		sysAnnualSetService.update(map);
		int result = Integer.valueOf(map.get("result"));
		if (result == 0) {
			DataHolder.reloadCustomerInfo();
			redirectAttributes.addFlashAttribute("msg", "修改成功");
		} else {
			redirectAttributes.addFlashAttribute("msg", "修改失败");
		}
		return "redirect:/sysannualset/index";
	}

}

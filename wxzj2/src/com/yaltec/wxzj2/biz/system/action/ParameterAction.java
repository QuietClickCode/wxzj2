package com.yaltec.wxzj2.biz.system.action;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.yaltec.comon.log.LogUtil;
import com.yaltec.comon.log.entity.Log;
import com.yaltec.comon.utils.StringUtil;
import com.yaltec.wxzj2.biz.system.entity.Parameter;
import com.yaltec.wxzj2.biz.system.service.ParameterService;
import com.yaltec.wxzj2.comon.data.DataHolder;
import com.yaltec.wxzj2.comon.data.service.ParameterDataService;

/**
 * @ClassName: ParameterAction
 * @Description: 系统参数设置
 * 
 * @author jiangyong
 * @date 2016-08-12 上午10:08:41
 */
@Controller
public class ParameterAction {

	@Autowired
	private ParameterService parameterService;

	/**
	 * 跳转到系统参数设置首页
	 */
	@RequestMapping("/parameter/index")
	public String list(Model model) {
		LogUtil.write(new Log("系统参数设置信息", "查询", "ParameterAction.list", ""));
		List<Parameter> list = parameterService.findAll();
		model.addAttribute("parameters", list);
		return "/system/parameter/index";
	}
	
	/**
	 * 跳转到系统参数设置首页
	 */
	@RequestMapping("/parameter/save")
	public String save(String bms, RedirectAttributes redirectAttributes) {
		LogUtil.write(new Log("系统参数设置信息", "保存", "ParameterAction.save", bms));
		// 按特定的分隔符把字符串转成List集合
		List<String> list = StringUtil.tokenize(bms, ",");
		int result = parameterService.save(list);
		if (result > 0) {
			// 重新加载系统参数缓存
			DataHolder.refresh(ParameterDataService.KEY);
			redirectAttributes.addFlashAttribute("msg", "保存成功");
		} else {
			redirectAttributes.addFlashAttribute("msg", "保存失败");
		}
		return "redirect:/parameter/index";
	}
}

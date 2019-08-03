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
import com.yaltec.comon.utils.StringUtil;
import com.yaltec.wxzj2.biz.comon.service.IdUtilService;
import com.yaltec.wxzj2.biz.system.entity.FSConfig;
import com.yaltec.wxzj2.biz.system.service.FSConfigService;

/**
 * 
 * @ClassName: FSConfigAction
 * @Description: TODO非税配置实现类
 * 
 * @author jiangyong
 * @date 2016-9-5 下午04:06:38
 */
@Controller
public class FSConfigAction {

	@Autowired
	private FSConfigService fsconfigService;
	
	@Autowired
	private IdUtilService idUtilService;

	/**
	 * 查询非税配置列表
	 * 
	 * @return 跳转的JSP页面
	 */
	@RequestMapping("/fsconfig/index")
	public String index() {
		
		// 跳转的JSP页面
		return "/system/fsconfig/index";
	}

	/**
	 * 查询非税配置列表
	 * 
	 */
	@RequestMapping("/fsconfig/list")
	public void list(@RequestBody ReqPamars<FSConfig> req, HttpServletRequest request, HttpServletResponse response)
			throws IOException {
		LogUtil.write(new Log("非税配置信息", "查询", "FSConfigAction.list", req.toString()));
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();

		Page<FSConfig> page = new Page<FSConfig>(req.getEntity(), req.getPageNo(), req.getPageSize());
		fsconfigService.findAll(page);
		// 返回结果
		pw.print(page.toJson());
	}
	
	/**
	 * 增加非税配置信息页面
	 */
	@RequestMapping("/fsconfig/toAdd")
	public String toAdd(String id, HttpServletRequest request, Model model) {
		if(!StringUtil.isEmpty(id)) {
			FSConfig fsconfig = fsconfigService.findById(id);
			model.addAttribute("fsconfig", fsconfig);
		}
		try {
			id = idUtilService.getNextId("Fsconfig");
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("id", id);
		model.addAttribute("CHARGECODE", FSConfig.CHARGECODE);
		model.addAttribute("BILLTYPE", FSConfig.BILLTYPE);
		return "/system/fsconfig/add";
	}

	/**
	 * 保存非税配置信息
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/fsconfig/add")
	public String add(FSConfig fsconfig, HttpServletRequest request, Model model,
			RedirectAttributes redirectAttributes) {
		LogUtil.write(new Log("非税配置信息", "添加", "FSConfigAction.add", fsconfig.toString()));
		int result = fsconfigService.add(fsconfig);
		if (result > 0) {
			redirectAttributes.addFlashAttribute("msg", "添加成功");
			return "redirect:/fsconfig/index";
		} else {
			request.setAttribute("msg", "添加失败");
			return "/system/fsconfig/add";
		}
	}
	
	/**
	 * 跳转到非税配置信息编辑界面
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/fsconfig/toUpdate")
	public String toUpdate(String id, Model model) {
		FSConfig fsconfig = fsconfigService.findById(id);
		model.addAttribute("fsconfig", fsconfig);
		model.addAttribute("CHARGECODE", FSConfig.CHARGECODE);
		model.addAttribute("BILLTYPE", FSConfig.BILLTYPE);
		return "/system/fsconfig/update";
	}
	
	/**
	 * 修改非税配置信息
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/fsconfig/update")
	public String update(FSConfig fsconfig, HttpServletRequest request, Model model,
			RedirectAttributes redirectAttributes) {
		LogUtil.write(new Log("非税配置信息", "修改", "FSConfigAction.update", fsconfig.toString()));
		int result = fsconfigService.update(fsconfig);
		if (result > 0) {
			redirectAttributes.addFlashAttribute("msg", "修改成功");
			return "redirect:/fsconfig/index";
		} else {
			request.setAttribute("msg", "修改失败");
			return "/system/fsconfig/update";
		}
	}
	
	/**
	 * 删除非税配置信息
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/fsconfig/delete")
	public String delete(String id, HttpServletRequest request, Model model,
			RedirectAttributes redirectAttributes) {
		LogUtil.write(new Log("非税配置信息", "删除", "FSConfigAction.delete",id));
		int result = fsconfigService.delete(id);
		if (result > 0) {
			redirectAttributes.addFlashAttribute("msg", "删除成功");
		} else {
			redirectAttributes.addFlashAttribute("msg", "删除失败");
		}
		return "redirect:/fsconfig/index";
	}
}

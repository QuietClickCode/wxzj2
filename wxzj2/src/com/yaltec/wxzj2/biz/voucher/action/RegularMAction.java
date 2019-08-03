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
import com.yaltec.comon.core.entity.Page;
import com.yaltec.comon.core.entity.ReqPamars;
import com.yaltec.comon.log.LogUtil;
import com.yaltec.comon.log.entity.Log;
import com.yaltec.comon.utils.StringUtil;
import com.yaltec.wxzj2.biz.voucher.entity.RegularM;
import com.yaltec.wxzj2.biz.voucher.service.RegularMService;

/**
 * 
 * @ClassName: RegularMAction
 * @Description: TODO定期管理实现类
 * 
 * @author chenxiaokuang
 * @date 2016-9-6 下午16:18:38
 */
@Controller
public class RegularMAction {

	@Autowired
	private RegularMService regularMService;

	/**
	 * 定期管理首页
	 * 
	 * @return 跳转的JSP页面
	 */
	@RequestMapping("/regularM/index")
	public String index() {
		// 跳转的JSP页面
		return "/voucher/regularm/index";
	}
	
	/**
	 * 查询定期管理列表
	 * 
	 */
	@RequestMapping("/regularM/list")
	public void list(@RequestBody ReqPamars<RegularM> req, HttpServletRequest request, HttpServletResponse response)
			throws IOException {
		LogUtil.write(new Log("定期管理信息","查询","RegularMAction.list",req.toString()));
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		Page<RegularM> page = new Page<RegularM>(req.getEntity(), req.getPageNo(), req.getPageSize());
		regularMService.findAll(page);
		// 返回结果
		pw.print(page.toJson());
	}
	
	/**
	 * 进入添加定期管理页面
	 * 
	 * @return 跳转的JSP页面
	 */
	@RequestMapping("/regularM/toAdd")
	public String toAdd() {
		return "/voucher/regularm/add";
	}
	
	/**
	 * 保存定期管理信息
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/regularM/add")
	public String add(RegularM regularM, HttpServletRequest request, Model model,
			RedirectAttributes redirectAttributes) {
		LogUtil.write(new Log("定期管理信息", "添加", "RegularMAction.add", regularM.toString()));
		Map<String, String> map = toMap(regularM);
		String userid= TokenHolder.getUser().getUserid();
		String username= TokenHolder.getUser().getUsername();
		map.put("userid", userid);
		map.put("username", username);
		regularMService.add(map);
		int result = Integer.valueOf(map.get("result"));
		if (result == 0) {
			redirectAttributes.addFlashAttribute("msg", "添加成功");
			return "redirect:/regularM/index";
		} else {
			request.setAttribute("msg", "添加失败");
			return "/voucher/regularm/add";
		}
	}
	
	/**
	 * 跳转到定期管理信息编辑界面
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/regularM/toUpdate")
	public String toUpdate(String id, Model model) {
		RegularM regularM = regularMService.findById(id);
		model.addAttribute("regularM", regularM);
		return "/voucher/regularm/update";
	}
	
	/**
	 * 修改定期管理信息
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/regularM/update")
	public String update(RegularM regularM, HttpServletRequest request, Model model,
			RedirectAttributes redirectAttributes) {
		LogUtil.write(new Log("定期管理信息", "修改", "RegularMAction.update", regularM.toString()));
		Map<String, String> map = toMap(regularM);
		String userid= TokenHolder.getUser().getUserid();
		String username= TokenHolder.getUser().getUsername();
		map.put("userid", userid);
		map.put("username", username);
		regularMService.update(map);
		int result = Integer.valueOf(map.get("result"));
		if (result == 0) {
			redirectAttributes.addFlashAttribute("msg", "修改成功");
			return "redirect:/regularM/index";
		} else {
			request.setAttribute("msg", "修改失败");
			return "/voucher/regularM/update";
		}
	}
	
	/**
	 * 删除定期管理信息
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/regularM/delete")
	public String delete(String id, HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
		LogUtil.write(new Log("定期管理信息", "删除", "RegularMAction.delete", id));
		int result = regularMService.delete(id);
		if (result > 0) {
			redirectAttributes.addFlashAttribute("msg", "删除成功");
		} else {
			redirectAttributes.addFlashAttribute("msg", "删除失败");
		}
		return "redirect:/regularM/index";
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
	@RequestMapping("/regularM/batchDelete")
	public String batchDelete(String ids, HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
		LogUtil.write(new Log("定期管理信息", "批量删除", "RegularMAction.batchDelete", ids));
		// 按特定的分隔符把字符串转成List集合
		List<String> idList = StringUtil.tokenize(ids, ",");
		int result = regularMService.batchDelete(idList);
		if (result > 0) {
			redirectAttributes.addFlashAttribute("msg", "删除成功");
		} else {
			redirectAttributes.addFlashAttribute("msg", "删除失败");
		}
		return "redirect:/regularM/index";
	}
	
	
	/**
	 * 返回需要提醒的定期管理首页
	 * @param 
	 * @return
	 */
	@RequestMapping("/regularM/expire/index")
	public String expireIndex() {
		// 跳转的JSP页面
		return "/voucher/regularm/expire/index";
	}
	
	/**
	 * 查询需要提醒的定期管理信息列表
	 * @param 
	 * @return
	 */
	@RequestMapping("/regularM/expire/list")
	public void expireList(@RequestBody ReqPamars<RegularM> req, HttpServletRequest request, HttpServletResponse response)
		throws IOException {
		LogUtil.write(new Log("定期管理信息", "查询", "RegularMAction.expire.list", req.toString()));
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		Page<RegularM> page = new Page<RegularM>(req.getEntity(), req.getPageNo(), req.getPageSize());
		regularMService.findExpireAll(page);
		// 返回结果
		pw.print(page.toJson());
	}
	
	
	/**
	 * 查询需要提醒的定期管理信息的个数
	 * @param 
	 * @return
	 */
	@RequestMapping("/regularM/expireNum")
	public void expireNum(HttpServletResponse response)
		throws IOException {
		LogUtil.write(new Log("定期管理信息", "查询", "RegularMAction.expire.expireNum", ""));
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		int num = regularMService.findExpireNum();
		// 返回结果
		pw.print(num);
	}
	
	
	
	private Map<String, String> toMap(RegularM regularM) {
		Map<String, String> map = new HashMap<String, String>();
		if(StringUtil.isEmpty(regularM.getId())) {
			map.put("id", "");
		} else {
			map.put("id", regularM.getId());	
		}
		map.put("begindate", regularM.getBegindate());
		map.put("enddate", regularM.getEnddate());
		map.put("advanceday", String.valueOf(regularM.getAdvanceday()));
		map.put("amount", regularM.getAmount());
		map.put("remark", regularM.getRemark());
		map.put("status", regularM.getStatus());
		map.put("state", regularM.getState());
		map.put("userid", regularM.getUserid());
		map.put("username", regularM.getUsername());
		map.put("result", "-1");
		return map;
	}
}
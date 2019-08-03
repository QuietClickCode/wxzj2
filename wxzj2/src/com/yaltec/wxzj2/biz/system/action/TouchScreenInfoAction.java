package com.yaltec.wxzj2.biz.system.action;

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

import com.yaltec.comon.core.entity.Page;
import com.yaltec.comon.core.entity.ReqPamars;
import com.yaltec.comon.log.LogUtil;
import com.yaltec.comon.log.entity.Log;
import com.yaltec.comon.utils.StringUtil;
import com.yaltec.wxzj2.biz.system.entity.TouchScreenInfo;
import com.yaltec.wxzj2.biz.system.service.TouchScreenInfoService;

/**
 * 
 * @ClassName: TouchScreenInfoAction
 * @Description: TODO触摸屏信息实现类
 * 
 * @author yangshanping
 * @date 2016-7-13 下午04:30:05
 */
@Controller
public class TouchScreenInfoAction {
	
	@Autowired
	private TouchScreenInfoService touchScreenInfoService;
	
	/**
	 * 查询触摸屏信息列表
	 * 
	 * @return 跳转的JSP页面
	 */
	@RequestMapping("/touchscreeninfo/index")
	public String index(Model model) {
		// 跳转的JSP页面
		return "/system/touchscreeninfo/index";
	}

	/**
	 * 查询触摸屏信息列表
	 * 
	 */
	@RequestMapping("/touchscreeninfo/list")
	public void list(@RequestBody ReqPamars<TouchScreenInfo> req, HttpServletRequest request, HttpServletResponse response)
			throws IOException {
		LogUtil.write(new Log("触摸屏信息", "查询", "TouchScreenInfoAction.list", req.toString()));
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();

		Page<TouchScreenInfo> page = new Page<TouchScreenInfo>(req.getEntity(), req.getPageNo(), req.getPageSize());
		touchScreenInfoService.findAll(page);
		// 返回结果
		pw.print(page.toJson());
	}
	
	/**
	 * 增加触摸屏信息页面
	 */
	@RequestMapping("/touchscreeninfo/toAdd")
	public String toAdd(HttpServletRequest request){
		return "/system/touchscreeninfo/add";
	}
	
	/**
	 * 保存触摸屏信息
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/touchscreeninfo/add")
	public String add(TouchScreenInfo touchScreenInfo, HttpServletRequest request, Model model,
			RedirectAttributes redirectAttributes) {
		LogUtil.write(new Log("触摸屏信息", "添加", "TouchScreenInfoAction.add", touchScreenInfo.toString()));
		Map<String, String> map = toMap(touchScreenInfo);
		touchScreenInfoService.add(map);
		int result = Integer.valueOf(map.get("result"));
		if (result == 0) {
			redirectAttributes.addFlashAttribute("msg", "添加成功");
			return "redirect:/touchscreeninfo/index";
		} else {
			request.setAttribute("msg", "添加失败");
			return "/system/touchscreeninfo/add";
		}
	}
	
	/**
	 * 跳转到触摸屏信息编辑界面
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/touchscreeninfo/toUpdate")
	public String toUpdate(String bm, Model model) {
		TouchScreenInfo touchScreenInfo = touchScreenInfoService.findByBm(bm);
		model.addAttribute("touchScreenInfo", touchScreenInfo);
		return "/system/touchscreeninfo/update";
	}

	/**
	 * 修改触摸屏信息
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/touchscreeninfo/update")
	public String update(TouchScreenInfo touchScreenInfo, HttpServletRequest request, Model model,
			RedirectAttributes redirectAttributes) {
		LogUtil.write(new Log("触摸屏信息", "修改", "TouchScreenInfoAction.update", touchScreenInfo.toString()));
		Map<String, String> map = toMap(touchScreenInfo);
		touchScreenInfoService.update(map);
		int result = Integer.valueOf(map.get("result"));
		if (result == 0) {
			redirectAttributes.addFlashAttribute("msg", "修改成功");
			return "redirect:/touchscreeninfo/index";
		} else {
			request.setAttribute("msg", "修改失败");
			return "/system/touchscreeninfo/update";
		}
	}
	
	/**
	 * 删除触摸屏信息
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/touchscreeninfo/delete")
	public String delete(String bm, HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
		LogUtil.write(new Log("触摸屏信息", "删除", "TouchScreenInfoAction.delete", bm));
		int result = touchScreenInfoService.delete(bm);
		if (result > 0) {
			redirectAttributes.addFlashAttribute("msg", "删除成功");
		} else {
			redirectAttributes.addFlashAttribute("msg", "删除失败");
		}
		return "redirect:/touchscreeninfo/index";
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
	@RequestMapping("/touchscreeninfo/batchDelete")
	public String batchDelete(String bms, HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
		LogUtil.write(new Log("触摸屏信息", "批量删除", "TouchScreenInfoAction.batchDelete", bms));
		// 按特定的分隔符把字符串转成List集合
		List<String> bmList = StringUtil.tokenize(bms, ",");
		int result = touchScreenInfoService.batchDelete(bmList);
		if (result > 0) {
			redirectAttributes.addFlashAttribute("msg", "删除成功");
		} else {
			redirectAttributes.addFlashAttribute("msg", "删除失败");
		}
		return "redirect:/touchscreeninfo/index";
	}
	
	/**
	 * touchscreeninfo转MAP
	 * 
	 * @param developer
	 * @return
	 */
	private Map<String, String> toMap(TouchScreenInfo touchScreenInfo) {
		Map<String, String> map = new HashMap<String, String>();
		map.put("bm", touchScreenInfo.getBm());
		map.put("typebm", touchScreenInfo.getTypebm());
		map.put("type", touchScreenInfo.getType());
		map.put("ywrq", touchScreenInfo.getYwrq());
		map.put("title", touchScreenInfo.getTitle());
		map.put("content", touchScreenInfo.getContent());
		map.put("oldName", touchScreenInfo.getOldName());
		map.put("newName", touchScreenInfo.getNewName());
		map.put("username", touchScreenInfo.getUsername());
		map.put("result", "-1");
		return map;
	}
}

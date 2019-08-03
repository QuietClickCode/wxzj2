package com.yaltec.wxzj2.biz.property.action;

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
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.comon.core.entity.ReqPamars;
import com.yaltec.comon.log.LogUtil;
import com.yaltec.comon.log.entity.Log;
import com.yaltec.comon.utils.StringUtil;
import com.yaltec.wxzj2.biz.property.entity.Project;
import com.yaltec.wxzj2.biz.property.service.ProjectService;
import com.yaltec.wxzj2.comon.data.DataHolder;
import com.yaltec.wxzj2.comon.data.service.ProjectDataService;

/**
 * 
 * @ClassName: ProjectAction
 * @Description: TODO 项目信息实现类
 * 
 * @author yangshanping
 * @date 2016-7-13 上午10:08:41
 */

@Controller
@SessionAttributes("req")
public class ProjectAction {

	@Autowired
	private ProjectService projectService;

	/**
	 * 查询项目信息列表
	 * 
	 * @return 跳转的JSP页面
	 */
	@RequestMapping("/project/index")
	public String index() {
		// 跳转的JSP页面
		return "/property/project/index";
	}

	/**
	 * 查询项目信息列表
	 * 
	 */
	@RequestMapping("/project/list")
	public void list(@RequestBody ReqPamars<Project> req, HttpServletRequest request, HttpServletResponse response,
			ModelMap model) throws IOException {
		LogUtil.write(new Log("项目信息", "查询", "ProjectAction.list", req.toString()));
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();

		Page<Project> page = new Page<Project>(req.getEntity(), req.getPageNo(), req.getPageSize());
		projectService.findAll(page);
		model.put("req", req);
		// 返回结果
		pw.print(page.toJson());
	}

	/**
	 * 增加项目信息页面
	 */
	@RequestMapping("/project/toAdd")
	public String toAdd(HttpServletRequest request, Model model) {
		model.addAttribute("districts", DataHolder.dataMap.get("district"));
		model.addAttribute("units", DataHolder.dataMap.get("assignment"));
		return "/property/project/add";
	}

	/**
	 * 增加项目信息页面（产权接口）
	 */
	@RequestMapping("/project/open/toAdd")
	public String toOpenAdd(HttpServletRequest request, Model model) {
		model.addAttribute("districts", DataHolder.dataMap.get("district"));
		model.addAttribute("units", DataHolder.dataMap.get("assignment"));
		return "/property/project/open/add";
	}

	/**
	 * 保存项目信息
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/project/add")
	public String add(Project project, HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
		if (projectService.findByMc(project) != null) {
			request.setAttribute("msg", "添加失败，项目名称已存在，请检查！");
			model.addAttribute("districts", DataHolder.dataMap.get("district"));
			model.addAttribute("units", DataHolder.dataMap.get("assignment"));
			return "/property/project/add";
		}
		LogUtil.write(new Log("项目信息", "添加", "ProjectAction.add", project.toString()));
		// 根据归集中心、区域编号获取对应value值
		project.setUnitName(DataHolder.dataMap.get("assignment").get(project.getUnitCode()));
		int result = projectService.add(project);
		if (result > 0) {
			// 更新缓存
			DataHolder.updateDataMap(ProjectDataService.KEY, project.getBm(), project.getMc());
			redirectAttributes.addFlashAttribute("msg", "添加成功");
			return "redirect:/project/index";
		} else {
			redirectAttributes.addFlashAttribute("msg", "添加失败");
			return "redirect:/project/toAdd";
		}
	}

	/**
	 * 跳转到项目信息编辑界面
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/project/toUpdate")
	public String toUpdate(String bm, Model model) {
		Project project = projectService.findByBm(bm);
		model.addAttribute("project", project);
		model.addAttribute("districts", DataHolder.dataMap.get("district"));
		model.addAttribute("units", DataHolder.dataMap.get("assignment"));
		return "/property/project/update";
	}

	/**
	 * 修改项目信息
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/project/update")
	public String update(Project project, HttpServletRequest request, Model model,
			RedirectAttributes redirectAttributes) {
		if (projectService.findByMc(project) != null) {
			request.setAttribute("msg", "添加失败，项目名称已存在，请检查！");
			request.setAttribute("project", project);
			model.addAttribute("districts", DataHolder.dataMap.get("district"));
			model.addAttribute("units", DataHolder.dataMap.get("assignment"));
			return "/property/project/update";
		}
		LogUtil.write(new Log("项目信息", "修改", "ProjectAction.update", project.toString()));
		// 根据归集中心、区域编号获取对应value值
		project.setUnitName(DataHolder.dataMap.get("assignment").get(project.getUnitCode()));
		int result = projectService.update(project);
		if (result > 0) {
			// 更新缓存
			DataHolder.updateDataMap(ProjectDataService.KEY, project.getBm(), project.getMc());
			redirectAttributes.addFlashAttribute("msg", "修改成功");
			return "redirect:/project/index";
		} else {
			request.setAttribute("msg", "修改失败");
			model.addAttribute("districts", DataHolder.dataMap.get("district"));
			model.addAttribute("units", DataHolder.dataMap.get("assignment"));
			return "/property/project/update";
		}
	}

	/**
	 * 删除项目信息
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/project/delete")
	public String delete(String bm, HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
		LogUtil.write(new Log("项目信息", "删除", "ProjectAction.delete", bm));
		Map<String, String> paramMap = new HashMap<String, String>();
		paramMap.put("bm", bm);
		int result = projectService.delete(paramMap);
		if (result == 0) {
			// 更新缓存
			DataHolder.updateDataMap(ProjectDataService.KEY, bm);
			redirectAttributes.addFlashAttribute("msg", "删除成功！");
		} else if (result == 5) {
			redirectAttributes.addFlashAttribute("error", "删除失败！");
		} else if (result == -1) {
			redirectAttributes.addFlashAttribute("error", "删除失败,请先删除该项目下关联的小区信息！");
		}
		return "redirect:/project/index";
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
	@RequestMapping("/project/batchDelete")
	public String batchDelete(String bms, HttpServletRequest request, Model model,
			RedirectAttributes redirectAttributes) {
		LogUtil.write(new Log("项目信息", "批量删除", "ProjectAction.batchDelete", bms));
		Map<String, String> paramMap = new HashMap<String, String>();
		paramMap.put("bm", bms);
		try {
			projectService.batchDelete(paramMap);
			// 更新缓存
			DataHolder.updateDataMap(ProjectDataService.KEY, StringUtil.tokenize(bms, ",").toArray());
			redirectAttributes.addFlashAttribute("msg", "删除成功！");
		} catch (Exception e) {
			redirectAttributes.addFlashAttribute("error", e.getMessage());
		}
		return "redirect:/project/index";
	}

}

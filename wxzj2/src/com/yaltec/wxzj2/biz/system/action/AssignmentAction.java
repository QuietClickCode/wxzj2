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
import com.yaltec.wxzj2.biz.comon.service.IdUtilService;
import com.yaltec.wxzj2.biz.system.entity.Assignment;
import com.yaltec.wxzj2.biz.system.service.AssignmentService;
import com.yaltec.wxzj2.comon.data.DataHolder;
import com.yaltec.wxzj2.comon.data.service.AssignmentDataService;

/**
 * 
 * @ClassName: AssignmentAction
 * @Description: TODO 归集中心设置信息实现类
 * 
 * @author hequanxin
 * @date 2016-7-13 上午10:08:41
 */
@Controller
public class AssignmentAction {

	@Autowired
	private AssignmentService assignmentService;
	
	@Autowired
	private IdUtilService idUtilService;
	
	
	/**
	 * 查询归集中心设置页面
	 */
	@RequestMapping("/assignment/index")
	public String index(Model model){
		return "/system/assignment/index";
	}
	
	/**
	 * 查询归集中心设置页面
	 */
	@RequestMapping("/assignment/list")
	public void list(@RequestBody ReqPamars<Assignment> req, HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		LogUtil.write(new Log("归集中心设置信息", "查询", "AssignmentAction.list", req.toString()));
		
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		Page<Assignment> page = new Page<Assignment>(req.getEntity(), req.getPageNo(), req.getPageSize());
		assignmentService.findAll(page);
		pw.print(page.toJson());
	}
	
	/**
	 * 归集中心添加页面
	 */
	@RequestMapping("/assignment/toAdd")
	public String toAdd(HttpServletRequest request, Model model){
		String bm = "";
		try {
			bm = idUtilService.getNextBm("Assignment");
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("bm", bm);
		model.addAttribute("banks", DataHolder.dataMap.get("bank"));
		return "/system/assignment/add";
	}
	
	/**
	 * 保存归集中心信息
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/assignment/add")
	public String add(Assignment assignment, HttpServletRequest request, Model model,
			RedirectAttributes redirectAttributes) {
		LogUtil.write(new Log("归集中心设置信息", "添加", "AssignmentAction.add", assignment.toString()));
		Map<String, String> map = toMap(assignment);
		assignmentService.add(map);
		int result = Integer.valueOf(map.get("result"));
		if (result == 0) {
			// 更新缓存
			DataHolder.updateDataMap(AssignmentDataService.KEY, map.get("bm"), assignment.getMc());
			redirectAttributes.addFlashAttribute("msg", "添加成功");
			return "redirect:/assignment/index";
		} else {
			request.setAttribute("msg", "添加失败");
			return "/system/assignment/add";
		}
	}
	
	/**
	 * 跳转到归集中心信息编辑界面
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/assignment/toUpdate")
	public String toUpdate(String bm, Model model) {
		Assignment assignment = assignmentService.findByBm(bm);
		model.addAttribute("assignment", assignment);
		model.addAttribute("banks", DataHolder.dataMap.get("bank"));
		return "/system/assignment/update";
	}
	
	/**
	 * 修改归集中心信息
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/assignment/update")
	public String update(Assignment assignment, HttpServletRequest request, Model model,
			RedirectAttributes redirectAttributes) {
		LogUtil.write(new Log("归集中心设置信息", "修改", "AssignmentAction.update", assignment.toString()));
		Map<String, String> map = toMap(assignment);
		assignmentService.update(map);
		int result = Integer.valueOf(map.get("result"));
		if (result == 0) {
			// 更新缓存
			DataHolder.updateDataMap(AssignmentDataService.KEY, map.get("bm"), assignment.getMc());
			redirectAttributes.addFlashAttribute("msg", "修改成功");
			return "redirect:/assignment/index";
		} else {
			request.setAttribute("msg", "修改失败");
			return "/system/assignment/update";
		}
	}
	
	/**
	 * 批量删除
	 * @param bm
	 * @param request
	 * @param model
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping("/assignment/batchDelete")
	public String batchDelete(String bms, HttpServletRequest request, Model model,
			RedirectAttributes redirectAttributes) {
		LogUtil.write(new Log("归集中心设置信息", "批量删除", "AssignmentAction.batchDelete", bms));
		// 按特定的分隔符把字符串转成List集合
		List<String> bmList = StringUtil.tokenize(bms, ",");
		int result = assignmentService.batchDelete(bmList);
		if (result > 0) {
			// 更新缓存
			DataHolder.updateDataMap(AssignmentDataService.KEY,bmList.toArray());
			redirectAttributes.addFlashAttribute("msg", "删除成功");
		} else {
			redirectAttributes.addFlashAttribute("msg", "删除失败");
		}
		return "redirect:/assignment/index";
	}
	
	/**
	 * assignment转MAP
	 * @param assignment
	 * @return
	 */
	private Map<String, String> toMap(Assignment assignment) {
		Map<String, String> map = new HashMap<String, String>();
		map.put("bm", assignment.getBm());
		map.put("mc", assignment.getMc());
		map.put("bankid", assignment.getBankid());
		map.put("bankno", assignment.getBankno());
		map.put("manager", assignment.getManager());
		map.put("financeSupervisor", assignment.getFinanceSupervisor());
		map.put("financialACC", assignment.getFinancialACC());
		map.put("review", assignment.getReview());
		map.put("marker", assignment.getMarker());
		map.put("tel", assignment.getTel());
		map.put("invokeBI", assignment.getInvokeBI() == null? "0": assignment.getInvokeBI());
		map.put("result", "-1");
		return map;
	}
}
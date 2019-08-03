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

import com.yaltec.comon.auth.TokenHolder;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.comon.core.entity.ReqPamars;
import com.yaltec.comon.log.LogUtil;
import com.yaltec.comon.log.entity.Log;
import com.yaltec.wxzj2.biz.property.entity.Developer;
import com.yaltec.wxzj2.biz.property.service.DeveloperService;
import com.yaltec.wxzj2.comon.data.DataHolder;
import com.yaltec.wxzj2.comon.data.service.DeveloperDataService;

/**
 * 
 * @ClassName: DeveloperAction
 * @Description: TODO开发单位实现类
 * 
 * @author jiangyong
 * @date 2016-7-7 上午10:04:38
 */
@Controller
@SessionAttributes("req")
public class DeveloperAction {

	@Autowired
	private DeveloperService developerService;

	/**
	 * 查询开发单位列表
	 * 
	 * @return 跳转的JSP页面
	 */
	@RequestMapping("/developer/index")
	public String index() {
		// 跳转的JSP页面
		return "/property/developer/index";
	}

	/**
	 * 查询开发单位列表
	 * 
	 */
	@RequestMapping("/developer/list")
	public void list(@RequestBody ReqPamars<Developer> req, HttpServletRequest request, HttpServletResponse response,
			ModelMap model) throws IOException {
		LogUtil.write(new Log("开发单位信息", "查询", "DeveloperAction.list", req.toString()));
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		Page<Developer> page = new Page<Developer>(req.getEntity(), req.getPageNo(), req.getPageSize());
		developerService.findAll(page);
		model.put("req", req);
		// 返回结果
		pw.print(page.toJson());
	}

	/**
	 * 增加开发单位信息页面
	 */
	@RequestMapping("/developer/toAdd")
	public String toAdd(HttpServletRequest request) {
		return "/property/developer/add";
	}

	/**
	 * 保存开发单位信息
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/developer/add")
	public String add(Developer developer, HttpServletRequest request, Model model,
			RedirectAttributes redirectAttributes) {
		if(developerService.findByMc(developer) != null) {
			request.setAttribute("msg", "添加失败，开发单位名称已存在，请检查！");
			return "/property/developer/add";
		}
		LogUtil.write(new Log("开发单位信息", "添加", "DeveloperAction.add", developer.toString()));
		Map<String, String> map = toMap(developer);
		developerService.add(map);
		int result = Integer.valueOf(map.get("result"));
		if (result == 0) {
			// 更新缓存
			DataHolder.updateDataMap(DeveloperDataService.KEY, map.get("bm"), developer.getMc());
			redirectAttributes.addFlashAttribute("msg", "添加成功");
			return "redirect:/developer/index";
		} else {
			request.setAttribute("msg", "添加失败");
			return "/property/developer/add";
		}
	}

	/**
	 * 跳转到开发单位信息编辑界面
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/developer/toUpdate")
	public String toUpdate(String bm, Model model) {
		Developer developer = developerService.findByBm(bm);
		model.addAttribute("developer", developer);
		return "/property/developer/update";
	}

	/**
	 * 修改开发单位信息
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/developer/update")
	public String update(Developer developer, HttpServletRequest request, Model model,
			RedirectAttributes redirectAttributes) {
		if(developerService.findByMc(developer) != null) {
			request.setAttribute("msg", "添加失败，开发单位名称已存在，请检查！");
			request.setAttribute("developer", developer);
			return "/property/developer/update";
		}
		LogUtil.write(new Log("开发单位信息", "修改", "DeveloperAction.update", developer.toString()));
		Map<String, String> map = toMap(developer);
		developerService.update(map);
		int result = Integer.valueOf(map.get("result"));
		if (result == 0) {
			// 更新缓存
			DataHolder.updateDataMap(DeveloperDataService.KEY, developer.getBm(), developer.getMc());
			redirectAttributes.addFlashAttribute("msg", "修改成功");
			return "redirect:/developer/index";
		} else {
			request.setAttribute("msg", "修改失败");
			request.setAttribute("developer", developer);
			return "/property/developer/update";
		}
	}

	/**
	 * 删除开发单位信息
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/developer/delete")
	public String delete(String bm, HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
		LogUtil.write(new Log("开发单位信息", "删除", "DeveloperAction.delete", bm));
		Map<String, String> map = new HashMap<String, String>();
		map.put("result", "");
		map.put("bm", bm);
		map.put("userid", TokenHolder.getUser().getUserid());
		map.put("username", TokenHolder.getUser().getUsername());
		map.put("flag", "1");
		String r = developerService.checkForDel(map);
		if (r.equals("1")) {
			map.put("result", "2"); // 单位预交中已存在该开发单位信息
		} else {
			developerService.delete(map);
		}
		int result = Integer.valueOf(map.get("result"));
		System.out.print("result=" + result);
		if (result == 0) {
			// 更新缓存
			DataHolder.updateDataMap(DeveloperDataService.KEY, bm);
			redirectAttributes.addFlashAttribute("msg", "删除成功");
		} else if (result == 1) {
			redirectAttributes.addFlashAttribute("error", "删除失败，该开发单位信息已启用！");
		} else if (result == 2) {
			redirectAttributes.addFlashAttribute("error", "删除失败，单位预交中已存在该开发单位信息！");
		} else {
			redirectAttributes.addFlashAttribute("error", "删除失败");
		}
		return "redirect:/developer/index";
	}

	/**
	 * 批量删除
	 * 
	 * @param bms
	 * @param request
	 * @param model
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping("/developer/batchDelete")
	public String batchDelete(String bms, HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
		// 添加操作日志
		LogUtil.write(new Log("开发单位信息", "批量删除", "DeveloperAction.delete", bms));
		Map<String, String> map = new HashMap<String, String>();
		map.put("userid", TokenHolder.getUser().getUserid());
		map.put("username", TokenHolder.getUser().getUsername());
		map.put("flag", "1");
		map.put("bm", bms);
		map.put("result", "-1");
		try {
			developerService.batchDelete(map);
//			//更新缓存
//			DataHolder.updateDataMap(DeveloperDataService.KEY,StringUtil.tokenize(bms, ",").toArray());
			redirectAttributes.addFlashAttribute("msg", "删除成功！");
		} catch (Exception e) {
			redirectAttributes.addFlashAttribute("error", e.getMessage());
		}
		return "redirect:/developer/index";
	}
	

	/**
	 * developer转MAP
	 * 
	 * @param developer
	 * @return
	 */
	private Map<String, String> toMap(Developer developer) {
		Map<String, String> map = new HashMap<String, String>();
		map.put("bm", developer.getBm());
		map.put("mc", developer.getMc());
		map.put("contactPerson", developer.getContactPerson());
		map.put("tel", developer.getTel());
		map.put("address", developer.getAddress());
		map.put("companyType", developer.getCompanyType());
		map.put("qualificationGrade", developer.getQualificationGrade());
		map.put("qualificationNO", developer.getQualificationNO());
		map.put("certificateIssuingDate", developer.getCertificateIssuingDate());
		map.put("certificateValidityDate", developer.getCertificateValidityDate());
		map.put("legalPerson", developer.getLegalPerson());
		map.put("registeredCapital", developer.getRegisteredCapital());
		map.put("inspectionDate", developer.getInspectionDate());
		map.put("openingDate", developer.getOpeningDate());
		map.put("annualReview", developer.getAnnualReview());
		map.put("ifReply", developer.getIfReply());
		map.put("approvalNumber", developer.getApprovalNumber());
		map.put("approvalDate", developer.getApprovalDate());
		map.put("companyAccount", developer.getCompanyAccount());
		map.put("result", "-1");
		return map;
	}
}

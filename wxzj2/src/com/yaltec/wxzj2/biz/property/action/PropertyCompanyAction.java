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
import com.yaltec.wxzj2.biz.property.entity.PropertyCompany;
import com.yaltec.wxzj2.biz.property.service.PropertyCompanyService;
import com.yaltec.wxzj2.comon.data.DataHolder;
import com.yaltec.wxzj2.comon.data.service.PropertyCompanyDataService;

/**
 * 
 * @ClassName: PropertyCompany
 * @Description: TODO物业公司实现类
 * 
 * @author yangshanping
 * @date 2016-7-13 上午10:05:28
 */

@Controller
@SessionAttributes("req")
public class PropertyCompanyAction {
	@Autowired
	private PropertyCompanyService propertyCompanyService;

	/**
	 * 跳转到首页
	 */
	@RequestMapping("/propertycompany/index")
	public String index(Model model) {
		return "/property/propertycompany/index";
	}
	/**
	 * 查询物业公司信息列表(ajax调用)
	 * 
	 * @param req 从第几条数据库开始算(+每页显示的条数)
	 * @param limit 每页显示的条数，相当于pageSize
	 * @param user 查询条件
	 * @throws IOException
	 */
	@RequestMapping("/propertycompany/list")
	public void list(@RequestBody ReqPamars<PropertyCompany> req, HttpServletRequest request,
			HttpServletResponse response,ModelMap model)throws IOException {
		// 添加操作日志
		LogUtil.write(new Log("物业公司信息", "查询", "PropertyCompanyAction.list", req.toString()));
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		
		Page<PropertyCompany> page = new Page<PropertyCompany>(req.getEntity(), req.getPageNo(), req.getPageSize());
		propertyCompanyService.findAll(page);
		
		model.put("req", req);
		// 返回结果
		pw.print(page.toJson());
	}

	/**
	 * 增加物业公司信息页面
	 */
	@RequestMapping("/propertycompany/toAdd")
	public String toAdd(HttpServletRequest request) {
		return "/property/propertycompany/add";
	}

	/**
	 * 保存物业公司信息
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/propertycompany/add")
	public String add(PropertyCompany propertyCom, HttpServletRequest request,
			Model model, RedirectAttributes redirectAttributes) {
		// 添加操作日志
		LogUtil.write(new Log("物业公司信息", "添加", "PropertyCompanyAction.add", propertyCom.toString()));
		Map<String, String> map = toMap(propertyCom);
		String flag = "0";
		// 保存物业公司前检查物业公司名称是否重复
		flag = propertyCompanyService.checkForSave(map);
		if (flag.equals("3")) {
			map.put("result", "3");
		}else{
			propertyCompanyService.save(map);
		}
		int result = Integer.valueOf(map.get("result"));
		if (result == 0) {
			// 更新缓存
			DataHolder.updateDataMap(PropertyCompanyDataService.KEY, map.get("bm"), propertyCom.getMc());
			redirectAttributes.addFlashAttribute("msg", "添加成功！");
			return "redirect:/propertycompany/index";
		}else if(result == 3){
			redirectAttributes.addFlashAttribute("msg", "物业公司已存在，请检查重试！");
			return "redirect:/propertycompany/toAdd";
		}else {
			redirectAttributes.addFlashAttribute("msg", "添加失败！");
			return "redirect:/propertycompany/toAdd";
		}
	}

	/**
	 * 编辑物业公司信息页面
	 */
	@RequestMapping("/propertycompany/toUpdate")
	public String toUpdate(PropertyCompany propertyCom,
			HttpServletRequest request, Model model) {
		propertyCom = propertyCompanyService.findByBm(propertyCom);
		model.addAttribute("propertyCom", propertyCom);
		return "/property/propertycompany/update";
	}

	/**
	 * 修改物业公司信息，成功：重定向到物业公司列表页面；失败：返回物业公司修改页面
	 * 
	 * @param message
	 * @param request
	 * @return
	 */
	@RequestMapping("/propertycompany/update")
	public String update(PropertyCompany propertyCom, Model model,
			RedirectAttributes redirectAttributes, HttpServletRequest request) {
		// 添加操作日志
		LogUtil.write(new Log("物业公司信息", "修改", "PropertyCompanyAction.update", propertyCom.toString()));
		Map<String, String> map = toMap(propertyCom);
		// 保存物业公司前检查物业公司名称是否重复
		String flag = propertyCompanyService.checkForSave(map);
		if (flag.equals("3")) {
			map.put("result", "3");
		}else{
			propertyCompanyService.update(map);
		}
		int result = Integer.valueOf(map.get("result"));
		if (result == 0) {
			// 更新缓存
			DataHolder.updateDataMap(PropertyCompanyDataService.KEY, propertyCom.getBm(), propertyCom.getMc());
			redirectAttributes.addFlashAttribute("msg", "修改成功！");
			return "redirect:/propertycompany/index";
		} else if(result == 3){
			request.setAttribute("msg", "物业公司已存在，请检查重试！");
			model.addAttribute("propertyCom", propertyCom);
			return "/property/propertycompany/update";
		} else {
			request.setAttribute("msg", "修改失败！");
			model.addAttribute("propertyCom", propertyCom);
			return "/property/propertycompany/update";
		}

	}
	
	/**
	 * 删除物业公司信息
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/propertycompany/delete")
	public String delete(String bm, HttpServletRequest request, Model model,
			RedirectAttributes redirectAttributes) {
		// 添加操作日志
		LogUtil.write(new Log("物业公司信息", "删除", "PropertyCompanyAction.delete", bm));
		Map<String,String> paramMap = new HashMap<String, String>();
		paramMap.put("userid", TokenHolder.getUser().getUserid());
		paramMap.put("username", TokenHolder.getUser().getUsername());
		paramMap.put("flag", "2");
		paramMap.put("bm", bm);
		paramMap.put("result", "");
		propertyCompanyService.delete(paramMap);
		int result = Integer.valueOf(paramMap.get("result"));
		if (result == 0) {
			// 更新缓存
			DataHolder.updateDataMap(PropertyCompanyDataService.KEY, bm);
			redirectAttributes.addFlashAttribute("msg", "删除成功！");
		} else if(result == 1){
			redirectAttributes.addFlashAttribute("error","删除失败，该物业公司信息已启用！");
        } else {
			redirectAttributes.addFlashAttribute("error", "删除失败！");
		}
		return "redirect:/propertycompany/index";
	}

	/**
	 * 删除物业公司信息后，跳转到物业公司列表
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/propertycompany/batchDelete")
	public String batchDelete(String bms, HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
		// 添加操作日志
		LogUtil.write(new Log("物业公司信息", "批量删除", "PropertyCompanyAction.batchDelete", bms));
		Map<String, String> paramMap = new HashMap<String, String>();
		paramMap.put("userid", TokenHolder.getUser().getUserid());
		paramMap.put("username", TokenHolder.getUser().getUsername());
		paramMap.put("flag", "2");
		paramMap.put("bm", bms);
		paramMap.put("result", "-1");
		try {
			propertyCompanyService.delPropertyCompany(paramMap);
//			// 更新缓存
//			DataHolder.updateDataMap(PropertyCompanyDataService.KEY,StringUtil.tokenize(bms, ",").toArray());
			redirectAttributes.addFlashAttribute("msg", "删除成功！");
		} catch (Exception e) {
			redirectAttributes.addFlashAttribute("error", e.getMessage());
		}
		return "redirect:/propertycompany/index";
	}

	/**
	 * PropertyCompany转MAP
	 * 
	 * @param developer
	 * @return
	 */
	private Map<String, String> toMap(PropertyCompany propertyCom) {
		Map<String, String> map = new HashMap<String, String>();
		map.put("bm", propertyCom.getBm());
		map.put("mc", propertyCom.getMc());
		map.put("contactPerson", propertyCom.getContactPerson());
		map.put("tel", propertyCom.getTel());
		map.put("address", propertyCom.getAddress());
		map.put("legalPerson", propertyCom.getLegalPerson());
		map.put("qualificationGrade", propertyCom.getQualificationGrade());
		map.put("qualificationCertificate", propertyCom.getQualificationCertificate());
		map.put("managementStartDate", propertyCom.getManagementStartDate());
		map.put("managementEndDate", propertyCom.getManagementEndDate());
		map.put("result", "-1");
		return map;
	}
}

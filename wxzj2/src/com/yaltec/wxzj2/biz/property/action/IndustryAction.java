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

import com.github.pagehelper.StringUtil;
import com.yaltec.comon.auth.TokenHolder;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.comon.core.entity.ReqPamars;
import com.yaltec.comon.log.LogUtil;
import com.yaltec.comon.log.entity.Log;
import com.yaltec.wxzj2.biz.property.entity.Industry;
import com.yaltec.wxzj2.biz.property.service.IndustryService;
import com.yaltec.wxzj2.comon.data.DataHolder;
import com.yaltec.wxzj2.comon.data.service.IndustryDataService;

/**
 * 
 * @ClassName: IndustryAction
 * @Description: TODO 业委会信息实现类
 * 
 * @author yangshanping
 * @date 2016-7-13 上午10:14:10
 */

@Controller
@SessionAttributes("req")
public class IndustryAction {

	@Autowired
	private IndustryService industryService;

	/**
	 * 跳转到首页
	 */
	@RequestMapping("/industry/index")
	public String index(Model model) {
		return "/property/industry/index";
	}

	/**
	 * 查询业委会信息列表(ajax调用)
	 * 
	 * @param req
	 *            从第几条数据库开始算(+每页显示的条数)
	 * @param limit
	 *            每页显示的条数，相当于pageSize
	 * @param user
	 *            查询条件
	 * @throws IOException
	 */
	@RequestMapping("/industry/list")
	public void list(@RequestBody ReqPamars<Industry> req,HttpServletRequest request, 
			HttpServletResponse response,ModelMap model)throws IOException {
		// 添加操作日志
		LogUtil.write(new Log("业委会信息", "查询", "IndustryAction.list", req.toString()));
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();

		Page<Industry> page = new Page<Industry>(req.getEntity(), req.getPageNo(), req.getPageSize());
		industryService.findAll(page);
		model.put("req",req);
		// 返回结果
		pw.print(page.toJson());
	}

	/**
	 * 增加业委会信息页面
	 */
	@RequestMapping("/industry/toAdd")
	public String toAdd(HttpServletRequest request, Model model) {
		model.addAttribute("communitys", DataHolder.communityMap);
		model.addAttribute("units", DataHolder.dataMap.get("assignment"));
		return "/property/industry/add";
	}

	/**
	 * 保存业委会信息
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/industry/add")
	public String add(Industry industry, HttpServletRequest request,
			Model model, RedirectAttributes redirectAttributes) {
		// 根据归集中心编号获取相应的value
		if(StringUtil.isEmpty(industry.getUnitCode())){
			industry.setUnitName("");
		}else{
			industry.setUnitName(DataHolder.dataMap.get("assignment").get(industry.getUnitCode()));
		}
		// 添加操作日志
		LogUtil.write(new Log("业委会信息", "添加", "IndustryAction.add", industry.toString()));
		Map<String, String> map = toMap(industry);
		// 判断小区下是否存在业委会
		String flag = industryService.IsYWHOnXQ(map);
		if (flag.equals("0")) {
			map.put("result", "-1");// 该小区下已经存在业委会
		}else{
			industryService.save(map);
		}
		int result = Integer.valueOf(map.get("result"));
		if (result == 0) {
			// 更新缓存
			DataHolder.updateDataMap(IndustryDataService.KEY, map.get("bm"), industry.getMc());
			redirectAttributes.addFlashAttribute("msg", "添加成功！");
			return "redirect:/industry/index";
		} else if(result == -1){
			redirectAttributes.addFlashAttribute("msg", "该小区下已经存在业委会！");
			return "redirect:/industry/toAdd";
		}else{
			redirectAttributes.addFlashAttribute("msg", "添加失败！");
			return "redirect:/industry/toAdd";
		}
	}

	/**
	 * 编辑业委会信息页面
	 */
	@RequestMapping("/industry/toUpdate")
	public String toUpdate(Industry industry, HttpServletRequest request,
			Model model) {
		industry = industryService.findByBm(industry);
		model.addAttribute("units", DataHolder.dataMap.get("assignment"));
		model.addAttribute("communitys", DataHolder.communityMap);
		model.addAttribute("industry", industry);
		return "/property/industry/update";
	}

	/**
	 * 修改业委会信息，成功：重定向到业委会列表页面；失败：返回业委会修改页面
	 * 
	 * @param message
	 * @param request
	 * @return
	 */
	@RequestMapping("/industry/update")
	public String update(Industry industry, HttpServletRequest request, Model model,
			RedirectAttributes redirectAttributes) {
		// 根据归集中心、区域编号获取相应的value
		if(StringUtil.isEmpty(industry.getUnitCode())){
			industry.setUnitName("");
		}else{
			industry.setUnitName(DataHolder.dataMap.get("assignment").get(industry.getUnitCode()));
		}
		// 添加操作日志
		LogUtil.write(new Log("业委会信息", "修改", "IndustryAction.update", industry.toString()));
		Map<String, String> map = toMap(industry);
		// 判断小区下是否存在业委会
		String flag = industryService.IsYWHOnXQ(map);
		if (flag.equals("0")) {
			map.put("result", "-1");// 该小区下已经存在业委会
		}else{
			industryService.update(map);
		}	
		int result = Integer.valueOf(map.get("result"));
		if (result == 0) {
			// 更新缓存
			DataHolder.updateDataMap(IndustryDataService.KEY, industry.getBm(), industry.getMc());
			redirectAttributes.addFlashAttribute("msg", "修改成功！");
			return "redirect:/industry/index";
		} else if(result == -1){
			request.setAttribute("msg", "该小区下已经存在业委会！");
			model.addAttribute("units", DataHolder.dataMap.get("assignment"));
			model.addAttribute("communitys", DataHolder.communityMap);
			model.addAttribute("industry", industry);
			return "/property/industry/update";
		} else {
			request.setAttribute("msg", "修改失败！");
			model.addAttribute("units", DataHolder.dataMap.get("assignment"));
			model.addAttribute("communitys", DataHolder.communityMap);
			model.addAttribute("industry", industry);
			return "/property/industry/update";
		}
	}

	/**
	 * 删除业委会信息
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/industry/delete")
	public String delete(String bm, HttpServletRequest request, Model model,
			RedirectAttributes redirectAttributes) {
		// 添加操作日志
		LogUtil.write(new Log("业委会信息", "删除", "IndustryAction.delete", bm));
		Map<String, String> paramMap = new HashMap<String, String>();
		paramMap.put("userid", TokenHolder.getUser().getUserid());
		paramMap.put("username", TokenHolder.getUser().getUsername());
		paramMap.put("flag", "4");
		paramMap.put("result", "");
		paramMap.put("bm", bm);
		industryService.delete(paramMap);
		int result = Integer.valueOf(paramMap.get("result"));
		if (result == 0) {
			// 更新缓存
			DataHolder.updateDataMap(IndustryDataService.KEY, bm);
			redirectAttributes.addFlashAttribute("msg", "删除成功！");
		} else if(result == 1){
			redirectAttributes.addFlashAttribute("error", "删除失败，该业委会信息已启用！");
        } else {
			redirectAttributes.addFlashAttribute("error", "删除失败！");
		}
		return "redirect:/industry/index";
	}


	/**
	 * 删除业委会信息后，跳转到业委会信息列表
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/industry/batchDel")
	public String batchDel(String bms, HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
		// 添加操作日志
		LogUtil.write(new Log("业委会信息", "删除", "IndustryAction.batchDel", bms));
		Map<String, String> paramMap = new HashMap<String, String>();
		paramMap.put("userid", TokenHolder.getUser().getUserid());
		paramMap.put("username", TokenHolder.getUser().getUsername());
		paramMap.put("flag", "4");
		paramMap.put("bm", bms);
		paramMap.put("result", "-1");
		try {
			industryService.delIndustry(paramMap);
//			// 更新缓存
//			DataHolder.updateDataMap(IndustryDataService.KEY, StringUtil.tokenize(bms, ",").toArray());
			redirectAttributes.addFlashAttribute("msg", "删除成功！");
		} catch (Exception e) {
			redirectAttributes.addFlashAttribute("error", e.getMessage());
		}
		return "redirect:/industry/index";
	}

	/**
	 * industry转MAP
	 * 
	 * @param developer
	 * @return
	 */
	private Map<String, String> toMap(Industry industry) {
		Map<String, String> map = new HashMap<String, String>();
		map.put("bm", industry.getBm());
		map.put("mc", industry.getMc());
		map.put("contactPerson", industry.getContactPerson());
		map.put("tel", industry.getTel());
		map.put("address", industry.getAddress());
		map.put("seupdate", industry.getSeupDate());
		map.put("approvaldate", industry.getApprovalDate());
		map.put("approvalnumber", industry.getApprovalNumber());
		map.put("nbhdcode", industry.getNbhdCode());
		map.put("nbhdname", industry.getNbhdName());
		map.put("unitcode", industry.getUnitCode());
		map.put("unitname", industry.getUnitName());
		map.put("managebldgno", industry.getManagebldgno());
		map.put("managehousno", industry.getManagehousno());
		map.put("manager", industry.getManager());
		map.put("result", "-2");
		return map;
	}
}

package com.yaltec.wxzj2.biz.property.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
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
import com.yaltec.comon.utils.JsonUtil;
import com.yaltec.wxzj2.biz.property.entity.Community;
import com.yaltec.wxzj2.biz.property.service.CommunityService;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 
 * @ClassName: CommunityAction
 * @Description: TODO 小区信息实现类
 * 
 * @author yangshanping
 * @date 2016-7-13 上午10:10:26
 */
@Controller
@SessionAttributes("req")
public class CommunityAction {

	@Autowired
	private CommunityService communityService;

	/**
	 * 跳转到首页
	 */
	@RequestMapping("/community/index")
	public String index(Model model) {
		model.addAttribute("unitNames", DataHolder.dataMap.get("assignment"));
		model.addAttribute("projects", DataHolder.dataMap.get("project"));
		model.addAttribute("communitys", DataHolder.communityMap);
		return "/property/community/index";
	}
	
	/**
	 * 快速查询
	 */
	@RequestMapping("/community/open/index")
	public String openindex(Model model) {
		return "/property/community/open/index";
	}
	/**
	 * 查询小区信息列表(ajax调用)
	 * 
	 * @param req 从第几条数据库开始算(+每页显示的条数)
	 * @param limit 每页显示的条数，相当于pageSize
	 * @param user 查询条件
	 * @throws IOException
	 */
	@RequestMapping("/community/list")
	public void list(@RequestBody ReqPamars<Community> req, HttpServletRequest request,
			HttpServletResponse response,ModelMap model)throws IOException {
		// 添加操作日志
		LogUtil.write(new Log("小区信息", "查询", "CommunityAction.list", req.toString()));
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		Page<Community> page = new Page<Community>(req.getEntity(), req.getPageNo(), req.getPageSize());
		communityService.findAll(page);
		model.put("req", req);
		// 返回结果
		pw.print(page.toJson());
		pw.close();
	}

	/**
	 * 查询小区信息列表(ajax调用)
	 * 
	 * @param req 从第几条数据库开始算(+每页显示的条数)
	 * @param limit 每页显示的条数，相当于pageSize
	 * @param user 查询条件
	 * @throws IOException
	 */
	@RequestMapping("/community/open/list")
	public void openlist(@RequestBody ReqPamars<Community> req, HttpServletRequest request,
			HttpServletResponse response)throws IOException {
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		
		Page<Community> page = new Page<Community>(req.getEntity(), req.getPageNo(), req.getPageSize());
		List<Community> cs = communityService.findAll(page.getQuery());
		// 返回结果
		pw.print(JsonUtil.toJson(cs));
	}
	
	/**
	 * 增加小区信息
	 */
	@RequestMapping("/community/toAdd")
	public String toAdd(HttpServletRequest request,Model model) {
		model.addAttribute("xmmc", DataHolder.dataMap.get("project"));
		model.addAttribute("districts", DataHolder.dataMap.get("district"));
		model.addAttribute("units", DataHolder.dataMap.get("assignment"));
		return "/property/community/add";
	}
	
	/**
	 * 快速增加小区信息
	 */
	@RequestMapping("/community/addCommunity")
	public String addCommunity(HttpServletRequest request,Model model) {
		model.addAttribute("xmmc", DataHolder.dataMap.get("project"));
		model.addAttribute("districts", DataHolder.dataMap.get("district"));
		model.addAttribute("units", DataHolder.dataMap.get("assignment"));
		return "/property/community/addCommunity";
	}

	/**
	 * 增加小区信息
	 */
	@RequestMapping("/community/open/toAdd")
	public String toOpenAdd(HttpServletRequest request,Model modle) {
		modle.addAttribute("xmmc", DataHolder.dataMap.get("project"));
		modle.addAttribute("districts", DataHolder.dataMap.get("district"));
		modle.addAttribute("units", DataHolder.dataMap.get("assignment"));
		return "/property/community/open/add";
	}
	
	/**
	 * 保存小区信息
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/community/add")
	public String add(Community community, HttpServletRequest request,
			Model model, RedirectAttributes redirectAttributes) {
		// 根据归集中心获取相应的value
		community.setUnitName(DataHolder.dataMap.get("assignment").get(community.getUnitCode()));
		// 添加操作日志
		LogUtil.write(new Log("小区信息", "添加", "CommunityAction.add", community.toString()));
		Map<String, String> map = toMap(community);
		String flag = "0";
		// 保存小区前检查小区名称是否重复
		flag = communityService.checkForSaveCommunity(map);
		if (flag.equals("3")) {
			map.put("result", "3");
		}else{ 
			communityService.save(map);
		}
		int result = Integer.valueOf(map.get("result"));
		community.setBm(map.get("bm"));
		if (result == 0) {
			// 更新缓存
			DataHolder.updateCommunityDataMap(community);
			redirectAttributes.addFlashAttribute("msg", "添加成功！");
			return "redirect:/community/index";
		} else if(result == 3){
			redirectAttributes.addFlashAttribute("msg", "小区名称已存在，请检查后重试！");
			return "redirect:/community/toAdd";
		}else{
			redirectAttributes.addFlashAttribute("msg", "添加失败！");
			return "redirect:/community/toAdd";
		}
	}

	/**
	 * 保存小区信息
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/community/addCommunitySave")
	public void addCommunitySave(Community community,HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		
		response.setCharacterEncoding("utf-8");
		Map<String, String> map = new HashMap<String, String>();
		
		map.put("userid", TokenHolder.getUser().getUserid());
		map.put("username", TokenHolder.getUser().getUsername());
		map.put("bm", request.getParameter("bm"));
		map.put("mc", request.getParameter("mc"));
		map.put("xmbm", request.getParameter("xmbm"));
		map.put("xmmc", request.getParameter("xmmc"));
		map.put("address", request.getParameter("address"));
		map.put("propertyHouse", request.getParameter("propertyHouse"));
		map.put("propertyOfficeHouse", request.getParameter("propertyOfficeHouse"));
		map.put("districtID", request.getParameter("districtID"));
		map.put("district", request.getParameter("district"));
		map.put("publicHouse", request.getParameter("publicHouse"));
		map.put("propertyHouseArea", request.getParameter("propertyHouseArea"));
		map.put("propertyOfficeHouseArea", request.getParameter("propertyOfficeHouseArea"));
		map.put("publicHouseArea", request.getParameter("publicHouseArea"));
		map.put("unitCode", request.getParameter("unitCode"));
		map.put("unitName", request.getParameter("unitName"));
		map.put("bldgNO", request.getParameter("bldgNO") == "" ? "0" : request.getParameter("bldgNO"));
		map.put("payableFunds", request.getParameter("payableFunds")== "" ? "0" : request.getParameter("payableFunds"));
		map.put("paidFunds", request.getParameter("paidFunds"));
		map.put("other", request.getParameter("other"));
		map.put("remarks", request.getParameter("remarks"));
		map.put("recordDate", request.getParameter("recordDate"));
		map.put("result", "-1");
		int result = Integer.valueOf(map.get("result"));
		
		try {
			// 添加操作日志
			LogUtil.write(new Log("业主交款_单位房屋上报", "新增小区", "CommunityAction.addCommunitySave", map.toString()));
			PrintWriter pw = response.getWriter();
			String flag = "0";
			// 保存小区前检查小区名称是否重复
			flag = communityService.checkForSaveCommunity(map);
			if (flag.equals("3")) {
				map.put("result", "3");
			}else{ 
				communityService.save(map);
				map.put("result", "0");
				//map.put("bm", map.get("bm"));
				community.setBm(map.get("bm"));
				DataHolder.updateCommunityDataMap(community);
			}
			// 返回结果
			pw.print(JsonUtil.toJson(map));	
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}
	
	/**
	 * 编辑小区信息页面
	 */
	@RequestMapping("/community/toUpdate")
	public String toUpdate(Community community, Model model,
			RedirectAttributes redirectAttributes) {
		community = communityService.findByBm(community.getBm());
		model.addAttribute("xmmc", DataHolder.dataMap.get("project"));
		model.addAttribute("districts", DataHolder.dataMap.get("district"));
		model.addAttribute("units", DataHolder.dataMap.get("assignment"));
		model.addAttribute("community", community);
		return "/property/community/update";
	}

	/**
	 * 修改小区信息，成功：重定向到小区列表页面；失败：返回小区修改页面
	 * 
	 * @param message
	 * @param request
	 * @return
	 */
	@RequestMapping("/community/update")
	public String update(Community community, HttpServletRequest request, Model model,RedirectAttributes redirectAttributes) {
		// 根据归集中心获取相应的value
		community.setUnitName(DataHolder.dataMap.get("assignment").get(community.getUnitCode()));
		// 添加操作日志
		LogUtil.write(new Log("小区信息", "修改", "CommunityAction.update", community.toString()));
		Map<String, String> map = toMap(community);
		// 保存小区前检查小区名称是否重复
		String flag = communityService.checkForSaveCommunity(map);
		if (flag.equals("3")) {
			map.put("result", "3");
		}else{ 
			communityService.update(map);
		}
		int result = Integer.valueOf(map.get("result"));
		if (result == 0) {
			// 更新缓存
			DataHolder.updateCommunityDataMap(community);
			redirectAttributes.addFlashAttribute("msg", "修改成功！");
			return "redirect:/community/index";
		} else if(result == 3){
			request.setAttribute("msg", "小区名称已存在，请检查后重试！");
			model.addAttribute("xmmc", DataHolder.dataMap.get("project"));
			model.addAttribute("districts", DataHolder.dataMap.get("district"));
			model.addAttribute("units", DataHolder.dataMap.get("assignment"));
			model.addAttribute("community", community);
			return "/property/community/update";
		} else {
			request.setAttribute("msg", "修改失败！");
			model.addAttribute("xmmc", DataHolder.dataMap.get("project"));
			model.addAttribute("districts", DataHolder.dataMap.get("district"));
			model.addAttribute("units", DataHolder.dataMap.get("assignment"));
			model.addAttribute("community", community);
			return "/property/community/update";
		}
	}

	/**
	 * 删除小区信息
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/community/delete")
	public String delete(String bm, HttpServletRequest request, Model model,
			RedirectAttributes redirectAttributes) {
		// 添加操作日志
		LogUtil.write(new Log("小区信息", "删除", "CommunityAction.delete", bm));
		Map<String,String> paramMap = new HashMap<String, String>();
		paramMap.put("userid", TokenHolder.getUser().getUserid());
		paramMap.put("username", TokenHolder.getUser().getUsername());
		paramMap.put("flag", "3");
		paramMap.put("result", "");
		paramMap.put("bm", bm);
		communityService.delete(paramMap);
		int result = Integer.valueOf(paramMap.get("result"));
		if (result == 0) {
			// 更新缓存
			DataHolder.updateCommunityDataMap(bm);
			redirectAttributes.addFlashAttribute("msg", "删除成功！");
		} else if (result == 5) {
			redirectAttributes.addFlashAttribute("error", "删除失败！");
		}  else if(result == 1){
			redirectAttributes.addFlashAttribute("error", "删除失败,请先删除该小区下关联的楼宇信息！");
        } else {
			redirectAttributes.addFlashAttribute("error", "删除失败！");
		}
		return "redirect:/community/index";
	}

	/**
	 * 删除小区信息后，跳转到小区信息列表
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/community/batchDelete")
	public String batchDelete(String bms, HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
		// 添加操作日志
		LogUtil.write(new Log("小区信息", "批量删除", "CommunityAction.batchDelete", bms));
		Map<String, String> paramMap = new HashMap<String, String>();
		paramMap.put("userid", TokenHolder.getUser().getUserid());
		paramMap.put("username", TokenHolder.getUser().getUsername());
		paramMap.put("flag", "3");
		paramMap.put("bm", bms);
		paramMap.put("result", "-1");
		try {
			communityService.delCommunity(paramMap);
//			// 更新缓存
//			DataHolder.updateCommunityDataMap(bms);
			redirectAttributes.addFlashAttribute("msg", "删除成功！");
		} catch (Exception e) {
			redirectAttributes.addFlashAttribute("error", e.getMessage());
		}
		return "redirect:/community/index";
	}

	/**
	 * community转MAP
	 * 
	 * @param developer
	 * @return
	 */
	private Map<String, String> toMap(Community community) {
		Map<String, String> map = new HashMap<String, String>();
		map.put("bm", community.getBm());
		map.put("mc", community.getMc());
		map.put("xmbm", community.getXmbm());
		map.put("xmmc", community.getXmmc());
		map.put("address", community.getAddress());
		map.put("propertyHouse", community.getPropertyHouse());
		map.put("propertyOfficeHouse", community.getPropertyOfficeHouse());
		map.put("districtID", community.getDistrictID());
		map.put("district", community.getDistrict());
		map.put("publicHouse", community.getPublicHouse());
		map.put("propertyHouseArea", community.getPublicHouseArea());
		map.put("propertyOfficeHouseArea", community.getPropertyOfficeHouseArea());
		map.put("publicHouseArea", community.getPublicHouseArea());
		map.put("unitCode", community.getUnitCode());
		map.put("unitName", community.getUnitName());
		map.put("bldgNO", community.getBldgNO() == "" ? "0" : community.getBldgNO());
		map.put("payableFunds", community.getPayableFunds()== "" ? "0" : community.getPayableFunds());
		map.put("paidFunds", community.getPaidFunds());
		map.put("other", community.getOther());
		map.put("remarks", community.getRemarks());
		map.put("recordDate", community.getRecordDate());
		map.put("result", "-1");
		return map;
	}
	
	/**
	 * 根据项目编号获取小区列表
	 */
	@RequestMapping("/community/ajaxGetList")
	public void ajaxGetList(String xmbh, HttpServletRequest request,Model model,
			HttpServletResponse response) throws Exception  {
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		LinkedHashMap<String, Community> map = null;
		if("".equals(xmbh)){
			map = (LinkedHashMap<String, Community>) DataHolder.communityMap;
		}else{
			map = DataHolder.projectCommunityMap.get(xmbh);
		}
		// 返回结果
		pw.print(JsonUtil.toJson(map));		
		//pw.print(map);			
	}
	
	/**
	 * 根据小区编号获取小区信息
	 */
	@RequestMapping("/community/get")
	public void get(String xqbh, HttpServletRequest request,Model model,
			HttpServletResponse response) throws Exception  {
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		Community community = communityService.findByBm(xqbh);
		// 返回结果
		pw.print(JsonUtil.toJson(community));			
	}
}

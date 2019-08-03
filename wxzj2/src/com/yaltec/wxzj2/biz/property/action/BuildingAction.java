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
import com.yaltec.wxzj2.biz.draw.entity.CodeName;
import com.yaltec.wxzj2.biz.property.entity.Building;
import com.yaltec.wxzj2.biz.property.service.BuildingService;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 
 * @ClassName: BuildingAction
 * @Description: TODO楼宇信息实现类
 * 
 * @author yangshanping
 * @date 2016-7-13 上午10:12:03
 */

@Controller
@SessionAttributes("req")
public class BuildingAction {
	
	@Autowired
	private BuildingService buildingService;
	
	/**
	 * 跳转到首页
	 */
	@RequestMapping("/building/index")
	public String index(Model model) {
		model.addAttribute("unitNames", DataHolder.dataMap.get("assignment"));
		model.addAttribute("kfgss", DataHolder.dataMap.get("developer"));
		model.addAttribute("communitys", DataHolder.communityMap);
		model.addAttribute("projects", DataHolder.dataMap.get("project"));
		return "/property/building/index";
	}
	
	/**
	 * 楼宇信息主页面【弹出界面】
	 */
	@RequestMapping("/building/open/list")
	public String openlist(Integer pageNo, Integer pageSize, Building building, Model model){
		Page<Building> page = new Page<Building>(building, pageNo, pageSize);
		buildingService.findAll(page);
		model.addAttribute("building", building);
		model.addAttribute("page", page);
		return "/property/building/open/index";
	}
	
	/**
	 * 楼宇信息主页面【弹出界面】
	 */
	@RequestMapping("/building/open/list2")
	public String openlist2(Integer pageNo, Integer pageSize, Building building, Model model){
		Page<Building> page = new Page<Building>(building, pageNo, pageSize);
		buildingService.findAll(page);
		model.addAttribute("building", building);
		model.addAttribute("page", page);
		return "/property/building/open/index2";
	}
	
	/**
	 * 查询楼宇信息列表(ajax调用)
	 * @param req 从第几条数据库开始算(+每页显示的条数)
	 * @param limit 每页显示的条数，相当于pageSize
	 * @param user 查询条件
	 * @throws IOException
	 */
	@RequestMapping("/building/list")
	public void list(@RequestBody ReqPamars<Building> req, HttpServletRequest request,
			HttpServletResponse response,ModelMap model)throws IOException {
		// 添加操作日志
		LogUtil.write(new Log("楼宇信息", "查询", "BuildingAction.list", req.toString()));
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		Page<Building> page = new Page<Building>(req.getEntity(), req.getPageNo(), req.getPageSize());
		buildingService.findAll(page);
		model.put("req", req);
		// 返回结果
		pw.print(page.toJson());
	}
	
	/**
	 * 跳转增加楼宇信息页面
	 */
	@RequestMapping("/building/toAdd")
	public String toAdd(HttpServletRequest request,Model model){
		model.addAttribute("communitys", DataHolder.communityMap);
		model.addAttribute("ywhs", DataHolder.dataMap.get("industry"));
		model.addAttribute("wygss", DataHolder.dataMap.get("propertycompany"));
		model.addAttribute("kfgss", DataHolder.dataMap.get("developer"));
		model.addAttribute("fwlxs", DataHolder.dataMap.get("housetype"));
		model.addAttribute("fwxzs", DataHolder.dataMap.get("houseproperty"));
		model.addAttribute("lyjgs", DataHolder.dataMap.get("buildingstructure"));
		return "/property/building/add";
	}
	
	/**
	 * 跳转增加楼宇信息页面(产权接口)
	 */
	@RequestMapping("/building/open/toAdd")
	public String toOpenAdd(HttpServletRequest request,Model model){
		model.addAttribute("communitys", DataHolder.communityMap);
		model.addAttribute("ywhs", DataHolder.dataMap.get("industry"));
		model.addAttribute("wygss", DataHolder.dataMap.get("propertycompany"));
		model.addAttribute("kfgss", DataHolder.dataMap.get("developer"));
		model.addAttribute("fwlxs", DataHolder.dataMap.get("housetype"));
		model.addAttribute("fwxzs", DataHolder.dataMap.get("houseproperty"));
		model.addAttribute("lyjgs", DataHolder.dataMap.get("buildingstructure"));
		return "/property/building/open/add";
	}
	
	/**
	 * 跳转增加楼宇信息页面(快速添加)
	 */
	@RequestMapping("/building/addBuilding")
	public String addBuilding(HttpServletRequest request,Model model){
		model.addAttribute("communitys", DataHolder.communityMap);
		model.addAttribute("ywhs", DataHolder.dataMap.get("industry"));
		model.addAttribute("wygss", DataHolder.dataMap.get("propertycompany"));
		model.addAttribute("kfgss", DataHolder.dataMap.get("developer"));
		model.addAttribute("fwlxs", DataHolder.dataMap.get("housetype"));
		model.addAttribute("fwxzs", DataHolder.dataMap.get("houseproperty"));
		model.addAttribute("lyjgs", DataHolder.dataMap.get("buildingstructure"));
		return "/property/building/addBuilding";
	}
	
	/**
	 * 保存楼宇信息
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/building/add")
	public void add(HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		response.setCharacterEncoding("utf-8");
		Map<String, String> map = new HashMap<String, String>();
		map.put("lybh", request.getParameter("lybh"));
		map.put("lymc", request.getParameter("lymc"));
		map.put("xqbh", request.getParameter("xqbh"));
		map.put("xqmc", request.getParameter("xqmc"));
		map.put("kfgsbm", request.getParameter("kfgsbm"));
		map.put("kfgsmc", request.getParameter("kfgsmc"));
		map.put("wygsbm", request.getParameter("wygsbm"));
		map.put("wygsmc", request.getParameter("wygsmc"));
		map.put("ywhbh", request.getParameter("ywhbh"));
		map.put("ywhmc", request.getParameter("ywhmc"));
		map.put("fwxzbm", request.getParameter("fwxzbm"));
		map.put("fwxz",	request.getParameter("fwxz"));
		map.put("fwlxbm", request.getParameter("fwlxbm"));
		map.put("fwlx", request.getParameter("fwlx"));
		map.put("lyjgbm", request.getParameter("lyjgbm"));
		map.put("lyjg", request.getParameter("lyjg"));
		map.put("address", request.getParameter("address"));
		map.put("totalArea", request.getParameter("totalArea"));
		map.put("totalCost", request.getParameter("totalCost"));
		map.put("protocolPrice", request.getParameter("protocolPrice"));
		map.put("unitNumber", request.getParameter("unitNumber"));
		map.put("layerNumber", request.getParameter("layerNumber"));
		map.put("houseNumber", request.getParameter("houseNumber"));
		map.put("useFixedYear", request.getParameter("useFixedYear"));
		map.put("completionDate", request.getParameter("completionDate"));
		map.put("result", "-1");
		int result = Integer.valueOf(map.get("result"));
		try {
			// 添加操作日志 
			LogUtil.write(new Log("楼宇信息", "添加", "BuildingAction.add", map.toString()));
			PrintWriter pw = response.getWriter();
			String flag = "0";
			// 保存小区前检查小区名称是否重复
			buildingService.save(map);
			if("0".equals(map.get("result"))){
				Building building = new Building(map.get("xqbh").toString(), map.get("xqmc").toString(), map.get("lybh").toString(), map.get("lymc").toString());
				//更新楼宇缓存 
				DataHolder.updateBuildingDataMap(building);
			}
			// 返回结果
			pw.print(JsonUtil.toJson(map));	
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 保存楼宇信息(快速添加)
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/building/addBuildingSave")
	public void addBuildingSave(HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		response.setCharacterEncoding("utf-8");
		Map<String, String> map = new HashMap<String, String>();
		map.put("lybh", request.getParameter("lybh"));
		map.put("lymc", request.getParameter("lymc"));
		map.put("xqbh", request.getParameter("xqbh"));
		map.put("xqmc", request.getParameter("xqmc"));
		map.put("kfgsbm", request.getParameter("kfgsbm"));
		map.put("kfgsmc", request.getParameter("kfgsmc"));
		map.put("wygsbm", request.getParameter("wygsbm"));
		map.put("wygsmc", request.getParameter("wygsmc"));
		map.put("ywhbh", request.getParameter("ywhbh"));
		map.put("ywhmc", request.getParameter("ywhmc"));
		map.put("fwxzbm", request.getParameter("fwxzbm"));
		map.put("fwxz",	request.getParameter("fwxz"));
		map.put("fwlxbm", request.getParameter("fwlxbm"));
		map.put("fwlx", request.getParameter("fwlx"));
		map.put("lyjgbm", request.getParameter("lyjgbm"));
		map.put("lyjg", request.getParameter("lyjg"));
		map.put("address", request.getParameter("address"));
		map.put("totalArea", request.getParameter("totalArea"));
		map.put("totalCost", request.getParameter("totalCost"));
		map.put("protocolPrice", request.getParameter("protocolPrice"));
		map.put("unitNumber", request.getParameter("unitNumber"));
		map.put("layerNumber", request.getParameter("layerNumber"));
		map.put("houseNumber", request.getParameter("houseNumber"));
		map.put("useFixedYear", request.getParameter("useFixedYear"));
		map.put("completionDate", request.getParameter("completionDate"));
		map.put("result", "-1");
		int result = Integer.valueOf(map.get("result"));
		try {
			// 添加操作日志 
			LogUtil.write(new Log("业主交款_单位房屋上报", "新增楼宇", "BuildingAction.addBuildingSave", map.toString()));
			PrintWriter pw = response.getWriter();
			String flag = "0";
			// 保存小区前检查小区名称是否重复
			buildingService.save(map);
			if("0".equals(map.get("result"))){
				Building building = new Building(map.get("xqbh").toString(), map.get("xqmc").toString(), map.get("lybh").toString(), map.get("lymc").toString());
				//更新楼宇缓存 
				DataHolder.updateBuildingDataMap(building);
			}
			
			// 返回结果
			pw.print(JsonUtil.toJson(map));	
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}
	
	
	/**
	 * 跳转编辑楼宇信息页面
	 */
	@RequestMapping("/building/toUpdate")
	public String toUpdate(Building building, Model model,RedirectAttributes redirectAttributes) {
		building = buildingService.findByLybh(building);
		model.addAttribute("ywhs", DataHolder.dataMap.get("industry"));
		model.addAttribute("wygss", DataHolder.dataMap.get("propertycompany"));
		model.addAttribute("kfgss", DataHolder.dataMap.get("developer"));
		model.addAttribute("fwlxs", DataHolder.dataMap.get("housetype"));
		model.addAttribute("fwxzs", DataHolder.dataMap.get("houseproperty"));
		model.addAttribute("lyjgs", DataHolder.dataMap.get("buildingstructure"));
		model.addAttribute("building", building);
		return "/property/building/update";
	}
	/**
	 * 修改楼宇信息，成功：重定向到楼宇列表页面；失败：返回楼宇修改页面
	 * 
	 * @param message
	 * @param request
	 * @return
	 */
	@RequestMapping("/building/update")
	public String update(Building building, Model model,RedirectAttributes redirectAttributes, HttpServletRequest request) {
		// 业委会、物业公司、开发公司、房屋类型、房屋性质、楼宇结构编号获取相应的value
		building.setFwlx(DataHolder.dataMap.get("housetype").get(building.getFwlxbm()));
		building.setFwxz(DataHolder.dataMap.get("houseproperty").get(building.getFwxzbm()));
		// 添加操作日志
		LogUtil.write(new Log("楼宇信息", "修改", "BuildingAction.update", building.toString()));
		Map<String, String> map = toMap(building);
		buildingService.update(map);
		int result = Integer.valueOf(map.get("result").toString());
		if (result == 0) {
			// 更新缓存
			DataHolder.updateBuildingDataMap(building);
			redirectAttributes.addFlashAttribute("msg", "修改成功！");
			return "redirect:/building/index";
		} else {
			request.setAttribute("msg", "修改失败！");
			model.addAttribute("ywhs", DataHolder.dataMap.get("industry"));
			model.addAttribute("wygss", DataHolder.dataMap.get("propertycompany"));
			model.addAttribute("kfgss", DataHolder.dataMap.get("developer"));
			model.addAttribute("fwlxs", DataHolder.dataMap.get("housetype"));
			model.addAttribute("fwxzs", DataHolder.dataMap.get("houseproperty"));
			model.addAttribute("lyjgs", DataHolder.dataMap.get("buildingstructure"));
			model.addAttribute("building", building);
			return "/property/building/update";
		}
	}

	/**
	 * 删除楼宇信息
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/building/delete")
	public String del(String bm, HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
		// 添加操作日志
		LogUtil.write(new Log("楼宇信息", "删除", "BuildingAction.delete", bm));
		Map<String, String> paramMap = new HashMap<String, String>();
		paramMap.put("userid", TokenHolder.getUser().getUserid());
		paramMap.put("username", TokenHolder.getUser().getUsername());
		paramMap.put("flag", "5");
		paramMap.put("result", "");
		paramMap.put("bm", bm);
		buildingService.delete(paramMap);
		int result = Integer.valueOf(paramMap.get("result"));
		if (result == 0) {
			// 更新缓存
			DataHolder.updateBuildingDataMap(bm);
			redirectAttributes.addFlashAttribute("msg", "删除成功！");
		} else if (result == 5) {
			redirectAttributes.addFlashAttribute("error", "删除失败！");
		} else if (result == 1) {
			redirectAttributes.addFlashAttribute("error", "删除失败,请先删除该楼宇下关联的房屋信息！");
		} else {
			redirectAttributes.addFlashAttribute("error", "删除失败！");
		}
		return "redirect:/building/index";
	}
	
	/**
	 * 删除楼宇信息后，跳转到楼宇信息列表
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/building/batchDelete")
	public String delete(String bms, HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
		// 添加操作日志
		LogUtil.write(new Log("楼宇信息", "批量删除", "BuildingAction.batchDelete", bms));
		Map<String, String> paramMap = new HashMap<String, String>();
		paramMap.put("userid", TokenHolder.getUser().getUserid());
		paramMap.put("username", TokenHolder.getUser().getUsername());
		paramMap.put("flag", "5");
		paramMap.put("bm", bms);
		paramMap.put("result", "");
		try {
			buildingService.delBuilding(paramMap);
//			// 更新缓存
//			DataHolder.updateBuildingDataMap(bms);
			redirectAttributes.addFlashAttribute("msg", "删除成功！");
		} catch (Exception e) {
			redirectAttributes.addFlashAttribute("error", e.getMessage());
		}
		return "redirect:/building/index";
	}

	/**
	 * building转MAP
	 * 
	 * @param developer
	 * @return
	 */
	private Map<String, String> toMap(Building building) {
		Map<String, String> map = new HashMap<String, String>();
		map.put("lybh", building.getLybh());
		map.put("lymc", building.getLymc());
		map.put("xqbh", building.getXqbh());
		map.put("xqmc", building.getXqmc());
		map.put("kfgsbm", building.getKfgsbm());
		map.put("kfgsmc", building.getKfgsmc());
		map.put("wygsbm", building.getWygsbm());
		map.put("wygsmc", building.getWygsmc());
		map.put("ywhbh", building.getYwhbh());
		map.put("ywhmc", building.getYwhmc());
		map.put("fwxzbm", building.getFwxzbm());
		map.put("fwxz", building.getFwxz());
		map.put("fwlxbm", building.getFwlxbm());
		map.put("fwlx", building.getFwlx());
		map.put("lyjgbm", building.getLyjgbm());
		map.put("lyjg", building.getLyjg());
		map.put("address", building.getAddress());
		map.put("totalArea", building.getTotalArea());
		map.put("totalCost", building.getTotalCost());
		map.put("protocolPrice", building.getProtocolPrice());
		map.put("unitNumber", building.getUnitNumber());
		map.put("layerNumber", building.getLayerNumber());
		map.put("houseNumber", building.getHouseNumber());
		map.put("useFixedYear", building.getUseFixedYear());
		map.put("completionDate", building.getCompletionDate());
		map.put("result", "-1");
		return map;
	}
	
	/**
	 * 根据小区编号获取业委会信息
	 */
	@RequestMapping("/building/getIndustry")
	public void getIndustry(String xqbh, HttpServletRequest request,Model model,
			HttpServletResponse response) throws Exception  {
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		Map<String, String> map = new HashMap<String, String>();
		map.put("xqbh", xqbh);
		// 根据小区编号获取对应的业委会信息
		List<CodeName> list=buildingService.queryIndustryByXqbh(map);
		// 返回结果
		pw.print(JsonUtil.toJson(list));			
	}
	
	/**
	 * 根据小区编号获取楼宇列表
	 */
	@RequestMapping("/building/ajaxGetList")
	public void ajaxGetList(String xqbh, HttpServletRequest request,Model model,
			HttpServletResponse response) throws Exception  {
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		LinkedHashMap<String, Building> map = DataHolder.communityBuildingMap.get(xqbh);
		LinkedHashMap<String, Building> _map = new LinkedHashMap<String, Building>();
		for (String key : map.keySet()) {
			Building building = map.get(key);
			_map.put(building.getLymc(), building);
		}
		//map.clear();
		// 返回结果
		pw.print(JsonUtil.toJson(_map));			
	}
	
}

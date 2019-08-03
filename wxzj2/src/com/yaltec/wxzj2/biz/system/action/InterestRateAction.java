package com.yaltec.wxzj2.biz.system.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
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
import com.yaltec.wxzj2.biz.comon.service.IdUtilService;
import com.yaltec.wxzj2.biz.system.entity.ActiveRate;
import com.yaltec.wxzj2.biz.system.entity.FixedRate;
import com.yaltec.wxzj2.biz.system.entity.HouseRate;
import com.yaltec.wxzj2.biz.system.service.InterestRateService;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 
 * @ClassName: InterestRateAction
 * @Description: 系统利率设置action
 * 
 * @author jiangyong
 * @date 2016-8-23 上午10:04:38
 */
@Controller
public class InterestRateAction {

	@Autowired
	private InterestRateService interestRateService;
	
	@Autowired
	private IdUtilService idUtilService;
	
	/**
	 * 跳转到系统利率设置首页
	 * 
	 * @return 跳转的JSP页面
	 */
	@RequestMapping("/interestrate/index")
	public String index(Model model) {
		model.addAttribute("communitys", DataHolder.communityMap);
		// 跳转的JSP页面
		return "/system/interestrate/index";
	}

	/**
	 * 查询存款利率设置信息
	 * 
	 */
	@RequestMapping("/interestrate/activerate/list")
	public void activeRateList(@RequestBody ReqPamars<ActiveRate> req, HttpServletRequest request, HttpServletResponse response)
			throws IOException {
		LogUtil.write(new Log("存款利率设置信息", "查询", "InterestRateAction.activeRateList", req.toString()));
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		
		Page<ActiveRate> page = new Page<ActiveRate>(req.getEntity(), req.getPageNo(), req.getPageSize());
		interestRateService.findActiveRate(page, req.getParams());
		// 返回结果
		pw.print(page.toJson());
	}
	
	/**
	 * 查询定期利率设置信息
	 * 
	 */
	@RequestMapping("/interestrate/fixedrate/list")
	public void fixedRateList(@RequestBody ReqPamars<FixedRate> req, HttpServletRequest request, HttpServletResponse response)
			throws IOException {
		LogUtil.write(new Log("定期利率设置信息", "查询", "InterestRateAction.fixedRateList", req.toString()));
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		Page<FixedRate> page = new Page<FixedRate>(req.getEntity(), req.getPageNo(), req.getPageSize());
		interestRateService.findFixedRate(page, req.getParams());
		// 返回结果
		pw.print(page.toJson());
	}
	
	/**
	 * 查询房屋利率设置信息
	 * 
	 */
	@RequestMapping("/interestrate/houserate/list")
	public void houseRateList(@RequestBody ReqPamars<HouseRate> req, HttpServletRequest request, HttpServletResponse response)
			throws IOException {
		LogUtil.write(new Log("房屋利率设置信息", "查询", "InterestRateAction.houseRateList", req.toString()));
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		Page<HouseRate> page = new Page<HouseRate>(req.getEntity(), req.getPageNo(), req.getPageSize());
		interestRateService.findHouseRate(page, req.getParams());
		// 返回结果
		pw.print(page.toJson());
	}
	
	/**
	 * 存款利率设置添加页面
	 */
	@RequestMapping("/interestrate/activerate/toAdd")
	public String toAddActiveRate(HttpServletRequest request, Model model){
		String bm = "";
		try {
			bm = idUtilService.getNextBm("SordineFDRate");
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("bm", bm);
		return "/system/interestrate/activerate/add";
	}
	
	/**
	 * 保存存款利率设置信息
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/interestrate/activerate/add")
	public String addActiveRate(ActiveRate activeRate, HttpServletRequest request, Model model,
			RedirectAttributes redirectAttributes) {
		LogUtil.write(new Log("存款利率设置信息", "添加", "InterestRateAction.addActiveRate", activeRate.toString()));
		Map<String, String> map = new HashMap<String, String>();
		map.put("begindate", activeRate.getBegindate());
		map.put("bm", activeRate.getBm());
		map.put("mc", activeRate.getMc());
		map.put("rate", activeRate.getRate());
		map.put("result", "-1");
		interestRateService.addActiveRate(map);
		int result = Integer.valueOf(map.get("result"));
		if (result == 0) {
			redirectAttributes.addFlashAttribute("msg", "添加成功");
			redirectAttributes.addFlashAttribute("action", "activerate");
			return "redirect:/interestrate/index";
		} else {
			request.setAttribute("msg", "添加失败");
			return "/system/interestrate/activerate/add";
		}
	}
	
	/**
	 * 定期利率设置添加页面
	 */
	@RequestMapping("/interestrate/fixedrate/toAdd")
	public String toAddFixedRate(HttpServletRequest request, Model model){
		String bm = "";
		try {
			bm = idUtilService.getNextBm("TimeDepositRate");
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("bm", bm);
		return "/system/interestrate/fixedrate/add";
	}
	
	/**
	 * 保存定期利率设置信息
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/interestrate/fixedrate/add")
	public String addFixedRate(FixedRate fixedRate, HttpServletRequest request, Model model,
			RedirectAttributes redirectAttributes) {
		LogUtil.write(new Log("定期利率设置信息", "添加", "InterestRateAction.addFixedRate", fixedRate.toString()));
		Map<String, String> map = new HashMap<String, String>();
		map.put("begindate", fixedRate.getBegindate());
		map.put("bm", fixedRate.getBm());
		map.put("mc", fixedRate.getMc());
		map.put("dqbm", fixedRate.getDqbm());
		map.put("dqmc", fixedRate.getDqmc());
		map.put("rate", fixedRate.getRate());
		map.put("result", "-1");
		interestRateService.addFixedRate(map);
		int result = Integer.valueOf(map.get("result"));
		if (result == 0) {
			redirectAttributes.addFlashAttribute("msg", "添加成功");
			redirectAttributes.addFlashAttribute("action", "fixedrate");
			return "redirect:/interestrate/index";
		} else {
			request.setAttribute("msg", "添加失败");
			return "/system/interestrate/fixedrate/add";
		}
	}
	
	/**
	 * 房屋利率设置添加页面
	 */
	@RequestMapping("/interestrate/houserate/toAdd")
	public String toAddHouseRate(HttpServletRequest request, Model model){
		model.addAttribute("communitys", DataHolder.communityMap);
		return "/system/interestrate/houserate/add";
	}
	
	/**
	 * 保存房屋利率设置信息
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/interestrate/houserate/add")
	public String addHouseRate(HouseRate houseRate, HttpServletRequest request, Model model,
			RedirectAttributes redirectAttributes) {
		LogUtil.write(new Log("房屋利率设置信息", "添加", "InterestRateAction.addHouseRate", houseRate.toString()));
		Map<String, String> map = new HashMap<String, String>();
		map.put("xqbh", houseRate.getXqbh());
		map.put("lybh", houseRate.getLybh());
		map.put("h001", houseRate.getH001());
		map.put("szlb", "0");
		map.put("hqje", houseRate.getHqje());
		map.put("dqbm", houseRate.getDqbm());
		map.put("nll", "0");
		map.put("username", TokenHolder.getUser().getUsername());
		map.put("bgyy", houseRate.getBgyy());
		map.put("ywrq", houseRate.getYwrq());
		map.put("bclb", "0");
		map.put("result", "-1");
		interestRateService.addHouseRate(map);
		int result = Integer.valueOf(map.get("result"));
		if (result == 0) {
			redirectAttributes.addFlashAttribute("msg", "添加成功");
			redirectAttributes.addFlashAttribute("action", "houserate");
			return "redirect:/interestrate/index";
		} else {
			request.setAttribute("msg", "添加失败");
			return "/system/interestrate/houserate/add";
		}
	}
	
	/**
	 * 跳转到存款利率设置信息编辑界面
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/interestrate/activerate/toUpdate")
	public String toUpdateActiveRate(String bm, Model model) {
		ActiveRate activeRate = interestRateService.getActiveRate(bm);
		model.addAttribute("activeRate", activeRate);
		return "/system/interestrate/activerate/update";
	}
	
	/**
	 * 修改存款利率设置信息
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/interestrate/activerate/update")
	public String updateActiveRate(ActiveRate activeRate, HttpServletRequest request, Model model,
			RedirectAttributes redirectAttributes) {
		LogUtil.write(new Log("存款利率设置信息", "修改", "InterestRateAction.updateActiveRate", activeRate.toString()));
		Map<String, String> map = new HashMap<String, String>();
		map.put("begindate", activeRate.getBegindate());
		map.put("bm", activeRate.getBm());
		map.put("mc", activeRate.getMc());
		map.put("rate", activeRate.getRate());
		map.put("result", "-1");
		interestRateService.updateActiveRate(map);
		int result = Integer.valueOf(map.get("result"));
		if (result == 0) {
			redirectAttributes.addFlashAttribute("msg", "修改成功");
			return "redirect:/interestrate/index";
		} else {
			request.setAttribute("msg", "修改失败");
			return "/system/interestrate/activerate/add";
		}
	}
	
	/**
	 * 跳转到定期利率设置信息编辑界面
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/interestrate/fixedrate/toUpdate")
	public String toUpdateFixedRate(String bm, Model model) {
		FixedRate fixedRate = interestRateService.getFixedRate(bm);
		model.addAttribute("fixedRate", fixedRate);
		return "/system/interestrate/fixedrate/update";
	}
	
	/**
	 * 修改定期利率设置信息
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/interestrate/fixedrate/update")
	public String updateFixedRate(FixedRate fixedRate, HttpServletRequest request, Model model,
			RedirectAttributes redirectAttributes) {
		LogUtil.write(new Log("定期利率设置信息", "修改", "InterestRateAction.updateFixedRate", fixedRate.toString()));
		Map<String, String> map = new HashMap<String, String>();
		map.put("begindate", fixedRate.getBegindate());
		map.put("bm", fixedRate.getBm());
		map.put("mc", fixedRate.getMc());
		map.put("dqbm", fixedRate.getDqbm());
		map.put("dqmc", fixedRate.getDqmc());
		map.put("rate", fixedRate.getRate());
		map.put("result", "-1");
		interestRateService.updateFixedRate(map);
		int result = Integer.valueOf(map.get("result"));
		if (result == 0) {
			redirectAttributes.addFlashAttribute("msg", "修改成功");
			return "redirect:/interestrate/index";
		} else {
			request.setAttribute("msg", "修改失败");
			return "/system/interestrate/fixedrate/update";
		}
	}
	
	/**
	 * 跳转到房屋利率设置信息编辑界面
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/interestrate/houserate/toUpdate")
	public String toUpdateHouseRate(Model model) {
//		HouseRate houseRate = interestRateService.getHouseRate();
//		model.addAttribute("houseRate", houseRate);
		return "/system/interestrate/houserate/update";
	}
	
	/**
	 * 修改房屋利率设置信息
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/interestrate/houserate/update")
	public String updateHouseRate(HouseRate houseRate, HttpServletRequest request, Model model,
			RedirectAttributes redirectAttributes) {
		LogUtil.write(new Log("房屋利率设置信息", "修改", "InterestRateAction.updateHouseRate", houseRate.toString()));
		Map<String, String> map = new HashMap<String, String>();
		map.put("xqbh", houseRate.getXqbh());
		map.put("lybh", houseRate.getLybh());
		map.put("h001", houseRate.getH001());
		map.put("szlb", "0");
		map.put("hqje", houseRate.getHqje());
		map.put("dqbm", houseRate.getDqbm());
		map.put("nll", "0");
		map.put("username", TokenHolder.getUser().getUsername());
		map.put("bgyy", houseRate.getBgyy());
		map.put("ywrq", houseRate.getYwrq());
		map.put("bclb", "0");
		map.put("result", "-1");
		interestRateService.updateHouseRate(map);
		int result = Integer.valueOf(map.get("result"));
		if (result == 0) {
			redirectAttributes.addFlashAttribute("msg", "修改成功");
			//return "redirect:/interestrate/index";
			return "/system/interestrate/houserate/update";
		} else {
			request.setAttribute("msg", "修改失败");
			return "/system/interestrate/houserate/update";
		}
	}
}

package com.yaltec.wxzj2.biz.workbench.action;

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
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.yaltec.comon.auth.TokenHolder;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.comon.core.entity.ReqPamars;
import com.yaltec.comon.log.LogUtil;
import com.yaltec.comon.log.entity.Log;
import com.yaltec.comon.utils.JsonUtil;
import com.yaltec.wxzj2.biz.property.entity.House;
import com.yaltec.wxzj2.biz.propertymanager.entity.ChangeProperty;
import com.yaltec.wxzj2.biz.workbench.entity.MyWorkbenchConfig;
import com.yaltec.wxzj2.biz.workbench.entity.MyWorkbenchPic;
import com.yaltec.wxzj2.biz.workbench.service.WorkbenchService;
import com.yaltec.wxzj2.biz.workbench.service.export.CjmxExport;
import com.yaltec.wxzj2.comon.data.DataHolder;

@Controller
public class WorkbenchAction {
	@Autowired
	private WorkbenchService workbenchService;
	/**
	 * 跳转工作台
	 * @return
	 */
	@RequestMapping("/workbench/myworkbench")
	public String index(Model model) {
		Map<String, List<MyWorkbenchConfig>> returnMap=workbenchService.getMyWorkbenchConfig("show");
		model.addAttribute("menuList100", returnMap.get("menuList100"));
		model.addAttribute("menuList200", returnMap.get("menuList200"));
		model.addAttribute("menuList300", returnMap.get("menuList300"));
		model.addAttribute("menuList400", returnMap.get("menuList400"));
		model.addAttribute("menuList500", returnMap.get("menuList500"));
		model.addAttribute("menuList600", returnMap.get("menuList600"));
		model.addAttribute("menuList700", returnMap.get("menuList700"));
		model.addAttribute("menuList800", returnMap.get("menuList800"));
		model.addAttribute("menuList900", returnMap.get("menuList900"));
		model.addAttribute("menuList9900", returnMap.get("menuList9900"));
		// 跳转的JSP页面
		return "/workbench/myworkbench/myworkbench";
	}
	
	/**
	 * 工作台设置
	 * @param model
	 * @return
	 */
	@RequestMapping("/workbench/myworkbenchconfig")
	public String myWorkbenchConfig(Model model) {
		//获取个人设置
		Map<String, List<MyWorkbenchConfig>> returnMap=workbenchService.getMyWorkbenchConfig("config");
		model.addAttribute("menuList100", returnMap.get("menuList100"));
		model.addAttribute("menuList200", returnMap.get("menuList200"));
		model.addAttribute("menuList300", returnMap.get("menuList300"));
		model.addAttribute("menuList400", returnMap.get("menuList400"));
		model.addAttribute("menuList500", returnMap.get("menuList500"));
		model.addAttribute("menuList600", returnMap.get("menuList600"));
		model.addAttribute("menuList700", returnMap.get("menuList700"));
		model.addAttribute("menuList800", returnMap.get("menuList800"));
		model.addAttribute("menuList900", returnMap.get("menuList900"));
		model.addAttribute("menuList9900", returnMap.get("menuList9900"));
		// 跳转的JSP页面
		return "/workbench/myworkbench/myworkbenchconfig";
	}
	
	/**
	 * 工作台保存
	 * @param model
	 * @param request
	 * @param response
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping("/workbench/saveconfig")
	public String saveConfig(Model model, HttpServletRequest request, HttpServletResponse response,RedirectAttributes redirectAttributes) {
		Map<String, String> map=new HashMap<String, String>();
		map.put("userid", TokenHolder.getUser().getUserid());
		map.put("roleid", TokenHolder.getUser().getRole().getBm());
		map.put("mdids", request.getParameter("mdids"));
		map.put("pics", request.getParameter("pics"));
		map.put("isxss", request.getParameter("isxss"));
		map.put("msg", "");
		workbenchService.saveConfig(map);
		if(map.get("msg").equals("1")){
			redirectAttributes.addFlashAttribute("msg","保存成功！");
		}else{
			redirectAttributes.addFlashAttribute("errorMsg","保存失败！");
		}
		return "redirect:/workbench/myworkbenchconfig";
	}
	
	/**
	 * 跳转选择图片
	 * @param model
	 * @return
	 */
	@RequestMapping("/workbench/changepic")
	public String changePic(Model model) {
		List<MyWorkbenchPic> myWorkbenchPicList =workbenchService.getMyWorkbenchPic();
		model.addAttribute("myWorkbenchPicList",myWorkbenchPicList);
		// 跳转的JSP页面
		return "/workbench/myworkbench/changepic";
	}
	
	
	/**
	 * 跳转催交页面
	 * @param model
	 * @return
	 */
	@RequestMapping("/workbench/cjmx")
	public String cjmx(Model model) {
		model.addAttribute("assignment", DataHolder.dataMap.get("assignment"));
		model.addAttribute("communitys", DataHolder.communityMap);
		// 跳转的JSP页面
		return "/workbench/cjmx";
	}
	
	/**
	 * 催交明细
	 * @param req
	 * @param request
	 * @param response
	 * @param model
	 * @throws IOException
	 */
	@RequestMapping("/workbench/cjmxList")
	public void cjmxList(@RequestBody ReqPamars<House> req, HttpServletRequest request, HttpServletResponse response,
			ModelMap model) throws IOException {
		Map<String,Object> map =req.getParams();
		Page<House> page = new Page<House>(req.getEntity(), req.getPageNo(), req.getPageSize());
		workbenchService.findCjmx(page,map);
		LogUtil.write(new Log("催交明细", "查询", "WorkbenchAction.cjmxList", req.toString()));
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		model.put("req", req);
		// 返回结果
		pw.print(page.toJson());
	}
	
	/**
	 * 跳转到修改密码页面
	 * @param model
	 * @param request
	 * @return
	 */
	@RequestMapping("/workbench/updatepwd")
	public String updatepwd(Model model,HttpServletRequest request) {
		model.addAttribute("user",TokenHolder.getUser());
		return "/workbench/updatepwd";
	}
	
	/**
	 * 导出房屋催交信息
	 * @param bm
	 * @param lb
	 * @param xqmc
	 * @param response
	 */
	@RequestMapping("/workbench/toExportCjmx")
	public void toExportCjmx(HttpServletRequest request,House house,HttpServletResponse response) {
		response.setCharacterEncoding("utf-8");
		String h001=request.getParameter("h001");
		String h013=request.getParameter("h013");
		String h015=request.getParameter("h015");
		String h040=request.getParameter("h040");
		String h049=request.getParameter("h049");
		String lybh=request.getParameter("lybh");
		String xqbh=request.getParameter("xqbh");
		Map<String, String> map= new HashMap<String, String>();
		//h001 + ","+h013 + ","+ h015 + "," + h040 + "," + h049+ "," + xqbh + "," + lybh ;
		map.put("h001",	h001);
		map.put("h013", h013);
		map.put("h015", h015);
		map.put("h040", h040);
		map.put("h049", h049);
		map.put("lybh", lybh);
		map.put("xqbh", xqbh);
		List<House> resultList = null;
		try {
			// 添加操作日志
			LogUtil.write(new Log("催交查询不足30%", "导出", "WorkbenchAction.toExportCjmx",map.toString()));
			//resultList = propertyService.queryChangeProperty2(map);
			resultList = workbenchService.toExportCjmx(map);
			CjmxExport.exportChangeProperty(resultList, response);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}

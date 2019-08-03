package com.yaltec.wxzj2.biz.system.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.yaltec.comon.auth.TokenHolder;
import com.yaltec.comon.core.entity.Result;
import com.yaltec.comon.log.LogUtil;
import com.yaltec.comon.log.entity.Log;
import com.yaltec.comon.utils.DateUtil;
import com.yaltec.comon.utils.JsonUtil;
import com.yaltec.comon.utils.StringUtil;
import com.yaltec.wxzj2.biz.comon.service.CustomerInfoService;
import com.yaltec.wxzj2.biz.system.entity.Menu;
import com.yaltec.wxzj2.biz.system.entity.SysAnnualSet;
import com.yaltec.wxzj2.biz.system.entity.User;
import com.yaltec.wxzj2.biz.system.service.SysAnnualSetService;
import com.yaltec.wxzj2.biz.system.service.UserService;

@Controller
public class LoginAction {
	@Autowired
	private SysAnnualSetService sysAnnualSetService;
	@Autowired
	private CustomerInfoService customerInfoService;
	/**
	 * 日志记录器.
	 */
	private static final Logger logger = Logger.getLogger("LoginAction");
	
	@Autowired
	private UserService service;

	/**
	 * 登录验证
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/doLogin")
	public String doLogin(HttpServletRequest request, User user, Model model, RedirectAttributes redirectAttributes,
			Map<String,String> map) {
		// 验证user
		if (null == user || StringUtil.isBlank(user.getUserid()) || StringUtil.isBlank(user.getPwd())) {
			model.addAttribute("error", "请求数据错误！");
			return "/login";
		}
		Result result = null;
		try {
			result = service.doLogin(request, user);
			logger.info(result);
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("error", "用户名或密码错误！");
			return "/login";
		}
		// 验证成功
		if (200 == result.getCode()) {
			return "redirect:/index";
		} else { // 验证失败
			model.addAttribute("error", result.getMessage());
			return "/login";
		}
	}

	@RequestMapping("/head")
	public String head(HttpServletRequest request,Model model) {
		SysAnnualSet sysAnnualSet = sysAnnualSetService.find();		
		String zwdate=DateUtil.format("yyyy-MM",  sysAnnualSet.getZwdate()).replace("-", "年")+"月";
		
		model.addAttribute("zwdate",zwdate);
		model.addAttribute("userName",TokenHolder.getUser().getUserid());
		List<Menu> menus= TokenHolder.getUser().getRole().getMenus();
		String showfile="0";
		for (Menu menu : menus) {
			if(menu.getId().equals("900")){
				showfile="1";
			}
		}
		model.addAttribute("showfile",showfile);		
		return "/head";
	}

	@RequestMapping("/center")
	public String center(HttpServletRequest request) {
		return "/center";
	}

	@RequestMapping("/index")
	public String index(HttpServletRequest request) {
		return "/main";
	}

	/**
	 * 获取使用单位名称
	 */
	@RequestMapping("/login/getCustomerName")
	public void getCustomerName(HttpServletRequest request,
			HttpServletResponse response)throws IOException{
		// 添加操作日志
		LogUtil.write(new Log("获取使用单位名称", "查询", "LoginAction.getCustomerName",""));
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 获取页面传入的查询条件，并存入map集合
		String customerName = customerInfoService.getCustomerName();
		// 返回结果
		pw.print(JsonUtil.toJson(customerName));
	}
	
	@RequestMapping("/login")
	public String login(HttpServletRequest request) {		
		return "/login";
	}

	/**
	 * 注销跳转到用户登陆界面
	 * 
	 * @param request
	 * @return 重定向到login
	 */
	@RequestMapping("/doLogout")
	public String doLogout(HttpServletRequest request) {
		service.doLogout(request);
		return "redirect:/login";
	}
	
}

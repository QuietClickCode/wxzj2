package com.yaltec.wxzj2.biz.system.action;

import java.util.List;
import java.util.logging.Logger;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.yaltec.comon.auth.TokenHolder;
import com.yaltec.wxzj2.biz.system.entity.Menu;
import com.yaltec.wxzj2.biz.system.entity.User;

/**
 * 菜单管理action
 * 
 * @ClassName: MenuAction
 * @author 重庆亚亮科技有限公司 txj
 * @date 2016-7-20 下午05:40:39
 */
@Controller
public class MenuAction {

	/**
	 * 日志记录器.
	 */
	@SuppressWarnings("unused")
	private static final Logger logger = Logger.getLogger("MenuAction");

	/**
	 * 菜单页面
	 * 
	 * @author tangxuanjian
	 */
	@RequestMapping("/menu/init")
	public String initMenus(HttpServletRequest request, Model model) {
		
		// 获取当前操作用户的系统权限
		User user = TokenHolder.getUser();
		List<Menu> menus = null;
		if (null != user && null != user.getRole()) {
			menus = user.getRole().getMenus();
		}
		model.addAttribute("menus", menus);
		return "/menu";
	}

}

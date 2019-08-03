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
import com.yaltec.comon.utils.StringUtil;
import com.yaltec.comon.utils.crypt.MD5Util;
import com.yaltec.wxzj2.biz.comon.entity.PrintSet2;
import com.yaltec.wxzj2.biz.draw.entity.CodeName;
import com.yaltec.wxzj2.biz.system.entity.User;
import com.yaltec.wxzj2.biz.system.service.UserService;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 
 * @ClassName: UserAction
 * @Description: TODO 用户管理信息实现类
 * 
 * @author hequanxin
 * @date 2016-7-13 上午10:08:41
 */
@Controller
@SessionAttributes("req")
public class UserAction {

	@Autowired
	private UserService userService;
	
	/**
	 * 跳转到首页
	 * @param model
	 * @return
	 */
	@RequestMapping("/user/index")
	public String index(Model model) {
		return "/system/user/index";
	}
	
	/**
	 * 角色列表
	 * @param req
	 * @param request
	 * @param response
	 * @throws IOException
	 */
	@RequestMapping("/user/list")
	public void list(@RequestBody ReqPamars<User> req, HttpServletRequest request,
			HttpServletResponse response,ModelMap model) throws IOException {
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 添加操作日志
		LogUtil.write(new Log("用户管理", "查询", "UserAction.list", req.toString()));
		Page<User> page = new Page<User>(req.getEntity(), req.getPageNo(), req.getPageSize());
		userService.findAll(page);
		model.put("req", req);
		// 返回结果
		pw.print(page.toJson());
	}
	
	/**
	 * 跳转到用户信息编辑界面
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/user/toUpdate")
	public String toUpdate(String userid, Model model) {
		User user = userService.findByUserid(userid);
		model.addAttribute("user", user);
		model.addAttribute("units", DataHolder.dataMap.get("assignment"));
		model.addAttribute("yhjs", DataHolder.dataMap.get("role"));
		return "/system/user/update";
	}
	
	/**
	 * 修改用户信息
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/user/update")
	public String update(User user, HttpServletRequest request, Model model,
			RedirectAttributes redirectAttributes) {
		// 添加操作日志
		LogUtil.write(new Log("用户管理", "修改", "UserAction.update", user.toString()));
		int result = userService.update(user);
		if (result > 0) {
			redirectAttributes.addFlashAttribute("msg", "修改成功");
			return "redirect:/user/index";
		} else {
			request.setAttribute("msg", "修改失败");
			return "/system/user/update";
		}
	}
	
	/**
	 * 重置密码
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/user/updatePassword")
	public String updatePassword(String userid, HttpServletRequest request,
			RedirectAttributes redirectAttributes) {
		// 添加操作日志
		LogUtil.write(new Log("用户管理", "重置密码", "UserAction.updatePassword", userid.toString()));
		int result = userService.updatePassword(userid);
		if (result > 0) {
			redirectAttributes.addFlashAttribute("msg", "重置成功！ 新密码为：123456");
			return "redirect:/user/index";
		} else {
			request.setAttribute("msg", "修改失败");
			return "/system/user/update";
		}
	}
	
	/**
	 * 用户添加页面
	 * @author hequanxin
	 */
	@RequestMapping("/user/toAdd")
	public String userSave(HttpServletRequest request, Model model){
		model.addAttribute("units", DataHolder.dataMap.get("assignment"));
		model.addAttribute("yhjs", DataHolder.dataMap.get("role"));
		return "/system/user/add";
	}
	
	/**
	 * 保存用户信息
	 * 
	 * @param request
	 * @return
	*/
	@RequestMapping("/user/add")
	public String add(User user, HttpServletRequest request, Model model,
			RedirectAttributes redirectAttributes) {
		// 添加操作日志
		LogUtil.write(new Log("用户管理", "添加", "UserAction.add", user.toString()));
		User _user=userService.findByUserid(user.getUserid());
		if (_user != null) {
			redirectAttributes.addFlashAttribute("msg", "登录名已存在，请重新输入登录名！");
			return "redirect:/user/toAdd";
		} else {
			// 密码加密
			user.setPwd(MD5Util.getPassWord(user.getPwd()));
			int result = userService.add(user);
			if (result > 0) {
				redirectAttributes.addFlashAttribute("msg", "添加成功");
				return "redirect:/user/index";
			} else {
				request.setAttribute("msg", "添加失败");
				return "/system/user/add";
			}
		}
	}
	 
	/**
	 * 跳转打印设置界面
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/user/toPrintSet")
	public String toPrintSet(HttpServletRequest request,Model model,User user) {
		String userid=request.getParameter("userid");
		model.addAttribute("userid", userid);
		List<CodeName> codename=userService.printset();
		model.addAttribute("codename", codename);
		return "/system/user/print/index";
	}

	/**
	 * 获取打印设置
	 * @param request
	 * @param model
	 * @param response
	 * @param userid
	 */
	@RequestMapping("/user/printSet")
	public void printSet(HttpServletRequest request,Model model,HttpServletResponse response,String userid) {
		try{
			response.setCharacterEncoding("utf-8");
			PrintWriter pw = response.getWriter();
			Map<String,Object> resultMap=new HashMap<String,Object>();
			List<CodeName> list=userService.printset();
			resultMap.put("list", list);
			PrintSet2 printset=userService.getPrintSetInfo(userid);
			resultMap.put("printset", printset);
			pw.print(JsonUtil.toJson(resultMap));
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * 保存打印设置
	 * @param request
	 * @param model
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping("/printSet/save")
	public void printSetSave(HttpServletRequest request,String userid,String xmlname1,String xmlname2, 
			Model model,HttpServletResponse response){
		try{
			response.setCharacterEncoding("utf-8");
			PrintWriter pw = response.getWriter();
			// 创建一个map集合，作为调用提交销户申请方法的参数
			Map<String,String> paramMap=new HashMap<String,String>();
			paramMap.put("userid",userid);
			paramMap.put("xmlname1",xmlname1);
			paramMap.put("xmlname2",xmlname2);
			paramMap.put("operid", TokenHolder.getUser().getUserid());
			paramMap.put("opername", TokenHolder.getUser().getUsername());
			paramMap.put("result", "-1");
			int _result=userService.printSetSave(paramMap);
			String result=_result+"";
			pw.print(result);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * 修改密码
	 * @param request
	 * @return
	 */
	@RequestMapping("/user/updatePasswordByUser")
	public String updatePasswordByUser(HttpServletRequest request,Model model) {
		String pwd=request.getParameter("pwd");
		String newpwd=request.getParameter("newpwd");
		// 验证user
		if (StringUtil.isBlank(newpwd) || StringUtil.isBlank(newpwd)) {
			model.addAttribute("errorMsg", "请求数据错误！");
			return "";
		}
		User user =TokenHolder.getUser();
		int result=userService.updatePasswordByUser(user,pwd,newpwd);
		if(result==-2){
			model.addAttribute("errorMsg", "用户已失效，请重试！");
		}else if(result==-1){
			model.addAttribute("errorMsg", "原密码不正确，请重新输入！");
		}else if(result==0){
			model.addAttribute("errorMsg", "修改密码失败，请重试！");
		}else if(result==1){
			model.addAttribute("msg", "修改密码成功！");	
		}
		model.addAttribute("user",TokenHolder.getUser());
		return "/workbench/updatepwd";
	}
}

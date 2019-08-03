package com.yaltec.wxzj2.biz.test.action;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.comon.core.entity.ReqPamars;
import com.yaltec.wxzj2.biz.system.entity.User;
import com.yaltec.wxzj2.biz.system.service.UserService;


/**
 * <p>ClassName: Bootstraptable</p>
 * <p>Description: Bootstraptable查询demo</p>
 * <p>Company: YALTEC</p> 
 * @author jiangyong
 * @date 2016-8-12 上午10:43:51
 */
@Controller
public class Bootstraptable {
	
	@Autowired
	private UserService userService;

	/**
	 * 跳转到首页
	 */
	@RequestMapping("/bootstraptable/index")
	public String index(Model model) {
		return "/test/bootstrap-table/index";
	}
	
	/**
	 * 查询用户列表(ajax调用)
	 * 
	 * @param req 从第几条数据库开始算(+每页显示的条数)
	 * @param limit 每页显示的条数，相当于pageSize
	 * @param user 查询条件
	 * @throws IOException
	 */
	@RequestMapping("/bootstraptable/list")
	public void list(@RequestBody ReqPamars<User> req, HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		
		Page<User> page = new Page<User>(req.getEntity(), req.getPageNo(), req.getPageSize());
		userService.findAll(page);
		// 返回结果
		pw.print(page.toJson());
	}
}

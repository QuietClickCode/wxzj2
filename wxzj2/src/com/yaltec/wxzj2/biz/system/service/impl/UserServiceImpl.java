package com.yaltec.wxzj2.biz.system.service.impl;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.github.pagehelper.PageHelper;
import com.yaltec.comon.auth.SessionHolder;
import com.yaltec.comon.auth.TokenHolder;
import com.yaltec.comon.auth.entity.Token;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.comon.core.entity.Result;
import com.yaltec.comon.utils.ObjectUtil;
import com.yaltec.comon.utils.crypt.MD5Util;
import com.yaltec.wxzj2.biz.comon.entity.PrintSet2;
import com.yaltec.wxzj2.biz.draw.entity.CodeName;
import com.yaltec.wxzj2.biz.system.dao.AssignmentDao;
import com.yaltec.wxzj2.biz.system.dao.MenuDao;
import com.yaltec.wxzj2.biz.system.dao.RoleDao;
import com.yaltec.wxzj2.biz.system.dao.UserDao;
import com.yaltec.wxzj2.biz.system.entity.Assignment;
import com.yaltec.wxzj2.biz.system.entity.Menu;
import com.yaltec.wxzj2.biz.system.entity.Role;
import com.yaltec.wxzj2.biz.system.entity.User;
import com.yaltec.wxzj2.biz.system.service.UserService;

/**
 * 
 * @ClassName: UserServiceImpl
 * @Description: 系统用户管理实现类
 * 
 * @author hequanxin
 * @date 2016-8-13 下午02:37:37
 */
@Service
public class UserServiceImpl implements UserService {

	@Autowired
	private UserDao userDao;

	@Autowired
	private RoleDao roleDao;

	@Autowired
	private MenuDao menuDao;
	
	@Autowired
	private AssignmentDao assignmentDao;

	/**
	 * 用户信息列表
	 */
	@Override
	public void findAll(Page<User> page) {
		PageHelper.startPage(page.getPageNo(), page.getPageSize());
		List<User> list = userDao.findAll(page.getQuery());
		page.setData(list);
	}

	/**
	 * 根据userid查找用户信息
	 */
	public User findByUserid(String userid) {
		return userDao.findByUserid(userid);
	}

	/**
	 * 修改用户信息
	 */
	public int update(User user) {
		return userDao.update(user);
	}

	/**
	 * 添加用户信息
	 */
	public int add(User user) {
		try {
			return userDao.add(user);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return 0;

	}

	/**
	 * 重置密码
	 */
	public int updatePassword(String userid) {
		return userDao.updatePassword(userid);
	}

	/**
	 * 查询打印配置信息
	 */
	public List<CodeName> printset(){
		return userDao.printset();
	}
	
	/**
	 * 根据userid获取打印设置信息 
	 * @param userid
	 * @return
	 */
	public PrintSet2 getPrintSetInfo(String userid){
		return userDao.getPrintSetInfo(userid);
	}
	
	/**
	 * 保存打印设置
	 */
	@Override
	public int printSetSave(Map<String, String> map) {
		userDao.printSetSave(map);
		return Integer.valueOf(map.get("result"));
	}
	
	@Override
	public Result doLogin(HttpServletRequest request, User user) {
		Result result = new Result();
		// 验证用户信息
		User _user = findByUserid(user.getUserid());
		if (ObjectUtil.isEmpty(_user)) {
			result.setCode(-100);
			result.setMessage("用户名错误，请检查！");
			return result;
		} else {
			// 是否加密为1表示密码已加密
			if (null != _user.getSfjm() && _user.getSfjm().equals("1")) {
				// 密码加密
				user.setPwd(MD5Util.getPassWord(user.getPwd()));
				System.out.println(MD5Util.getPassWord(user.getPwd())+"------------------");
			}
			if (_user.getSfqy().equals("0")) {
				result.setCode(-300);
				result.setMessage("用户未启用，登录失败！");
			} else if (user.getPwd().equalsIgnoreCase(_user.getPwd())) {
				// 清空用户密码
				_user.setPwd(null);
				// 获取用户角色权限信息，加载权限资源
				Role role = roleDao.findByBm(_user.getYwqx());
				List<Menu> menus = menuDao.findAll(role.getBm());
				role.setMenus(menus);
				_user.setRole(role);
				// 加载打印设置
				PrintSet2 printSet = userDao.getPrintSetInfo(user.getUserid());
				_user.setPrintSet(printSet);
				// 加载银行编码
				Assignment assignment = assignmentDao.findByBm(_user.getUnitcode());
				_user.setBankId(assignment.getBankid());
				// 验证成功，生成token
				HttpSession session = request.getSession();
				String tokenId = MD5Util.encrypt(_user.getUserid() + MD5Util.encrypt(session.getId()));
				Token token = new Token(tokenId, _user, System.currentTimeMillis());
				TokenHolder.put(token);
				// 把token保存到session中，以便请求登录认证
				session.setAttribute(TokenHolder.TOKEN_KEY, token);
				SessionHolder.holdSession(TokenHolder.getUser().getUserid(), session);
			} else {
				System.out.println("用户登录验证失败，密码*****"+user.getPwd()+"*****密码*****"+_user.getPwd()+"*****");
				result.setCode(-400);
				result.setMessage("用户密码错误，请检查！");
			}
		}
		return result;
	}

	@Override
	public void doLogout(HttpServletRequest request) {
		HttpSession session = request.getSession();
		Object object = session.getAttribute(TokenHolder.TOKEN_KEY);
		if (!ObjectUtil.isEmpty(object)) {
			// 移除token
			session.removeAttribute(TokenHolder.TOKEN_KEY);
		}
		SessionHolder.remove(TokenHolder.getUser().getUserid());
		TokenHolder.remove();
	}

	public List<CodeName> getUserByBank(String yhbh) {
		return userDao.getUserByBank(yhbh);
	}
	/**
	 *  根据用户输入修改密码
	 *  @return -2:未找到用户；-1密码不正确；0:修改失败；1：修改成功
	 */
	@Override
	public int updatePasswordByUser(User user, String pwd, String newpwd) {
		int result=-2;
		// 验证用户信息
		User _user = findByUserid(user.getUserid());
		if (ObjectUtil.isEmpty(_user)) {
			result=-2;
		} else {
			// 是否加密为1表示密码已加密
			if (null != _user.getSfqy() && _user.getSfjm().equals("1")) {
				//原密码密码输入正确
				if(MD5Util.getPassWord(pwd).equalsIgnoreCase(_user.getPwd())){
					_user.setPwd(MD5Util.getPassWord(newpwd));
					result=userDao.updatePasswordByUser(_user);
				}else{
					result=-1;
				}	
			}else if(null != _user.getSfqy() && _user.getSfjm().equals("0")){
				//原密码密码输入正确
				if(MD5Util.getPassWord(pwd).equalsIgnoreCase(_user.getPwd())){
					_user.setPwd(newpwd);
					result=userDao.updatePasswordByUser(_user);
				}else{
					result=-1;
				}
			}else{
				result=-1;
			}
		}	
		return result;
	}
	

}

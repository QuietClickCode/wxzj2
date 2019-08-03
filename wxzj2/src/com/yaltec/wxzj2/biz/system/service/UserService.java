package com.yaltec.wxzj2.biz.system.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.comon.core.entity.Result;
import com.yaltec.wxzj2.biz.comon.entity.PrintSet2;
import com.yaltec.wxzj2.biz.draw.entity.CodeName;
import com.yaltec.wxzj2.biz.system.entity.User;

/**
 * 
 * @ClassName: UserService
 * @Description: 用户管理服务接口
 * 
 * @author hequanxin
 * @date 2016-8-13 下午02:37:37
 */
public interface UserService {

	Result doLogin(HttpServletRequest request, User user);

	void doLogout(HttpServletRequest request);
	
	/**
	 * 查询用户信息列表
	 * @param page
	 */
	public void findAll(Page<User> page);
	
	/**
	 * 根据id查询用户信息
	 * @param userid
	 * @return
	 */
	public User findByUserid(String userid);
	
	/**
	 * 更新信息
	 * @param role
	 * @return
	 */
	public int update(User user);
	
	/**
	 * 添加用户信息
	 * @param user
	 * @return
	 */
	public int add(User user);
	
	/**
	 * 重置密码
	 * @param userid
	 * @return
	 */
	public int updatePassword(String userid);
	
	/**
	 * 查询打印配置信息放入下拉框
	 */
	public List<CodeName> printset();
	
	/**
	 * 保存打印
	 * @param map
	 */
	public int printSetSave(Map<String, String> map);
	
	/**
	 * 根据userid获取打印设置信息 
	 * @param userid
	 * @return
	 */
	public PrintSet2 getPrintSetInfo(String userid);
	/**
	 * 获取银行的所有用户信息
	 * @param yhbh
	 * @return
	 */
	public List<CodeName> getUserByBank(String yhbh);
	/**
	 * 根据用户输入修改密码
	 * @param user
	 * @param pwd
	 * @param newpwd
	 * @return
	 */
	public int updatePasswordByUser(User user, String pwd, String newpwd);
}

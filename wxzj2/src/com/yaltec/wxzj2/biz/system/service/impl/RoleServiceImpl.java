package com.yaltec.wxzj2.biz.system.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.github.pagehelper.PageHelper;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.system.dao.RoleDao;
import com.yaltec.wxzj2.biz.system.entity.Permission;
import com.yaltec.wxzj2.biz.system.entity.Role;
import com.yaltec.wxzj2.biz.system.entity.ZTree;
import com.yaltec.wxzj2.biz.system.service.RoleService;

/**
 * 
 * @ClassName: RoleServiceImpl
 * @Description: 角色管理实现类
 * 
 * @author hequanxin
 * @date 2016-8-13 下午02:37:37
 */
@Service
public class RoleServiceImpl implements RoleService {

	@Autowired
	private RoleDao roledao;
	
	/**
	 * 查询所有角色列表
	 */
	@Override
	public void findAll(Page<Role> page) {
		PageHelper.startPage(page.getPageNo(), page.getPageSize());
		List<Role> list = roledao.findAll(page.getQuery());
		page.setData(list);
	}
	
	/**
	 * 根据bm查询角色信息
	 */
	public Role findByBm(String bm) {
		return roledao.findByBm(bm);
	}
	
	/**
	 * 修改角色信息
	 */
	public int update(Role role) {
		return roledao.update(role);
	}
	
	/**
	 * 添加角色信息
	 */
	public int add(Role role){
		try {
			return roledao.add(role);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return 0;
	}
	
	/**
	 * 查询权限模块
	 */
	public List<ZTree> findTree(String roleid){
		return roledao.findTree(roleid);
	}
	
	/**
	 * 清空角色已有权限
	 */
	public int deletePermission(String bm){
		return roledao.deletePermission(bm);
	}
	
	/**
	 * 保存角色权限
	 */
	public int savePermission(List<Permission> list){
		return roledao.savePermission(list);		
	}
	
	/**
	 * 根据角色名称获取角色信息
	 */
	public Role findByMc(String mc){
		return roledao.findByMc(mc);
	}
	
	/**
	 * 根据bm、mc获取角色编码
	 */
	public String findByBmMc(Role role){
		return roledao.findByBmMc(role);
	}
}

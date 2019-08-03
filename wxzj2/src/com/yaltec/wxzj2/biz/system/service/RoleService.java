package com.yaltec.wxzj2.biz.system.service;

import java.util.List;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.system.entity.Permission;
import com.yaltec.wxzj2.biz.system.entity.Role;
import com.yaltec.wxzj2.biz.system.entity.ZTree;

/**
 * 
 * @ClassName: RoleService
 * @Description: 角色权限管理服务接口
 * 
 * @author hequanxin
 * @date 2016-8-13 下午02:37:37
 */
public interface RoleService {
	
	/**
	 * 查询角色列表
	 * @param roleid
	 * @return
	 */
	public void findAll(Page<Role> page);
	
	/**
	 * 根据bm查询角色信息
	 * @param bm
	 * @return
	 */
	public Role findByBm(String bm);
	
	/**
	 * 更新角色信息
	 * @param role
	 * @return
	 */
	public int update(Role role);
	
	/**
	 * 添加角色信息
	 * @param role
	 * @return
	 */
	public int add(Role role);
	
	/**
	 * 查询权限模块
	 * @param bm
	 * @return
	 */
	public List<ZTree> findTree(String bm);
	
	/**
	 * 清空已用权限模块
	 * @param bm
	 * @return
	 */
	public int deletePermission(String bm);
	
	/**
	 * 保存权限设置
	 * @param list
	 * @return
	 */
	public int savePermission(List<Permission> list);
	
	/**
	 * 根据mc获取角色信息
	 * @param mc
	 * @return
	 */
	public Role findByMc(String mc);
	
	/**
	 * 根据bm、mc获取角色编码
	 * @param role
	 * @return
	 */
	public String findByBmMc(Role role);
	
}

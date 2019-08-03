package com.yaltec.wxzj2.biz.system.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.yaltec.wxzj2.biz.system.entity.Permission;
import com.yaltec.wxzj2.biz.system.entity.Role;
import com.yaltec.wxzj2.biz.system.entity.ZTree;

@Repository
public interface RoleDao {

	public List<Role> findAll(Role role);
	
	public Role findByBm(String bm);
	
	public int update(Role role);
	
	public int add(Role role);
	
	public List<ZTree> findTree(String roleid);
	
	public int deletePermission(String bm);
	
	public int savePermission(List<Permission> list);
	
	public Role findByMc(String mc);
	
	public String findByBmMc(Role role);
	
	public void moduleDraw(Map<String, String> map);
	
}

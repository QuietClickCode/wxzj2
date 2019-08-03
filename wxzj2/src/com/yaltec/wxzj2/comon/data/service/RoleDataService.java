package com.yaltec.wxzj2.comon.data.service;

import java.util.LinkedHashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import com.yaltec.wxzj2.biz.system.dao.RoleDao;
import com.yaltec.wxzj2.biz.system.entity.Role;
import com.yaltec.wxzj2.comon.data.DataServie;

public class RoleDataService extends DataServie {

	/**
	 * 缓存唯一标识
	 */
	public static final String KEY = "role";
	
	/**
	 * 备注信息
	 */
	public static final String REMARK = "角色数据缓存"; 
	
	@Autowired
	private RoleDao roleDao;

	public RoleDataService() {
		
		// 调用父类构造方法
		super(KEY, REMARK);
	}
	
	@Override
	public LinkedHashMap<String, String> init() {
		// 定义有序MAP集合
		LinkedHashMap<String, String> map = new LinkedHashMap<String, String>();
		map.put("", "请选择");
		// 查询数据
		List<Role> list = roleDao.findAll(new Role());
		// 设置缓存数据条数
		super.setSize(list.size());
		for (Role role : list) {
			map.put(role.getBm(), role.getMc());
		}
		return map;
	}

}

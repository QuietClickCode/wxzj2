package com.yaltec.wxzj2.biz.system.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.yaltec.wxzj2.biz.system.dao.MenuDao;
import com.yaltec.wxzj2.biz.system.entity.Menu;
import com.yaltec.wxzj2.biz.system.service.MenuService;

/**
 * 菜单管理service实现
 * 
 * @ClassName: MenuServiceImpl
 * @author 重庆亚亮科技有限公司 txj
 * @date 2016-7-20 下午05:41:37
 */
@Service
public class MenuServiceImpl implements MenuService {

	@Autowired
	private MenuDao menuDao;

	/**
	 * 根据角色id查询菜单列表
	 */
	@Override
	public List<Menu> findAll(String roleid) {
		return menuDao.findAll(roleid);
	}
}

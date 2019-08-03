package com.yaltec.wxzj2.biz.system.service;


import java.util.List;

import com.yaltec.wxzj2.biz.system.entity.Menu;
/**
 * 
* @ClassName: MenuService 
* @Description: 菜单管理Service 
* @author 重庆亚亮科技有限公司 txj 
* @date 2016-7-20 下午05:37:31
 */
public interface MenuService {
	
	/**
	 * 根据角色id查询菜单列表
	 * @param roleid
	 * @return
	 */
	List<Menu> findAll(String roleid);
	
}

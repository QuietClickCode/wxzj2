package com.yaltec.wxzj2.biz.system.dao;


import java.util.List;

import org.springframework.stereotype.Repository;

import com.yaltec.wxzj2.biz.system.entity.Menu;
/**
 * 菜单管理Dao
 * @ClassName: MenuDao 
 * @author 重庆亚亮科技有限公司 txj 
 * @date 2016-7-20 下午05:42:23
 */
@Repository
public interface MenuDao {
	//根据角色id查询菜单列表
	public List<Menu> findAll(String roleid);

}

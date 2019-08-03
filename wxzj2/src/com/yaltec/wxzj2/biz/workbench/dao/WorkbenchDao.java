package com.yaltec.wxzj2.biz.workbench.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.yaltec.wxzj2.biz.property.entity.House;
import com.yaltec.wxzj2.biz.system.entity.Menu;
import com.yaltec.wxzj2.biz.workbench.entity.MyWorkbenchConfig;
import com.yaltec.wxzj2.biz.workbench.entity.MyWorkbenchPic;

@Repository
public interface WorkbenchDao {
	public List<House> findCjmx(Map<String, Object> map);	
	/**
	 * 查找个人设置(有权限的)
	 * @param userid
	 * @return
	 */
	public List<MyWorkbenchConfig> findConfig(Map<String, String> map);		
	/**
	 * 删除个人设置
	 * @param loginid
	 */
	public int delteleByloginid(String loginid);
	/**
	 * 个人添加所有的二级菜单id
	 * @param userid
	 */
	public int insertConfig(MyWorkbenchConfig myConfig);
	/**
	 * 获取所有工作台选择的图片
	 * @return
	 */
	public List<MyWorkbenchPic> getMyWorkbenchPic();
	/**
	 * 查询个人设置后添加的权限
	 * @return
	 */
	public List<Menu> findOtherConfig(Map<String, String> map);
	
	/**
	 * 导出催交明细
	 * @param map
	 * @return
	 */
	public List<House> toExportCjmx(Map<String, String> map);
	
}

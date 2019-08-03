package com.yaltec.wxzj2.biz.workbench.service;

import java.util.List;
import java.util.Map;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.property.entity.House;
import com.yaltec.wxzj2.biz.propertymanager.entity.ChangeProperty;
import com.yaltec.wxzj2.biz.workbench.entity.MyWorkbenchConfig;
import com.yaltec.wxzj2.biz.workbench.entity.MyWorkbenchPic;

public interface WorkbenchService {
	/**
	 * 查询催交明细
	 * @param page
	 * @param map
	 */
	public void findCjmx(Page<House> page, Map<String, Object> map);	
	/**
	 * 获取个人工作台设置信息
	 * @param paramMap
	 * @return
	 */
	public Map<String, List<MyWorkbenchConfig>> getMyWorkbenchConfig(String typeName);

	/**
	 *  保存个人工作台设置
	 * @param map
	 */
	public void saveConfig(Map<String, String> map);
	/**
	 * 获取所有工作台选择的图片
	 * @return
	 */
	public List<MyWorkbenchPic> getMyWorkbenchPic();
	
	/**
	 * 导出不足30%的房屋信息
	 * @param map
	 * @return
	 */
	public List<House> toExportCjmx(Map<String, String> map);
}

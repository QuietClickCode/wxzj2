package com.yaltec.wxzj2.biz.propertymanager.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

/**
 * 
 * @ClassName: HouseChangeService
 * @Description: TODO房屋变更 service接口
 * 
 * @author YL
 * @date 2016-8-25 上午09:11:19
 */
public interface HouseChangeService {
	
	/**
	 * 查询临时表中的数据
	 * @return
	 */
	public List<Map<String,String>> query(Map<String, String> map);
	

	/**
	 * 执行修改或插入语句
	 * @return
	 */
	public Integer execUpdate(Map<String, String> map);
	
	/**
	 * 执行查询语句
	 * @return
	 */
	public List<Map<String,String>> execQuery(Map<String, String> map);

	
	/**
	 * 执行变更
	 * @return
	 */
	public Integer executeChange(Map<String, String> map);
	/**
	 * 资金分摊 
	 * @return
	 */
	public Integer share(Map<String, String> map);
	/**
	 * 房屋变更记录查询
	 * @param map
	 * @return
	 */
	public List<Map<String,String>> queryHouseChange(Map<String, Object> map);
	/**
	 * 导出房屋变更记录
	 */	
	public void export(Map<String, Object> map,HttpServletResponse response);

	/**
	 * 按业务编号删除房屋变更业务
	 * @return
	 */
	public Integer delBusinessByP004(Map<String, String> map);
}	
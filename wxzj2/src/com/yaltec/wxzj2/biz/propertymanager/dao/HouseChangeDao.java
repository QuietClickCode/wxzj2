package com.yaltec.wxzj2.biz.propertymanager.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.yaltec.wxzj2.biz.property.entity.House;
import com.yaltec.wxzj2.biz.propertymanager.entity.Redemption;

@Repository
public interface HouseChangeDao {
	
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
	public void executeChange(Map<String, String> map);
	/**
	 * 资金分摊 
	 * @return
	 */
	public void share(Map<String, String> map);
	/**
	 * 房屋变更记录查询
	 * @param map
	 * @return
	 */
	public List<Map<String,String>> queryHouseChange(Map<String, Object> map);

	/**
	 * 按业务编号删除房屋变更业务
	 * @return
	 */
	public void delBusinessByP004(Map<String, String> map);
}

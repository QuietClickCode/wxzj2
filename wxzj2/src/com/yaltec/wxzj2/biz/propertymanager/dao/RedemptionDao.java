package com.yaltec.wxzj2.biz.propertymanager.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.yaltec.wxzj2.biz.property.entity.House;
import com.yaltec.wxzj2.biz.propertymanager.entity.Redemption;

@Repository
public interface RedemptionDao {
	
	/**
	 * 查询房屋换购列表
	 * 
	 * @param query
	 * @return
	 */
	public List<Redemption> findAll(Map<String, Object> paramMap);
	
	/**
	 * 检查换购日期不能小于原房屋交款日期
	 * @param paramMap
	 * @return
	 */
	public String checkForsaveRedemption(Map<String, String> map);
	
	/**
	 * 保存房屋换购信息
	 * @param map
	 * @return
	 */
	public void saveRedemption(Map<String, String> map);
	
	/**
	 * 查询打印房屋换购通知书
	 * @param w008
	 * @return
	 */
	public List<Redemption> getRedemptionByW008(String w008);
	
	/**
	 * 删除房屋换购
	 * @param map
	 */
	public void delRedemption(Map<String, String> map);
	
	/**
	 * 导出换购补交信息
	 * @param map
	 * @return
	 */
	public List<House> exportForHouseUnit(Map<String, String> map);
	
}

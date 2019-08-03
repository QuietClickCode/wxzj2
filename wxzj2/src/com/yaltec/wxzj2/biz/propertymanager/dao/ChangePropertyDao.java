package com.yaltec.wxzj2.biz.propertymanager.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.yaltec.wxzj2.biz.payment.entity.HousedwImport;
import com.yaltec.wxzj2.biz.propertymanager.entity.ChangeProperty;
import com.yaltec.wxzj2.biz.propertymanager.entity.HouseUnitImport;

@Repository
public interface ChangePropertyDao {
	
	/**
	 * 查询变更信息列表
	 * 
	 * @param query
	 * @return
	 */
	public List<ChangeProperty> change(Map<String, Object> paramMap);
	
	/**
	 * 打印清册
	 * @param paramMap
	 * @return
	 */
	public List<ChangeProperty> inventory(Map<String, String> paramMap);
	
	/**
	 * 根据h001查询该房屋的变更信息
	 * @return
	 */
	public ChangeProperty findByH001();
	
	/**
	 * 保存产权变更
	 * @param map
	 */
	public void saveChangeProperty(Map<String, String> map);
	
	/**
	 * 保存变更编辑
	 * @param map
	 */
	public void propertySave(Map<String, String> map);
	
	/**
	 * 判断是否江津
	 * @return
	 */
	public String queryIsJJ();
	
	/**
	 * 删除票据接收信息
	 * @param map
	 */
	public void delReceiveBill(Map<String, String> map);
	
	/**
	 *  获取单位房屋上报BS临时表最大tmepCode+1
	 */
	public String getMaxCodeHouse_dwBS();
	
	/**
	 * 插入单位房屋上报BS临时数据之前，清空当前用户的相关数据
	 * @param map
	 */
	public void deleteHouse_dwBSByUserid(Map<String, Object> map);
	
	/**
	 * 保存变更批录
	 * @param map
	 */
	public void saveChangeProperty_PL(Map<String, Object> paramMap);
	
	public List<ChangeProperty> queryChangeProperty2(Map<String, String> map);
	

	public void insertHouseUnit(List<HousedwImport> list);

	public String check_jcbz(String tempCode);

	public String checkInsertHouseUnitData1(String tempCode);

	public String checkInsertHouseUnitData2(String tempCode);

	public List<HouseUnitImport> checkIsHouseByLYAndH005(String tempCode);
	
	public List<ChangeProperty> pdfManyChangeProperty(Map<String, String> map); 
	
	
}

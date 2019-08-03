package com.yaltec.wxzj2.biz.property.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.yaltec.wxzj2.biz.property.entity.PropertyCompany;

/**
 * 
 * @ClassName: PropertyCompanyDao
 * @Description: TODO物业公司dao
 * 
 * @author yangshanping
 * @date 2016-7-18 上午10:35:11
 */
@Repository
public interface PropertyCompanyDao {
	
	public List<PropertyCompany> findAll(PropertyCompany propertyCom);
	
	public PropertyCompany findByBm(PropertyCompany propertyCom);
	
	public PropertyCompany find(PropertyCompany propertyCom);
	
	public void save(Map<String, String> map);
	
	public void update(Map<String, String> map);
	
	public int delPropertyCompany(Map<String, String> paramMap);
	
	public String checkForSave(Map<String, String> map);
	
}

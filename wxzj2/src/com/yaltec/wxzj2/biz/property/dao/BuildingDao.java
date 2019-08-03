package com.yaltec.wxzj2.biz.property.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.yaltec.wxzj2.biz.draw.entity.CodeName;
import com.yaltec.wxzj2.biz.property.entity.Building;

/**
 * 
 * @ClassName: BuildingDao
 * @Description: TODO楼宇dao接口
 * 
 * @author yangshanping
 * @date 2016-7-22 下午05:26:00
 */
@Repository
public interface BuildingDao {
	
	public List<Building> findAll(Building building);

	public Building findByLybh(Building building);
	
	public Building find(String xqbh);
	
	public Building findByLymc(String lymc);

	//获取楼宇编码
	public void getBuildingBm(Map<String, String> map);
	
	public void save(Map<String, String> map);

	public void update(Map<String, String> map);

	public int delBuilding(Map<String, String> paramMap);

	public String getFwlxByBuilding(String lybh);
	
	public String getAddressForBuilding(String lybh);

	public List<Building> findXqByKfgs(String kfgs);
	
	public List<CodeName> queryIndustryByXqbh(Map<String, String> map);
}

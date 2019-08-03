package com.yaltec.wxzj2.biz.compositeQuery.service;

import java.util.List;
import java.util.Map;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.compositeQuery.entity.BuildingInterestF;

/**
 * <p>ClassName: BuildingInterestFService</p>
 * <p>Description: 楼宇利息单查询服务接口</p>
 * <p>Company: YALTEC</p> 
 * @author moqian
 * @date 2016-8-23 下午14:12:03
 */

public interface BuildingInterestFService {	
	/**
	 * 翻页查询所有楼宇利息单信息
	 * 
	 * @param page
	 */	
	public void queryBuildingInterestF(Page<BuildingInterestF> page,Map<String, Object> paramMap);
	
	/**
	 * 查询楼宇利息单信息
	 * @param paramMap
	 * @return
	 */
	public List<BuildingInterestF> findBuildingInterestF(Map<String, Object> paramMap);

}

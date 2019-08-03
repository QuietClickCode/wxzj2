package com.yaltec.wxzj2.biz.compositeQuery.dao;

import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Repository;
import com.yaltec.wxzj2.biz.compositeQuery.entity.BuildingInterestF;

@Repository
public interface BuildingInterestFDao {
	
	public List<BuildingInterestF> queryBuildingInterestF(Map<String, Object> paramMap);
	
	public List<BuildingInterestF> findBuildingInterestF(Map<String, Object> paramMap);

}

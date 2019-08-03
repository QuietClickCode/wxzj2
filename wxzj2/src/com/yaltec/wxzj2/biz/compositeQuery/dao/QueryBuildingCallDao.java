package com.yaltec.wxzj2.biz.compositeQuery.dao;

import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Repository;
import com.yaltec.wxzj2.biz.compositeQuery.entity.BuildingCall;

@Repository
public interface QueryBuildingCallDao {
	
	public List<BuildingCall> queryBuildingCall(Map<String, Object> paramMap);

	public List<BuildingCall> findBuildingCall(Map<String, String> paramMap);
}
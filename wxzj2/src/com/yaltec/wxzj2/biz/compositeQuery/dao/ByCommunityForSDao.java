package com.yaltec.wxzj2.biz.compositeQuery.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.yaltec.wxzj2.biz.compositeQuery.entity.ByBuildingForC1;

@Repository
public interface ByCommunityForSDao {
	
	public List<ByBuildingForC1> queryByCommunityForS_BS(Map<String, Object> paramMap);
	
	public List<ByBuildingForC1> findByCommunityForS(Map<String, Object> paramMap);
}

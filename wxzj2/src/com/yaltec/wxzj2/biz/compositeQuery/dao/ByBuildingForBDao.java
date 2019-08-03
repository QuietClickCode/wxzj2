package com.yaltec.wxzj2.biz.compositeQuery.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;
import com.yaltec.wxzj2.biz.compositeQuery.entity.ByCommunityForB;

@Repository
public interface ByBuildingForBDao {
	
	public List<ByCommunityForB> queryByBuildingForB(Map<String, Object> paramMap);
	
	public List<ByCommunityForB> findByBuildingForB(Map<String, Object> paramMap);

}

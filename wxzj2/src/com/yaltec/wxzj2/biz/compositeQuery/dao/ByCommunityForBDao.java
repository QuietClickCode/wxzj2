package com.yaltec.wxzj2.biz.compositeQuery.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.yaltec.wxzj2.biz.compositeQuery.entity.ByCommunityForB;
import com.yaltec.wxzj2.biz.draw.entity.CodeName;

@Repository
public interface ByCommunityForBDao {
	
	public List<ByCommunityForB> queryByCommunityForB(Map<String, Object> paramMap);

	public List<CodeName> queryOpenCommunityByBank(Map<String, String> map);
	
	public List<ByCommunityForB> findByCommunityForB(Map<String, Object> paramMap);
}

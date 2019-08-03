package com.yaltec.wxzj2.biz.compositeQuery.service;

import java.util.List;
import java.util.Map;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.compositeQuery.entity.QueryCommunityP;

public interface QueryCommunityPService {

	/**
	 * 翻页查询
	 * 
	 * @param page
	 */	
	public void findList(Page<QueryCommunityP> page,Map<String, Object> paramMap);
	
	/**
	 * 查询
	 * @param paramMap
	 * @return
	 */
	public List<QueryCommunityP> findList(Map<String, Object> paramMap);
	
	
	public List<QueryCommunityP> findByCommunityP(Map<String, Object> paramMap);
}

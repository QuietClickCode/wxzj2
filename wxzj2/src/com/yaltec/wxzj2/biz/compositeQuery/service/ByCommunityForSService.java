package com.yaltec.wxzj2.biz.compositeQuery.service;

import java.util.List;
import java.util.Map;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.compositeQuery.entity.ByBuildingForC1;

/**
 * <p>ClassName: ByCommunityForSService</p>
 * <p>Description: 小区台账查询服务接口</p>
 * <p>Company: YALTEC</p> 
 * @author moqian
 * @date 2016-8-4 下午14:12:03
 */

public interface ByCommunityForSService {
	
	/**
	 * 翻页查询
	 * 
	 * @param page
	 */	
	public void queryByCommunityForS_BS(Page<ByBuildingForC1> page,Map<String, Object> paramMap);
	
	/**
	 * 查询小区台账信息
	 * @param paramMap
	 * @return
	 */
	public List<ByBuildingForC1> findByCommunityForS(Map<String, Object> paramMap);
}

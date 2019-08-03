package com.yaltec.wxzj2.biz.compositeQuery.service;

import java.util.List;
import java.util.Map;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.compositeQuery.entity.BuildingInterestF;

/**
 * <p>ClassName: CommunityInterestFService</p>
 * <p>Description: 小区利息单查询服务接口</p>
 * <p>Company: YALTEC</p> 
 * @author moqian
 * @date 2016-8-23 下午14:12:03
 */

public interface CommunityInterestFService {	
	/**
	 * 翻页查询所有小区利息单信息
	 * 
	 * @param page
	 */	
	public void queryCommunityInterestF(Page<BuildingInterestF> page,Map<String, Object> paramMap);
	
	/**
	 * 查询小区利息单信息
	 * @param paramMap
	 * @return
	 */
	public List<BuildingInterestF> findCommunityInterestF(Map<String, Object> paramMap);

}

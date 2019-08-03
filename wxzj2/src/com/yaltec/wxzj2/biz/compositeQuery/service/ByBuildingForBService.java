package com.yaltec.wxzj2.biz.compositeQuery.service;

import java.util.List;
import java.util.Map;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.compositeQuery.entity.ByCommunityForB;

/**
 * <p>ClassName: ByBuildingForBService</p>
 * <p>Description: 楼宇余额查询服务接口</p>
 * <p>Company: YALTEC</p> 
 * @author moqian
 * @date 2016-8-9 下午16:12:03
 */

public interface ByBuildingForBService {	
	/**
	 * 翻页查询所有楼宇余额信息
	 * 
	 * @param page
	 */	
	public void queryByBuildingForB(Page<ByCommunityForB> page,Map<String, Object> paramMap);
	
	/**
	 * 查询楼宇余额信息
	 * @param paramMap
	 * @return
	 */
	public List<ByCommunityForB> findByBuildingForB(Map<String, Object> paramMap);

}

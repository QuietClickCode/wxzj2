package com.yaltec.wxzj2.biz.compositeQuery.service;

import java.util.List;
import java.util.Map;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.compositeQuery.entity.BuildingCall;
import com.yaltec.wxzj2.biz.property.entity.House;

/**
 * <p>ClassName: QueryBuildingCallService</p>
 * <p>Description: 楼宇催交查询服务接口</p>
 * <p>Company: YALTEC</p> 
 * @author moqian
 * @date 2016-8-26 下午14:12:03
 */

public interface QueryBuildingCallService {
	
	/**
	 * 翻页查询
	 * 
	 * @param page
	 */	
	public void queryBuildingCall(Page<BuildingCall> page,Map<String, Object> paramMap);
	/**
	 * 查询楼宇催交信息
	 * @param paramMap
	 * @return
	 */
	public List<BuildingCall> findBuildingCall(Map<String, String> paramMap);

}

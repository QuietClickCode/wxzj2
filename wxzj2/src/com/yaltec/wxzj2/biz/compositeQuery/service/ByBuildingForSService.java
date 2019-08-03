package com.yaltec.wxzj2.biz.compositeQuery.service;

import java.util.List;
import java.util.Map;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.compositeQuery.entity.ByBuildingForC1;

/**
 * <p>ClassName: ByBuildingForSService</p>
 * <p>Description: 楼宇台账查询服务接口</p>
 * <p>Company: YALTEC</p> 
 * @author moqian
 * @date 2016-8-4 上午09:12:03
 */

public interface ByBuildingForSService {
	
	/**
	 * 翻页查询
	 * 
	 * @param page
	 */	
	public void queryByBuildingForS(Page<ByBuildingForC1> page,Map<String, Object> paramMap);
	
	/**
	 * 查询楼宇台账信息
	 * @param paramMap
	 * @return
	 */
	public List<ByBuildingForC1> findByBuildingForS(Map<String, Object> paramMap);

}

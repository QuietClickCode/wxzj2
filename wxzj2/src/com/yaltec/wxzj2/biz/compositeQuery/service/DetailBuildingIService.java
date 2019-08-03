package com.yaltec.wxzj2.biz.compositeQuery.service;

import java.util.List;
import java.util.Map;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.compositeQuery.entity.DetailBuildingI;

/**
 * <p>ClassName: DetailBuildingIService</p>
 * <p>Description: 楼宇利息明细查询服务接口</p>
 * <p>Company: YALTEC</p> 
 * @author moqian
 * @date 2016-8-23 下午14:12:03
 */

public interface DetailBuildingIService {	
	/**
	 * 翻页查询所有楼宇利息明细信息
	 * 
	 * @param page
	 */	
	public void queryDetailBuildingI(Page<DetailBuildingI> page,Map<String, Object> paramMap);
	
	/**
	 * 查询楼宇利息明细信息
	 * @param paramMap
	 * @return
	 */
	public List<DetailBuildingI> findDetailBuildingI(Map<String, Object> paramMap);

}

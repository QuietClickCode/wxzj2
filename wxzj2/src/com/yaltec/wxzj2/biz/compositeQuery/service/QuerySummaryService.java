package com.yaltec.wxzj2.biz.compositeQuery.service;

import java.util.List;
import java.util.Map;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.compositeQuery.entity.ByBuildingForC1;



/**
 * <p>ClassName: QuerySummaryService</p>
 * <p>Description: 汇总台账查询服务接口</p>
 * <p>Company: YALTEC</p> 
 * @author moqian
 * @date 2016-8-9 上午09:12:03
 */
public interface QuerySummaryService {
	
	/**
	 * 翻页查询
	 * 
	 * @param page
	 */	
	public void queryQuerySummary_BS(Page<ByBuildingForC1> page,Map<String, Object> paramMap);
	
	/**
	 * 查询汇总台账信息
	 * @param paramMap
	 * @return
	 */
	public List<ByBuildingForC1> findQuerySummary(Map<String, Object> paramMap);

}

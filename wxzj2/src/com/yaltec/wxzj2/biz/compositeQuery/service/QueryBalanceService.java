package com.yaltec.wxzj2.biz.compositeQuery.service;

import java.util.List;
import java.util.Map;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.compositeQuery.entity.QueryBalance;

/**
 * <p>ClassName: QueryBalanceService</p>
 * <p>Description: 业主余额查询服务接口</p>
 * <p>Company: YALTEC</p> 
 * @author moqian
 * @date 2016-8-9 下午16:12:03
 */

public interface QueryBalanceService {	
	/**
	 * 翻页查询
	 * 
	 * @param page
	 */	
	public void queryQueryBalance(Page<QueryBalance> page,Map<String, Object> paramMap);
	
	/**
	 * 查询业主余额(导出)信息
	 */
	public List<QueryBalance> findQueryBalance(Map<String, Object> paramMap);

}

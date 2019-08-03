package com.yaltec.wxzj2.biz.compositeQuery.service;

import java.util.List;
import java.util.Map;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.property.entity.House;

/**
 * <p>ClassName: QueryMoneyWarningService</p>
 * <p>Description: 资金预警查询服务接口</p>
 * <p>Company: YALTEC</p> 
 * @author moqian
 * @date 2016-8-29 上午09:12:03
 */

public interface QueryMoneyWarningService {	
	/**
	 * 翻页查询所有资金预警查询信息
	 * 
	 * @param page
	 */	
	public void QueryMoneyWarning(Page<House> page,Map<String, Object> paramMap);
	/**
	 * 查询资金预警信息
	 * @param paramMap
	 * @return
	 */
	public List<House> findMoneyWarning(Map<String, String> paramMap);

}

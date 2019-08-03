package com.yaltec.wxzj2.biz.compositeQuery.service;

import java.util.List;
import java.util.Map;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.payment.entity.UnitToPrepay;
import com.yaltec.wxzj2.biz.property.entity.House;

/**
 * <p>ClassName: QueryDunningService</p>
 * <p>Description: 续筹催交查询服务接口</p>
 * <p>Company: YALTEC</p> 
 * @author moqian
 * @date 2016-8-25 下午14:12:03
 */

public interface QueryDunningService {	
	/**
	 * 翻页查询所有续筹催交信息
	 * 
	 * @param page
	 */	
	public void queryQueryDunning(Page<House> page,Map<String, Object> paramMap);
	
	/**
	 * 查询单位交支信息
	 * @param paramMap
	 * @return
	 */
	public List<House> findQueryDunning(Map<String, String> paramMap);

}

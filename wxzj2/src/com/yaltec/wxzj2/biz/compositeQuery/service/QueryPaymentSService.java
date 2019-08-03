package com.yaltec.wxzj2.biz.compositeQuery.service;

import java.util.List;
import java.util.Map;


import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.compositeQuery.entity.QueryPaymentS;

/**
 * <p>ClassName: QueryPaymentSService</p>
 * <p>Description: 汇缴清册查询服务接口</p>
 * <p>Company: YALTEC</p> 
 * @author moqian
 * @date 2016-8-25 上午09:12:03
 */

public interface QueryPaymentSService {	
	/**
	 * 翻页查询所有汇缴清册信息
	 * 
	 * @param page
	 */	
	public void queryQueryPaymentS(Page<QueryPaymentS> page,Map<String, Object> paramMap);
	
	/**
	 * 查询小区余额(导出)信息
	 * @param paramMap
	 * @return
	 */
	public List<QueryPaymentS> findQueryPaymentS(Map<String, Object> paramMap);
	
}

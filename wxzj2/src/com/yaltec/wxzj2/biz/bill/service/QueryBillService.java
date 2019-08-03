package com.yaltec.wxzj2.biz.bill.service;

import java.util.List;
import java.util.Map;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.bill.entity.QueryBill;

public interface QueryBillService {
	
	/**
	 * 翻页查询
	 * 
	 * @param page
	 */	
	public void findAll(Page<QueryBill> page,Map<String, Object> paramMap);
	
	/**
	 * 查询票据信息
	 */	
	public List<QueryBill> findQueryBill(Map<String, Object> paramMap);
	
	/**
	 * 查询票据页面的查询票据统计信息
	 */	
	public QueryBill getQueryBillInfoSum(Map<String, String> paramMap);

}

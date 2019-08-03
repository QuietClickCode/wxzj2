package com.yaltec.wxzj2.biz.bill.service;

import java.util.Map;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.bill.entity.CountBill;

/**
 * <p>ClassName: CountBillService</p>
 * <p>Description: 票据统计服务接口</p>
 * <p>Company: YALTEC</p> 
 * @author moqian
 * @date 2016-7-30 下午02:35:57
 */

public interface CountBillService {
	
	/**
	 * 翻页查询
	 * 
	 * @param page
	 */	
	public void findAll(Page<CountBill> page,Map<String, Object> paramMap);;

}

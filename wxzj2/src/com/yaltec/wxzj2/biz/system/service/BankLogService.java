package com.yaltec.wxzj2.biz.system.service;

import java.util.List;
import java.util.Map;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.system.entity.BankLog;

/**
 * <p>ClassName: BankLogService</p>
 * <p>Description: 银行日志信息服务接口(这里用一句话描述这个类的作用)</p>
 * <p>Company: YALTEC</p> 
 * @author jiangyong
 * @date 2016-10-10 下午02:35:57
 */
public interface BankLogService {
	
	/**
	 * 翻页查询
	 * 
	 * @param page
	 */
	public void findAll(Page<BankLog> page, Map<String, Object> params);

	List<BankLog> findAll2(Map<String, Object> params);
	
}

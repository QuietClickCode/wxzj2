package com.yaltec.wxzj2.biz.compositeQuery.service;

import java.util.List;
import java.util.Map;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.compositeQuery.entity.MonthReportOfBank;

/**
 * <p>ClassName: MonthReportOfBankService</p>
 * <p>Description:  按银行统计月报查询服务接口</p>
 * <p>Company: YALTEC</p> 
 * @author moqian
 * @date 2016-8-25 上午10:12:03
 */

public interface MonthReportOfBankService {	
	/**
	 * 翻页查询所有按银行统计月报信息
	 * 
	 * @param page
	 */	
	public void queryMonthReportOfBank(Page<MonthReportOfBank> page,Map<String, Object> paramMap);
	/**
	 * 查询银行统计月报信息
	 * @param map
	 * @return
	 */
	public List<MonthReportOfBank> findReportOfBank(Map<String, String> map);

}

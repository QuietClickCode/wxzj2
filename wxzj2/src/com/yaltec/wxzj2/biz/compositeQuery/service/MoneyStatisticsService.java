package com.yaltec.wxzj2.biz.compositeQuery.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.compositeQuery.entity.MoneyStatistics;

/**
 * <p>ClassName: BuildingInterestFService</p>
 * <p>Description: 资金统计报表查询服务接口</p>
 * <p>Company: YALTEC</p> 
 * @author moqian
 * @date 2016-8-23 下午14:12:03
 */

public interface MoneyStatisticsService {	
	/**
	 * 分页查询资金统计报表
	 * 
	 * @param page
	 */	
	public void queryList(Page<MoneyStatistics> page,Map<String, Object> paramMap);
	
	/**
	 * 查询资金统计报表
	 */	
	public List<MoneyStatistics> queryList(Map<String, Object> paramMap);
	/**
	 * 导出资金统计报表
	 */	
	public void export(Map<String, Object> map,HttpServletResponse response);
	/**
	 * 打印资金统计报表
	 */	
	public void print(Map<String, Object> map,HttpServletResponse response);

}

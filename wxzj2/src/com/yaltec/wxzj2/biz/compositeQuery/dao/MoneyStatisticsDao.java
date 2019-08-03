package com.yaltec.wxzj2.biz.compositeQuery.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.yaltec.wxzj2.biz.compositeQuery.entity.MoneyStatistics;

@Repository
public interface MoneyStatisticsDao {
	
	public List<MoneyStatistics> queryMoneyStatistics(Map<String, Object> paramMap);
	
	/**
	 * 资金统计报表查询（用于导出和打印）
	 * @param paramMap
	 * @return
	 */
	public List<Map<String,String>> queryMoneyStatisticsResultMap(Map<String, Object> paramMap);
	
}

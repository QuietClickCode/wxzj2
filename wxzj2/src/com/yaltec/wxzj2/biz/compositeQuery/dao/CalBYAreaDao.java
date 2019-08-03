package com.yaltec.wxzj2.biz.compositeQuery.dao;

import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Repository;
import com.yaltec.wxzj2.biz.compositeQuery.entity.MonthReportOfBank;

@Repository
public interface CalBYAreaDao {
	
	public List<MonthReportOfBank> queryCalBYArea(Map<String, Object> paramMap);

	public List<MonthReportOfBank> findCalBYArea(Map<String, String> map);
}

package com.yaltec.wxzj2.biz.compositeQuery.dao;

import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Repository;
import com.yaltec.wxzj2.biz.property.entity.House;

@Repository
public interface QueryMoneyWarningDao {
	
	public List<House> QueryMoneyWarning(Map<String, Object> paramMap);
	
	public List<House> findMoneyWarning(Map<String, String> paramMap);

}

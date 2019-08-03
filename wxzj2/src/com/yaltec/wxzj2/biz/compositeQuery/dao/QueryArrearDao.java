package com.yaltec.wxzj2.biz.compositeQuery.dao;

import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Repository;
import com.yaltec.wxzj2.biz.property.entity.House;

@Repository
public interface QueryArrearDao {
	
	public List<House> QueryArrear(Map<String, Object> paramMap);

	public List<House> findArrear(Map<String, String> paramMap);
}

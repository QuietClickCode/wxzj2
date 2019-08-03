package com.yaltec.wxzj2.biz.compositeQuery.dao;

import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Repository;
import com.yaltec.wxzj2.biz.compositeQuery.entity.CountHouse;

@Repository
public interface CountHouseDao {
	
	public List<CountHouse> queryCountHouse(Map<String, Object> paramMap);
	
	public List<CountHouse> findCountHouse(Map<String, Object> paramMap);

}


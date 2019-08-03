package com.yaltec.wxzj2.biz.compositeQuery.dao;

import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Repository;

import com.yaltec.wxzj2.biz.compositeQuery.entity.QueryBalance;

@Repository
public interface QueryBalanceDao {
	
	public List<QueryBalance> queryQueryBalance(Map<String, Object> paramMap);
	
	public List<QueryBalance> findQueryBalance(Map<String, Object> paramMap);

}

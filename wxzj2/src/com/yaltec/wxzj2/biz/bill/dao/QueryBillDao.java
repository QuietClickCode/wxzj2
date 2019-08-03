package com.yaltec.wxzj2.biz.bill.dao;

import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Repository;
import com.yaltec.wxzj2.biz.bill.entity.QueryBill;

@Repository
public interface QueryBillDao {
	
	public List<QueryBill> findAll(Map<String, Object> paramMap);
	
	public List<QueryBill> findQueryBill(Map<String, Object> paramMap);
	
	public QueryBill getQueryBillInfoSum(Map<String, String> paramMap);

}

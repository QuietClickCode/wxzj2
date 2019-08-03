package com.yaltec.wxzj2.biz.bill.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;
import com.yaltec.wxzj2.biz.bill.entity.CountBill;

@Repository
public interface CountBillDao {
	
	public List<CountBill> findAll(Map<String, Object> paramMap);

}

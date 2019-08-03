package com.yaltec.wxzj2.biz.bill.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;
import com.yaltec.wxzj2.biz.bill.entity.ErrorBill;

@Repository
public interface ErrorBillDao {
	
	public List<ErrorBill> findAll(Map<String, Object> paramMap);
	
	public List<ErrorBill> findErrorBill(Map<String, Object> paramMap);
	
	public String checkRegNo(Map<String, String> paramMap);
	
	public String checkEditW011_1(Map<String, String> paramMap);
	
	public String checkEditW011_2(Map<String, String> paramMap);
	
	public int checkEditW011_3();
	
	public int eidtW011_01(Map<String, String> paramMap);
	
	public int eidtW011_02(Map<String, String> paramMap);
	
	public int eidtW011PaymentReg_01(Map<String, String> paramMap);
	
	public int eidtW011PaymentReg_02(Map<String, String> paramMap);
	
	public int eidtW011PaymentReg_03(Map<String, String> paramMap);
	
	public String queryRegNoByBill(Map<String, String> paramMap);
	
}

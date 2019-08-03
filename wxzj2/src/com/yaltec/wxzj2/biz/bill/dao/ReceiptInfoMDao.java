package com.yaltec.wxzj2.biz.bill.dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;


@Repository
public interface ReceiptInfoMDao {
	
	public String getNextBillNo(Map<String, String> paramMap);
	
	public String getRegNoByBillNo(String billNo);
	
	public void saveBillNo(Map<String, String> paramMap);
	
	public int handleRegNo();
	
	public List<String> getNextBillNos(Map<String, String> paramMap);
	
	public ArrayList<String> execSQL(Map<String, String> paramMap);
}

package com.yaltec.wxzj2.biz.bill.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.bill.entity.ReceiptInfoM;

@Repository
public interface StartUseBillDao {
	
	public void find(Page<ReceiptInfoM> page,Map<String, Object> paramMap);
	
	public List<ReceiptInfoM> findAll(Map<String, Object> paramMap);

	public int save(Map<String, Object> map);	
	
	public String check(Map<String, String> paramMap);
	
	public int clearOwner(Map<String, String> paramMap);
}

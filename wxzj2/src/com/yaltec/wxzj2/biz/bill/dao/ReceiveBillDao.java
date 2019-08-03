package com.yaltec.wxzj2.biz.bill.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;
import com.yaltec.wxzj2.biz.bill.entity.ReceiveBill;

@Repository
public interface ReceiveBillDao {
	
	public List<ReceiveBill> findAll(ReceiveBill receiveBill);

	public int save(ReceiveBill receiveBill);	
	
    public ReceiveBill findByBm(String bm);
	
	public int update(ReceiveBill receiveBill);
	
	public void batchDelete(Map<String, String> paramMap);
	
	public ReceiveBill findMaxBm();
}

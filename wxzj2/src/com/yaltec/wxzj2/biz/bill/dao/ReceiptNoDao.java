package com.yaltec.wxzj2.biz.bill.dao;

import java.util.List;

import org.springframework.stereotype.Repository;
import com.yaltec.wxzj2.biz.bill.entity.ReceiptNo;

@Repository
public interface ReceiptNoDao {
	
	public List<ReceiptNo> findAll(ReceiptNo receiptNo);
	
}

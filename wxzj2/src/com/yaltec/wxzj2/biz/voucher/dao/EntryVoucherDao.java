package com.yaltec.wxzj2.biz.voucher.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.yaltec.wxzj2.biz.voucher.entity.ReviewCertificate;

@Repository
public interface EntryVoucherDao {

	public List<ReviewCertificate> findAll(Map<String, Object> map);
	
	public int batchDelVoucher(List<String> list);
	
	public void getBusinessNO(Map<String, Object> map);
	
	public void add(Map<String, Object> map);
	
}

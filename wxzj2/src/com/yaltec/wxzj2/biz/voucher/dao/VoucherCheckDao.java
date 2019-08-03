package com.yaltec.wxzj2.biz.voucher.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.yaltec.wxzj2.biz.voucher.entity.QueryVoucherCheck;
import com.yaltec.wxzj2.biz.voucher.entity.VoucherAnnex;
import com.yaltec.wxzj2.biz.voucher.entity.VoucherCheck;

@Repository
public interface VoucherCheckDao {

	public List<VoucherCheck> get(Map<String, Object> map);

	public List<QueryVoucherCheck> findAll(Map<String, Object> map);

	public void save(Map<String, Object> map);

	public void updateP022(Map<String, Object> map);

	public String getCheckDate();

	public String getInterestDate(String p004);

	public List<VoucherAnnex> findVoucherAnnexDN(Map<String, Object> map);
	
	public List<VoucherAnnex> findVoucherAnnexLS(Map<String, Object> map);
	
	public String GetSummaryByP004(Map<String, Object> map);
}

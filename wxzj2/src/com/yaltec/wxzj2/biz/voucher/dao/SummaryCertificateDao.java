package com.yaltec.wxzj2.biz.voucher.dao;

import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Repository;
import com.yaltec.wxzj2.biz.voucher.entity.SummaryCertificate;

@Repository
public interface SummaryCertificateDao {

	public List<SummaryCertificate> findAll(Map<String, Object> map);
	
	public List<SummaryCertificate> findSummaryCertificate(Map<String, Object> map);

}

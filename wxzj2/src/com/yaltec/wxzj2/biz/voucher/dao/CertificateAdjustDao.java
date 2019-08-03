package com.yaltec.wxzj2.biz.voucher.dao;

import java.util.List;

import com.yaltec.wxzj2.biz.voucher.entity.ReviewCertificate;

public interface CertificateAdjustDao {
	
	public List<ReviewCertificate> findByTime(ReviewCertificate reviewCertificate);
	
	public void updateCertificateAdjust(String p005);

}

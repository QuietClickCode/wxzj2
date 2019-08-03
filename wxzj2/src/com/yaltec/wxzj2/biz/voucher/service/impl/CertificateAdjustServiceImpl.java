package com.yaltec.wxzj2.biz.voucher.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.github.pagehelper.PageHelper;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.voucher.dao.CertificateAdjustDao;
import com.yaltec.wxzj2.biz.voucher.entity.ReviewCertificate;
import com.yaltec.wxzj2.biz.voucher.service.CertificateAdjustService;



/**
 * <p>
 * ClassName: DeveloperServiceImpl
 * </p>
 * <p>
 * Description: 凭证号调整模块服务实现类(这里用一句话描述这个类的作用)
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author chenxiaokuang
 * @date 2016-9-12 上午08:52:14
 */
@Service
public class CertificateAdjustServiceImpl implements CertificateAdjustService{

	@Autowired
	private CertificateAdjustDao certificateAdjustDao;
	
	@Override
	public void findByTime(Page<ReviewCertificate> page) {
		PageHelper.startPage(page.getPageNo(), page.getPageSize());
		List<ReviewCertificate> list = certificateAdjustDao.findByTime(page.getQuery());
		page.setData(list);
	}
	@Override
	public void updateCertificateAdjust(String p005) {
		certificateAdjustDao.updateCertificateAdjust(p005);
	}
}

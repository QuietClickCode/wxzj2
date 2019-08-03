package com.yaltec.wxzj2.biz.voucher.service.impl;

import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.yaltec.wxzj2.biz.voucher.dao.SummaryCertificateDao;
import com.yaltec.wxzj2.biz.voucher.entity.SummaryCertificate;
import com.yaltec.wxzj2.biz.voucher.service.SummaryCertificateService;

/**
 * <p>
 * ClassName: SummaryCertificateServiceImpl
 * </p>
 * <p>
 * Description: 凭证汇总服务实现类
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author moqian
 * @date 2016-9-5 下午14:02:19
 */
@Service
public class SummaryCertificateServiceImpl implements SummaryCertificateService {

	@Autowired
	private SummaryCertificateDao summaryCertificateDao;

	@Override
	public List<SummaryCertificate> findAll(Map<String, Object> map) {
		List<SummaryCertificate> list = summaryCertificateDao.findAll(map);
		return list;
	}
	
	public List<SummaryCertificate> findSummaryCertificate(Map<String, Object> map) {
		return summaryCertificateDao.findSummaryCertificate(map);
	}

}

package com.yaltec.wxzj2.biz.voucher.service;


import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.voucher.entity.ReviewCertificate;

/**
 * <p>ClassName: DeveloperService</p>
 * <p>Description: 凭证号调整服务接口(这里用一句话描述这个类的作用)</p>
 * <p>Company: YALTEC</p> 
 * @author chenxiaokuang
 * @date 2016-9-12 下午02:35:57
 */
public interface CertificateAdjustService {
	/**
	 * 根据对应的月份查询凭证号调整列表
	 * @param time
	 * @return
	 */
	public void findByTime(Page<ReviewCertificate> page);
	
	/**
	 * 凭证审核_凭证号调整
	 * @param p005
	 * @return
	 */
	public void updateCertificateAdjust(String p005);
}

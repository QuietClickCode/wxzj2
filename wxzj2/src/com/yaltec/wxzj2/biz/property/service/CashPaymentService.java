package com.yaltec.wxzj2.biz.property.service;

import com.yaltec.wxzj2.biz.property.entity.CashPayment;


/**
 * 
 * @ClassName: CashPaymentService
 * @Description: TODO现金资金凭证信息Service接口
 * 
 * @author yangshanping
 * @date 2016-7-29 下午04:15:59
 */
public interface CashPaymentService {
	
	/**
	 * 根据楼h001查询房屋信息
	 * @return
	 */
	public CashPayment findByH001(String h001);
}

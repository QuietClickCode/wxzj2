package com.yaltec.wxzj2.biz.property.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.yaltec.wxzj2.biz.property.dao.CashPaymentDao;
import com.yaltec.wxzj2.biz.property.entity.CashPayment;
import com.yaltec.wxzj2.biz.property.service.CashPaymentService;

/**
 * 
 * @ClassName: CashPaymentServiceImpl
 * @Description: TODO现金资金凭证信息Service接口实现类
 * 
 * @author yangshanping
 * @date 2016-7-29 下午04:19:40
 */
@Service
public class CashPaymentServiceImpl implements CashPaymentService{
	@Autowired 
	private CashPaymentDao cashPaymentDao;

	public CashPayment findByH001(String h001) {
		return cashPaymentDao.findByH001(h001);
	}
}

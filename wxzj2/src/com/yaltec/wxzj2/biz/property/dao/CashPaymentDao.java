package com.yaltec.wxzj2.biz.property.dao;

import org.springframework.stereotype.Repository;

import com.yaltec.wxzj2.biz.property.entity.CashPayment;

/**
 * 
 * @ClassName: CashPaymentDao
 * @Description: TODO现金资金凭证信息Dao接口
 * 
 * @author yangshanping
 * @date 2016-7-29 下午05:13:04
 */
@Repository
public interface CashPaymentDao {
	
	public CashPayment findByH001(String h001);
}

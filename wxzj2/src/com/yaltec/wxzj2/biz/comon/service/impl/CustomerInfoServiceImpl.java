package com.yaltec.wxzj2.biz.comon.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.yaltec.wxzj2.biz.comon.dao.CustomerInfoDao;
import com.yaltec.wxzj2.biz.comon.service.CustomerInfoService;

/**
 * <p>
 * ClassName: CustomerInfoServiceImpl
 * </p>
 * <p>
 * Description: 客户信息服务实现类
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author jiangyong
 * @date 2016-9-19 下午03:52:19
 */
@Service
public class CustomerInfoServiceImpl implements CustomerInfoService {

	@Autowired
	private CustomerInfoDao customerInfoDao;

	@Override
	public String getCustomerName() {
		return customerInfoDao.getCustomerName();
	}

	@Override
	public String getLastExpRegNo() {
		return customerInfoDao.getLastExpRegNo();
	}

	@Override
	public String getFinanceMonth() {
		return customerInfoDao.getFinanceMonth();
	}

}

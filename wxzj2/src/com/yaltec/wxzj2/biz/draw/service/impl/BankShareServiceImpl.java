package com.yaltec.wxzj2.biz.draw.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.yaltec.wxzj2.biz.draw.dao.BankShareDao;
import com.yaltec.wxzj2.biz.draw.service.BankShareService;

/**
 * 
 * @ClassName: BankShareServiceImpl
 * @Description: 银行利息收益分摊service实现类
 * 
 * @author yangshanping
 * @date 2016-9-7 下午03:09:03
 */
@Service
public class BankShareServiceImpl implements BankShareService {

	@Autowired
	private BankShareDao bankShareDao;

	public int checkSordineInterest() {
		return bankShareDao.checkSordineInterest();
	}

	public String shareBankShareInterestI(Map<String, String> map) {
		return bankShareDao.shareBankShareInterestI(map);
	}

}

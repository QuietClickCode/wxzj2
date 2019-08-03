package com.yaltec.wxzj2.biz.draw.dao;

import java.util.Map;

import org.springframework.stereotype.Repository;

/**
 * 
 * @ClassName: BankShareDao
 * @Description: 银行利息分摊Dao接口
 * 
 * @author yangshanping
 * @date 2016-9-7 下午03:08:09
 */
@Repository
public interface BankShareDao {

	public int checkSordineInterest();
	
	public String shareBankShareInterestI(Map<String ,String> map);
}

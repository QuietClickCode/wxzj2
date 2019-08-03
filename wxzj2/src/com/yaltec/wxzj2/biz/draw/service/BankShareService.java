package com.yaltec.wxzj2.biz.draw.service;

import java.util.Map;

/**
 * 
 * @ClassName: BankShareService
 * @Description: 银行利息收益分摊Service接口
 * 
 * @author yangshanping
 * @date 2016-9-7 下午03:05:25
 */
public interface BankShareService {
	/**
	 * 判断是否已经计算积数 
	 * @return
	 */
	public int checkSordineInterest();
	/**
	 * 保存银行利息收益分摊
	 */
	public String shareBankShareInterestI(Map<String ,String> map);
}

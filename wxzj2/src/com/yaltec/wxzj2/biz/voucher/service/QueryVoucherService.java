package com.yaltec.wxzj2.biz.voucher.service;

import java.util.List;


/**
 * <p>ClassName: QueryVoucherService</p>
 * <p>Description: 凭证查询服务接口</p>
 * <p>Company: YALTEC</p> 
 * @author jiangyong
 * @date 2016-8-29 下午03:33:23
 */
public interface QueryVoucherService {

	/**
	 * 查询历史年度
	 * @return
	 */
	public List<String> getHistoryYear();
}

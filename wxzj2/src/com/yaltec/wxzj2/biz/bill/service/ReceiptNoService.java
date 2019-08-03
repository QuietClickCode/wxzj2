package com.yaltec.wxzj2.biz.bill.service;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.bill.entity.ReceiptNo;

/**
 * <p>ClassName: ReceiptNoService</p>
 * <p>Description: 票据回传情况服务接口</p>
 * <p>Company: YALTEC</p> 
 * @author moqian
 * @date 2016-7-28 上午09:18:57
 */

public interface ReceiptNoService {
	
	/**
	 * 翻页查询
	 * 
	 * @param page
	 */	
	public void findAll(Page<ReceiptNo> page);

}

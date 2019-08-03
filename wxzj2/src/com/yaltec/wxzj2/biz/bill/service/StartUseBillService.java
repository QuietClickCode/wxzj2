package com.yaltec.wxzj2.biz.bill.service;


import java.util.List;
import java.util.Map;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.bill.entity.ReceiptInfoM;

/**
 * <p>ClassName: StartUseBillService</p>
 * <p>Description: 票据启用服务接口</p>
 * <p>Company: YALTEC</p> 
 * @author moqian
 * @date 2016-7-19 下午02:35:57
 */

public interface StartUseBillService {
	
	/**
	 * 通过传入的map集合,翻页查询所有启用票据信息
	 * @param page
	 */	
	public void find(Page<ReceiptInfoM> page,Map<String, Object> paramMap);
	
	/**
	 * 查询启用票据信息
	 */
	public List<ReceiptInfoM> findAll(Map<String, Object> paramMap);
	
	/**
	 * 保存启用票据信息
	 * @param startUseBill
	 * @return
	 */
	public int save(Map<String, Object> map);
	
	/**
	 * 检查票据是否已启用 
	 */
	public String check(Map<String, String> paramMap);
	
	/**
	 * 清除票据领用人
	 */
	public int clearOwner(Map<String, String> paramMap);
}

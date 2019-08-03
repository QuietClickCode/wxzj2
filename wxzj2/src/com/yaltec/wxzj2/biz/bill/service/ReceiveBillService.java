package com.yaltec.wxzj2.biz.bill.service;

import java.util.Map;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.bill.entity.ReceiveBill;

/**
 * <p>ClassName: ReceiveBillService</p>
 * <p>Description: 票据接收服务接口</p>
 * <p>Company: YALTEC</p> 
 * @author moqian
 * @date 2016-7-27 下午02:35:57
 */

public interface ReceiveBillService {
	
	/**
	 * 翻页查询
	 * 
	 * @param page
	 */	
	public void findAll(Page<ReceiveBill> page);
	
	/**
	 * 保存信息
	 * @param ReceiveBill
	 * @return
	 */
	public int save(ReceiveBill receiveBill);
	
	/**
	 * 通过bm查询票据接收详情
	 * @param bm
	 * @return
	 */
	public ReceiveBill findByBm(String bm);
	
	/**
	 * 更新票据接收信息
	 * @param receiveBill
	 * @return
	 */
	public int update(ReceiveBill receiveBill);
		
	/**
	 * 批量删除票据接收信息
	 * @param batchDelete
	 * @return
	 */
	public int batchDelete(Map<String, String> paramMap);
	
	/**
	 * 查找表中最大的bm
	 * @return
	 */
	public ReceiveBill find();

}

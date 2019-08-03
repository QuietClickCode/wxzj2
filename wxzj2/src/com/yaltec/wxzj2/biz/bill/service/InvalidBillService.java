package com.yaltec.wxzj2.biz.bill.service;

import java.util.List;
import java.util.Map;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.bill.entity.ReceiptInfoM;

/**
 * <p>ClassName: InvalidBillService</p>
 * <p>Description: 票据作废服务接口</p>
 * <p>Company: YALTEC</p> 
 * @author moqian
 * @date 2016-7-27 上午10:00:57
 */

public interface InvalidBillService {
	
	/**
	 * 通过传入的map集合,翻页查询所有票据作废信息
	 * @param page
	 */	
	public void find(Page<ReceiptInfoM> page,Map<String, Object> paramMap);
	
	/**
	 * 查询票据作废信息
	 */
	public List<ReceiptInfoM> findAll(Map<String, Object> paramMap);
	
	/**
	 * 通过bm,pjh查询作废票据详情
	 * @return
	 */
	public ReceiptInfoM findByBmPjh(ReceiptInfoM receiptInfoM);
	
	/**
	 * 保存作废票据信息
	 * @param receiveBill
	 * @return
	 */
	public int update(Map<String, String> map);
	
	/**
	 * 批量启用作废票据
	 * 
	 * @return
	 */
	public void reUseInvalidBill(Map<String, String> map);
	
	/**
	 * 删除交款重启票据
	 * @param paramMap
	 * @author txj
	 */
	public void reUseBillForJK(Map<String, String> paramMap);
	
	/**
	 * 票据批量作废
	 * @param paramMap
	 * @return
	 */
	public int batchInvalid(Map<String, String> paramMap);

}

package com.yaltec.wxzj2.biz.bill.dao;

import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Repository;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.bill.entity.ReceiptInfoM;

@Repository
public interface InvalidBillDao {
	
	public void find(Page<ReceiptInfoM> page,Map<String, Object> paramMap);
	
	public List<ReceiptInfoM> findAll(Map<String, Object> paramMap);

	public ReceiptInfoM findByBmPjh(ReceiptInfoM receiptInfoM);

	public int update(Map<String, String> map);

	public void reUseInvalidBill(Map<String, String> map);

	/**
	 * 删除交款重启票据
	 * 
	 * @param paramMap
	 * @author txj
	 */
	public void reUseBillForJK(Map<String, String> paramMap);
	
	/**
	 * 票据批量作废
	 * @return
	 */
	public int batchInvalid(Map<String, String> paramMap);
}

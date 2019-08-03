package com.yaltec.wxzj2.biz.voucher.dao;

import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Repository;
import com.yaltec.wxzj2.biz.voucher.entity.BankDepositReceipt;

@Repository
public interface BankDepositReceiptDao {
	/**
	 * 查询所有银行进账单
	 */
	public List<BankDepositReceipt> findAll(Map<String, Object> map);
	
	/**
	 * 判断是否九龙坡
	 */
	public String isJLP();
	
	/**
	 * 取消对账
	 */
	public void delete(Map<String, String> map);
	
	public int update_sql1(Map<String, String> paramMap);
	public int update_sql2(Map<String, String> paramMap);
	
	/**
	 * 查询所有银行进账单
	 */
	public List<BankDepositReceipt> findBankDepositReceipt(Map<String, Object> paraMap);

}

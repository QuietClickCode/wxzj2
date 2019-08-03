package com.yaltec.wxzj2.biz.voucher.service;

import java.util.List;
import java.util.Map;
import com.yaltec.wxzj2.biz.voucher.entity.BankDepositReceipt;

/**
 * <p>
 * ClassName: BankDepositReceiptService
 * </p>
 * <p>
 * Description: 银行进账单服务接口
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author moqian
 * @date 2016-9-5 下午16:35:39
 */
public interface BankDepositReceiptService {

	/**
	 * 查询银行进账单列表
	 * @param page
	 */
	public List<BankDepositReceipt> findAll(Map<String, Object> map);
	
	/**
	 * 批量取消对账
	 */
	public void delete(Map<String, String> map);
	
	/**
	 * 判断是否是九龙坡
	 */
	public String isJLP();
	
	/**
	 * 取消对账
	 */
	public int update_sql1(Map<String, String> paramMap);
	public int update_sql2(Map<String, String> paramMap);
	
	/**
	 * 查询银行进账单列表
	 */
	public List<BankDepositReceipt> findBankDepositReceipt(Map<String, Object> paramMap);

}

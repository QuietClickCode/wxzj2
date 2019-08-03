package com.yaltec.wxzj2.biz.voucher.service.impl;

import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.yaltec.wxzj2.biz.voucher.dao.BankDepositReceiptDao;
import com.yaltec.wxzj2.biz.voucher.entity.BankDepositReceipt;
import com.yaltec.wxzj2.biz.voucher.service.BankDepositReceiptService;

/**
 * <p>
 * ClassName: BankDepositReceiptServiceImpl
 * </p>
 * <p>
 * Description: 银行进账单服务实现类
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author moqian
 * @date 2016-9-5 下午16:37:19
 */
@Service
public class BankDepositReceiptServiceImpl implements BankDepositReceiptService {

	@Autowired
	private BankDepositReceiptDao bankDepositReceiptDao;

	@Override
	public List<BankDepositReceipt> findAll(Map<String, Object> map) {
		List<BankDepositReceipt> list = bankDepositReceiptDao.findAll(map);
		return list;
	}
	
	/**
	 * 取消对账
	 */
	public void delete(Map<String, String> map) {
		bankDepositReceiptDao.delete(map);
	}
	
	public String isJLP() {
		return bankDepositReceiptDao.isJLP();
	}
	
	public int update_sql1(Map<String, String> paramMap) {
		return bankDepositReceiptDao.update_sql1(paramMap);
	}
	public int update_sql2(Map<String, String> paramMap) {
		return bankDepositReceiptDao.update_sql2(paramMap);
	}
	
	public List<BankDepositReceipt> findBankDepositReceipt(Map<String, Object> paraMap){
		return bankDepositReceiptDao.findBankDepositReceipt(paraMap);
	}

}

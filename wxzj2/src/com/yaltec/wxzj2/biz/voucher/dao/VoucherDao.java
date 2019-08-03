package com.yaltec.wxzj2.biz.voucher.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.yaltec.wxzj2.biz.voucher.entity.Voucher;

@Repository
public interface VoucherDao {
	/**
	 * 检查当业务编号w008不为空时，交款方式是否与该业务编号的交款方式一致。
	 * @param newmap
	 * @return
	 */
	public List<Voucher> checkPaymentTypeForPR(Map<String, String> newmap);
	
	/**
	 * 判断该交款记录是否自己的业务
	 * @param paramMap
	 * @return
	 */
	public List<Voucher> isOwnOfData(Map<String, String> paramMap);
	
	/**
	 * 根据业务编号批量删除凭证
	 * @param ywbhList
	 * @return
	 */
	public int delByP004(List<String> ywbhList);
	
}

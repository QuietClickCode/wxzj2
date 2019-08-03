package com.yaltec.wxzj2.biz.voucher.service;

import java.util.List;
import java.util.Map;

import com.yaltec.wxzj2.biz.voucher.entity.CheckoutEndOfMonth;

public interface MonthCheckOutService {
	
	/**
	 * 获取审核日期（审核日期）
	 * @return
	 */
	public String getReviewDate();
	
	/**
	 * 月末结账界面初始化
	 */
	public void monthinit(Map<String, String> map);
	
	/**
	 * 月末结账前进行检查1
	 * @return
	 */
	public String checkOutEndOfMonthCA();
	
	/**
	 * 月末结账前进行检查2
	 */
	public List<CheckoutEndOfMonth> checkOutEndOfMonthCB();
	
	/**
	 * 月末结账
	 * @param map
	 * @return
	 */
	public int CheckoutEndOfMonth(Map<String, String> map);
}

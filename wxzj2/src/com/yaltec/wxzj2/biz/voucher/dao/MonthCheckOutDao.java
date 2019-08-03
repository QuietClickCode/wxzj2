package com.yaltec.wxzj2.biz.voucher.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.yaltec.wxzj2.biz.voucher.entity.CheckoutEndOfMonth;

@Repository
public interface MonthCheckOutDao {
	
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
	 * @return
	 */
	public List<CheckoutEndOfMonth> checkOutEndOfMonthCB();
	
	/**
	 * 月末结账
	 * @param map
	 * @return
	 */
	public int checkOutEndOfMonth(Map<String, String> map);
}
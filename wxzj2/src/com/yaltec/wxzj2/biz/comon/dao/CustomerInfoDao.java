package com.yaltec.wxzj2.biz.comon.dao;

import org.springframework.stereotype.Repository;

@Repository
public interface CustomerInfoDao {

	/**
	 * 获取客户单位全称
	 * @return
	 */
	public String getCustomerName();

	/**
	 * 获取上次非税上报导出的票据批次号
	 * @return
	 */
	public String getLastExpRegNo();
	
	/**
	 * 获取财物月度
	 * @return
	 */
	public String getFinanceMonth();
}

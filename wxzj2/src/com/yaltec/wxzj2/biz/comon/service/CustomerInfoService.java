package com.yaltec.wxzj2.biz.comon.service;

/**
 * <p>ClassName: CustomerInfoService</p>
 * <p>Description: 客户信息服务接口</p>
 * <p>Company: YALTEC</p> 
 * @author jiangyong
 * @date 2016-9-19 下午03:52:19
 */
public interface CustomerInfoService {

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

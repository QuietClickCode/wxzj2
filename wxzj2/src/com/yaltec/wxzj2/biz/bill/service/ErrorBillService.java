package com.yaltec.wxzj2.biz.bill.service;

import java.util.List;
import java.util.Map;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.bill.entity.ErrorBill;

/**
 * <p>ClassName: ErrorBillService</p>
 * <p>Description: 错误票据服务接口</p>
 * <p>Company: YALTEC</p> 
 * @author moqian
 * @date 2016-8-01 上午08:35:57
 */

public interface ErrorBillService {
	
	/**
	 * 翻页查询
	 * 
	 * @param page
	 */	
	public void findAll(Page<ErrorBill> page,Map<String, Object> paramMap);
	
	/**
	 * 查询
	 */	
	public List<ErrorBill> findErrorBill(Map<String, Object> paramMap);
	
	/**
	 * 修改票据号
	 */	
	public int eidtW011PaymentReg(Map<String, String> paramMap);
	
	/**
	 * 检查票据 通过票据号和注册号检查在本地是否存在对应的票据
	 */
	public String checkRegNo(Map<String, String> paramMap);
	
	/**
	 * 检查票据是否启用
	 */
	public String checkEditW011_1(Map<String, String> paramMap);
	
	/**
	 * 检查票据是否已用或者作废 
	 */
	public String checkEditW011_2(Map<String, String> paramMap);
	
	/**
	 * 判断是否采用接口
	 */
	public int checkEditW011_3();
	
	/**
	 * 更新票据状态为已用，使用人，业主姓名 等信息1
	 */
	public int eidtW011_01(Map<String, String> paramMap);
	
	/**
	 * 更新票据状态为已用，使用人，业主姓名 等信息2
	 */
	public int eidtW011_02(Map<String, String> paramMap);
	
	/**
	 * 修改交款信息的票据号1
	 */
	public int eidtW011PaymentReg_01(Map<String, String> paramMap);
	/**
	 * 修改交款信息的票据号2
	 */
	public int eidtW011PaymentReg_02(Map<String, String> paramMap);
	/**
	 * 修改交款信息的票据号3
	 */
	public int eidtW011PaymentReg_03(Map<String, String> paramMap);
	
	/**
	 * 根据票据号获取对应批次号
	 */
	public String queryRegNoByBill(Map<String, String> paramMap);
	
}

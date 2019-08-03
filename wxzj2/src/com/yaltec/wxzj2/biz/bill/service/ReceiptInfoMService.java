package com.yaltec.wxzj2.biz.bill.service;

import java.util.Map;

/**
 * <p>
 * ClassName: ReceiptInfoMService
 * </p>
 * <p>
 * Description: 票据明细服务接口
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author jiangyong
 * @date 2016-8-20 下午04:46:12
 */
public interface ReceiptInfoMService {

	/**
	 * 获取归集中心+用户当前可用票据号
	 * 
	 * @param paramMap
	 * @return
	 */
	public String getNextBillNo(Map<String, String> paramMap);

	/**
	 * 获取票据号对应的批次号
	 * 
	 * @param billNo
	 * @return
	 */
	public String getRegNoByBillNo(String billNo);

	/**
	 * 保存票据信息
	 * 
	 * @param param
	 * @return
	 */
	public void saveBillNo(Map<String, String> param);

	/**
	 * 批量保存票据信息
	 * 
	 * @param param
	 * @return
	 */
	public void batchSaveBillNo(Map<String, String> param)
			throws Exception;
	
	/**
	 * 处理票据批次号为null的问题（定时器调用）
	 */
	public int handleRegNo()  throws Exception ;
}

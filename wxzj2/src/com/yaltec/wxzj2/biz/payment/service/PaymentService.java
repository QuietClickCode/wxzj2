package com.yaltec.wxzj2.biz.payment.service;

import java.io.ByteArrayOutputStream;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.payment.entity.CashPayment;
import com.yaltec.wxzj2.biz.payment.entity.PayToStore;
import com.yaltec.wxzj2.biz.payment.entity.ResultPljk;

/**
 * 交款service接口
 * @ClassName: PaymentService 
 * @author 重庆亚亮科技有限公司 txj 
 * @date 2016-7-25 上午11:47:23
 */
public interface PaymentService {
	/**
	 * 查询交款信息
	 * @param page
	 */
	public void findAll(Page<PayToStore> page);	
	/**
	 * 交款登记-房屋查询交款信息
	 * @param page
	 */
	public void queryPaymentDJBS(Page<PayToStore> page,Map<String, Object> paramMap);
	/**
	 * 保存交款登记
	 * @param payToStore
	 * @return
	 */
	public int add(Map<String, String> paramMap);
	/**
	 * 删除一条交款信息
	 * @param paramMap
	 * @return
	 */
	public int deleone(Map<String, String> paramMap);
	/**
	 * 根据业务编号删除交款信息
	 * @param paramMap
	 * @return
	 */
	public int delByW008(Map<String, String> paramMap);
	/**
	 * 修改交款pos号
	 * @param paramMap
	 * @return
	 */
	public int eidtPoshPaymentReg(Map<String, String> paramMap);	
	/**
	 * 修改交款票据号
	 * @param paramMap
	 * @return
	 */
	public int eidtPJPaymentReg(Map<String, String> paramMap);
	/**
	 * 批量交款查询(不分页)
	 * @param paramMap
	 * @return
	 */
	public List<Map<String,String>> queryBankJinZhangChanNonsort(Map<String, Object> paramMap);
	/**
	 * 批量交款查询
	 * @param page
	 * @param paramMap
	 */
	public void queryBankJinZhangChan(Page<ResultPljk> page,
			Map<String, Object> paramMap);
	/**
	 * 打印通知书
	 * @param paramMap
	 * @return
	 */
	public ByteArrayOutputStream paymentRegTZS(Map<String, String> paramMap);
	/**
	 * 打印输出
	 * @param ops
	 * @param response
	 */
	public void output(ByteArrayOutputStream ops, HttpServletResponse response);
	/**
	 * 打印
	 * @param paramMap
	 * @return
	 */
	public ByteArrayOutputStream toPrint(Map<String, String> paramMap);
	/**
	 * 获取打印现金交款凭证的信息
	 * @param h001
	 * @return
	 */
	public CashPayment getCashPayment(String h001);
	/**
	 * 打印现金凭证
	 * @param paramMap
	 * @return
	 */
	public ByteArrayOutputStream printpdfCashPayment(
			Map<String, String> paramMap);
	/**
	 * 打印通知书明细
	 * @param paramMap
	 * @return
	 */
	public ByteArrayOutputStream paymentRegTZSMX(Map<String, String> paramMap);
	/**
	 * 根据楼宇获取最近次交款的归集中心
	 * @param parameter
	 * @return
	 */
	public Map<String, String> getUnitcodeByLybh(String lybh);
	/**
	 * 根据业务编号获取归集中心
	 * @param w008
	 * @return
	 */
	public String getUnitcodeByW008(String w008);
	/**
	 * 根据楼宇获取该楼宇未打票数量
	 * @param lybh
	 * @return
	 */
	public int getNotPrintByLybh(String lybh);
	/**
	 * 根据w008获取该笔业务的交款房屋数量
	 * @param w008
	 * @return
	 */
	public int getNumByW008(String w008);
	/**
	 * 获取缴款的房屋总的交款条数
	 * @param paramMap
	 * @return
	 */
	public int getPayNumByH001(Map<String, String> paramMap);
	
}

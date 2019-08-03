package com.yaltec.wxzj2.biz.payment.dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.yaltec.wxzj2.biz.bill.entity.ReceiptInfoM;
import com.yaltec.wxzj2.biz.comon.entity.PrintSet2;
import com.yaltec.wxzj2.biz.payment.entity.CashPayment;
import com.yaltec.wxzj2.biz.payment.entity.PayToStore;
import com.yaltec.wxzj2.biz.payment.entity.PaymentRegTZS;
import com.yaltec.wxzj2.biz.payment.entity.PdfPaymentPegTZSMX;
import com.yaltec.wxzj2.biz.payment.entity.ResultPljk;

import com.yaltec.wxzj2.biz.property.entity.House;

/**
 * 交款dao接口
 * 
 * @ClassName: PaymentDao
 * @author 重庆亚亮科技有限公司 txj
 * @date 2016-8-1 下午03:50:31
 */
@Repository
public interface PaymentDao {

	public List<PayToStore> findAll(PayToStore query);

	/**
	 * 交款登记
	 * 
	 * @param map
	 */
	public void add(Map<String, String> map);

	/**
	 * 交款登记-房屋查询交款信息
	 * 
	 * @param query
	 * @return
	 */
	public List<PayToStore> queryPaymentDJBS(Map<String, Object> paramMap);
	
	/**
	 * 交款登记-房屋查询交款信息
	 * @param paramMap
	 * @return
	 */
	public List<PayToStore> queryPaymentDJBSW008(Map<String, Object> paramMap);

	/**
	 * 检查交款摘要为‘首次交款’时该房屋是否为首次交款（保存交款登记信息之前）
	 * 
	 * @param payToStore
	 * @return
	 */

	public List<PayToStore> checkSavePaymentReg(Map<String, String> paramMap);

	/**
	 * 查询该业务是否到账
	 * 
	 * @param paramMap
	 * @return
	 */
	public List<PayToStore> isToTheAccount(Map<String, String> paramMap);

	/**
	 * 删除一条交款信息
	 * 
	 * @param paramMap
	 */
	public void deleone(Map<String, String> paramMap);

	/**
	 * 根据业务编号删除交款
	 * 
	 * @param paramMap
	 */
	public void delByW008(Map<String, String> paramMap);
	/**
	 * 修改交款pos号
	 * @param paramMap
	 */
	public void eidtPoshPaymentReg(Map<String, String> paramMap);
	/**
	 * 修改交款票据号
	 * @param paramMap
	 */
	public void eidtPJPaymentReg(Map<String, String> paramMap);
	/**
	 * 批量交款查询(不分页)
	 * @param paramMap
	 * @return
	 */
	public List<Map<String,String>> queryBankJinZhangChanNonsort(Map<String, Object> paramMap);
	/**
	 * 批量交款查询
	 * @param paramMap
	 * @return
	 */
	public List<ResultPljk> queryBankJinZhangChan(Map<String, Object> paramMap);
	
	/**
	 * 获取打印通知书信息
	 * @param paramMap
	 * @return
	 */
	public PaymentRegTZS getPaymentRegTZS(Map<String, String> paramMap);
	/**
	 * 获取打印房屋信息
	 * @param h001
	 * @return
	 */
	public House pdfPaymentReg(String h001);
	/**
	 * 获取打印房屋信息(永川)
	 * @param h001
	 * @return
	 */
	public House pdfPaymentRegByYc(String h001);
	/**
	 * 票据库中查找找到当前房屋的票据信息
	 * @param h001
	 * @return
	 */
	public ReceiptInfoM getFingerprintData(String h001);

	public PrintSet2 getPrintSetInfo(String userid);

	public CashPayment getCashPayment(String h001);

	public void eidtW011_01(Map<String, String> paramMap);

	public void eidtW011PaymentReg_01(Map<String, String> paramMap);

	public void eidtW011PaymentReg_02(Map<String, String> paramMap);

	public void eidtW011PaymentReg_03(Map<String, String> paramMap);

	public ArrayList<PdfPaymentPegTZSMX> getPaymentRegTZSMX(String string);

	public String getUnitcodeByLybh(String lybh);

	public String getUnitcodeByLybh_his(String lybh);

	public String getUnitcodeByW008(String w008);
	/**
	 * 根据楼宇获取该楼宇未打票数量
	 * @param lybh
	 * @return
	 */
	public int getNotPrintByLybh(String lybh);
	/**
	 * 获取已打印的数据
	 * @param paramMap
	 * @return
	 */
	public List<PayToStore> isPrint(Map<String, String> paramMap);
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

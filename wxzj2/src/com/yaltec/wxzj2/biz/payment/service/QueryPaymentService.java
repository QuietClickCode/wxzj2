package com.yaltec.wxzj2.biz.payment.service;

import java.util.List;
import java.util.Map;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.payment.entity.QueryPayment;

/**
 * <p>
 * ClassName: QueryPaymentService
 * </p>
 * <p>
 * Description: 交款查询服务接口
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author jiangyong
 * @date 2016-8-18 下午05:11:41
 */
public interface QueryPaymentService {

	/**
	 * 查询交款信息(分页)
	 * 
	 * @param map
	 *            查询条件map
	 * @return
	 */
	public void findAll(Page<QueryPayment> page, Map<String, Object> map);

	/**
	 * 查询交款信息
	 * 
	 * @param map
	 *            查询条件map
	 * @return
	 */
	public List<QueryPayment> findAll(Map<String, Object> map);
	/**
	 * 查询交款信息(导出)
	 * @param map
	 * @return
	 */
	public List<Map<String,String>> findDataToExport(Map<String, Object> map);

	/**
	 * 查询该业务是否到账 type：0 单笔打印，1批量打印 单笔打印：返回结果<1则是未到帐 批量打印：返回结果>0则有未到帐的业务
	 * 
	 * @param type
	 * @param map
	 * @return
	 */
	public boolean isPayIn(String type, Map<String, String> map);

	/**
	 * 根据房屋编号获取利息,票据号
	 */
	public QueryPayment getW005(String h001, String w008);

	/**
	 * 根据业务编号获取缴款银行编码
	 * 
	 * @param w008
	 * @return
	 */
	public String getBankIdByW008(String w008);
}

package com.yaltec.wxzj2.biz.payment.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.yaltec.wxzj2.biz.payment.entity.QueryPayment;

/**
 * <p>ClassName: QueryPaymentDao</p>
 * <p>Description: 交款查询数据库持久层接口</p>
 * <p>Company: YALTEC</p> 
 * @author jiangyong
 * @date 2016-8-18 下午05:31:58
 */
@Repository
public interface QueryPaymentDao {

	/**
	 * 查询交款信息
	 * @param map
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
	 * 查询该业务是否到账(单个打印), 返回结果<0 则是未到帐
	 * @param map
	 * @return
	 */
	public int isPayInSP(Map<String, String> map);
	
	/**
	 * 查询该业务是否到账(批量打印)，返回结果>=1则有未到帐的业务
	 * @param map
	 * @return
	 */
	public int isPayInBP(Map<String, String> map);
	/**
	 * 根据房屋编号获取利息、票据号
	 * @param h001、w008
	 * @return
	 */
	public QueryPayment getW005(Map<String, Object> map);
	
	/**
	 * 根据业务编号获取缴款银行编码
	 * @param w008
	 * @return
	 */
	public String getBankIdByW008(String w008);
}

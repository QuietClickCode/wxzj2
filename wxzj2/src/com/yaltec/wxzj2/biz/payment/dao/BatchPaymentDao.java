package com.yaltec.wxzj2.biz.payment.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.yaltec.wxzj2.biz.payment.entity.QryHouseUnit;
/**
 * 批量交款dao接口
 * @ClassName: BatchPaymentDao 
 * @author 重庆亚亮科技有限公司 txj 
 * @date 2016-8-25 下午02:54:23
 */
@Repository
public interface BatchPaymentDao {
	/**
	 * 批量交款查询
	 * @param paramMap
	 * @return
	 */
	public List<QryHouseUnit> queryQryUnitSterilisation(Map<String, Object> paramMap);
	/**
	 * 根据kfgsbm获取单位余额
	 * @param kfgs
	 * @return
	 */
	public String getDWYE(String kfgs);
	/**
	 * 保存批量交存
	 * @param map
	 */
	public void saveImportBatchPaymentExcel(Map<String, String> map);
	/**
	 * 删除批量交存
	 * @param map
	 */
	public void delBatchPayment(Map<String, String> map);
	

}

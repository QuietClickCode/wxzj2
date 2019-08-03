package com.yaltec.wxzj2.biz.payment.service;

import java.util.Map;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.payment.entity.QryHouseUnit;

/**
 * 批量交款service接口
 * @ClassName: BatchPaymentService 
 * @author 重庆亚亮科技有限公司 txj 
 * @date 2016-8-25 下午02:53:31
 */
public interface BatchPaymentService {
	/**
	 * 查询批量交款
	 */
	public void queryQryUnitSterilisation(Page<QryHouseUnit> page,
			Map<String, Object> paramMap);
	/**
	 * 根据kfgsbm获取单位余额
	 * @param kfgs
	 * @return
	 */
	public String getDWYE(String kfgs);
	/**
	 * 保存单位预交
	 * @param map
	 * @return
	 */
	public int saveImportBatchPaymentExcel(Map<String, String> map);
	/**
	 * 删除批量交存
	 * @param map
	 * @return
	 */
	public int delBatchPayment(Map<String, String> map);
	

}

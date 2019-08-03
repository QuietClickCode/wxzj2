package com.yaltec.wxzj2.biz.payment.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.payment.dao.BatchPaymentDao;
import com.yaltec.wxzj2.biz.payment.entity.QryHouseUnit;
import com.yaltec.wxzj2.biz.payment.service.BatchPaymentService;
/**
 * 批量交款service实现
 * @ClassName: BatchPaymentServiceImpl 
 * @author 重庆亚亮科技有限公司 txj 
 * @date 2016-8-25 下午02:53:13
 */
@Service
public class BatchPaymentServiceImpl implements BatchPaymentService {
	@Autowired
	private BatchPaymentDao batchPaymentDao;
	/**
	 * 查询批量交款
	 */
	@Override
	public void queryQryUnitSterilisation(Page<QryHouseUnit> page,
			Map<String, Object> paramMap) {		
		try {
			// 根据页面传入的map查询数据
			List<QryHouseUnit> list =batchPaymentDao.queryQryUnitSterilisation(paramMap);
			page.setDataByList(list, page.getPageNo(), page.getPageSize());
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	/**
	 * 根据kfgsbm获取单位余额
	 */
	@Override
	public String getDWYE(String kfgs) {		
		return batchPaymentDao.getDWYE(kfgs);
	}
	
	/**
	 * 保存
	 */
	@Override
	public int saveImportBatchPaymentExcel(Map<String, String> map) {
		batchPaymentDao.saveImportBatchPaymentExcel(map);
		return Integer.valueOf(map.get("result"));
	}
	/**
	 * 删除批量交存
	 */
	@Override
	public int delBatchPayment(Map<String, String> map) {
		batchPaymentDao.delBatchPayment(map);
		return Integer.valueOf(map.get("result"));
	}
	
}

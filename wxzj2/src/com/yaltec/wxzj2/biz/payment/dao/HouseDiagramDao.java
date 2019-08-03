package com.yaltec.wxzj2.biz.payment.dao;

import java.util.Map;

import org.springframework.stereotype.Repository;

/**
 * 楼盘信息dao接口
 * @ClassName: HouseDiagramDao 
 * @author 重庆亚亮科技有限公司 txj 
 * @date 2016-9-1 上午10:22:56
 */
@Repository
public interface HouseDiagramDao {
	/**
	 * 交款	
	 * @param paramMap
	 */
	public void savePaymentByJK(Map<String, String> paramMap);
	/**
	 * 补交
	 * @param paramMap
	 */
	public void savePaymentByBJ(Map<String, String> paramMap);

}

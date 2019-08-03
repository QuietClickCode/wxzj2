package com.yaltec.wxzj2.biz.payment.service;

import java.util.Map;


/**
 * 楼盘信息service接口
 * @ClassName: HouseDiagramService 
 * @author 重庆亚亮科技有限公司 txj 
 * @date 2016-8-29 下午02:55:03
 */
public interface HouseDiagramService {
	/**
	 * 楼盘显示信息（房屋信息由系统录入）
	 * @param xqbh
	 * @param lybh
	 * @return
	 */
	public Map<String, Object> getShowTableByLR(Map<String, Object> map);
	
	/**
	 * 显示合计
	 * 
	 * @param map
	 * @return
	 */
	public void getShowTableSum(Map<String, Object> map);
	
	/**
	 * 交款
	 * @param paramMap
	 * @return
	 */
	public int savePaymentByJK(Map<String, String> paramMap);
	/**
	 * 补交
	 * @param paramMap
	 * @return
	 */
	public int savePaymentByBJ(Map<String, String> paramMap);
	

}

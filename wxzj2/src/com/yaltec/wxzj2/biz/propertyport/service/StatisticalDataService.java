package com.yaltec.wxzj2.biz.propertyport.service;

import java.util.List;
import java.util.Map;

/**
 * 产权接口 数据统计查询  service接口
 * @author 亚亮科技有限公司.YL
 *
 * @version: 2016-9-13 上午11:08:21
 */
public interface StatisticalDataService {
	
	/**
	 * 数据统计查询 
	 * @param map
	 * @return
	 */
	public List<Map<String,String>> query(Map<String, Object> map);
}

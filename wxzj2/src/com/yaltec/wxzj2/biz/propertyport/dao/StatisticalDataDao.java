package com.yaltec.wxzj2.biz.propertyport.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;
/**
 * 产权接口 数据统计查询 dao接口
 * @author 亚亮科技有限公司.YL
 *
 * @version: 2016-9-13 上午11:03:04
 */
@Repository
public interface StatisticalDataDao {
	/**
	 * 数据统计查询
	 * @param map
	 * @return
	 */
	public List<Map<String,String>> query(Map<String, Object> map);
}

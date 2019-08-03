package com.yaltec.wxzj2.biz.propertyport.service;

import java.util.List;
import java.util.Map;

/**
 * 产权接口 房屋变更 service接口
 * @author 亚亮科技有限公司.YL
 *
 * @version: 2016-9-13 上午11:08:21
 */
public interface ChangeDataService {
	
	/**
	 * 房屋信息查询
	 * @param map
	 * @return
	 */
	public List<Map<String,String>> query(Map<String, Object> map);
	/**
	 * 房屋变更记录查询
	 * @param map
	 * @return
	 */
	public List<Map<String,String>> changeQuery(Map<String, Object> map);
	/**
	 * 执行传入的sql语句
	 * @param parasMap
	 * @return
	 */
	public Integer exec(Map<String, Object> parasMap);
	/**
	 * 产权接口按回备业务进行房屋变更操作
	 * @param map
	 * @return
	 */
	public int change(Map<String, Object> map);
	
	
}

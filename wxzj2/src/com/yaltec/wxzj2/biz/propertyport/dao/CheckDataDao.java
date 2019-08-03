package com.yaltec.wxzj2.biz.propertyport.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;
/**
 * 产权接口 房屋审核 dao接口
 * @author 亚亮科技有限公司.YL
 *
 * @version: 2016-9-13 上午11:03:04
 */
@Repository
public interface CheckDataDao {
	/**
	 * 房屋信息查询
	 * @param map
	 * @return
	 */
	public List<Map<String,String>> query(Map<String, Object> map);
	/**
	 * 执行传入的sql语句
	 * @param parasMap
	 * @return
	 */
	public Integer exec(Map<String, Object> parasMap);
	/**
	 * 审核产权接口新建房屋
	 * @param map
	 * @return
	 */
	public void checkFW(Map<String, Object> map);
	/**
	 * 产权接口退回新建房屋到房屋同步
	 * @param map
	 * @return
	 */
	public void returnFW(Map<String, Object> map);
}

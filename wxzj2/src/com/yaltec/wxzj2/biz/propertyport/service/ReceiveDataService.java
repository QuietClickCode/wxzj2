package com.yaltec.wxzj2.biz.propertyport.service;

import java.util.List;
import java.util.Map;

/**
 * 产权接口 数据接收 service接口
 * @author 亚亮科技有限公司.YL
 *
 * @version: 2016-9-13 上午11:08:21
 */
public interface ReceiveDataService {
	/**
	 * 项目信息查询
	 * @param map
	 * @return
	 */
	public List<Map<String,String>> queryPortReceiveDataP(Map<String, Object> map);
	/**
	 * 小区信息查询
	 * @param map
	 * @return
	 */
	public List<Map<String,String>> queryPortReceiveDataN(Map<String, Object> map);
	/**
	 * 楼宇信息查询
	 * @param map
	 * @return
	 */
	public List<Map<String,String>> queryPortReceiveDataB(Map<String, Object> map);
	/**
	 * 房屋信息查询
	 * @param map
	 * @return
	 */
	public List<Map<String,String>> queryPortReceiveDataH(Map<String, Object> map);
	
	/**
	 * 房屋对照（本地与回备）查询 
	 * @param tbid
	 * @return
	 */
	public Map<String,String> queryContrast(String tbid);
	/**
	 * 小区数据关联
	 * @param map
	 * @return
	 */
	public int mergeXQ(Map<String, Object> map);
	/**
	 * 楼宇数据关联
	 * @param map
	 * @return
	 */
	public int mergeLY(Map<String, Object> map);
	/**
	 * 项目数据新建
	 * @param map
	 * @return
	 */
	public int addXM(Map<String, Object> map);
	/**
	 * 小区数据新建
	 * @param map
	 * @return
	 */
	public int addXQ(Map<String, Object> map);
	/**
	 * 楼宇数据新建
	 * @param map
	 * @return
	 */
	public int addLY(Map<String, Object> map);
	/**
	 * 提交新增房屋数据到临时表
	 * @param map
	 * @return
	 */
	public int receiveFW(Map<String, Object> map);
	/**
	 * 执行传入的sql语句
	 * @param parasMap
	 * @return
	 */
	public Integer exec(Map<String, Object> parasMap);
	/**
	 * 同步产权接口变更的房屋
	 * @param map
	 * @return
	 */
	public int syncFW(Map<String, Object> map);
	
}

package com.yaltec.wxzj2.biz.comon.service;

/**
 * <p>
 * ClassName: IdService
 * </p>
 * <p>
 * Description: 获取ID服务接口(这里用一句话描述这个类的作用)
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author jiangyong
 * @date 2016-7-21 上午11:14:53
 */
public interface IdUtilService {

	/**
	 * 获取32位UUID编码
	 * 
	 * @return
	 */
	public String getUuid();

	/**
	 * 获取数据库表当前可用编码，该方法只适用于获取格式为01、001、0001、00001、000001、00000001、00000001的编码
	 * 注意：数据库表中必须含有bm字段
	 * @param table 数据库表名
	 * @return
	 */
	public String getNextBm(String table) throws Exception;
	
	/**
	 * 获取数据库表当前可用ID，该方法只适用于获取格式为01、001、0001、00001、000001、00000001、00000001的编码
	 * 注意：数据库表中必须含有bm字段
	 * @param table 数据库表名
	 * @return
	 */
	public String getNextId(String table) throws Exception;
}

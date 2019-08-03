package com.yaltec.wxzj2.biz.system.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.yaltec.wxzj2.biz.system.entity.ConfigPrint;

@Repository
public interface ConfigPrintDao {
	
	/**
	 * 查询打印配置信息放入下拉框
	 */
	public List<ConfigPrint> queryConfigPrintByModuleKey(String moduleKey);
	
	/**
	 * 判断打印名称在数据库是否存在
	 */
	public String ifNameExists(Map<String, String> map);
	
	/**
	 * 判断打印标识在数据库是否存在
	 */
	public String ifModuleKeyExists(Map<String, String> map);
	
	/**
	 * 判断属性标识在数据库是否存在
	 */
	public String ifPropertyExists(Map<String, String> map);
	
	/**
	 * 按moduleKey删除打印配置文件
	 */
	public void delConfigPrint(Map<String, Object> map);
	
	/**
	 * 保存打印配置文件
	 */
	public void saveConfigPrint(Map<String, Object> map);
	
}

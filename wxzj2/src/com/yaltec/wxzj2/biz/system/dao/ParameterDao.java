package com.yaltec.wxzj2.biz.system.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.yaltec.wxzj2.biz.system.entity.Parameter;

@Repository
public interface ParameterDao {

	public List<Parameter> findAll();
	
	/**
	 * 禁用所有系统参数
	 * @return
	 */
	public int closeAll();
	
	/**
	 * 启用指定的系统参数设置
	 * @param list bm集合
	 * @return
	 */
	public int open(List<String> list);
	
	public Parameter findByBm(String bm);
	
}
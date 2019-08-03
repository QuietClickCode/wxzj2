package com.yaltec.wxzj2.biz.system.service;

import java.util.List;

import com.yaltec.wxzj2.biz.system.entity.Parameter;

/**
 * 
 * @ClassName: ParameterService
 * @Description: 系统参数设置服务接口
 * 
 * @author jiangyong
 * @date 2016-8-13 下午02:37:37
 */
public interface ParameterService {
	
	/**
	 * 获取所有系统参数信息
	 * 
	 * @return
	 */
	public List<Parameter> findAll();
	
	/**
	 * 保存系统参数设置
	 * 
	 * @param list bm集合
	 */
	public int save(List<String> list);
	/**
	 * 根据编码获取系统参数设置
	 */
	public Parameter findByBm(String bm);
}

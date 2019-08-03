package com.yaltec.wxzj2.biz.system.service;

import java.util.List;
import java.util.Map;

import com.yaltec.wxzj2.biz.system.entity.CodeName;
import com.yaltec.wxzj2.biz.system.entity.MySysCode;

/**
 * 
 * @ClassName: MySysCodeService
 * @Description: 系统编码服务接口
 * 
 * @author hequanxin
 * @date 2016-8-13 下午02:37:37
 */
public interface MySysCodeService {
	
	/**
	 * 查询编码类型列表
	 * @return
	 */
	public List<CodeName> findList();
	
	/**
	 * 根据编码类型名称查询对应的编码信息
	 * @param page
	 */
	public List<Map<String,String>> findById(Map<String, String> map);
	
	/**
	 * 更新系统编码信息
	 * @param MSCode
	 * @return
	 */
	public int update(Map<String, String> map);
	
	/**
	 * 添加保存信息
	 * @param MSCode
	 * @return
	 */
	public int add(Map<String, String> map);
	
	/**
	 * 通过bm查询编码类型信息
	 * @param bm
	 * @return
	 */
	public MySysCode findByBm(String bm);
	
	/**
	 * 根据mycode_bm 查询编码信息
	 * @param bm
	 * @return
	 */
	public String findByMycodeBm(String mycodeBm);
	
}

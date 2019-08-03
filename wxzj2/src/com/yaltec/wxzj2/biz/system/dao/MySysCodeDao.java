package com.yaltec.wxzj2.biz.system.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.yaltec.wxzj2.biz.system.entity.CodeName;
import com.yaltec.wxzj2.biz.system.entity.MySysCode;

/**
 * <p>ClassName: MySysCodeDao</p>
 * <p>Description: 系统编码数据层服务类(这里用一句话描述这个类的作用)</p>
 * <p>Company: YALTEC</p> 
 * @author jiangyong
 * @date 2016-7-29 下午05:13:49
 */
@Repository
public interface MySysCodeDao {
	
	/**
	 *  查询所有系统编码
	 * @return
	 */
	public List<MySysCode> findAll();

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
	 * 添加系统编码
	 * @param MSCode
	 * @return
	 */
	public int add(Map<String, String> map);
	
	/**
	 * 根据bm查询系统编码信息
	 * @param bm
	 * @return
	 */
	public MySysCode findByBm(String bm);
	
	/**
	 * 修改系统编码信息
	 * @param MSCode
	 * @return
	 */
	public int update(Map<String, String> map);
	
	/**
	 * 根据mycode_bm 查询编码信息
	 * @param bm
	 * @return
	 */
	public String findByMycodeBm(String mycodeBm);
}

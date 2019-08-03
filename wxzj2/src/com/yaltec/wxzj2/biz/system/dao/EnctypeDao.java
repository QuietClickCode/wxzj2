package com.yaltec.wxzj2.biz.system.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.yaltec.wxzj2.biz.system.entity.Enctype;

@Repository
public interface EnctypeDao {
	
	/**
	 * 查询编码类型列表
	 * @param enctype
	 * @return
	 */
	public List<Enctype> findAll(Enctype enctype);
	
	/**
	 * 添加编码类型列表
	 * @param enctype
	 * @return
	 */
	public int add(Enctype enctype);
	
	/**
	 * 根据bm查询编码类型信息
	 * @param bm
	 * @return
	 */
	public Enctype findByBm(String bm);
	
	/**
	 * 修改编码类型信息
	 * @param enctype
	 * @return
	 */
	public int update(Enctype enctype);
	
	/**
	 * 获取编码类型名称
	 * @param mc
	 * @return
	 */
	public Enctype findByMc(String mc);
	
	/**
	 * 根据bm、mc获取编码类型编码
	 * @param enctype
	 * @return
	 */
	public String findByBmMc(Enctype enctype);
}

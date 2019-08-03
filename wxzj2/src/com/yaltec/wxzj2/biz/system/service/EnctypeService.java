package com.yaltec.wxzj2.biz.system.service;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.system.entity.Enctype;

/**
 * 
 * @ClassName: EnctypeService
 * @Description: 编码类型服务接口
 * 
 * @author hequanxin
 * @date 2016-8-13 下午02:37:37
 */
public interface EnctypeService {
	
	/**
	 * 查询角色列表
	 * @param bm
	 * @return
	 */
	public void findAll(Page<Enctype> page);


	/**
	 * 保存信息
	 * @param Enctype
	 * @return
	 */
	public int add(Enctype enctype);
	
	/**
	 * 通过bm查询编码类型信息详情
	 * @param bm
	 * @return
	 */
	public Enctype findByBm(String bm);
	
	/**
	 * 更新编码类型信息
	 * @param Enctype
	 * @return
	 */
	public int update(Enctype enctype);
	
	/**
	 * 根据mc编码类型信息
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




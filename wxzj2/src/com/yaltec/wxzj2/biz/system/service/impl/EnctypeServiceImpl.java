package com.yaltec.wxzj2.biz.system.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.github.pagehelper.PageHelper;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.system.dao.EnctypeDao;
import com.yaltec.wxzj2.biz.system.entity.Enctype;
import com.yaltec.wxzj2.biz.system.service.EnctypeService;


/**
 * <p>
 * ClassName: EnctypeServiceImpl
 * </p>
 * <p>
 * Description: 编码类型设置模块服务实现类
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author hequanxin
 * @date 2016-7-27 下午04:32:14
 */
@Service
public class EnctypeServiceImpl implements EnctypeService {

	@Autowired
	private EnctypeDao enctypedao;
	
	/**
	 * 查询编码类型列表
	 */
	@Override
	public void findAll(Page<Enctype> page) {
		PageHelper.startPage(page.getPageNo(), page.getPageSize());
		List<Enctype> list = enctypedao.findAll(page.getQuery());
		page.setData(list);
	}
	/**
	 * 保存编码类型信息
	 */
	public int add(Enctype enctype){
		try {
			return enctypedao.add(enctype);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return 0;
		
	}
	
	/**
	 * 根据bm查询编码类型信息
	 */
	public Enctype findByBm(String bm) {
		return enctypedao.findByBm(bm);
	}
	
	/**
	 * 修改编码类型信息
	 */
	public int update(Enctype enctype) {
		return enctypedao.update(enctype);
	}
	
	/**
	 * 根据mc编码类型信息
	 * @param mc
	 * @return
	 */
	public Enctype findByMc(String mc){
		return enctypedao.findByMc(mc);
	}
	
	/**
	 * 根据bm、mc获取编码类型编码
	 * @param enctype
	 * @return
	 */
	public String findByBmMc(Enctype enctype){
		return enctypedao.findByBmMc(enctype);
	}
}




	
	
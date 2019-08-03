package com.yaltec.wxzj2.biz.fixedDeposit.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.github.pagehelper.PageHelper;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.fixedDeposit.dao.DepositsDao;
import com.yaltec.wxzj2.biz.fixedDeposit.entity.Deposits;
import com.yaltec.wxzj2.biz.fixedDeposit.service.DepositsService;

@Service
public class DepositsServiceImpl implements DepositsService {

	@Autowired
	private DepositsDao depositsdao;
	
	/**
	 * 查询所有存款列表
	 */
	public void findAll(Page<Deposits> page) {
		PageHelper.startPage(page.getPageNo(), page.getPageSize());
		List<Deposits> list = depositsdao.findAll(page.getQuery());
		page.setData(list);
	}
	
	
	public int save(Map<String, String> map) {
		try {
			return depositsdao.save(map);
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
		
	}
	
	public Deposits findById(String id) {
		return depositsdao.findById(id);
	}
	
	/**
	 * 修改存款
	 */
	public int update(Deposits deposits) {
		return depositsdao.update(deposits);
	}
	
	/**
	 * 删除
	 */
	public int delete(String id) {
		return depositsdao.delete(id);
	}
}

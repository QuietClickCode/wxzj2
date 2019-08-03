package com.yaltec.wxzj2.biz.propertymanager.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.propertymanager.dao.MoneyTransferDao;
import com.yaltec.wxzj2.biz.propertymanager.entity.MoneyTransfer;
import com.yaltec.wxzj2.biz.propertymanager.service.MoneyTransferService;

/**
 * 
 * @author Administrator
 *
 */

@Service
public class MoneyTransferServiceImpl implements MoneyTransferService{
	
	@Autowired
	private MoneyTransferDao moneyTransferDao;
	
	@Override
	public void findAll(Page<MoneyTransfer> page, Map<String, Object> paramMap) {
		try {
			// 根据页面传入的map查询数据
			List<MoneyTransfer> list = moneyTransferDao.findAll(paramMap);
			page.setDataByList(list, page.getPageNo(), page.getPageSize());
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	@Override
	public int save(Map<String, String> map) {
		moneyTransferDao.save(map);
		return Integer.valueOf(map.get("result"));
	}
	
	@Override
	public int delete(Map<String, String> paramMap) {
		return moneyTransferDao.delete(paramMap);
	}
}

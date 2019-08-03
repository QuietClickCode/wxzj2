package com.yaltec.wxzj2.biz.propertymanager.service;

import java.util.Map;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.propertymanager.entity.MoneyTransfer;

public interface MoneyTransferService {
	public void findAll(Page<MoneyTransfer> page, Map<String, Object> paramMap);
	
	
	public int save(Map<String, String> map);
	
	public int delete(Map<String, String> paramMap);
}





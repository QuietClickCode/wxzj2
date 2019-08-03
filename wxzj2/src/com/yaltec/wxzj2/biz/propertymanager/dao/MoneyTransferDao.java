package com.yaltec.wxzj2.biz.propertymanager.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.yaltec.wxzj2.biz.propertymanager.entity.MoneyTransfer;

@Repository
public interface MoneyTransferDao {
	
	public List<MoneyTransfer> findAll(Map<String, Object> paramMap);
	
	public void save(Map<String, String> map);
	
	public int delete(Map<String, String> paramMap);
}

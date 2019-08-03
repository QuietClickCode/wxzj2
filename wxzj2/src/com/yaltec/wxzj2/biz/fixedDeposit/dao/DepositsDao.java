package com.yaltec.wxzj2.biz.fixedDeposit.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.yaltec.wxzj2.biz.fixedDeposit.entity.Deposits;

@Repository
public interface DepositsDao {

	public List<Deposits> findAll(Deposits deposits);
	
	public int save(Map<String, String> map);
	
	public Deposits findById(String id);
	
	public int update(Deposits deposits);
	
	public int delete(String id);
}
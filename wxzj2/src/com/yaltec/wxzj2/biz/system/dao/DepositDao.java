package com.yaltec.wxzj2.biz.system.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.yaltec.wxzj2.biz.system.entity.Deposit;

@Repository
public interface DepositDao {

	public List<Deposit> findAll(Deposit deposit);
	
	public int add(Deposit deposit);
	
	public Deposit findByBm(String bm);
	
	public int update(Deposit deposit);
}

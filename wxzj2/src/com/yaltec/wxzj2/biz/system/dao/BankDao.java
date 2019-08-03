package com.yaltec.wxzj2.biz.system.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.yaltec.wxzj2.biz.system.entity.Bank;

@Repository
public interface BankDao {

	public List<Bank> findAll(Bank bank);
	
	public int add(Bank bank);
	
	public Bank findByBm(String bm);
	
	public int update(Bank bank);
	
	public Bank findByMc(Bank bank);
}

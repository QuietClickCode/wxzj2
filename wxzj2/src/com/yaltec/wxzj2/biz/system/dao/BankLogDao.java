package com.yaltec.wxzj2.biz.system.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.yaltec.wxzj2.biz.system.entity.BankLog;

@Repository
public interface BankLogDao {

	public List<BankLog> findAll(Map<String, Object> params);

}
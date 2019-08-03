package com.yaltec.wxzj2.biz.system.dao;

import java.util.Map;

import org.springframework.stereotype.Repository;

import com.yaltec.wxzj2.biz.system.entity.SysAnnualSet;

@Repository
public interface SysAnnualSetDao {

	public SysAnnualSet find();
	
	public void update(Map<String, String> map);
}

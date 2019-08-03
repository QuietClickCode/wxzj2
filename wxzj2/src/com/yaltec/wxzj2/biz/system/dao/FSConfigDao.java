package com.yaltec.wxzj2.biz.system.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.yaltec.wxzj2.biz.system.entity.FSConfig;

@Repository
public interface FSConfigDao {

	public List<FSConfig> findAll(FSConfig fsconfig);
	
	public int add(FSConfig fsconfig);
	
	public FSConfig findById(String id);
	
	public int update(FSConfig fsconfig);
	
	public int delete(String id);
}

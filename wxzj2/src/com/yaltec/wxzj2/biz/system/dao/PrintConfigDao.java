package com.yaltec.wxzj2.biz.system.dao;


import java.util.List;

import org.springframework.stereotype.Repository;

import com.yaltec.wxzj2.biz.system.entity.ConfigPrint;

@Repository
public interface PrintConfigDao {
	
	public List<ConfigPrint> get(String key);

}

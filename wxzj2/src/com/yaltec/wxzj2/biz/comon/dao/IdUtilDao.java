package com.yaltec.wxzj2.biz.comon.dao;

import java.util.Map;

import org.springframework.stereotype.Repository;

@Repository
public interface IdUtilDao {

	public void getNextBm(Map<String, String> map);
	
	public void getNextId(Map<String, String> map);
}

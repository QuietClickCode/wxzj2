package com.yaltec.wxzj2.biz.system.dao;

import java.util.Map;

import org.springframework.stereotype.Repository;

@Repository
public interface BackupsDao {

	public void backupDB(Map<String, Object> map);
	
}

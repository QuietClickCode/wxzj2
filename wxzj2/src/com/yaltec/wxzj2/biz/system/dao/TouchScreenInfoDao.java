package com.yaltec.wxzj2.biz.system.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.yaltec.wxzj2.biz.system.entity.TouchScreenInfo;

@Repository
public interface TouchScreenInfoDao {

	public List<TouchScreenInfo> findAll(TouchScreenInfo touchScreenInfo);
	
	public void save(Map<String, String> map);
	
	public TouchScreenInfo findByBm(String bm);
	
	public int delete(String bm);
	
	public int batchDelete(List<String> bmList);
	
}

package com.yaltec.wxzj2.biz.property.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.yaltec.wxzj2.biz.property.entity.Developer;

@Repository
public interface DeveloperDao {

	public List<Developer> findAll(Developer developer);
	
	public void save(Map<String, String> map);
	
	public Developer findByBm(String bm);
	
	public int delDeveloper(Map<String, String> map);
	
	public Developer findByMc(Developer developer);
	
	public String checkForDel(Map<String, String> map);
}

package com.yaltec.wxzj2.biz.property.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.yaltec.wxzj2.biz.property.entity.Project;

@Repository
public interface ProjectDao {

	public List<Project> findAll(Project project);
	
	public int add(Project project);
	
	public Project findByBm(String bm);
	
	public int update(Project project);
	
	//删除项目前检查项目下是否有小区信息
	public String checkForDelProject(Map<String, String> paramMap);
	
	public int batchDelete(Map<String, String> paramMap);
	
	public Project findByMc(Project project);
}

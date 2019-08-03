package com.yaltec.wxzj2.biz.system.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.yaltec.wxzj2.biz.system.entity.Assignment;

@Repository
public interface AssignmentDao {

	public List<Assignment> findAll(Assignment assignment);

	public void save(Map<String, String> map);

	public Assignment findByBm(String bm);

	public int batchDelete(List<String> bmList);
}
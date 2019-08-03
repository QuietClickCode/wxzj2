package com.yaltec.wxzj2.biz.system.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.yaltec.comon.log.entity.Log;

@Repository
public interface SysLogDao {

	public List<Log> findAll(Map<String, Object> map);
	
	public int batchAdd(List<Log> list);
	
	public Log find(String id);

}

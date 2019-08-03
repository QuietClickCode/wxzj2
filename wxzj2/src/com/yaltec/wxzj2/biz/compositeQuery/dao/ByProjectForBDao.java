package com.yaltec.wxzj2.biz.compositeQuery.dao;

import java.io.ByteArrayOutputStream;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Repository;

import com.yaltec.wxzj2.biz.compositeQuery.entity.ByCommunityForB;
import com.yaltec.wxzj2.biz.compositeQuery.entity.ByProjectForB;

@Repository
public interface ByProjectForBDao {
	
	public List<ByCommunityForB> queryByProjectForB(Map<String, Object> paramMap);
	
	public List<ByProjectForB> findByProjectForB(Map<String, Object> paramMap);
	
	public void output(ByteArrayOutputStream ops,HttpServletResponse response);

}

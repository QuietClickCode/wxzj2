package com.yaltec.wxzj2.biz.compositeQuery.dao;

import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Repository;
import com.yaltec.wxzj2.biz.compositeQuery.entity.ProjectInterestF;

@Repository
public interface ProjectInterestFDao {
	
	public List<ProjectInterestF> queryProjectInterestF(Map<String, Object> paramMap);
	
	public List<String> getReviewNd();
	
	public List<ProjectInterestF> findProjectInterestF(Map<String, Object> paraMap);

}

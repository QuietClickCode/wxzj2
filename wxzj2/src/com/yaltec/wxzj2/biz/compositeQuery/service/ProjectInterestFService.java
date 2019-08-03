package com.yaltec.wxzj2.biz.compositeQuery.service;
import java.util.List;
import java.util.Map;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.compositeQuery.entity.ProjectInterestF;

/**
 * <p>ClassName: ProjectInterestFService</p>
 * <p>Description: 项目利息单服务接口</p>
 * <p>Company: YALTEC</p> 
 * @author moqian
 * @date 2016-8-23 上午09:12:03
 */

public interface ProjectInterestFService {	
	/**
	 * 翻页查询所有项目利息单
	 * 
	 * @param page
	 */	
	public void queryProjectInterestF(Page<ProjectInterestF> page,Map<String, Object> paramMap);

	/**
	 * 查询年度
	 */
	public List<String> getReviewNd();
	
	/**
	 * 查询项目利息单信息
	 * @param paramMap
	 * @return
	 */
	public List<ProjectInterestF> findProjectInterestF(Map<String, Object> paramMap);

}

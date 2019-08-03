package com.yaltec.wxzj2.biz.compositeQuery.service.Impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.compositeQuery.dao.ProjectInterestFDao;
import com.yaltec.wxzj2.biz.compositeQuery.entity.ProjectInterestF;
import com.yaltec.wxzj2.biz.compositeQuery.service.ProjectInterestFService;

/**
 * <p>
 * ClassName: ProjectInterestFServiceImpl
 * </p>
 * <p>
 * Description: 项目利息模块服务实现类
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author moqian
 * @date 2016-8-23 上午09:12:03
 */

@Service
public class ProjectInterestFServiceImpl implements ProjectInterestFService {
	
	@Autowired
	private ProjectInterestFDao projectInterestFDao;	
	/**
	 * 查询所有项目利息信息
	 */
	@Override	
	public void queryProjectInterestF(Page<ProjectInterestF> page, Map<String, Object> paramMap) {
		try {
			// 根据页面传入的map查询数据
			List<ProjectInterestF> list = projectInterestFDao.queryProjectInterestF(paramMap);
			page.setDataByList(list, page.getPageNo(), page.getPageSize());
		} catch (Exception e) {
			e.printStackTrace();
		}				
	}
	
	/**
	 * 查询年度
	 */
	@Override
	public List<String> getReviewNd() {
		return projectInterestFDao.getReviewNd();
	}
	
	/**
	 * 查询所有项目利息信息
	 */
	public List<ProjectInterestF> findProjectInterestF(Map<String, Object> paramMap) {
		return projectInterestFDao.findProjectInterestF(paramMap);
	}

}

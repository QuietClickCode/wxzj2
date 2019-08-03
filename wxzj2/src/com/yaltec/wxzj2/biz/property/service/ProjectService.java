package com.yaltec.wxzj2.biz.property.service;

import java.util.Map;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.property.entity.Project;


/**
 * <p>ClassName: ProjectService</p>
 * <p>Description: 项目信息服务接口(这里用一句话描述这个类的作用)</p>
 * <p>Company: YALTEC</p> 
 * @author jiangyong
 * @date 2016-7-19 下午02:35:57
 */
public interface ProjectService {
	
	/**
	 * 翻页查询
	 * 
	 * @param page
	 */
	public void findAll(Page<Project> page);
	
	/**
	 * 保存信息
	 * @param Project
	 * @return
	 */
	public int add(Project project);
	
	/**
	 * 通过bm查询项目信息详情
	 * @param bm
	 * @return
	 */
	public Project findByBm(String bm);
	
	/**
	 * 更新项目信息
	 * @param project
	 * @return
	 */
	public int update(Project project);
	
	/**
	 * 通过bm删除信息详情
	 * @param bm
	 * @return
	 */
	public int delete(Map<String, String> paramMap);
	
	/**
	 * 批量删除项目信息
	 * 
	 * @param batchDelete
	 * @return
	 */
	public int batchDelete(Map<String, String> paramMap) throws Exception;
	
	/**
	 * 通过bm、mc查询项目信息详情
	 * @param bm
	 * @return
	 */
	public Project findByMc(Project project);
}

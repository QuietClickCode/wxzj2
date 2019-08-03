package com.yaltec.wxzj2.biz.property.service;

import java.util.Map;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.property.entity.Developer;


/**
 * <p>ClassName: DeveloperService</p>
 * <p>Description: 开发单位服务接口(这里用一句话描述这个类的作用)</p>
 * <p>Company: YALTEC</p> 
 * @author jiangyong
 * @date 2016-7-19 下午02:35:57
 */
public interface DeveloperService {
	
	/**
	 * 翻页查询
	 * 
	 * @param page
	 */
	public void findAll(Page<Developer> page);
	
	/**
	 * 保存信息
	 * @param Deposit
	 * @return
	 */
	public void add(Map<String, String> map);
	
	/**
	 * 通过bm查询开发单位信息详情
	 * @param bm
	 * @return
	 */
	public Developer findByBm(String bm);
	
	/**
	 * 通过mc查询开发单位信息
	 * @param bm
	 * @return
	 */
	public Developer findByMc(Developer developer);
	
	/**
	 * 更新信息
	 * @param developer
	 * @return
	 */
	public void update(Map<String, String> map);
	
	/**
	 * 通过bm删除信息详情
	 * @param bm
	 * @return
	 */
	public int delete(Map<String, String> map);
	
	/**
	 * 批量删除开发单位信息
	 * 
	 * @param batchDelete
	 * @return
	 */
	public int batchDelete(Map<String, String> map) throws Exception;
	
	/**
	 * 删除开发单位信息前检查  单位预交  中是否有开发单位信息
	 */
	public String checkForDel(Map<String, String> map);
}

package com.yaltec.wxzj2.biz.property.service;

import java.util.List;
import java.util.Map;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.property.entity.Community;

/**
 * 
 * @ClassName: CommunityService
 * @Description: TODO小区service接口
 * 
 * @author yangshanping
 * @date 2016-7-21 下午02:31:30
 */
public interface CommunityService {

	/**
	 * 翻页查询小区信息列表
	 * 
	 * @param page
	 * @return
	 */
	public void findAll(Page<Community> page);
	
	/**
	 * 查询小区信息列表
	 * 
	 * @param page
	 * @return
	 */
	public List<Community> findAll(Community community);

	/**
	 * 根据编码bm查询小区信息
	 * 
	 * @param community
	 * @return
	 */
	public Community findByBm(String Bm);
	/**
	 * 根据小区名称mc查询小区信息
	 * @return
	 */
	public Community findByMc(String mc);
	/**
	 * 保存小区信息
	 * 
	 * @param community
	 * @return
	 */
	public void save(Map<String, String> map);

	/**
	 * 修改小区信息
	 * 
	 * @param community
	 * @return
	 */
	public void update(Map<String, String> map);

	/**
	 * 删除小区信息
	 * 
	 * @param 
	 * @return
	 */
	public int delCommunity(Map<String, String> paramMap) throws Exception;

	/**
	 * 添加小区时，检查是否已存在
	 * @param map
	 * @return
	 */
	public String checkForSaveCommunity(Map<String, String> map);
	/**
	 * 通过bm删除信息详情
	 * @param bm
	 * @return
	 */
	public int delete(Map<String, String> paramMap);
}

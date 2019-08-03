package com.yaltec.wxzj2.biz.property.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;
import com.yaltec.wxzj2.biz.property.entity.Community;

/**
 * 
 * @ClassName: CommunityDao
 * @Description: TODO小区dao接口
 * 
 * @author yangshanping
 * @date 2016-7-21 下午02:33:34
 */
@Repository
public interface CommunityDao {

	public List<Community> findAll(Community community);
	
	public Community findByBm(String bm);
	
	public Community findByMc(String mc);
	
	public void save(Map<String, String> map);
	
	public int delCommunity(Map<String, String> paramMap);
	
	public String checkForSaveCommunity(Map<String, String> map);
	
}

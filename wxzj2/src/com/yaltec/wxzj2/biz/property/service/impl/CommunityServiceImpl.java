package com.yaltec.wxzj2.biz.property.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.github.pagehelper.PageHelper;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.comon.service.IdUtilService;
import com.yaltec.wxzj2.biz.property.dao.CommunityDao;
import com.yaltec.wxzj2.biz.property.entity.Community;
import com.yaltec.wxzj2.biz.property.service.CommunityService;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 
 * @ClassName: CommunityServiceImpl
 * @Description: TODO小区service接口实现类
 * 
 * @author yangshanping
 * @date 2016-7-21 下午02:31:18
 */
@Service
public class CommunityServiceImpl implements CommunityService {

	@Autowired
	private CommunityDao communityDao;
	
	@Autowired
	private IdUtilService idUtilService;
	
	@Override
	public void findAll(Page<Community> page) {
		PageHelper.startPage(page.getPageNo(), page.getPageSize());
		List<Community> list = communityDao.findAll(page.getQuery());
		page.setData(list);
	}
	@Override
	public List<Community> findAll(Community community) {
		return communityDao.findAll(community);
	}
	public Community findByMc(String mc) {
		return communityDao.findByMc(mc);
	}

	public Community findByBm(String bm) {
		return communityDao.findByBm(bm);
	}

	public void save(Map<String, String> map) {
		try {
			// 获取当前数据库表可用BM
			String bm = idUtilService.getNextBm("NeighBourHood");
			map.put("bm",bm);
			communityDao.save(map);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void update(Map<String, String> map) {
		communityDao.save(map);
	}
	
	public int delCommunity(Map<String, String> paramMap) throws Exception {
		int result = -1;
		String bms = paramMap.get("bm");
		String[] paras = bms.split(",");
		// 删除数据
		for (String bm : paras) {
			paramMap.put("bm", bm);
			communityDao.delCommunity(paramMap);
			result = Integer.valueOf(paramMap.get("result"));
			if (result == 0) {
				// 更新缓存
				DataHolder.updateCommunityDataMap(bm);
			}
			if (result == 1) {
				throw new Exception("删除失败,请先删除该小区下关联的楼宇信息！");
			} else if (result != 0) {
				throw new Exception("删除失败！");
			}
		}
		return result;
	}
	
	public String checkForSaveCommunity(Map<String, String> map) {
		return communityDao.checkForSaveCommunity(map);
	}
	
	public int delete(Map<String, String> paramMap) {
		return communityDao.delCommunity(paramMap);
	}

}

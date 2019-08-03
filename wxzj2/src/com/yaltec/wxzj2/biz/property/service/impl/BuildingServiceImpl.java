package com.yaltec.wxzj2.biz.property.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.github.pagehelper.PageHelper;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.draw.entity.CodeName;
import com.yaltec.wxzj2.biz.property.dao.BuildingDao;
import com.yaltec.wxzj2.biz.property.dao.CommunityDao;
import com.yaltec.wxzj2.biz.property.entity.Building;
import com.yaltec.wxzj2.biz.property.entity.Community;
import com.yaltec.wxzj2.biz.property.service.BuildingService;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 
 * @ClassName: BuildingServiceImpl
 * @Description: TODO楼宇信息实现类
 * 
 * @author
 * @date 2016-7-23 上午11:30:50
 */
@Service
public class BuildingServiceImpl implements BuildingService{

	@Autowired
	private BuildingDao buildingDao;
	@Autowired
	private CommunityDao communityDao;
	
	@Override
	public void findAll(Page<Building> page) {
		PageHelper.startPage(page.getPageNo(), page.getPageSize());
		List<Building> list = buildingDao.findAll(page.getQuery());
		page.setData(list);
	}
	
	public Building findByLybh(Building building){
		return buildingDao.findByLybh(building);
	}
	
	public Building find(String xqbh){
		return buildingDao.find(xqbh);
	}
	
	public Building findByLymc(String lymc){
		return buildingDao.findByLymc(lymc);
	}
	
	public void save(Map<String, String> map){
		try {
			// 查询数据库中现存最大编码bm，如果存在，新增数据的编码加1，不存在，将编码设为00000001
//			Building _building = buildingDao.find(map.get("xqbh"));
//			if(_building==null){
//				map.put("lybh", map.get("xqbh")+"001");
//			}else{
//				int i=Integer.parseInt(_building.getLybh());
//				i=i+1;
//				// 编码的值显示为8位，位数不够左边加0
//				map.put("lybh", String.format("%08d",i));
//			}
			map.put("lybh", getBuildingBm(map.get("xqbh")));
			buildingDao.save(map);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public void update(Map<String, String> map){
		// 根据小区名称获取小区信息，并将小区编码赋给xqbh
		Community community=communityDao.findByMc(map.get("xqmc"));
		map.put("xqbh", community.getBm());
		buildingDao.save(map);
	}
	
	public int delBuilding(Map<String, String> paramMap) throws Exception {
		int result = -1;
		String bms = paramMap.get("bm");
		String[] paras = bms.split(",");
		for (String bm : paras) {
			paramMap.put("bm", bm);
			buildingDao.delBuilding(paramMap);
			result = Integer.valueOf(paramMap.get("result"));
			if (result == 0) {
				// 更新缓存
				DataHolder.updateBuildingDataMap(bm);
			}
			if(result==1){
				throw new Exception("删除失败,请先删除该楼宇下关联的房屋信息！");
			}else if(result != 0) {
				throw new Exception("删除失败！");
			}
		}
		return result;
	}

	public int delete(Map<String, String> paramMap) {
		return buildingDao.delBuilding(paramMap);
	}

	public String getFwlxByBuilding(String lybh) {
		return buildingDao.getFwlxByBuilding(lybh);
	}

	public String getAddressForBuilding(String lybh) {
		return buildingDao.getAddressForBuilding(lybh);
	}
	/**
	 * 根据开发公司获取小区信息
	 */
	@Override
	public List<Building> findXqByKfgs(String kfgs) {		
		return buildingDao.findXqByKfgs(kfgs);
	}
	
	public List<CodeName> queryIndustryByXqbh(Map<String, String> map) {
		return buildingDao.queryIndustryByXqbh(map);
	}

	/**
	 * 获取楼宇编码
	 */
	@Override
	public String getBuildingBm(String xqbh) {
		Map<String, String> map = new HashMap<String,String>();
		map.put("result", "");
		map.put("bm", xqbh);
		buildingDao.getBuildingBm(map);
		return map.get("result").toString();
	}
}

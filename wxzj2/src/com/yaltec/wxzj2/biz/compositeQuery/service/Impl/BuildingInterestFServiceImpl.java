package com.yaltec.wxzj2.biz.compositeQuery.service.Impl;

import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.compositeQuery.dao.BuildingInterestFDao;
import com.yaltec.wxzj2.biz.compositeQuery.entity.BuildingInterestF;
import com.yaltec.wxzj2.biz.compositeQuery.service.BuildingInterestFService;

/**
 * <p>
 * ClassName: BuildingInterestFServiceImpl
 * </p>
 * <p>
 * Description: 楼宇利息单查询模块服务实现类
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author moqian
 * @date 2016-8-23 下午14:12:03
 */

@Service
public class BuildingInterestFServiceImpl implements BuildingInterestFService {
	
	@Autowired
	private BuildingInterestFDao buildingInterestFDao;	
	/**
	 * 查询所有楼宇利息单信息
	 */
	@Override	
	public void queryBuildingInterestF(Page<BuildingInterestF> page, Map<String, Object> paramMap) {
		try {
			// 根据页面传入的map查询数据
			List<BuildingInterestF> list = buildingInterestFDao.queryBuildingInterestF(paramMap);
			page.setDataByList(list, page.getPageNo(), page.getPageSize());
		} catch (Exception e) {
			e.printStackTrace();
		}				
	}
	
	public List<BuildingInterestF> findBuildingInterestF(Map<String, Object> paramMap) {
		return buildingInterestFDao.findBuildingInterestF(paramMap);
	}

}

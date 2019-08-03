package com.yaltec.wxzj2.biz.propertyport.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.yaltec.wxzj2.biz.propertyport.dao.StatisticalDataDao;
import com.yaltec.wxzj2.biz.propertyport.service.StatisticalDataService;
/**
 * 产权接口 数据统计查询 
 * @author 亚亮科技有限公司.YL
 *
 * @version: 2016-10-10 上午11:36:03
 */
@Service
public class StatisticalDataServiceImpl implements StatisticalDataService {
	@Autowired
	private StatisticalDataDao dao;
	
	/**
	 * 数据统计查询 
	 * @param map
	 * @return
	 */
	@Override
	public List<Map<String, String>> query(Map<String, Object> map) {
		return dao.query(map);
	}

}

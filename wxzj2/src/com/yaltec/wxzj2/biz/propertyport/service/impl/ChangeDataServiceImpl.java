package com.yaltec.wxzj2.biz.propertyport.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.yaltec.wxzj2.biz.propertyport.dao.ChangeDataDao;
import com.yaltec.wxzj2.biz.propertyport.service.ChangeDataService;

/**
 * 产权接口 房屋变更 Service接口实现类
 * @author 亚亮科技有限公司.YL
 *
 * @version: 2016-9-13 上午11:09:28
 */
@Service
public class ChangeDataServiceImpl implements ChangeDataService{

	@Autowired
	private ChangeDataDao dao;

	
	/**
	 * 房屋信息查询
	 * @param map
	 * @return
	 */
	@Override
	public List<Map<String, String>> query(Map<String, Object> map) {
		map.put("result", "-1");
		return dao.query(map);
	}
	
	/**
	 * 执行传入的sql语句
	 * @param parasMap
	 * @return
	 */
	@Override
	public Integer exec(Map<String, Object> parasMap) {
		return dao.exec(parasMap);
	}

	/**
	 * 产权接口按回备业务进行房屋变更操作
	 * @param map
	 * @return
	 */
	@Override
	public int change(Map<String, Object> map) {
		map.put("result", -1);
		dao.change(map);
		return Integer.valueOf(map.get("result").toString());
	}

	/**
	 * 房屋变更记录查询
	 * @param map
	 * @return
	 */
	@Override
	public List<Map<String, String>> changeQuery(Map<String, Object> map) {
		map.put("result", "-1");
		return dao.changeQuery(map);
	}
	
}

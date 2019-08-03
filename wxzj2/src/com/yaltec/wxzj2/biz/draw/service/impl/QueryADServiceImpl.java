package com.yaltec.wxzj2.biz.draw.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.yaltec.wxzj2.biz.draw.dao.QueryADDao;
import com.yaltec.wxzj2.biz.draw.service.QueryADService;

/**
 * 支取查询 Service接口实现类
 * @author 亚亮科技有限公司.YL
 *
 * @version: 2016-8-29 上午11:33:38
 */
@Service
public class QueryADServiceImpl implements QueryADService{

	@Autowired
	private QueryADDao dao;

	/**
	 * 支取查询(模糊查询、申请编号、经办人)
	 * @param map
	 * @return
	 */
	@Override
	public List<Map<String, String>> queryQueryAD(Map<String, Object> map) {
		return dao.queryQueryAD(map);
	}

	/**
	 * 支取统计查询  
	 * @param map
	 * @return
	 */
	@Override
	public List<Map<String, String>> queryCountAD(Map<String, Object> map) {
		return dao.queryCountAD(map);
	}

	/**
	 * 支取查询(明细查询)
	 * @param map
	 * @return
	 */
	@Override
	public List<Map<String, String>> queryQueryADMX(Map<String, Object> map) {
		return dao.queryQueryADMX(map);
	}

	

	

}

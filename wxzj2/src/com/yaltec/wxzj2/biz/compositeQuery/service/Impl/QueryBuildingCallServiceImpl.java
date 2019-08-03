package com.yaltec.wxzj2.biz.compositeQuery.service.Impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.compositeQuery.dao.QueryBuildingCallDao;
import com.yaltec.wxzj2.biz.compositeQuery.entity.BuildingCall;
import com.yaltec.wxzj2.biz.compositeQuery.service.QueryBuildingCallService;

/**
 * <p>
 * ClassName: QueryBuildingCallServiceImpl
 * </p>
 * <p>
 * Description: 楼宇催交查询模块服务实现类
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author moqian
 * @date 2016-8-26 下午14:12:03
 */

@Service
public class QueryBuildingCallServiceImpl implements QueryBuildingCallService {
	
	@Autowired
	private QueryBuildingCallDao queryBuildingCallDao;	
	/**
	 * 查询所有楼宇催交信息
	 */
	@Override	
	public void queryBuildingCall(Page<BuildingCall> page, Map<String, Object> paramMap) {
		try {
			// 根据页面传入的map查询数据
			List<BuildingCall> list = queryBuildingCallDao.queryBuildingCall(paramMap);
			page.setDataByList(list, page.getPageNo(), page.getPageSize());
		} catch (Exception e) {
			e.printStackTrace();
		}				
	}
	
	public List<BuildingCall> findBuildingCall(Map<String, String> paramMap) {
		return queryBuildingCallDao.findBuildingCall(paramMap);
	}

}

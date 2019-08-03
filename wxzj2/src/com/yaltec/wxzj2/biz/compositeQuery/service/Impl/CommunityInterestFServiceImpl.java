package com.yaltec.wxzj2.biz.compositeQuery.service.Impl;

import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.compositeQuery.dao.CommunityInterestFDao;
import com.yaltec.wxzj2.biz.compositeQuery.entity.BuildingInterestF;
import com.yaltec.wxzj2.biz.compositeQuery.service.CommunityInterestFService;

/**
 * <p>
 * ClassName: CommunityInterestFServiceImpl
 * </p>
 * <p>
 * Description: 小区利息单查询模块服务实现类
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author moqian
 * @date 2016-8-23 下午14:12:03
 */

@Service
public class CommunityInterestFServiceImpl implements CommunityInterestFService {
	
	@Autowired
	private CommunityInterestFDao communityInterestFDao;	
	/**
	 * 查询所有小区利息单信息
	 */
	@Override	
	public void queryCommunityInterestF(Page<BuildingInterestF> page, Map<String, Object> paramMap) {
		try {
			// 根据页面传入的map查询数据
			List<BuildingInterestF> list = communityInterestFDao.queryCommunityInterestF(paramMap);
			page.setDataByList(list, page.getPageNo(), page.getPageSize());
		} catch (Exception e) {
			e.printStackTrace();
		}				
	}
	
	/**
	 * 查询所有小区利息单信息
	 */
	public List<BuildingInterestF> findCommunityInterestF(Map<String, Object> paramMap) {
		return communityInterestFDao.findCommunityInterestF(paramMap);
	}

}

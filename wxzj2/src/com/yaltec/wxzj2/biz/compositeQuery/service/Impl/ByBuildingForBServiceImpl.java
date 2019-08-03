package com.yaltec.wxzj2.biz.compositeQuery.service.Impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.compositeQuery.dao.ByBuildingForBDao;
import com.yaltec.wxzj2.biz.compositeQuery.entity.ByCommunityForB;
import com.yaltec.wxzj2.biz.compositeQuery.service.ByBuildingForBService;

/**
 * <p>
 * ClassName: ByBuildingForBServiceImpl
 * </p>
 * <p>
 * Description: 楼宇余额查询模块服务实现类
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author moqian
 * @date 2016-8-9 下午16:12:03
 */

@Service
public class ByBuildingForBServiceImpl implements ByBuildingForBService {
	
	@Autowired
	private ByBuildingForBDao byBuildingForBDao;	
	/**
	 * 查询所有楼宇余额信息
	 */
	@Override	
	public void queryByBuildingForB(Page<ByCommunityForB> page, Map<String, Object> paramMap) {
		try {
			// 根据页面传入的map查询数据
			List<ByCommunityForB> list = byBuildingForBDao.queryByBuildingForB(paramMap);
			page.setDataByList(list, page.getPageNo(), page.getPageSize());
		} catch (Exception e) {
			e.printStackTrace();
		}				
	}
	
	public List<ByCommunityForB> findByBuildingForB(Map<String, Object> paramMap) {
		return byBuildingForBDao.findByBuildingForB(paramMap);
	}

}

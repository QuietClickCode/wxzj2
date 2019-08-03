package com.yaltec.wxzj2.biz.compositeQuery.service.Impl;

import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.compositeQuery.dao.ByCommunityForSDao;
import com.yaltec.wxzj2.biz.compositeQuery.entity.ByBuildingForC1;
import com.yaltec.wxzj2.biz.compositeQuery.service.ByCommunityForSService;

/**
 * <p>
 * ClassName: ByCommunityForSServiceImpl
 * </p>
 * <p>
 * Description: 小区台账查询模块服务实现类
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author moqian
 * @date 2016-8-4 下午14:12:03
 */

@Service
public class ByCommunityForSServiceImpl implements ByCommunityForSService {
	
	@Autowired
	private ByCommunityForSDao byCommunityForSDao;

	@Override	
	public void queryByCommunityForS_BS(Page<ByBuildingForC1> page, Map<String, Object> paramMap) {
		try {
			// 根据页面传入的map查询数据
			List<ByBuildingForC1> list = byCommunityForSDao.queryByCommunityForS_BS(paramMap);
			page.setDataByList(list, page.getPageNo(), page.getPageSize());
		} catch (Exception e) {
			e.printStackTrace();
		}				
	}
	
	public List<ByBuildingForC1> findByCommunityForS(Map<String, Object> paramMap) {
		return byCommunityForSDao.findByCommunityForS(paramMap);
	}

}

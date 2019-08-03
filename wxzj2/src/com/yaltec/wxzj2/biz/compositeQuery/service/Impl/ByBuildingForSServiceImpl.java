package com.yaltec.wxzj2.biz.compositeQuery.service.Impl;

import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.compositeQuery.dao.ByBuildingForSDao;
import com.yaltec.wxzj2.biz.compositeQuery.entity.ByBuildingForC1;
import com.yaltec.wxzj2.biz.compositeQuery.service.ByBuildingForSService;

/**
 * <p>
 * ClassName: ByBuildingForSServiceImpl
 * </p>
 * <p>
 * Description: 楼宇台账查询模块服务实现类
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author moqian
 * @date 2016-8-4 上午09:12:03
 */

@Service
public class ByBuildingForSServiceImpl implements ByBuildingForSService {
	
	@Autowired
	private ByBuildingForSDao byBuildingForSDao;
			
	@Override	
	public void queryByBuildingForS(Page<ByBuildingForC1> page, Map<String, Object> paramMap) {
		try {
			// 根据页面传入的map查询数据
			List<ByBuildingForC1> list = byBuildingForSDao.queryByBuildingForS(paramMap);
			page.setDataByList(list, page.getPageNo(), page.getPageSize());
		} catch (Exception e) {
			e.printStackTrace();
		}				
	}
	
	public List<ByBuildingForC1> findByBuildingForS(Map<String, Object> paramMap) {
		return byBuildingForSDao.findByBuildingForS(paramMap);
	}

}

package com.yaltec.wxzj2.biz.compositeQuery.service.Impl;

import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.compositeQuery.dao.DetailBuildingIDao;
import com.yaltec.wxzj2.biz.compositeQuery.entity.DetailBuildingI;
import com.yaltec.wxzj2.biz.compositeQuery.service.DetailBuildingIService;

/**
 * <p>
 * ClassName: DetailBuildingIServiceImpl
 * </p>
 * <p>
 * Description: 楼宇利息明细查询模块服务实现类
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author moqian
 * @date 2016-8-23 下午14:12:03
 */

@Service
public class DetailBuildingIServiceImpl implements DetailBuildingIService {
	
	@Autowired
	private DetailBuildingIDao detailBuildingIDao;	
	/**
	 * 查询所有楼宇利息明细信息
	 */
	@Override	
	public void queryDetailBuildingI(Page<DetailBuildingI> page, Map<String, Object> paramMap) {
		try {
			// 根据页面传入的map查询数据
			List<DetailBuildingI> list = detailBuildingIDao.queryDetailBuildingI(paramMap);
			page.setDataByList(list, page.getPageNo(), page.getPageSize());
		} catch (Exception e) {
			e.printStackTrace();
		}				
	}
	
	public List<DetailBuildingI> findDetailBuildingI(Map<String, Object> paramMap) {
		return detailBuildingIDao.findDetailBuildingI(paramMap);
	}

}

package com.yaltec.wxzj2.biz.compositeQuery.service.Impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.compositeQuery.dao.QuerySummaryDao;
import com.yaltec.wxzj2.biz.compositeQuery.entity.ByBuildingForC1;
import com.yaltec.wxzj2.biz.compositeQuery.service.QuerySummaryService;



/**
 * <p>
 * ClassName: QuerySummaryServiceImpl
 * </p>
 * <p>
 * Description: 汇总台账查询模块服务实现类
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author moqian
 * @date 2016-8-9 上午09:12:03
 */

@Service
public class QuerySummaryServiceImpl implements QuerySummaryService {
	
	@Autowired
	private QuerySummaryDao querySummaryDao;
	
	/**
	 * 查询所有汇总台账信息
	 */

	@Override	
	public void queryQuerySummary_BS(Page<ByBuildingForC1> page, Map<String, Object> paramMap) {
		try {
			// 根据页面传入的map查询数据
			List<ByBuildingForC1> list = querySummaryDao.queryQuerySummary_BS(paramMap);
			page.setDataByList(list, page.getPageNo(), page.getPageSize());
		} catch (Exception e) {
			e.printStackTrace();
		}				
	}
	
	public List<ByBuildingForC1> findQuerySummary(Map<String, Object> paramMap) {
		return querySummaryDao.findQuerySummary(paramMap);
	}

}

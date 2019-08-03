package com.yaltec.wxzj2.biz.compositeQuery.service.Impl;

import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.compositeQuery.dao.QueryDunningDao;
import com.yaltec.wxzj2.biz.compositeQuery.service.QueryDunningService;
import com.yaltec.wxzj2.biz.property.entity.House;

/**
 * <p>
 * ClassName: QueryDunningServiceImpl
 * </p>
 * <p>
 * Description: 续筹催交查询模块服务实现类
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author moqian
 * @date 2016-8-25 下午14:12:03
 */

@Service
public class QueryDunningServiceImpl implements QueryDunningService {

	@Autowired
	private QueryDunningDao queryDunningDao;
	
	@Override	
	public void queryQueryDunning(Page<House> page, Map<String, Object> paramMap) {
		try {
			// 根据页面传入的map查询数据
			List<House> list = queryDunningDao.queryQueryDunning(paramMap);
			page.setDataByList(list, page.getPageNo(), page.getPageSize());
		} catch (Exception e) {
			e.printStackTrace();
		}				
	}

	public List<House> findQueryDunning(Map<String, String> paramMap) {
		return queryDunningDao.findQueryDunning(paramMap);
	}

}

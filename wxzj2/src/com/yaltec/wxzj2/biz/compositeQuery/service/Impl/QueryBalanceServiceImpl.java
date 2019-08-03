package com.yaltec.wxzj2.biz.compositeQuery.service.Impl;

import java.util.List;
import java.util.Map;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.compositeQuery.dao.QueryBalanceDao;
import com.yaltec.wxzj2.biz.compositeQuery.entity.QueryBalance;
import com.yaltec.wxzj2.biz.compositeQuery.service.QueryBalanceService;

/**
 * <p>
 * ClassName: QueryBalanceServiceImpl
 * </p>
 * <p>
 * Description: 业主余额查询模块服务实现类
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author moqian
 * @date 2016-8-9 下午16:12:03
 */

@Service
public class QueryBalanceServiceImpl implements QueryBalanceService {
	
	@Autowired
	private QueryBalanceDao queryBalanceDao;	
	/**
	 * 查询所有业主余额信息
	 */
	@Override	
	public void queryQueryBalance(Page<QueryBalance> page, Map<String, Object> paramMap) {
		try {
			// 根据页面传入的map查询数据
			List<QueryBalance> list = queryBalanceDao.queryQueryBalance(paramMap);
			page.setDataByList(list, page.getPageNo(), page.getPageSize());
		} catch (Exception e) {
			e.printStackTrace();
		}				
	}
	
	public List<QueryBalance> findQueryBalance(Map<String, Object> paramMap) {
		return queryBalanceDao.findQueryBalance(paramMap);
	}
}

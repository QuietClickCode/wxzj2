package com.yaltec.wxzj2.biz.compositeQuery.service.Impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.compositeQuery.dao.QueryMoneyWarningDao;
import com.yaltec.wxzj2.biz.compositeQuery.service.QueryMoneyWarningService;
import com.yaltec.wxzj2.biz.property.entity.House;

/**
 * <p>
 * ClassName: QueryMoneyWarningServiceImpl
 * </p>
 * <p>
 * Description: 资金预警查询模块服务实现类
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author moqian
 * @date 2016-8-29 上午09:12:03
 */

@Service
public class QueryMoneyWarningServiceImpl implements QueryMoneyWarningService {
	
	@Autowired
	private QueryMoneyWarningDao queryMoneyWarningDao;	
	/**
	 * 查询所有资金预警查询信息
	 */
	@Override	
	public void QueryMoneyWarning(Page<House> page, Map<String, Object> paramMap) {
		try {
			// 根据页面传入的map查询数据
			List<House> list = queryMoneyWarningDao.QueryMoneyWarning(paramMap);
			page.setDataByList(list, page.getPageNo(), page.getPageSize());
		} catch (Exception e) {
			e.printStackTrace();
		}				
	}

	public List<House> findMoneyWarning(Map<String, String> paramMap) {
		return queryMoneyWarningDao.findMoneyWarning(paramMap);
	}

}

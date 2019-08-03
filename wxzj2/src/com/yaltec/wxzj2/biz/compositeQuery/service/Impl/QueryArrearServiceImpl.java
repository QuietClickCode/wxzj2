package com.yaltec.wxzj2.biz.compositeQuery.service.Impl;

import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.compositeQuery.dao.QueryArrearDao;
import com.yaltec.wxzj2.biz.compositeQuery.service.QueryArrearService;
import com.yaltec.wxzj2.biz.property.entity.House;

/**
 * <p>
 * ClassName: QueryArrearServiceImpl
 * </p>
 * <p>
 * Description: 欠费催交查询模块服务实现类
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author moqian
 * @date 2016-8-25 下午15:12:03
 */

@Service
public class QueryArrearServiceImpl implements QueryArrearService {
	
	@Autowired
	private QueryArrearDao queryArrearDao;	
	/**
	 * 查询所有欠费催交信息
	 */
	@Override	
	public void QueryArrear(Page<House> page, Map<String, Object> paramMap) {
		try {
			// 根据页面传入的map查询数据
			List<House> list = queryArrearDao.QueryArrear(paramMap);
			page.setDataByList(list, page.getPageNo(), page.getPageSize());
		} catch (Exception e) {
			e.printStackTrace();
		}				
	}
	
	public List<House> findArrear(Map<String, String> paramMap) {
		return queryArrearDao.findArrear(paramMap);
	}

}

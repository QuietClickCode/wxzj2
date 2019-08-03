package com.yaltec.wxzj2.biz.compositeQuery.service.Impl;

import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.compositeQuery.dao.QueryUnitToPrepayDao;
import com.yaltec.wxzj2.biz.compositeQuery.service.QueryUnitToPrepayService;
import com.yaltec.wxzj2.biz.payment.entity.UnitToPrepay;

/**
 * <p>
 * ClassName: QueryUnitToPrepayServiceImpl
 * </p>
 * <p>
 * Description: 单位交支查询模块服务实现类
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author moqian
 * @date 2016-8-26 上午09:12:03
 */

@Service
public class QueryUnitToPrepayServiceImpl implements QueryUnitToPrepayService {

	@Autowired
	private QueryUnitToPrepayDao queryUnitToPrepayDao;	
	/**
	 * 查询所有单位交支信息
	 */
	@Override	
	public void queryQryUnitToPrepay(Page<UnitToPrepay> page, Map<String, Object> paramMap) {
		try {
			// 根据页面传入的map查询数据
			List<UnitToPrepay> list = queryUnitToPrepayDao.queryQryUnitToPrepay(paramMap);
			page.setDataByList(list, page.getPageNo(), page.getPageSize());
		} catch (Exception e) {
			e.printStackTrace();
		}				
	}
	public List<UnitToPrepay> findUnitToPrepay(Map<String, String> paramMap) {
		return queryUnitToPrepayDao.findUnitToPrepay(paramMap);
	}

}

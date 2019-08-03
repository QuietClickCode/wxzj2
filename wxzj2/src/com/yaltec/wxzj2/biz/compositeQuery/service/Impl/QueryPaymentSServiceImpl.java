package com.yaltec.wxzj2.biz.compositeQuery.service.Impl;

import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.compositeQuery.dao.QueryPaymentSDao;
import com.yaltec.wxzj2.biz.compositeQuery.entity.QueryPaymentS;
import com.yaltec.wxzj2.biz.compositeQuery.service.QueryPaymentSService;

/**
 * <p>
 * ClassName: QueryPaymentSServiceImpl
 * </p>
 * <p>
 * Description: 汇缴清册查询模块服务实现类
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author moqian
 * @date 2016-8-25 上午09:12:03
 */

@Service
public class QueryPaymentSServiceImpl implements QueryPaymentSService {
	
	@Autowired
	private QueryPaymentSDao queryPaymentSDao;	
	
	/**
	 * 查询所有汇缴清册信息
	 */
	@Override	
	public void queryQueryPaymentS(Page<QueryPaymentS> page, Map<String, Object> paramMap) {
		try {
			// 根据页面传入的map查询数据
			List<QueryPaymentS> list = queryPaymentSDao.queryQueryPaymentS(paramMap);
			page.setDataByList(list, page.getPageNo(), page.getPageSize());
		} catch (Exception e) {
			e.printStackTrace();
		}				
	}
	
	public List<QueryPaymentS> findQueryPaymentS(Map<String, Object> paramMap){
		return queryPaymentSDao.findQueryPaymentS(paramMap);
	}
	
}

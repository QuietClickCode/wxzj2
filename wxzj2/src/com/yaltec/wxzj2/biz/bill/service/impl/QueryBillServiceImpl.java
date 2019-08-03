package com.yaltec.wxzj2.biz.bill.service.impl;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.bill.dao.QueryBillDao;
import com.yaltec.wxzj2.biz.bill.entity.QueryBill;
import com.yaltec.wxzj2.biz.bill.service.QueryBillService;

/**
 * <p>
 * ClassName: QueryBillServiceImpl
 * </p>
 * <p>
 * Description: 票据查询模块服务实现类
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author moqian
 * @date 2016-7-28 上午11:32:14
 */

@Service
public class QueryBillServiceImpl implements QueryBillService {
	
	private static final Logger logger = Logger.getLogger("RefundPrint");
	
	@Autowired
	private QueryBillDao queryBillDao;

	@Override	
	public void findAll(Page<QueryBill> page, Map<String, Object> paramMap) {
		try {
			//根据页面传入的map查询数据
			List<QueryBill> list = queryBillDao.findAll(paramMap);
			page.setDataByList(list, page.getPageNo(), page.getPageSize());
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public List<QueryBill> findQueryBill(Map<String, Object> paramMap){
		return queryBillDao.findQueryBill(paramMap);
	} 
	
	@Override
	public QueryBill getQueryBillInfoSum(Map<String, String> paramMap) {		
		return queryBillDao.getQueryBillInfoSum(paramMap);
	}
}
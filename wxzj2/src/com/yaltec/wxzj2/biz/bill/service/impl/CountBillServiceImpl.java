package com.yaltec.wxzj2.biz.bill.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.bill.dao.CountBillDao;
import com.yaltec.wxzj2.biz.bill.entity.CountBill;
import com.yaltec.wxzj2.biz.bill.service.CountBillService;


/**
 * <p>
 * ClassName: CountBillServiceImpl
 * </p>
 * <p>
 * Description: 票据统计模块服务实现类
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author moqian
 * @date 2016-7-30 下午04:32:14
 */

@Service
public class CountBillServiceImpl implements CountBillService {
	
	@Autowired
	private CountBillDao countBillDao;
	
	@Override	
	public void findAll(Page<CountBill> page, Map<String, Object> paramMap) {
		try {
			// 根据页面传入的map查询数据
			List<CountBill> list = countBillDao.findAll(paramMap);
			page.setDataByList(list, page.getPageNo(), page.getPageSize());
		} catch (Exception e) {
			e.printStackTrace();
		}				
	}

}

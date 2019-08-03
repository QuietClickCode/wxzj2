package com.yaltec.wxzj2.biz.bill.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.github.pagehelper.PageHelper;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.bill.dao.ReceiptNoDao;
import com.yaltec.wxzj2.biz.bill.entity.ReceiptNo;
import com.yaltec.wxzj2.biz.bill.service.ReceiptNoService;

/**
 * <p>
 * ClassName: ReceiptNoServiceImpl
 * </p>
 * <p>
 * Description: 票据回传情况模块服务实现类
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author moqian
 * @date 2016-7-28 上午09:18:14
 */

@Service
public class ReceiptNoServiceImpl implements ReceiptNoService {
	
	@Autowired
	private ReceiptNoDao receiptNoDao;
	
	@Override	
	public void findAll(Page<ReceiptNo> page) {
		PageHelper.startPage(page.getPageNo(), page.getPageSize());
		List<ReceiptNo> list = receiptNoDao.findAll(page.getQuery());
		page.setData(list);
	}
}

package com.yaltec.wxzj2.biz.system.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.github.pagehelper.PageHelper;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.system.dao.BankLogDao;
import com.yaltec.wxzj2.biz.system.entity.BankLog;
import com.yaltec.wxzj2.biz.system.service.BankLogService;

/**
 * <p>
 * ClassName: BankLogServiceImpl
 * </p>
 * <p>
 * Description: 银行日志模块服务实现类(这里用一句话描述这个类的作用)
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author jiangyong
 * @date 2016-10-10 下午02:32:14
 */
@Service
public class BankLogServiceImpl implements BankLogService {

	@Autowired
	private BankLogDao bankLogDao;
	 
	
	@Override
	public void findAll(Page<BankLog> page, Map<String, Object> params) {
		try {
			PageHelper.startPage(page.getPageNo(), page.getPageSize());
			List<BankLog> list = bankLogDao.findAll(params);
			page.setData(list);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	@Override
	public List<BankLog> findAll2(Map<String,Object> params){
		return bankLogDao.findAll(params);
	}
	
}
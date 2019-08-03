package com.yaltec.wxzj2.biz.system.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.github.pagehelper.PageHelper;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.system.dao.BankDao;
import com.yaltec.wxzj2.biz.system.entity.Bank;
import com.yaltec.wxzj2.biz.system.service.BankService;


/**
 * <p>
 * ClassName: BankServiceImpl
 * </p>
 * <p>
 * Description: 银行管理设置模块服务实现类(这里用一句话描述这个类的作用)
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author jiangyong
 * @date 2016-7-27 下午04:32:14
 */
@Service
public class BankServiceImpl implements BankService {

	@Autowired
	private BankDao bankDao;
	
	/**
	 * 查询银行列表
	 */
	@Override
	public void findAll(Page<Bank> page) {
		PageHelper.startPage(page.getPageNo(), page.getPageSize());
		List<Bank> list = bankDao.findAll(page.getQuery());
		page.setData(list);
	}
	
	/**
	 * 保存银行信息
	 */
	public int add(Bank bank){
		try {
			return bankDao.add(bank);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return 0;
		
	}
	
	/**
	 * 根据bm查询银行信息
	 */
	public Bank findByBm(String bm) {
		return bankDao.findByBm(bm);
	}
	
	/**
	 * 修改银行信息
	 */
	public int update(Bank bank) {
		return bankDao.update(bank);
	}
	
	@Override
	public Bank findByMc(Bank bank) {
		return bankDao.findByMc(bank);
	}
}

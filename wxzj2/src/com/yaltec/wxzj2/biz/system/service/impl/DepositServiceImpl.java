package com.yaltec.wxzj2.biz.system.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.github.pagehelper.PageHelper;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.comon.service.IdUtilService;
import com.yaltec.wxzj2.biz.system.dao.DepositDao;
import com.yaltec.wxzj2.biz.system.entity.Deposit;
import com.yaltec.wxzj2.biz.system.service.DepositService;

/**
 * <p>
 * ClassName: DepositServiceImpl
 * </p>
 * <p>
 * Description: 交存标准模块服务实现类(这里用一句话描述这个类的作用)
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author jiangyong
 * @date 2016-8-1 上午10:27:14
 */
@Service
public class DepositServiceImpl implements DepositService {

	@Autowired
	private DepositDao depositDao;

	@Autowired
	private IdUtilService idUtilService;
	
	@Override
	public void findAll(Page<Deposit> page) {
		PageHelper.startPage(page.getPageNo(), page.getPageSize());
		List<Deposit> list = depositDao.findAll(page.getQuery());
		page.setData(list);
	}
	
	/**
	 * 保存交存标准信息
	 */
	public int add(Deposit deposit){
		try {
			// 获取当前数据库表可用BM
			String bm = idUtilService.getNextBm("Deposit");
			deposit.setBm(bm);
			return depositDao.add(deposit);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return 0;
	}
	
	public Deposit findByBm(String bm) {
		return depositDao.findByBm(bm);
	}
	
	public int update(Deposit deposit) {
		return depositDao.update(deposit);
	}
}

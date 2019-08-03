package com.yaltec.wxzj2.biz.system.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.github.pagehelper.PageHelper;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.comon.service.IdUtilService;
import com.yaltec.wxzj2.biz.system.dao.InterestRateDao;
import com.yaltec.wxzj2.biz.system.entity.ActiveRate;
import com.yaltec.wxzj2.biz.system.entity.FixedRate;
import com.yaltec.wxzj2.biz.system.entity.HouseRate;
import com.yaltec.wxzj2.biz.system.service.InterestRateService;

/**
 * <p>
 * ClassName: InterestRateServiceImpl
 * </p>
 * <p>
 * Description:系统利率设置服务实现类
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author jiangyong
 * @date 2016-8-23 下午05:29:42
 */
@Service
public class InterestRateServiceImpl implements InterestRateService {

	@Autowired
	private InterestRateDao interestRateDao;

	@Autowired
	private IdUtilService idUtilService;

	@Override
	public void findActiveRate(Page<ActiveRate> page, Map<String, Object> map) {
		PageHelper.startPage(page.getPageNo(), page.getPageSize());
		List<ActiveRate> list = interestRateDao.findActiveRate(map);
		page.setData(list);
	}

	@Override
	public void findFixedRate(Page<FixedRate> page, Map<String, Object> map) {
		PageHelper.startPage(page.getPageNo(), page.getPageSize());
		List<FixedRate> list = interestRateDao.findFixedRate(map);
		page.setData(list);
	}

	@Override
	public void findHouseRate(Page<HouseRate> page, Map<String, Object> map) {
		PageHelper.startPage(page.getPageNo(), page.getPageSize());
		List<HouseRate> list = interestRateDao.findHouseRate(map);
		page.setData(list);
	}

	/**
	 * 保存存款利率设置信息
	 */
	public void addActiveRate(Map<String, String> map) {
		try {
			// 获取当前数据库表可用BM
			String bm = idUtilService.getNextBm("SordineFDRate");
			map.put("bm", bm);
			interestRateDao.addActiveRate(map);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 保存定期利率设置信息
	 */
	public void addFixedRate(Map<String, String> map) {
		try {
			// 获取当前数据库表可用BM
			String bm = idUtilService.getNextBm("TimeDepositRate");
			map.put("bm", bm);
			interestRateDao.addFixedRate(map);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 保存房屋利率设置信息
	 */
	public void addHouseRate(Map<String, String> map) {
		try {
			interestRateDao.addHouseRate(map);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 通过bm查询系统利率设置信息信息
	 */
	public ActiveRate getActiveRate(String bm) {
		return interestRateDao.getActiveRate(bm);
	}

	public FixedRate getFixedRate(String bm) {
		return interestRateDao.getFixedRate(bm);
	}

	public HouseRate getHouseRate() {
		return interestRateDao.getHouseRate();
	}

	/**
	 * 修改系统利率设置信息
	 */
	public void updateActiveRate(Map<String, String> map) {
		interestRateDao.updateActiveRate(map);
	}

	public void updateFixedRate(Map<String, String> map) {
		interestRateDao.updateFixedRate(map);
	}

	public void updateHouseRate(Map<String, String> map) {
		interestRateDao.updateHouseRate(map);
	}
}

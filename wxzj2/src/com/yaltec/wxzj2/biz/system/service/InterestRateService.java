package com.yaltec.wxzj2.biz.system.service;

import java.util.Map;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.system.entity.ActiveRate;
import com.yaltec.wxzj2.biz.system.entity.FixedRate;
import com.yaltec.wxzj2.biz.system.entity.HouseRate;

/**
 * <p>ClassName: InterestRateService</p>
 * <p>Description: 系统利率设置服务接口</p>
 * <p>Company: YALTEC</p> 
 * @author jiangyong
 * @date 2016-8-23 下午05:11:41
 */
public interface InterestRateService {

	/**
	 * 查询系统利率设置信息
	 * 
	 * @param map 查询条件map
	 * @return
	 */
	public void findActiveRate(Page<ActiveRate> page, Map<String, Object> map);

	public void findFixedRate(Page<FixedRate> page, Map<String, Object> map);
	
	public void findHouseRate(Page<HouseRate> page, Map<String, Object> map);
	
	/**
	 * 保存系统利率设置信息
	 * @param InterestRate
	 * @return
	 */
	public void addActiveRate(Map<String, String> map);
	
	public void addFixedRate(Map<String, String> map);
	
	public void addHouseRate(Map<String, String> map);
	
	/**
	 * 通过bm查询系统利率设置信息详情
	 * @param bm
	 * @return
	 */
	public ActiveRate getActiveRate(String bm);
	
	public FixedRate getFixedRate(String bm);
	
	public HouseRate getHouseRate();
	
	/**
	 * 更新系统利率设置信息
	 * @param assignment
	 * @return
	 */
	public void updateActiveRate(Map<String, String> map);
	
	public void updateFixedRate(Map<String, String> map);
	
	public void updateHouseRate(Map<String, String> map);
}

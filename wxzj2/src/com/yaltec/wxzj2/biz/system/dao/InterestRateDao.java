package com.yaltec.wxzj2.biz.system.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.yaltec.wxzj2.biz.system.entity.ActiveRate;
import com.yaltec.wxzj2.biz.system.entity.FixedRate;
import com.yaltec.wxzj2.biz.system.entity.HouseRate;

/**
 * <p>ClassName: InterestRateDao</p>
 * <p>Description: 系统利率设置数据库持久层接口</p>
 * <p>Company: YALTEC</p> 
 * @author jiangyong
 * @date 2016-8-18 下午05:31:58
 */
@Repository
public interface InterestRateDao {
	
	/**
	 * 查询系统利率设置信息
	 * 
	 */
	public List<ActiveRate> findActiveRate(Map<String, Object> map);

	public List<FixedRate> findFixedRate(Map<String, Object> map);
	
	public List<HouseRate> findHouseRate(Map<String, Object> map);
	
	/**
	 * 保存系统利率设置信息
	 */
	public void addActiveRate(Map<String, String> map);
	
	public void addFixedRate(Map<String, String> map);
	
	public void addHouseRate(Map<String, String> map);
	
	/**
	 * 通过bm查询系统利率设置信息信息
	 */
	public ActiveRate getActiveRate(String bm);
	
	public FixedRate getFixedRate(String bm);
	
	public HouseRate getHouseRate();
	
	/**
	 * 修改系统利率设置信息
	 */
	public void updateActiveRate(Map<String, String> map);
	
	public void updateFixedRate(Map<String, String> map);
	
	public void updateHouseRate(Map<String, String> map);
}

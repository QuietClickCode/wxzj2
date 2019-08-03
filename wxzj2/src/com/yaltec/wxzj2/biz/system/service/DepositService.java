package com.yaltec.wxzj2.biz.system.service;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.system.entity.Deposit;


/**
 * <p>ClassName: DepositService</p>
 * <p>Description: 交存标准服务接口(这里用一句话描述这个类的作用)</p>
 * <p>Company: YALTEC</p> 
 * @author jiangyong
 * @date 2016-8-1 上午10:24:57
 */
public interface DepositService {
	
	/**
	 * 翻页查询
	 * 
	 * @param page
	 */
	public void findAll(Page<Deposit> page);
	
	/**
	 * 保存信息
	 * @param Deposit
	 * @return
	 */
	public int add(Deposit deposit);
	
	/**
	 * 通过bm查询交存标准信息详情
	 * @param bm
	 * @return
	 */
	public Deposit findByBm(String bm);
	
	/**
	 * 更新交存标准信息
	 * @param deposit
	 * @return
	 */
	public int update(Deposit deposit);
}

package com.yaltec.wxzj2.biz.system.service;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.system.entity.Bank;


/**
 * <p>ClassName: BankService</p>
 * <p>Description: 银行信息服务接口(这里用一句话描述这个类的作用)</p>
 * <p>Company: YALTEC</p> 
 * @author jiangyong
 * @date 2016-7-27 下午02:35:57
 */
public interface BankService {
	
	/**
	 * 翻页查询
	 * 
	 * @param page
	 */
	public void findAll(Page<Bank> page);
	
	/**
	 * 保存信息
	 * @param Bank
	 * @return
	 */
	public int add(Bank bank);
	
	/**
	 * 通过bm查询银行信息详情
	 * @param bm
	 * @return
	 */
	public Bank findByBm(String bm);
	
	/**
	 * 更新银行信息
	 * @param bank
	 * @return
	 */
	public int update(Bank Bank);
	
	/**
	 * 通过bm、mc查询项目信息详情
	 * @param bm
	 * @return
	 */
	public Bank findByMc(Bank Bank);
}

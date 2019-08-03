package com.yaltec.wxzj2.biz.fixedDeposit.service;

import java.util.Map;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.fixedDeposit.entity.Deposits;

/**
 * 
 * @ClassName: DepositsService
 * @Description: 存款信息服务接口
 * 
 * @author hequanxin
 * @date 2017-10-30 下午02:37:37
 */
public interface DepositsService {

	/**
	 * 查询存款信息列表
	 * 
	 * @param roleid
	 * @return
	 */
	public void findAll(Page<Deposits> page);
	
	
	/**
	 * 保存存款信息
	 * 
	 * @param house
	 * @return
	 */
	public int save(Map<String, String> map);
	
	public Deposits findById(String id);
	
	public int update(Deposits deposits) ;
	
	public int delete(String id);
}

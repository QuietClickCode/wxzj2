package com.yaltec.wxzj2.biz.bill.service;


import java.util.Map;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.bill.entity.BillM;

/**
 * <p>ClassName: DeveloperService</p>
 * <p>Description: 票据信息服务接口</p>
 * <p>Company: YALTEC</p> 
 * @author moqian
 * @date 2016-7-19 下午02:35:57
 */

public interface BillMService {
	
	/**
	 * 翻页查询所有票据信息
	 * 
	 * @param page
	 */	
	public void findAll(Page<BillM> page);
	
	/**
	 * 保存信息
	 * @param billM
	 * @return
	 */
	public int save(Map<String,String> paramMap);

	/**
	 * 通过bm查询票据信息详情
	 * @param bm
	 * @return
	 */
	public BillM findByBm(String bm);
	
	/**
	 * 修改票据信息
	 * @param billM
	 * @return
	 */
	public int update(Map<String,String> paramMap);
		
	/**
	 * 删除票据信息	 * 
	 * @param delete
	 * @return
	 */
	public int delete(Map<String, String> paramMap);
	
}

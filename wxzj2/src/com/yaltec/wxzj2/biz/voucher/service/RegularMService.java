package com.yaltec.wxzj2.biz.voucher.service;

import java.util.List;
import java.util.Map;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.voucher.entity.RegularM;

/**
 * <p>ClassName: RegularMService</p>
 * <p>Description: 定期管理服务接口(这里用一句话描述这个类的作用)</p>
 * <p>Company: YALTEC</p> 
 * @author chenxiaokuang
 * @date 2016-7-19 下午02:35:57
 */
public interface RegularMService {

	/**
	 * 翻页查询定期管理信息
	 * 
	 * @param page
	 */
	public void findAll(Page<RegularM> page);
	
	/**
	 * 保存定期管理信息
	 * @param map
	 * @return
	 */
	public void add(Map<String, String> map);
	
	/**
	 * 根据Id查询定期管理信息
	 * @param id
	 * @return
	 */
	public RegularM findById(String id);
	
	/**
	 * 更新定期管理信息
	 * @param map
	 * @return
	 */
	public void update(Map<String, String> map);
	
	
	/**
	 * 通过id删除信息详情
	 * @param bm
	 * @return
	 */
	public int delete(String id);
	
	/**
	 * 批量删除定期管理信息
	 * 
	 * @param idList
	 * @return
	 */
	public int batchDelete(List<String> idList);
	/**
	 * 查询需要提醒的定期管理信息列表
	 * 
	 * @param 
	 * @return
	 */
	public void findExpireAll(Page<RegularM> page);
	/**
	 * 查询需要提醒的定期管理信息的个数
	 * 
	 * @param 
	 * @return
	 */
	public int findExpireNum();
}

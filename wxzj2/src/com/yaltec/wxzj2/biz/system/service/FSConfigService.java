package com.yaltec.wxzj2.biz.system.service;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.system.entity.FSConfig;


/**
 * <p>ClassName: FSConfigService</p>
 * <p>Description: 非税配置服务接口(这里用一句话描述这个类的作用)</p>
 * <p>Company: YALTEC</p> 
 * @author jiangyong
 * @date 2016-9-5 下午04:15:57
 */
public interface FSConfigService {
	
	/**
	 * 翻页查询
	 * 
	 * @param page
	 */
	public void findAll(Page<FSConfig> page);
	
	/**
	 * 保存非税配置信息
	 * @param FSConfig
	 * @return
	 */
	public int add(FSConfig fsconfig);
	
	/**
	 * 通过id查询非税配置信息详情
	 * @param id
	 * @return
	 */
	public FSConfig findById(String id);
	
	/**
	 * 更新非税配置信息
	 * @param fsconfig
	 * @return
	 */
	public int update(FSConfig fsconfig);
	
	/**
	 * 通过id删除非税配置信息详情
	 * @param id
	 * @return
	 */
	public int delete(String id);
}

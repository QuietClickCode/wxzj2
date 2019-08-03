package com.yaltec.wxzj2.biz.system.service;

import java.util.List;
import java.util.Map;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.system.entity.TouchScreenInfo;


/**
 * <p>ClassName: TouchScreenInfoService</p>
 * <p>Description: 触摸屏信息服务接口(这里用一句话描述这个类的作用)</p>
 * <p>Company: YALTEC</p> 
 * @author jiangyong
 * @date 2016-9-6 下午02:35:57
 */
public interface TouchScreenInfoService {
	
	/**
	 * 翻页查询触摸屏信息
	 * 
	 * @param page
	 */
	public void findAll(Page<TouchScreenInfo> page);
	
	/**
	 * 保存触摸屏信息
	 * @param TouchScreenInfo
	 * @return
	 */
	public void add(Map<String, String> map);
	
	/**
	 * 通过bm查询触摸屏信息详情
	 * @param bm
	 * @return
	 */
	public TouchScreenInfo findByBm(String bm);
	
	/**
	 * 更新触摸屏信息
	 * @param touchScreenInfo
	 * @return
	 */
	public void update(Map<String, String> map);
	
	/**
	 * 通过bm删除信息详情
	 * @param bm
	 * @return
	 */
	public int delete(String bm);
	
	/**
	 * 批量删除触摸屏信息
	 * 
	 * @param batchDelete
	 * @return
	 */
	public int batchDelete(List<String> bmList);
}

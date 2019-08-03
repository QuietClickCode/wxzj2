package com.yaltec.wxzj2.biz.system.service;

import java.util.List;
import java.util.Map;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.system.entity.Assignment;

/**
 * <p>ClassName: AssignmentService</p>
 * <p>Description: 归集中心设置信息服务接口(这里用一句话描述这个类的作用)</p>
 * <p>Company: YALTEC</p> 
 * @author jiangyong
 * @date 2016-7-28 下午02:35:57
 */
public interface AssignmentService {
	
	/**
	 * 翻页查询
	 * 
	 * @param page
	 */
	public void findAll(Page<Assignment> page);
	
	/**
	 * 保存信息
	 * @param Assignment
	 * @return
	 */
	public void add(Map<String, String> map);
	
	/**
	 * 通过bm查询归集中心信息详情
	 * @param bm
	 * @return
	 */
	public Assignment findByBm(String bm);
	
	/**
	 * 更新归集中心信息
	 * @param assignment
	 * @return
	 */
	public void update(Map<String, String> map);
	
	/**
	 * 批量删除归集中心信息
	 * 
	 * @param batchDelete
	 * @return
	 */
	public int batchDelete(List<String> bmList);
}

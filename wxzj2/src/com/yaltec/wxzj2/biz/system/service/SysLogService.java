package com.yaltec.wxzj2.biz.system.service;

import java.util.List;
import java.util.Map;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.comon.log.entity.Log;


/**
 * <p>ClassName: SysLogService</p>
 * <p>Description: 系统日志查询服务接口(这里用一句话描述这个类的作用)</p>
 * <p>Company: YALTEC</p> 
 * @author jiangyong
 * @date 2016-8-20 上午10:15:57
 */
public interface SysLogService {
	
	/**
	 * 翻页查询
	 * 
	 * @param page
	 */
	public void findAll(Page<Log> page, Map<String, Object> map);
	
	/**
	 * 批量保存日志记录
	 * @param list
	 * @return
	 */
	public int batchAdd(List<Log> list);
	
	/**
	 * 根据ID获取日志详情
	 * @param id
	 * @return
	 */
	public Log find(String id);

	/**
	 * 导出日志
	 * @param map
	 * @return
	 */
	List<Log> findAll2(Map<String, Object> map);
}

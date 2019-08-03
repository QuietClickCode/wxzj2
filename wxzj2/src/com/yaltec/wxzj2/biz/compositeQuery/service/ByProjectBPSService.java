package com.yaltec.wxzj2.biz.compositeQuery.service;

import java.util.List;
import java.util.Map;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.compositeQuery.entity.ByProjectBPS;
import com.yaltec.wxzj2.biz.property.entity.House;


/**
 * <p>ClassName: ByProjectBPSService</p>
 * <p>Description: 项目收支统计服务接口</p>
 * <p>Company: YALTEC</p> 
 * @author moqian
 * @date 2016-8-26 下午16:12:03
 */

public interface ByProjectBPSService {	
	/**
	 * 翻页查询所有项目收支统计信息
	 * 
	 * @param page
	 */	
	public void queryByProjectBPS(Page<ByProjectBPS> page,Map<String, Object> paramMap);
	/**
	 * 查询项目收支统计信息
	 * @param paramMap
	 * @return
	 */
	public List<ByProjectBPS> findProjectBPS(Map<String, String> paramMap);

}

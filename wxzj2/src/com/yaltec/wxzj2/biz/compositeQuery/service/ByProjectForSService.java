package com.yaltec.wxzj2.biz.compositeQuery.service;

import java.util.List;
import java.util.Map;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.compositeQuery.entity.ByBuildingForC1;

/**
 * <p>ClassName: ByProjectForSService</p>
 * <p>Description: 项目台账查询服务接口</p>
 * <p>Company: YALTEC</p> 
 * @author moqian
 * @date 2016-8-23 下午16:12:03
 */

public interface ByProjectForSService {	
	/**
	 * 翻页查询所有项目台账信息
	 * 
	 * @param page
	 */	
	public void queryByProjectForS(Page<ByBuildingForC1> page,Map<String, Object> paramMap);
	
	/**
	 * 查询楼宇台账信息
	 * @param paramMap
	 * @return
	 */
	public List<ByBuildingForC1> findByProjectForS(Map<String, Object> paramMap);

}

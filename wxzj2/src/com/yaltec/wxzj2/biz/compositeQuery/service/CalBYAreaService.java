package com.yaltec.wxzj2.biz.compositeQuery.service;

import java.util.List;
import java.util.Map;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.compositeQuery.entity.MonthReportOfBank;

/**
 * <p>ClassName: CalBYAreaService</p>
 * <p>Description: 面积户数查询服务接口</p>
 * <p>Company: YALTEC</p> 
 * @author moqian
 * @date 2016-8-25 上午10:12:03
 */

public interface CalBYAreaService {	
	/**
	 * 翻页查询所有面积户数查询信息
	 * 
	 * @param page
	 */	
	public List<MonthReportOfBank> queryCalBYArea(Map<String, Object> paramMap);
	/**
	 * 查询面积户数查询信息
	 */
	public List<MonthReportOfBank> findCalBYArea(Map<String, String> map);
	
}

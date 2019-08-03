package com.yaltec.wxzj2.biz.compositeQuery.service;

import java.util.List;
import java.util.Map;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.compositeQuery.entity.WxzjInfoTj;

/**
 * <p>ClassName: QueryWxzjInfoTjService</p>
 * <p>Description: 信息统计查询服务接口</p>
 * <p>Company: YALTEC</p> 
 * @author moqian
 * @date 2016-8-29 上午09:12:03
 */

public interface QueryWxzjInfoTjService {	
	/**
	 * 翻页查询所有信息统计查询
	 * 
	 * @param page
	 */	
	public void QueryWxzjInfoTj(Page<WxzjInfoTj> page,Map<String, Object> paramMap);
	/**
	 * 根据年度查询信息统计
	 * @param map
	 * @return
	 */
	public List<WxzjInfoTj> findWxzjInfoTj(Map<String, Object> map);
}

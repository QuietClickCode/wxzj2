package com.yaltec.wxzj2.biz.compositeQuery.service;
import java.util.List;
import java.util.Map;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.compositeQuery.entity.CountHouse;

/**
 * <p>ClassName: CountHouseService</p>
 * <p>Description:  户数统计查询服务接口</p>
 * <p>Company: YALTEC</p> 
 * @author moqian
 * @date 2016-8-25 上午09:12:03
 */

public interface CountHouseService {	
	/**
	 * 翻页查询所有户数统计信息
	 * 
	 * @param page
	 */	
	public void queryCountHouse(Page<CountHouse> page,Map<String, Object> paramMap);
	
	/**
	 * 查询户数统计信息
	 * @param paramMap
	 * @return
	 */
	public List<CountHouse> findCountHouse(Map<String, Object> paramMap);

}

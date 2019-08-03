package com.yaltec.wxzj2.biz.compositeQuery.service;

import java.util.List;
import java.util.Map;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.payment.entity.UnitToPrepay;

/**
 * <p>ClassName: QueryUnitToPrepayService</p>
 * <p>Description: 单位交支查询服务接口</p>
 * <p>Company: YALTEC</p> 
 * @author moqian
 * @date 2016-8-26 上午09:12:03
 */

public interface QueryUnitToPrepayService {	
	/**
	 * 翻页查询所有单位交支信息
	 * 
	 * @param page
	 */	
	public void queryQryUnitToPrepay(Page<UnitToPrepay> page,Map<String, Object> paramMap);
	/**
	 * 查询单位交支信息
	 * @param paramMap
	 * @return
	 */
	public List<UnitToPrepay> findUnitToPrepay(Map<String, String> paramMap);

}

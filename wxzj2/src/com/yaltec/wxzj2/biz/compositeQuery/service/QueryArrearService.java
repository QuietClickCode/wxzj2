package com.yaltec.wxzj2.biz.compositeQuery.service;

import java.util.List;
import java.util.Map;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.payment.entity.UnitToPrepay;
import com.yaltec.wxzj2.biz.property.entity.House;

/**
 * <p>ClassName: QueryArrearService</p>
 * <p>Description: 欠费催交查询服务接口</p>
 * <p>Company: YALTEC</p> 
 * @author moqian
 * @date 2016-8-25 下午15:12:03
 */

public interface QueryArrearService {	
	/**
	 * 翻页查询所有欠费催交信息
	 * 
	 * @param page
	 */	
	public void QueryArrear(Page<House> page,Map<String, Object> paramMap);
	/**
	 * 查询欠费催交信息
	 * @param paramMap
	 * @return
	 */
	public List<House> findArrear(Map<String, String> paramMap);
}

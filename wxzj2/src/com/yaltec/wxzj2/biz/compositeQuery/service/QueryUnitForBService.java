package com.yaltec.wxzj2.biz.compositeQuery.service;

import java.util.List;
import java.util.Map;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.compositeQuery.entity.QueryUnitForB;
import com.yaltec.wxzj2.biz.draw.entity.CodeName;

/**
 * <p>ClassName: QueryUnitForBService</p>
 * <p>Description: 单元余额查询服务接口</p>
 * <p>Company: YALTEC</p> 
 * @author moqian
 * @date 2016-8-23 上午09:12:03
 */

public interface QueryUnitForBService {	
	/**
	 * 翻页查询所有单元余额信息
	 * 
	 * @param page
	 */	
	public void queryQueryUnitForB(Page<QueryUnitForB> page,Map<String, Object> paramMap);
	
	/**
	 * 查询单元余额信息
	 * @param paramMap
	 * @return
	 */
	public List<QueryUnitForB> findQueryUnitForB(Map<String, Object> paramMap);
	/**
	 * 按银行查询项目
	 * @param yhbh
	 * @return
	 */
	public List<CodeName> queryProjectByBank(String yhbh);
	/**
	 * 按银行查询小区
	 * @param yhbh
	 * @return
	 */
	public List<CodeName> queryCommunityByBank(String yhbh);

}

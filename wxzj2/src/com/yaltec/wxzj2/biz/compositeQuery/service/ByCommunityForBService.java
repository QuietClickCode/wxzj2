package com.yaltec.wxzj2.biz.compositeQuery.service;

import java.util.List;
import java.util.Map;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.compositeQuery.entity.ByCommunityForB;
import com.yaltec.wxzj2.biz.draw.entity.CodeName;

/**
 * <p>ClassName: ByCommunityForBService</p>
 * <p>Description: 小区余额查询服务接口</p>
 * <p>Company: YALTEC</p> 
 * @author moqian
 * @date 2016-8-9 下午14:12:03
 */

public interface ByCommunityForBService {
	
	/**
	 * 查询小区余额信息
	 * 
	 * @param page
	 */	
	public void queryByCommunityForB(Page<ByCommunityForB> page,Map<String, Object> paramMap);
	/**
	 * 根据银行编码获取小区信息
	 */
	public List<CodeName> queryOpenCommunityByBank(Map<String, String> map);
	
	/**
	 * 查询小区余额(导出)信息
	 * @param paramMap
	 * @return
	 */
	public List<ByCommunityForB> findByCommunityForB(Map<String, Object> paramMap);

}

package com.yaltec.wxzj2.biz.draw.service;

import java.util.List;
import java.util.Map;

import com.yaltec.wxzj2.biz.draw.entity.ApplyDraw;
import com.yaltec.wxzj2.biz.draw.entity.ShareAD;
import com.yaltec.wxzj2.biz.draw.entity.TransferAD;


/**
 * 支取查询Service接口
 * @author 亚亮科技有限公司.YL
 *
 * @version: 2016-8-29 上午11:31:39
 */
public interface QueryADService {
	/**
	 * 支取查询(模糊查询、申请编号、经办人)
	 * @param map
	 * @return
	 */
	public List<Map<String,String>> queryQueryAD(Map<String, Object> map);
	/**
	 * 支取查询(明细查询)
	 * @param map
	 * @return
	 */
	public List<Map<String,String>> queryQueryADMX(Map<String, Object> map);
	/**
	 * 支取统计查询  
	 * @param map
	 * @return
	 */
	public List<Map<String,String>> queryCountAD(Map<String, Object> map);
}

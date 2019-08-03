package com.yaltec.wxzj2.biz.draw.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.yaltec.wxzj2.biz.draw.entity.ApplyDraw;
import com.yaltec.wxzj2.biz.draw.entity.ShareAD;
import com.yaltec.wxzj2.biz.draw.entity.TransferAD;

/**
 * 支取查询操作接口
 * @author 亚亮科技有限公司.YL
 *
 * @version: 2016-8-29 上午11:29:19
 */
@Repository
public interface QueryADDao {
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

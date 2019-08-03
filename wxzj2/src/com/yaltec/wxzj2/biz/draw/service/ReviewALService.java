package com.yaltec.wxzj2.biz.draw.service;

import java.util.List;
import java.util.Map;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.draw.entity.ApplyLogout;

/**
 * 
 * @ClassName: ReviewALService
 * @Description: TODO销户审核Service接口
 * 
 * @author yangshanping
 * @date 2016-8-10 上午09:35:50
 */
public interface ReviewALService {
	/**
	 * 通过传入的map集合，分页查询销户审核信息
	 * @param page
	 * @param paramMap
	 * @return
	 */
	public void find(Page<ApplyLogout> page,Map<String, Object> paramMap);
	/**
	 * 通过传入的map集合，查询销户审核信息
	 */
	public List<ApplyLogout> queryApplyLogout(Map<String, Object> paramMap);
	/**
	 * 查询销户审核
	 * @param paramMap
	 * @return
	 */
	public List<ApplyLogout> queryApplyLogoutJ(Map<String, Object> paramMap);
	/**
	 * 销户审核通过
	 */
	public String updtApplyLogout(Map<String, String> paramMap);
	/**
	 * 返回申请
	 */
	public String returnReviewAL(Map<String, String> paramMap);
	
}

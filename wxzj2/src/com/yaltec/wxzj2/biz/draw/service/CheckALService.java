package com.yaltec.wxzj2.biz.draw.service;

import java.util.List;
import java.util.Map;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.draw.entity.ApplyLogout;

/**
 * 
 * @ClassName: CheckALService
 * @Description: TODO销户初审Service接口
 * 
 * @author yangshanping
 * @date 2016-8-9 下午03:35:48
 */
public interface CheckALService {
	/**
	 * 通过传入的map集合，分页查询销户初审信息
	 * @param page
	 * @param paramMap
	 * @return
	 */
	public void find(Page<ApplyLogout> page,Map<String, Object> paramMap);
	/**
	 * 通过传入的map集合，查询销户初审信息
	 */
	public List<ApplyLogout> queryApplyLogout(Map<String, Object> paramMap);
	/**
	 * 查询销户初审
	 * @param paramMap
	 * @return
	 */
	public List<ApplyLogout> queryApplyLogoutJ(Map<String, Object> paramMap);
	/**
	 * 销户初审通过
	 */
	public String updtApplyLogout(Map<String, String> paramMap);
	/**
	 * 返回申请
	 */
	public String returnReviewAL(Map<String, String> paramMap);
}

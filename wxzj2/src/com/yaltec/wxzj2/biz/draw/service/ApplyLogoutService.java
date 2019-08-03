package com.yaltec.wxzj2.biz.draw.service;

import java.util.List;
import java.util.Map;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.draw.entity.ApplyLogout;

/**
 * 
 * @ClassName: ApplyLogoutService
 * @Description: TODO 销户申请Service接口
 * 
 * @author yangshanping
 * @date 2016-8-8 上午10:40:29
 */
public interface ApplyLogoutService {
	/**
	 * 通过传入的map集合，分页查询销户申请信息
	 * @param page
	 * @param paramMap
	 * @return
	 */
	public void find(Page<ApplyLogout> page,Map<String, Object> paramMap);
	/**
	 * 通过传入的map集合，查询销户申请信息
	 */
	public List<ApplyLogout> queryApplyLogout(Map<String, Object> paramMap);
	/**
	 * 查询销户信息(初审退回,审核退回,拒绝受理)
	 * @param paramMap
	 * @return
	 */
	public List<ApplyLogout> queryApplyLogoutJ(Map<String, Object> paramMap);
	/**
	 * 保存销户申请信息
	 * @param paramMap
	 * @return
	 */
	public int saveApplyLogout(Map<String, String> paramMap);
	/**
	 * 提交销户申请
	 */
	public String updtApplyLogout(Map<String, String> paramMap);
	/**
	 * 删除销户申请
	 */
	public int delApplyLogout(Map<String, String> paramMap);
	
}

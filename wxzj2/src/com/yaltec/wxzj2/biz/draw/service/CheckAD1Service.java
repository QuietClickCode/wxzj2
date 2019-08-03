package com.yaltec.wxzj2.biz.draw.service;

import java.util.List;
import java.util.Map;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.draw.entity.ApplyDraw;
import com.yaltec.wxzj2.biz.draw.entity.ShareAD;

/**
 * 
 * @ClassName: CheckAD1Service
 * @Description: 支取初审Service接口
 * 
 * @author yangshanping
 * @date 2016-8-31 下午04:39:20
 */
public interface CheckAD1Service {
	
	/**
	 * 通过传入的map集合，分页查询支取申请信息
	 * @param page
	 * @param paramMap
	 * @return
	 */
	public void find(Page<ApplyDraw> page,Map<String, Object> paramMap);
	/**
	 * 通过传入的map集合，查询支取申请信息
	 */
	public List<ApplyDraw> queryApplyDraw(Map<String, Object> paramMap);
	/**
	 * 根据bm获取支取审核意见 
	 * @param bm
	 * @return
	 */
	public ApplyDraw getOpinionByBm(String bm);
	/**
	 * 支取初审-通过 
	 * @param paramMap
	 * @return
	 */
	public int execute(Map<String, String> paramMap);
	
	
	/**
	 * 通过传入的map集合，分页查询支取记录信息
	 * @param page
	 * @param paramMap
	 * @return
	 */
	public void findDrawForRe(Page<ShareAD> page,Map<String, Object> paramMap);
	/**
	 * 通过传入的map集合，查询支取记录信息
	 */
	public List<ShareAD> OpenQryDrawForRe(Map<String, Object> paramMap);
	/**
	 * 支取初审-返回支取申请
	 * @param paramMap
	 * @return
	 */
	public int  returnCheckAD1(Map<String, String> paramMap);
}

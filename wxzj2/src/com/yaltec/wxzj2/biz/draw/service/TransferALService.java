package com.yaltec.wxzj2.biz.draw.service;

import java.util.List;
import java.util.Map;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.draw.entity.ApplyLogout;

/**
 * 
 * @ClassName: TransferALService
 * @Description: TODO销户划拨Service接口
 * 
 * @author yangshanping
 * @date 2016-8-10 下午03:09:13
 */
public interface TransferALService {
	/**
	 * 通过传入的map集合，分页查询销户划拨信息
	 * @param page
	 * @param paramMap
	 * @return
	 */
	public void find(Page<ApplyLogout> page,Map<String, Object> paramMap);
	/**
	 * 通过传入的map集合，查询销户划拨信息
	 */
	public List<ApplyLogout> queryTransferAL(Map<String, Object> paramMap);
	/**
	 * 结算利息,并返回数据(销户划拨)
	 */
	public List<ApplyLogout> queryTransferAL_LXJS(Map<String, Object> paramMap);
	/**
	 * 返回审核
	 */
	public String returnReviewAL(Map<String, String> paramMap);
	/**
	 * 划拨入账
	 */
	public int saveTransferAL(Map<String, Object> paramMap);
	/**
	 * 销户划拨保存前检查(销户日期不能小于该房屋最后一笔的交款日期)
	 */
	public String checkForsaveTransferAL(Map<String, Object> paramMap);
	
}

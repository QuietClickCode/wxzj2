package com.yaltec.wxzj2.biz.voucher.service;

import java.util.List;
import java.util.Map;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.voucher.entity.ReviewCertificate;

/**
 * 
 * @ClassName: CancelAuditService
 * @Description: 撤销审核Service接口
 * 
 * @author yangshanping
 * @date 2016-9-12 下午02:51:29
 */
public interface CancelAuditService {

	/**
	 * 通过传入的map集合，分页查询撤销审核信息
	 * @param page
	 * @param paramMap
	 * @return
	 */
	public void find(Page<ReviewCertificate> page,Map<String, Object> paramMap);
	/**
	 * 通过传入的map集合，查询撤销审核信息
	 */
	public List<ReviewCertificate> queryReviewCertificate(Map<String, Object> paramMap);
	/**
	 * 修改银行
	 * @param paramMap
	 * @return
	 */
	public int updateBank(Map<String, String> paramMap);
	/**
	 * 修改银行时检查是否有记录
	 * @param paramMap
	 * @return
	 */
	public String IsThereRecord(String str);
	/**
	 * 撤销审核时检查是否有记录
	 * @param paramMap
	 * @return
	 */
	public String IsRecord(String str);
	/**
	 * 凭证审核_撤消审核_撤消审核
	 * @param map
	 */
	public void cancelAudit(String[] p004s, String[] p005s) throws Exception;
	
}

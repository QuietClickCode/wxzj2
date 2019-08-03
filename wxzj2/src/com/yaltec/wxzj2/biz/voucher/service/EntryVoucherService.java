package com.yaltec.wxzj2.biz.voucher.service;

import java.util.List;
import java.util.Map;

import com.yaltec.wxzj2.biz.voucher.entity.ReviewCertificate;

/**
 * <p>
 * ClassName: EntryVoucherService
 * </p>
 * <p>
 * Description: 凭证录入服务接口
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author jiangyong
 * @date 2016-8-24 下午05:35:39
 */
public interface EntryVoucherService {

	/**
	 * 查询凭证录入列表
	 * 
	 * @param page
	 */
	public List<ReviewCertificate> findAll(Map<String, Object> map);

	/**
	 * 添加凭证录入信息
	 * 
	 * @param map
	 */
	public int add(Map<String, Object> map) throws Exception;

	/**
	 * 批量删除凭证信息
	 * 
	 * @param list
	 * @return
	 */
	public int batchDelete(List<String> list);

	/**
	 * 删除凭证信息
	 * 
	 * @param list
	 * @return
	 */
	public int delete(String poo4);
}

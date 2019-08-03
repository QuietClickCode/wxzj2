package com.yaltec.wxzj2.biz.voucher.service;

import java.util.List;
import java.util.Map;

import com.yaltec.wxzj2.biz.voucher.entity.QueryVoucherCheck;
import com.yaltec.wxzj2.biz.voucher.entity.VoucherAnnex;
import com.yaltec.wxzj2.biz.voucher.entity.VoucherCheck;

/**
 * <p>
 * ClassName: VoucherCheck
 * </p>
 * <p>
 * Description: 凭证审核服务接口
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author jiangyong
 * @date 2016-8-26 下午02:09:56
 */
public interface VoucherCheckService {

	/**
	 * 根据凭证编号获取凭证信息(未审核或已审核)
	 * 
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<VoucherCheck> get(Map<String, Object> map) throws Exception;

	/**
	 * 凭证审核查询（已审和未审）
	 * 
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<QueryVoucherCheck> findAll(Map<String, Object> map) throws Exception;

	/**
	 * 审核凭证
	 * 
	 * @param map
	 */
	public void save(Map<String, Object> map);

	/**
	 * 获取审核日期
	 * 
	 * @return
	 */
	public String getCheckDate();

	/**
	 * 获取起息日期
	 * 
	 * @param p004
	 * @return
	 */
	public String getInterestDate(String p004);

	/**
	 * 查询凭证附件(包括当年和历史)
	 * 
	 * @param map
	 * @return
	 */
	public List<VoucherAnnex> findVoucherAnnex(Map<String, Object> map);

	/**
	 * 根据业务编号获取凭证摘要
	 * 
	 * @param map
	 * @return
	 */
	public String GetSummaryByP004(Map<String, Object> map);
}

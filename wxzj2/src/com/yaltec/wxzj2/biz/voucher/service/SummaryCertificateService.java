package com.yaltec.wxzj2.biz.voucher.service;
import java.util.List;
import java.util.Map;
import com.yaltec.wxzj2.biz.voucher.entity.SummaryCertificate;

/**
 * <p>
 * ClassName: SummaryCertificateService
 * </p>
 * <p>
 * Description: 凭证汇总服务接口
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author moqian
 * @date 2016-9-5 下午14:02:39
 */
public interface SummaryCertificateService {

	/**
	 * 查询凭证汇总列表
	 * 
	 * @param page
	 */
	public List<SummaryCertificate> findAll(Map<String, Object> map);
	
	/**
	 * 查询凭证汇总列表
	 */
	public List<SummaryCertificate> findSummaryCertificate(Map<String, Object> map);

}

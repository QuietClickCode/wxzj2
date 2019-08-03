package com.yaltec.wxzj2.biz.voucher.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.voucher.entity.ReviewCertificate;

/**
 * 
 * @ClassName: CancelAuditDao
 * @Description: 撤销审核Dao接口
 * 
 * @author yangshanping
 * @date 2016-9-12 下午02:53:47
 */
@Repository
public interface CancelAuditDao {

	public void find(Page<ReviewCertificate> page,Map<String, Object> paramMap);
	
	public List<ReviewCertificate> queryReviewCertificate(Map<String, Object> paramMap);
	
	public int updateBank(Map<String, String> paramMap);
	
	public String IsThereRecord(String str);
	
	public String IsRecord(String str);
	
	public void cancelAudit(Map<String, String> map);
}

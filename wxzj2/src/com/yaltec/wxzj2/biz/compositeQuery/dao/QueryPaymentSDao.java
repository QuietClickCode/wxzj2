package com.yaltec.wxzj2.biz.compositeQuery.dao;

import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Repository;
import com.yaltec.wxzj2.biz.compositeQuery.entity.QueryPaymentS;

@Repository
public interface QueryPaymentSDao {
	
	public List<QueryPaymentS> queryQueryPaymentS(Map<String, Object> paramMap);
	
	public List<QueryPaymentS> findQueryPaymentS(Map<String, Object> paraMap);

}

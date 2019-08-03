package com.yaltec.wxzj2.biz.compositeQuery.dao;

import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Repository;
import com.yaltec.wxzj2.biz.payment.entity.UnitToPrepay;

@Repository
public interface QueryUnitToPrepayDao {
	
	public List<UnitToPrepay> queryQryUnitToPrepay(Map<String, Object> paramMap);
	
	public List<UnitToPrepay> findUnitToPrepay(Map<String, String> paramMap);

}

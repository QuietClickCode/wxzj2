package com.yaltec.wxzj2.biz.compositeQuery.dao;

import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Repository;
import com.yaltec.wxzj2.biz.compositeQuery.entity.ByProjectBPS;
import com.yaltec.wxzj2.biz.property.entity.House;

@Repository
public interface ByProjectBPSDao {
	
	public List<ByProjectBPS> queryByProjectBPS(Map<String, Object> paramMap);

	public List<ByProjectBPS> findProjectBPS(Map<String, String> paramMap);
}

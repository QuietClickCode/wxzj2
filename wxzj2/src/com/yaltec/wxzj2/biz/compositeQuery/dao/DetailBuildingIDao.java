package com.yaltec.wxzj2.biz.compositeQuery.dao;

import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Repository;
import com.yaltec.wxzj2.biz.compositeQuery.entity.DetailBuildingI;

@Repository
public interface DetailBuildingIDao {
	
	public List<DetailBuildingI> queryDetailBuildingI(Map<String, Object> paramMap);
	
	public List<DetailBuildingI> findDetailBuildingI(Map<String, Object> paraMap);
		
}

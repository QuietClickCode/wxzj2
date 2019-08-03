package com.yaltec.wxzj2.biz.compositeQuery.dao;

import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Repository;
import com.yaltec.wxzj2.biz.compositeQuery.entity.WxzjInfoTj;

@Repository
public interface QueryWxzjInfoTjDao {
	
	public List<WxzjInfoTj> QueryWxzjInfoTj(Map<String, Object> paramMap);

	public List<WxzjInfoTj> findWxzjInfoTj(Map<String, Object> map);
}

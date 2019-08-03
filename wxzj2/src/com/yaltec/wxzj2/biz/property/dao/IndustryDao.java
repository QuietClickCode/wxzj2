package com.yaltec.wxzj2.biz.property.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;
import com.yaltec.wxzj2.biz.property.entity.Industry;

/**
 * 
 * @ClassName: IndustryDao
 * @Description: TODO业委会dao接口
 * 
 * @author yangshanping
 * @date 2016-7-20 下午04:59:51
 */
@Repository
public interface IndustryDao {
	
	public List<Industry> findAll(Industry industry);
	
	public Industry findByBm(Industry industry);
	
	public Industry find(Industry industry);
	
	public void save(Map<String, String> map);
	
	public void update(Map<String, String> map);
	
	public int delIndustry(Map<String,String> paramMap);
	
	public String IsYWHOnXQ(Map<String,String> paramMap);
	
}

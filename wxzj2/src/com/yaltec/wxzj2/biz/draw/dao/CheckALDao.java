package com.yaltec.wxzj2.biz.draw.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.draw.entity.ApplyLogout;

/**
 * 
 * @ClassName: CheckALDao
 * @Description: TODO销户初审Dao接口
 * 
 * @author yangshanping
 * @date 2016-8-9 下午03:37:35
 */
@Repository
public interface CheckALDao {
	
	public void find(Page<ApplyLogout> page,Map<String, Object> paramMap);
	
	public List<ApplyLogout> queryApplyLogout(Map<String, Object> paramMap);
	
	public List<ApplyLogout> queryApplyLogoutJ(Map<String, Object> paramMap);
	
	public String updtApplyLogout(Map<String, String> paramMap);
	
	public String returnReviewAL(Map<String, String> paramMap);
}

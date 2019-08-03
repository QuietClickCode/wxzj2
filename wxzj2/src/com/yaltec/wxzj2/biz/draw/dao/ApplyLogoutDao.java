package com.yaltec.wxzj2.biz.draw.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.draw.entity.ApplyLogout;

/**
 * 
 * @ClassName: ApplyLogoutDao
 * @Description: TODO销户申请Dao接口
 * 
 * @author yangshanping
 * @date 2016-8-8 上午10:46:07
 */
@Repository
public interface ApplyLogoutDao {

	public void find(Page<ApplyLogout> page,Map<String, Object> paramMap);
	
	public List<ApplyLogout> queryApplyLogout(Map<String, Object> paramMap);
	
	public List<ApplyLogout> queryApplyLogoutJ(Map<String, Object> paramMap);
	
	public int saveApplyLogout(Map<String, String> paramMap);
	
	public String updtApplyLogout(Map<String, String> paramMap);
	
	public int delApplyLogout(Map<String, String> paramMap);
}

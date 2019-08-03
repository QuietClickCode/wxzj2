package com.yaltec.wxzj2.biz.draw.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.draw.entity.ApplyLogout;

/**
 * 
 * @ClassName: TransferALDao
 * @Description: TODO销户划拨Dao接口
 * 
 * @author yangshanping
 * @date 2016-8-10 下午03:08:58
 */
@Repository
public interface TransferALDao {

	public void find(Page<ApplyLogout> page,Map<String, Object> paramMap);
	
	public List<ApplyLogout> queryTransferAL(Map<String, Object> paramMap);
	
	public List<ApplyLogout> queryTransferAL_LXJS(Map<String, Object> paramMap);
	
	public String returnReviewAL(Map<String, String> paramMap);
	
	public int saveTransferAL(Map<String, Object> paramMap);
	
	public String checkForsaveTransferAL(Map<String, Object> paramMap);
	
}

package com.yaltec.wxzj2.biz.draw.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.yaltec.wxzj2.biz.draw.entity.CodeName;
import com.yaltec.wxzj2.biz.draw.entity.ShareAD;
import com.yaltec.wxzj2.biz.property.entity.Developer;

/**
 * 
 * @ClassName: BatchRefundDao
 * @Description: 批量退款Dao接口
 * 
 * @author yangshanping
 * @date 2016-8-23 下午02:46:48
 */
@Repository
public interface BatchRefundDao {
	
	public List<CodeName> queryShareAD_LY2(Map<String, String> parasMap);
	
	public List<CodeName> queryShareAD_LY(Map<String, String> parasMap);
	
	public List<CodeName> queryShareAD_DY(String lybh);
	
	public List<CodeName> queryShareAD_LC(Map<String, String> parasMap);
	
	public List<CodeName> queryShareAD_FW(Map<String, String> parasMap);
	
	public void saveRefund_PL(Map<String, String> parasMap);

	public Developer getDeveloperBylybh(String lybh);
	
	public List<ShareAD> QryExportShareAD(Map<String, String> parasMap);
}

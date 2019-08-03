package com.yaltec.wxzj2.biz.draw.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.yaltec.wxzj2.biz.draw.entity.CodeName;
import com.yaltec.wxzj2.biz.draw.entity.ShareAD;

/**
 * 
 * @ClassName: PreSplitDao
 * @Description: 支取预分摊Dao接口
 * 
 * @author yangshanping
 * @date 2016-9-9 上午11:36:09
 */
@Repository
public interface PreSplitDao {

	public List<ShareAD> ExportFtFwInfo(String strsql);
	
	public String queryIsTL();
	
	public List<CodeName> QryExportShareADLYB(Map<String, String> map);
	
	public List<ShareAD> QryExportShareAD2(Map<String, String> map);
	
	public List<ShareAD> QryExportShareAD3(Map<String, String> map);
}

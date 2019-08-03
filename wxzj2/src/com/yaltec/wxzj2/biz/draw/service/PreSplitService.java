package com.yaltec.wxzj2.biz.draw.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.yaltec.wxzj2.biz.draw.entity.CodeName;
import com.yaltec.wxzj2.biz.draw.entity.ShareAD;

/**
 * 
 * @ClassName: PreSplitService
 * @Description: 支取预分摊Service接口
 * 
 * @author yangshanping
 * @date 2016-9-9 上午11:33:43
 */
public interface PreSplitService {

	/**
	 * 导出要进行分摊的房屋明细信息 
	 * @param map
	 * @return
	 */
	public List<ShareAD> ExportFtFwInfo(String strsql);
	/**
	 * 查询是否是铜梁
	 * @return
	 */
	public String queryIsTL();
	/**
	 * 获取支取分摊相关的楼宇 By 申请编号
	 * @param map
	 * @return
	 */
	public List<CodeName> QryExportShareADLYB(Map<String, String> map);
	
	public List<ShareAD> QryExportShareAD2(Map<String, String> map);
	
	public List<ShareAD> QryExportShareAD3(Map<String, String> map);
}

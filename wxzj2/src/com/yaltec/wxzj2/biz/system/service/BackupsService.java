package com.yaltec.wxzj2.biz.system.service;



/**
 * <p>ClassName: BackupsService</p>
 * <p>Description: 中心数据管理-数据备份服务接口(这里用一句话描述这个类的作用)</p>
 * <p>Company: YALTEC</p> 
 * @author jiangyong
 * @date 2016-9-27 下午02:35:57
 */
public interface BackupsService {
	
	/**
	 * 查询数据备份信息详情
	 * @param 
	 * @return
	 */
	public void backupDB(String path, String compression);
	
	
}

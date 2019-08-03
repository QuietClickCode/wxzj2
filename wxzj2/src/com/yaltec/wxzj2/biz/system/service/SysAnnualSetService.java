package com.yaltec.wxzj2.biz.system.service;

import java.util.Map;

import com.yaltec.wxzj2.biz.system.entity.SysAnnualSet;


/**
 * <p>ClassName: SysAnnualSetService</p>
 * <p>Description: 系统年度设置服务接口(这里用一句话描述这个类的作用)</p>
 * <p>Company: YALTEC</p> 
 * @author jiangyong
 * @date 2016-7-19 下午02:35:57
 */
public interface SysAnnualSetService {
	
	/**
	 * 查询系统年度设置信息详情
	 * @param 
	 * @return
	 */
	public SysAnnualSet find();
	
	public void update(Map<String, String> map);
}

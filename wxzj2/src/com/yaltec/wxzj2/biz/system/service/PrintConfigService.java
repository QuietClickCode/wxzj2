package com.yaltec.wxzj2.biz.system.service;

import java.util.List;
import java.util.Map;

import com.yaltec.wxzj2.biz.system.entity.ConfigPrint;
import com.yaltec.wxzj2.biz.system.entity.PrintSet;


/**
 * <p>ClassName: PrintConfigService</p>
 * <p>Description: 打印配置服务接口</p>
 * <p>Company: YALTEC</p> 
 * @author jiangyong
 * @date 2016-8-22 下午06:17:46
 */
public interface PrintConfigService {

	/**
	 * 获取所有的打印设置
	 * @return
	 */
	public List<ConfigPrint> findAll();
	
	/**
	 * 获取打印设置下的配置项
	 * @return
	 */
	public Map<String, PrintSet> get(String key);
}

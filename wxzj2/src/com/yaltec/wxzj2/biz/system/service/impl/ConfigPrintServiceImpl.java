package com.yaltec.wxzj2.biz.system.service.impl;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.yaltec.wxzj2.biz.system.dao.ConfigPrintDao;
import com.yaltec.wxzj2.biz.system.entity.ConfigPrint;
import com.yaltec.wxzj2.biz.system.service.ConfigPrintService;

/**
 * 打印参数service实现
 * 
 * @ClassName: ConfigPrintServiceImpl
 * @author 重庆亚亮科技有限公司 hqx
 * @date 2016-10-13 上午 10:41:37
 */
@Service
public class ConfigPrintServiceImpl implements ConfigPrintService {

	@Autowired
	private ConfigPrintDao configprintdao;
	
	public List<ConfigPrint> queryConfigPrintByModuleKey(String moduleKey){
		return configprintdao.queryConfigPrintByModuleKey(moduleKey);
	}
	
	/**
	 * 判断打印名称在数据库是否存在
	 */
	public String ifNameExists(Map<String, String> map){
		return configprintdao.ifNameExists(map);
	}
	
	/**
	 * 判断打印标识在数据库是否存在
	 */
	public String ifModuleKeyExists(Map<String, String> map){
		return configprintdao.ifModuleKeyExists(map);
	}
	
	/**
	 * 判断属性标识在数据库是否存在
	 */
	public String ifPropertyExists(Map<String, String> map){
		return configprintdao.ifPropertyExists(map);
	}
	
	/**
	 * 按moduleKey删除打印配置文件
	 */
	public void delConfigPrint(Map<String, Object> map){
		configprintdao.delConfigPrint(map);
	}
	
	/**
	 * 保存打印配置文件
	 */
	public void saveConfigPrint(Map<String, Object> map){
		configprintdao.saveConfigPrint(map);
	}
	
	
}




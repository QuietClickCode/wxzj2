package com.yaltec.wxzj2.comon.data.service;

import java.util.LinkedHashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import com.yaltec.wxzj2.biz.system.dao.ParameterDao;
import com.yaltec.wxzj2.biz.system.entity.Parameter;
import com.yaltec.wxzj2.comon.data.DataServie;

/**
 * <p>ClassName: ParameterDataService</p>
 * <p>Description: 系统参数数据服务类(这里用一句话描述这个类的作用)</p>
 * <p>Company: YALTEC</p> 
 * @author jiangyong
 * @date 2016-8-18 下午03:39:14
 */
public class ParameterDataService extends DataServie {

	/**
	 * 缓存唯一标识
	 */
	public static final String KEY = "parameter";
	
	/**
	 * 备注信息
	 */
	public static final String REMARK = "系统参数数据缓存"; 
	
	@Autowired
	private ParameterDao parameterDao;

	public ParameterDataService() {
		
		// 调用父类构造方法
		super(KEY, REMARK);
	}
	
	@Override
	public LinkedHashMap<String, String> init() {
		// 定义有序MAP集合
		LinkedHashMap<String, String> map = new LinkedHashMap<String, String>();
		
		// 查询数据
		List<Parameter> list = parameterDao.findAll();
		// 设置缓存数据条数
		super.setSize(list.size());
		for (Parameter parameter : list) {
			map.put(parameter.getBm(), parameter.getSf());
		}
		return map;
	}

}

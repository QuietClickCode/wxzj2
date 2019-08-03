package com.yaltec.wxzj2.comon.data.service;

import java.util.LinkedHashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import com.yaltec.wxzj2.biz.property.dao.PropertyCompanyDao;
import com.yaltec.wxzj2.biz.property.entity.PropertyCompany;
import com.yaltec.wxzj2.comon.data.DataServie;

/**
 * <p>ClassName: PropertyCompanyDataService</p>
 * <p>Description: 物业公司数据服务类(这里用一句话描述这个类的作用)</p>
 * <p>Company: YALTEC</p> 
 * @author jiangyong
 * @date 2016-7-29 下午03:39:14
 */
public class PropertyCompanyDataService extends DataServie {

	/**
	 * 缓存唯一标识
	 */
	public static final String KEY = "propertycompany";
	
	/**
	 * 备注信息
	 */
	public static final String REMARK = "物业公司数据缓存"; 
	
	@Autowired
	private PropertyCompanyDao propertyCompanyDao;

	public PropertyCompanyDataService() {
		
		// 调用父类构造方法
		super(KEY, REMARK);
	}
	
	@Override
	public LinkedHashMap<String, String> init() {
		// 定义有序MAP集合
		LinkedHashMap<String, String> map = new LinkedHashMap<String, String>();
		map.put("", "请选择");
		// 查询数据
		List<PropertyCompany> list = propertyCompanyDao.findAll(new PropertyCompany());
		// 设置缓存数据条数
		super.setSize(list.size());
		for (PropertyCompany propertyCompany : list) {
			map.put(propertyCompany.getBm(), propertyCompany.getMc());
		}
		return map;
	}

}

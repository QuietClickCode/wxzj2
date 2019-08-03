package com.yaltec.wxzj2.biz.property.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.github.pagehelper.PageHelper;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.comon.service.IdUtilService;
import com.yaltec.wxzj2.biz.property.dao.PropertyCompanyDao;
import com.yaltec.wxzj2.biz.property.entity.PropertyCompany;
import com.yaltec.wxzj2.biz.property.service.PropertyCompanyService;
import com.yaltec.wxzj2.comon.data.DataHolder;
import com.yaltec.wxzj2.comon.data.service.PropertyCompanyDataService;

@Service
public class PropertyCompanyServiceImpl implements PropertyCompanyService {
	
	@Autowired
	private PropertyCompanyDao propertyCompanyDao;
	
	@Autowired
	private IdUtilService idUtilService;
	
	@Override
	public void findAll(Page<PropertyCompany> page) {
		PageHelper.startPage(page.getPageNo(), page.getPageSize());
		List<PropertyCompany> list = propertyCompanyDao.findAll(page.getQuery());
		page.setData(list);
	}
	
	public PropertyCompany findByBm(PropertyCompany propertyCom){
		return propertyCompanyDao.findByBm(propertyCom);
	}
	
	public PropertyCompany find(PropertyCompany propertyCom){
		return propertyCompanyDao.find(propertyCom);
	}
	
	public void save(Map<String, String> map){
		try {
			// 获取当前数据库表可用BM
			String bm = idUtilService.getNextBm("PropertyCompany");
			map.put("bm",bm);
			propertyCompanyDao.save(map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}
	
	public void update(Map<String, String> map){
		propertyCompanyDao.save(map);
	}
	
	
	public int delete(Map<String, String> paramMap) {
		return propertyCompanyDao.delPropertyCompany(paramMap);
	}
	
	public int delPropertyCompany(Map<String, String> paramMap) throws Exception {
		int result = -1;
		String bms = paramMap.get("bm");
		String[] paras = bms.split(",");
		// 删除数据
		for (String bm : paras) {
			paramMap.put("bm", bm);
			propertyCompanyDao.delPropertyCompany(paramMap);
			result = Integer.valueOf(paramMap.get("result"));
			if (result == 0) {
				DataHolder.updateDataMap(PropertyCompanyDataService.KEY, bm);
			}
			if (result == 1) {
				throw new Exception("删除失败，该物业公司信息已启用！");
			} else if (result != 0) {
				throw new Exception("删除失败！");
			}
		}
		return result;
	}

	public String checkForSave(Map<String, String> map) {
		return propertyCompanyDao.checkForSave(map);
	}
		
	
}

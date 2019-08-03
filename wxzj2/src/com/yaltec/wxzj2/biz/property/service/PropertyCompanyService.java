package com.yaltec.wxzj2.biz.property.service;


import java.util.Map;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.property.entity.PropertyCompany;

/**
 * 
 * @ClassName: PropertyCompanyService
 * @Description: TODO物业公司service接口
 * 
 * @author yangshanping
 * @date 2016-7-18 上午10:24:46
 */
public interface PropertyCompanyService {

	/**
	 * 翻页查询物业公司信息列表
	 * 
	 * @param page
	 * @return
	 */
	public void findAll(Page<PropertyCompany> page);

	/**
	 * 根据编码bm查询物业公司信息
	 * 
	 * @param propertyCom
	 * @return
	 */
	public PropertyCompany findByBm(PropertyCompany propertyCom);
	/**
	 * 查找物业公司表中最大的bm
	 * @return
	 */
	public PropertyCompany find(PropertyCompany propertyCom);
	/**
	 * 保存物业公司信息
	 * 
	 * @param map
	 * @return
	 */
	public void save(Map<String, String> map);

	/**
	 * 修改物业公司信息
	 * 
	 * @param propertyCom
	 * @return
	 */
	public void update(Map<String, String> map);

	/**
	 * 批量删除物业公司信息
	 * 
	 * @param 
	 * @return
	 */
	public int delPropertyCompany(Map<String, String> paramMap) throws Exception;
	
	/**
	 * 通过bm删除信息详情
	 * @param bm
	 * @return
	 */
	public int delete(Map<String, String> paramMap);

	/**
	 * 添加物业公司时，检查是否已存在
	 * @param map
	 * @return
	 */
	public String checkForSave(Map<String, String> map);
}

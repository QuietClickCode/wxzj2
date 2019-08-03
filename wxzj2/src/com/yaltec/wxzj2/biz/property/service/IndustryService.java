package com.yaltec.wxzj2.biz.property.service;

import java.util.Map;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.property.entity.Industry;

/**
 * 
 * @ClassName: IndustryService
 * @Description: TODO业委会service接口
 * 
 * @author yangshanping
 * @date 2016-7-20 下午04:52:25
 */
public interface IndustryService {

	/**
	 * 翻页查询业委会信息列表
	 * 
	 * @param page
	 * @return
	 */
	public void findAll(Page<Industry> page);

	/**
	 * 根据编码bm查询业委会信息
	 * 
	 * @param industry
	 * @return
	 */
	public Industry findByBm(Industry industry);
	/**
	 * 查找业委会表中最大的bm
	 * @return
	 */
	public Industry find(Industry industry);
	/**
	 * 保存业委会信息
	 * 
	 * @param industry
	 * @return
	 */
	public void save(Map<String, String> map);

	/**
	 * 修改业委会信息
	 * 
	 * @param industry
	 * @return
	 */
	public void update(Map<String, String> map);

	/**
	 * 删除业委会信息
	 * 
	 * @param 
	 * @return
	 */
	public int delIndustry(Map<String,String> paramMap) throws Exception;
	
	/**
	 * 判断业委会是否已存在
	 * @param paramMap
	 * @return
	 */
	public String IsYWHOnXQ(Map<String,String> paramMap);
	/**
	 * 通过bm删除信息详情
	 * @param bm
	 * @return
	 */
	public int delete(Map<String,String> paramMap);
}

package com.yaltec.wxzj2.biz.property.service;

import java.util.List;
import java.util.Map;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.draw.entity.CodeName;
import com.yaltec.wxzj2.biz.property.entity.Building;

/**
 * 
 * @ClassName: BuildingService
 * @Description: TODO楼宇service接口
 * 
 * @author yangshanping
 * @date 2016-7-22 下午05:20:46
 */
public interface BuildingService {

	/**
	 * 翻页查询楼宇信息列表
	 * 
	 * @param page
	 * @return
	 */
	public void findAll(Page<Building> page);

	/**
	 * 根据编码bm查询楼宇信息
	 * 
	 * @param building
	 * @return
	 */
	public Building findByLybh(Building building);
	/**
	 * 查找楼宇表中最大的bm
	 * @return
	 */
	public Building find(String xqbh);
	/**
	 * 根据楼宇名称lymc查询楼宇信息
	 * @return
	 */
	public Building findByLymc(String lymc);

	/**
	 * 获取楼宇编码
	 * @param map
	 */
	public String getBuildingBm(String xqbh);
	/**
	 * 保存楼宇信息
	 * 
	 * @param building
	 * @return
	 */
	public void save(Map<String, String> map);

	/**
	 * 修改楼宇信息
	 * 
	 * @param building
	 * @return
	 */
	public void update(Map<String, String> map);

	/**
	 * 批量删除楼宇信息
	 * @param
	 * @return
	 */
	public int delBuilding(Map<String, String> paramMap) throws Exception;

	/**
	 * 通过bm删除信息详情
	 * @param bm
	 * @return
	 */
	public int delete(Map<String, String> paramMap);
	/**
	 * 根据楼宇编号获取房屋类型
	 */
	public String getFwlxByBuilding(String lybh);
	/**
	 * 根据楼宇编号获取楼宇地址
	 */
	public String getAddressForBuilding(String lybh);
	/**
	 * 根据开发公司获取小区信息
	 * @param kfgs
	 * @return
	 */
	public List<Building> findXqByKfgs(String kfgs);
	
	/**
	 * 根据小区编号获取业委会信息
	 */
	public List<CodeName> queryIndustryByXqbh(Map<String, String> map);
}

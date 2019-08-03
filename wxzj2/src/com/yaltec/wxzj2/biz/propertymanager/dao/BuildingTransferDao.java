package com.yaltec.wxzj2.biz.propertymanager.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.yaltec.wxzj2.biz.propertymanager.entity.BuildingTransfer;

@Repository
public interface BuildingTransferDao {
	
	/**
	 * 查询楼盘转移列表
	 * 
	 * @param query
	 * @return
	 */
	public List<BuildingTransfer> findAll(Map<String, Object> paramMap);
	
	/**
	 * 打印清册
	 * @param paramMap
	 * @return
	 */
	public List<BuildingTransfer> inventory(Map<String, String> paramMap);
	
	/**
	 * 保存整栋楼的楼盘转移
	 * @param map
	 */
	public void save(Map<String, String> map);
	
	/**
	 * 保存单个房屋或一些房屋的楼盘转移
	 * @param map
	 */
	public void saveh001(Map<String, String> map);
	
	/**
	 * 判断业务是否审核 
	 * @param map
	 * @return
	 */
	public String checkPZSFSH(Map<String, String> map);
	
	/**
	 * 删除楼盘转移信息
	 * @param map
	 * @return
	 */
	public void delBuildingTransfer(Map<String, String> map);
}


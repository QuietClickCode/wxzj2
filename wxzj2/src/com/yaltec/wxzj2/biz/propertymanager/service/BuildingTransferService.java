package com.yaltec.wxzj2.biz.propertymanager.service;

import java.io.ByteArrayOutputStream;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.propertymanager.entity.BuildingTransfer;

/**
 * 
 * @ClassName: BuildingTransferService
 * @Description: TODO楼盘转移service接口
 * 
 * @author hqx
 * @date 2016-8-25 上午09:39:19
 */
public interface BuildingTransferService {

	/**
	 * 翻页查询产权变更列表
	 * 
	 * @param page
	 * @return
	 */
	public void findAll(Page<BuildingTransfer> page, Map<String, Object> paramMap);

	/**
	 * 保存整栋楼的楼盘转移
	 * 
	 * @param map
	 */
	public Map<String, String> save(Map<String, String> map);

	/**
	 * 保存单个房屋或一些房屋的楼盘转移
	 * 
	 * @param map
	 */
	public int saveh001(Map<String, String> map);
	
	/**
	 * 判断业务是否审核 
	 * @param map
	 * @return
	 */
	public String checkPZSFSH(Map<String, String> map);

	/**
	 * 删除楼盘转移信息
	 * @param map
	 */
	public void delBuildingTransfer(Map<String, String> map);
	
	/**
	 * 打印清册
	 * @param paramMap
	 * @return
	 */ 
	public ByteArrayOutputStream inventory(Map<String, String> paramMap);
	
	/**
	 * 打印输出
	 * @param ops
	 * @param response
	 */
	public void output(ByteArrayOutputStream ops, HttpServletResponse response);
}

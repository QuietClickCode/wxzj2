package com.yaltec.wxzj2.biz.propertymanager.service;

import java.io.ByteArrayOutputStream;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.payment.entity.HousedwImport;
import com.yaltec.wxzj2.biz.propertymanager.entity.ChangeProperty;

/**
 * 
 * @ClassName: PropertyService
 * @Description: TODO产权变更service接口
 * 
 * @author hqx
 * @date 2016-8-25 上午09:39:19
 */
public interface PropertyService {

	/**
	 * 翻页查询产权变更列表
	 * 
	 * @param page
	 * @return
	 */
	public void change(Page<ChangeProperty> page, Map<String, Object> paramMap);

	/**
	 * 保存产权变更
	 * 
	 * @param map
	 */
	public int saveChangeProperty(Map<String, String> map);

	/**
	 * 保存变更编辑
	 * 
	 * @param map
	 */
	public int propertySave(Map<String, String> map);

	/**
	 * 打印输出
	 * 
	 * @param ops
	 * @param response
	 */
	public void output(ByteArrayOutputStream ops, HttpServletResponse response);

	/**
	 * 打印
	 * 
	 * @param paramMap
	 * @return
	 */
	public ByteArrayOutputStream toPrint(Map<String, String> paramMap);

	/**
	 * 打印清册
	 * 
	 * @param paramMap
	 * @return
	 */
	public ByteArrayOutputStream inventory(Map<String, String> paramMap);

	/**
	 * 删除票据接收信息
	 * 
	 * @param map
	 */
	public void delReceiveBill(Map<String, String> map);

	/**
	 * 获取单位房屋上报BS临时表最大tmepCode+1
	 */
	public String getMaxCodeHouse_dwBS();

	/**
	 * 插入单位房屋上报BS临时数据之前，清空当前用户的相关数据
	 * 
	 * @param map
	 */
	public void deleteHouse_dwBSByUserid(Map<String, Object> map);

	/**
	 * 保存变更批录
	 * 
	 * @param paramMap
	 */
	public int saveChangeProperty_PL(Map<String, Object> paramMap);

	/**
	 * 导出变更查询信息
	 * 
	 * @param map
	 * @return
	 */
	public List<ChangeProperty> queryChangeProperty2(Map<String, String> map);

	/**
	 * 单位房屋批量上报数据合法，则写入数据库表
	 */
	public void insertHouseUnit(List<HousedwImport> list,
			Map<String, Object> map) throws Exception;

	/**
	 * 批量打印产权变更证明
	 * 
	 * @param map
	 * @return
	 */
	public List<ChangeProperty> printManyPdf(Map<String, String> map);
}

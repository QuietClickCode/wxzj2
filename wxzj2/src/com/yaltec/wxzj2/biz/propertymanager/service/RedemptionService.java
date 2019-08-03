package com.yaltec.wxzj2.biz.propertymanager.service;

import java.io.ByteArrayOutputStream;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.property.entity.House;
import com.yaltec.wxzj2.biz.propertymanager.entity.ChangeProperty;
import com.yaltec.wxzj2.biz.propertymanager.entity.Redemption;

/**
 * 
 * @ClassName: RedemptionService
 * @Description: TODO房屋换购service接口
 * 
 * @author hqx
 * @date 2016-8-25 上午09:11:19
 */
public interface RedemptionService {

	/**
	 * 翻页查询房屋换购列表
	 * 
	 * @param page
	 * @return
	 */
	public void findAll(Page<Redemption> page, Map<String, Object> paramMap);
	
	/**
	 * 检查换购日期不能小于原房屋交款日期
	 * @param paramMap
	 * @return
	 */
	public String checkForsaveRedemption(Map<String, String> map);
	
	/**
	 * 保存房屋换购信息
	 * @param map
	 * @return
	 */
	public int saveRedemption(Map<String, String> map);
	
	/**
	 * 删除房屋换购
	 * @param map
	 * @return
	 */
	public int delRedemption(Map<String, String> map);
	
	/**
	 * 打印输出
	 * @param ops
	 * @param response
	 */
	public void output(ByteArrayOutputStream ops, HttpServletResponse response);
	
	/**
	 * 打印清册
	 * @param paramMap
	 * @return
	 */
	public ByteArrayOutputStream inventory(Map<String, Object> paramMap);
	
	/**
	 * 打印
	 * @param w008
	 * @return
	 */
	public ByteArrayOutputStream pdfRedemption(Map<String, String> paramMap);
	
	/**
	 * 导出换购补交信息
	 * @param map
	 * @return
	 */
	public List<House> exportForHouseUnit(Map<String, String> map);
}	
package com.yaltec.wxzj2.biz.property.service;

import java.io.ByteArrayOutputStream;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.property.entity.House;

/**
 * 
 * @ClassName: HouseService
 * @Description: TODO房屋信息service接口
 * 
 * @author yangshanping
 * @date 2016-7-25 上午09:39:19
 */
public interface HouseService {

	/**
	 * 翻页查询房屋信息列表
	 * 
	 * @param page
	 * @return
	 */
	public void findAll(Page<House> page);

	/**
	 * 根据传入的map值，查询房屋信息
	 * 
	 * @param page
	 * @param paramMap
	 */
	public void find(Page<House> page, Map<String, Object> paramMap);

	/**
	 * 根据编码h001查询房屋信息
	 * 
	 * @param house
	 * @return
	 */
	public House findByH001(String h001);

	/**
	 * 根据编码h001查询房屋信息(用于票据打印)
	 * 
	 * @param house
	 * @return
	 */
	public House findByH001ForPDF(String h001);

	/**
	 * 根据楼宇名称查找房屋信息
	 * 
	 * @param lymc
	 * @return
	 */
	public House findByLybh(String lybh);

	/**
	 * 保存房屋信息
	 * 
	 * @param house
	 * @return
	 */
	public void save(Map<String, String> map);

	/**
	 * 修改房屋信息
	 * 
	 * @param house
	 * @return
	 */
	public String update(Map<String, String> map);

	/**
	 * 删除房屋信息之前判断改房屋是否已做业务
	 * 
	 * @param h001
	 * @return
	 */
	public int checkForDelHouse(String h001);

	/**
	 * 批量删除房屋信息
	 * 
	 * @param
	 * @return
	 */
	public int delHouse(Map<String, String> paramMap) throws Exception;

	/**
	 * 删除房屋信息
	 * 
	 * @param
	 * @return
	 */
	public int delete(Map<String, String> paramMap);

	/**
	 * 输出PDF
	 * 
	 * @param ops
	 * @param response
	 */
	public void output(ByteArrayOutputStream ops, HttpServletResponse response);

	/**
	 * 房屋编号为空，根据楼宇编号查询房屋信息(产权变更)
	 * 
	 * @param page
	 */
	public void changePropertyLybh(Page<House> page);

	/**
	 * 查询房屋信息-房屋编号不为空，根据房屋编号查询(产权变更)
	 * 
	 * @param page
	 */
	public void changePropertyH001(Page<House> page);
	
	/**
	 * 查询房屋信息-业主姓名不为空，根据业主姓名查询(产权变更)
	 * 
	 * @param page
	 */
	public void changePropertyH013(Page<House> page);

	/**
	 * 根据h001查询变更信息
	 * 
	 * @param h001
	 * @return
	 */
	public House changeProperty_h001(String h001);

	/**
	 * 获取产权变更打印的信息
	 * 
	 * @param h001
	 * @return
	 */
	public House pdfChangeProperty(String h001);

	/**
	 * 获取房屋信息编码
	 */
	public String getHouseBm(Map<String, String> map);

	/**
	 * 统计 （总房屋： 户， 总计建筑面积： 平方米， 总计应交资金： 元，总计本金： 元，总计利息：元）
	 */
	public House queryHouseInfoCount(Map<String, String> map);

	/**
	 * 根据编码h001查询房屋信息(获取房屋信息、楼宇和小区名称)
	 * 
	 * @param house
	 * @return
	 */
	public House getHouseByH001(String h001);

	/**
	 * 查询房屋信息列表
	 * 
	 * @param page
	 * @return
	 */
	public List<House> findForLogout(House house);

	/**
	 * 根据传入的map值，房屋快速查询
	 * 
	 * @param page
	 * @param paramMap
	 */
	public void findFast(Page<House> page, Map<String, Object> paramMap);

	/**
	 * 合计计算支取金额
	 */
	public int sumDraw();
}

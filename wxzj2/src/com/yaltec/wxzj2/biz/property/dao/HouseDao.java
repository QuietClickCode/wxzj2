package com.yaltec.wxzj2.biz.property.dao;

import java.io.ByteArrayOutputStream;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Repository;

import com.yaltec.wxzj2.biz.property.entity.House;

/**
 * 
 * @ClassName: HouseDao
 * @Description: 房屋dao接口
 * 
 * @author yangshanping
 * @date 2016-7-25 上午09:49:49
 */
@Repository
public interface HouseDao {

	public List<House> findAll(House house);

	public List<House> find(Map<String, Object> paramMap);
	
	public House findByH001(String h001);

	public House findByH001ForPDF(String h001);
	
	public House findByLybh(String lybh);

	public String save(Map<String, String> map);

	public String update(Map<String, String> map);

	public int checkForDelHouse(String h001);

	public int delHouse(Map<String, String> paramMap);

	public Map getPrintSet(String moduleKey);

	public void output(ByteArrayOutputStream ops, HttpServletResponse response);

	/**
	 * 房屋编号为空，根据楼宇编号查询房屋信息(产权变更)
	 * 
	 * @param house
	 * @return
	 */
	public List<House> changePropertyLybh(House house);

	/**
	 * 查询房屋信息-房屋编号不为空，根据房屋编号查询(产权变更)
	 * 
	 * @param house
	 * @return
	 */
	public List<House> changePropertyH001(House house);
	
	/**
	 * 查询房屋信息-业主姓名不为空，根据业主姓名查询(产权变更)
	 * 
	 * @param house
	 * @return
	 */
	public List<House> changePropertyH013(House house);
	

	public House changeProperty_h001(String h001);

	/**
	 * 获取产权变更打印的信息
	 * 
	 * @param h001
	 * @return
	 */
	public House pdfChangeProperty(String h001);
	
	public String getHouseBm(Map<String, String> map);
	
	public House queryHouseInfoCount(Map<String, String> map);
	
	public House getHouseByH001(String h001);

	public List<House> findForLogout(House house);
	
	public List<House> queryHouseUnit(Map<String, Object> parasMap);

	public int sumDraw();
	
}

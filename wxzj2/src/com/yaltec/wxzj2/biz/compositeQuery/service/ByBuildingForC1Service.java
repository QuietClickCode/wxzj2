package com.yaltec.wxzj2.biz.compositeQuery.service;

import java.io.ByteArrayOutputStream;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.compositeQuery.entity.ByBuildingForC1;
import com.yaltec.wxzj2.biz.property.entity.House;

/**
 * <p>ClassName: ByBuildingForC1Service</p>
 * <p>Description: 分户台账查询服务接口</p>
 * <p>Company: YALTEC</p> 
 * @author moqian
 * @date 2016-8-2 下午14:12:03
 */

public interface ByBuildingForC1Service {
	
	/**
	 * 翻页查询
	 * @param page
	 */	
	public void queryByBuildingForC1(Page<ByBuildingForC1> page,Map<String, Object> paramMap);
	
	/**
	 * 根据编码h001查询房屋信息
	 * @param house
	 * @return
	 */
	public House findByH001(String h001);
	
	/**
	 * 输出PDF
	 * @param ops
	 * @param response
	 */
	public void output(ByteArrayOutputStream ops,HttpServletResponse response);
	
	/**
	 * 打印查询resultList
	 */
	public List<ByBuildingForC1> queryByBuildingForC1(Map<String, Object> paramMap);
	
	/**
	 * 根据编码h001查询房屋信息打印物业专项维修资金缴存证明
	 */
	public House pdfPaymentProve(String h001);

}

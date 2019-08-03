package com.yaltec.wxzj2.biz.compositeQuery.service.Impl;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.compositeQuery.dao.ByBuildingForC1Dao;
import com.yaltec.wxzj2.biz.compositeQuery.entity.ByBuildingForC1;
import com.yaltec.wxzj2.biz.compositeQuery.service.ByBuildingForC1Service;
import com.yaltec.wxzj2.biz.property.entity.House;

/**
 * <p>
 * ClassName: ByBuildingForC1ServiceImpl
 * </p>
 * <p>
 * Description: 分户台账查询模块服务实现类
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author moqian
 * @date 2016-8-2 下午14:12:03
 */

@Service
public class ByBuildingForC1ServiceImpl implements ByBuildingForC1Service {
	
	@Autowired
	private ByBuildingForC1Dao byBuildingForC1Dao;
		
	/**
	 * 日志记录器.
	 */
	private static final Logger logger = Logger.getLogger("ByBuildingForC1Print");

	@Override	
	public void queryByBuildingForC1(Page<ByBuildingForC1> page, Map<String, Object> paramMap) {
		try {
			// 根据页面传入的map查询数据
			List<ByBuildingForC1> list = byBuildingForC1Dao.queryByBuildingForC1(paramMap);
			page.setDataByList(list, page.getPageNo(), page.getPageSize());
		} catch (Exception e) {
			e.printStackTrace();
		}				
	}
	
	 //根据编码h001查询房屋信息
	@Override
	public House findByH001(String h001) {
		return byBuildingForC1Dao.findByH001(h001);
	}
	
	//打印查询resultList
	
	@Override
	public List<ByBuildingForC1> queryByBuildingForC1(Map<String, Object> paramMap){
		return byBuildingForC1Dao.queryByBuildingForC1(paramMap);
	}

	// 输出PDF
	@Override
	public void output(ByteArrayOutputStream ops,HttpServletResponse response) {
		response.setContentType("application/pdf");

		response.setHeader("Cache-Control", "must-revalidate, post-check=0, pre-check=0");
		response.setHeader("Pragma", "public");
		response.setDateHeader("Expires", (System.currentTimeMillis() + 1000));

		response.setContentLength(ops.size());
		ServletOutputStream out = null;
		try {
			out = response.getOutputStream();
			ops.writeTo(out);
		} catch (IOException e) {
			logger.error(e.getMessage());
		} finally {
			try {
				out.flush();
				out.close();
			} catch (IOException e) {
				logger.error(e.getMessage());
			}
		}
	}
	
	 //根据编码h001查询房屋信息打印物业专项维修资金缴存证明
	@Override
	public House pdfPaymentProve(String h001) {
		return byBuildingForC1Dao.pdfPaymentProve(h001);
	}
	
}

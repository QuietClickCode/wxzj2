package com.yaltec.wxzj2.biz.draw.service.impl;

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
import com.yaltec.wxzj2.biz.draw.dao.QueryALDao;
import com.yaltec.wxzj2.biz.draw.entity.QueryAL;
import com.yaltec.wxzj2.biz.draw.entity.QueryAL1;
import com.yaltec.wxzj2.biz.draw.service.QueryALService;

/**
 * 
 * @ClassName: QueryALServiceImpl
 * @Description: 支取情况查询service接口实现类
 * 
 * @author
 * @date 2016-8-19 下午02:53:01
 */
@Service
public class QueryALServiceImpl implements QueryALService{

	@Autowired
	private QueryALDao queryALDao;
	/**
	 * 日志记录器.
	 */
	private static final Logger logger = Logger.getLogger("QueryALPrint");

	public void find(Page<QueryAL> page,Map<String, Object> paramMap){
		List<QueryAL> resultList = null;
		String cxlb=paramMap.get("cxlb").toString();
		paramMap.put("cxlb", (Integer.valueOf(cxlb) + 9));
		try {
			if (cxlb.equals("10")) {// 全部显示
				resultList = queryALDao.queryQueryAL1_1(paramMap);
			} else {
				resultList = queryALDao.queryQueryAL1_2(paramMap);
			}
			page.setDataByList(resultList, page.getPageNo(), page.getPageSize());
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public List<QueryAL> queryQueryAL1_1(Map<String, Object> paramMap) {
		return queryALDao.queryQueryAL1_1(paramMap);
	}

	public List<QueryAL> queryQueryAL1_2(Map<String, Object> paramMap) {
		return queryALDao.queryQueryAL1_2(paramMap);
	}
	
	
	// 输出PDF
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
	
	public List<QueryAL1> queryQueryAL4_PrintPDF(Map<String, String> paramMap){
		return queryALDao.queryQueryAL4_PrintPDF(paramMap);
	}
	
	public void findQueryAL1(Page<QueryAL1> page,Map<String, Object> paramMap){
		List<QueryAL1> resultList = null;
		paramMap.put("result","0");
		try {
			resultList = queryALDao.queryQueryAL4(paramMap);
			page.setDataByList(resultList, page.getPageNo(), page.getPageSize());
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public List<QueryAL1> queryQueryAL4(Map<String, Object> paramMap){
		return queryALDao.queryQueryAL4(paramMap);
	}
}

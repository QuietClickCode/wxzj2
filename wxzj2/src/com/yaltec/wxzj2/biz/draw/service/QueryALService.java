package com.yaltec.wxzj2.biz.draw.service;

import java.io.ByteArrayOutputStream;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.draw.entity.QueryAL;
import com.yaltec.wxzj2.biz.draw.entity.QueryAL1;

/**
 * 
 * @ClassName: QueryALService
 * @Description: 支取情况查询service接口
 * 
 * @author yangshanping
 * @date 2016-8-19 下午02:48:38
 */
public interface QueryALService {
	/**
	 * 通过传入的map集合，分页查询销户信息
	 */
	public void find(Page<QueryAL> page,Map<String, Object> paramMap);
	/**
	 * 销户查询（模糊查询-全部显示 )
	 */
	public List<QueryAL> queryQueryAL1_1(Map<String, Object> paramMap);
	/**
	 * 销户查询（模糊查询）
	 */
	public List<QueryAL> queryQueryAL1_2(Map<String, Object> paramMap);
	/**
	 * 通过传入的map集合，分页查询销户明细信息
	 * @param page
	 * @param paramMap
	 */
	public void findQueryAL1(Page<QueryAL1> page,Map<String, Object> paramMap);
	/**
	 * 销户查询（明细查询）
	 */
	public List<QueryAL1> queryQueryAL4(Map<String, Object> paramMap);
	/**
	 * 输出PDF
	 * @param ops
	 * @param response
	 */
	public void output(ByteArrayOutputStream ops,HttpServletResponse response);
	/**
	 * 打印销户查询（模糊查询）
	 * @param paramMap
	 * @return
	 */
	public List<QueryAL1> queryQueryAL4_PrintPDF(Map<String, String> paramMap);
}

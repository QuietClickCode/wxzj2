package com.yaltec.wxzj2.biz.draw.dao;

import java.io.ByteArrayOutputStream;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Repository;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.draw.entity.QueryAL;
import com.yaltec.wxzj2.biz.draw.entity.QueryAL1;

/**
 * 
 * @ClassName: QueryALDao
 * @Description: 支取情况查询(模糊查询、申请编号、经办人)DAO接口
 *  
 * @author yangshanping
 * @date 2016-8-19 下午02:41:19
 */
@Repository
public interface QueryALDao {
	
	public void find(Page<QueryAL> page,Map<String, Object> paramMap);

	public List<QueryAL> queryQueryAL1_1(Map<String, Object> paramMap);
	
	public List<QueryAL> queryQueryAL1_2(Map<String, Object> paramMap);
	
	public void output(ByteArrayOutputStream ops,HttpServletResponse response);
	
	public void findQueryAL1(Page<QueryAL1> page,Map<String, Object> paramMap);
	
	public List<QueryAL1> queryQueryAL4_PrintPDF(Map<String, String> paramMap);
	
	public List<QueryAL1> queryQueryAL4(Map<String, Object> paramMap);
}

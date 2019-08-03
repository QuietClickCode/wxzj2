package com.yaltec.wxzj2.biz.compositeQuery.service;

import java.io.ByteArrayOutputStream;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.compositeQuery.entity.ByCommunityForB;
import com.yaltec.wxzj2.biz.compositeQuery.entity.ByProjectForB;

/**
 * <p>ClassName: ByProjectForBService</p>
 * <p>Description: 项目余额查询服务接口</p>
 * <p>Company: YALTEC</p> 
 * @author moqian
 * @date 2016-8-19 下午13:12:03
 */

public interface ByProjectForBService {	
	/**
	 * 翻页查询所有项目余额信息
	 * 
	 * @param page
	 */	
	public void queryByProjectForB(Page<ByCommunityForB> page,Map<String, Object> paramMap);
	
	/**
	 * 查询项目余额信息
	 * @param paramMap
	 * @return
	 */
	public List<ByProjectForB> findByProjectForB(Map<String, Object> paramMap);
	
	/**
	 * 输出PDF
	 * @param ops
	 * @param response
	 */
	public void output(ByteArrayOutputStream ops,HttpServletResponse response);

}

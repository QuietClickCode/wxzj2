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
import com.yaltec.wxzj2.biz.compositeQuery.dao.ByProjectForBDao;
import com.yaltec.wxzj2.biz.compositeQuery.entity.ByCommunityForB;
import com.yaltec.wxzj2.biz.compositeQuery.entity.ByProjectForB;
import com.yaltec.wxzj2.biz.compositeQuery.service.ByProjectForBService;

/**
 * <p>
 * ClassName: ByProjectForBServiceImpl
 * </p>
 * <p>
 * Description: 项目余额查询模块服务实现类
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author moqian
 * @date 2016-8-19 下午13:12:03
 */

@Service
public class ByProjectForBServiceImpl implements ByProjectForBService {
	
	@Autowired
	private ByProjectForBDao byProjectForBDao;	
	
	/**
	 * 日志记录器.
	 */
	private static final Logger logger = Logger.getLogger("ByProjectForBPrint");
	
	/**
	 * 查询所有项目余额信息
	 */
	@Override	
	public void queryByProjectForB(Page<ByCommunityForB> page, Map<String, Object> paramMap) {
		try {
			// 根据页面传入的map查询数据
			List<ByCommunityForB> list = byProjectForBDao.queryByProjectForB(paramMap);
			page.setDataByList(list, page.getPageNo(), page.getPageSize());
		} catch (Exception e) {
			e.printStackTrace();
		}				
	}
	
	public List<ByProjectForB> findByProjectForB(Map<String, Object> paramMap) {
		return byProjectForBDao.findByProjectForB(paramMap);
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

}

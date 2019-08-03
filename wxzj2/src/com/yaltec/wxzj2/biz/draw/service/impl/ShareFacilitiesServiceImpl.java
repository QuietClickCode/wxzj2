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
import com.yaltec.comon.utils.ObjectUtil;
import com.yaltec.wxzj2.biz.draw.dao.ShareFacilitiesDao;
import com.yaltec.wxzj2.biz.draw.entity.ShareAD;
import com.yaltec.wxzj2.biz.draw.entity.ShareFacilities;
import com.yaltec.wxzj2.biz.draw.entity.ShareInterest;
import com.yaltec.wxzj2.biz.draw.service.ShareFacilitiesService;

/**
 * 
 * @ClassName: ShareFacilitiesServiceImpl
 * @Description: 公共设施收益分摊servcer实现类
 * 
 * @author yangshanping
 * @date 2016-9-5 上午09:47:20
 */
@Service
public class ShareFacilitiesServiceImpl implements ShareFacilitiesService{

	@Autowired
	private ShareFacilitiesDao shareFacilitiesDao;
	/**
	 * 日志记录器.
	 */
	private static final Logger logger = Logger.getLogger("ShareFacilitiesPrint");
	public void find(Page<ShareFacilities> page, Map<String, Object> paramMap) {
		List<ShareFacilities> resultList = null;
		try {
			resultList = shareFacilitiesDao.queryShareFacilities(paramMap);
			page.setDataByList(resultList, page.getPageNo(), page.getPageSize());
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}

	public List<ShareFacilities> queryShareFacilities(Map<String, Object> paramMap) {
		return shareFacilitiesDao.queryShareFacilities(paramMap);
	}

	public void delFacilities(Map<String, String> paramMap) {
		shareFacilitiesDao.delFacilities(paramMap);
		
	}

	public void saveFacilities(Map<String, Object> paramMap) {
		shareFacilitiesDao.saveFacilities(paramMap);
	}

	public ShareFacilities pdfShareFacilities(String bm){
		return shareFacilitiesDao.pdfShareFacilities(bm);
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
				if(!ObjectUtil.isEmpty(out)){
					out.flush();
				}
				out.close();
			} catch (IOException e) {
				logger.error(e.getMessage());
			}
		}
	}

	public void updateShareFacilities(Map<String, String> paramMap) {
		shareFacilitiesDao.updateShareFacilities(paramMap);
	}

	public void shareFacilitiesI1(Map<String, String> paramMap) {
		shareFacilitiesDao.shareFacilitiesI1(paramMap);
	}

	public List<ShareAD> shareFacilitiesI2(Map<String, String> paramMap) {
		return shareFacilitiesDao.shareFacilitiesI2(paramMap);
	}
	
	public void saveShareFacilitiesI(Map<String, String> paramMap){
		shareFacilitiesDao.saveShareFacilitiesI(paramMap);
	}

	public List<ShareInterest> getShareInterest(Map<String, String> paramMap) {
		return shareFacilitiesDao.getShareInterest(paramMap);
	}
}

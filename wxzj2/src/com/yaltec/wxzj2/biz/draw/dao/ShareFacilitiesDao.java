package com.yaltec.wxzj2.biz.draw.dao;

import java.io.ByteArrayOutputStream;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Repository;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.draw.entity.ShareAD;
import com.yaltec.wxzj2.biz.draw.entity.ShareFacilities;
import com.yaltec.wxzj2.biz.draw.entity.ShareInterest;

/**
 * 
 * @ClassName: ShareFacilitiesDao
 * @Description: 公共设施收益分摊Dao接口
 * 
 * @author yangshanping
 * @date 2016-9-5 上午09:48:22
 */
@Repository
public interface ShareFacilitiesDao {

	public void find(Page<ShareFacilities> page,Map<String, Object> paramMap);
	
	public List<ShareFacilities> queryShareFacilities(Map<String, Object> paramMap);
	
	public void saveFacilities(Map<String, Object> paramMap);
	
	public void delFacilities(Map<String, String> paramMap);
	
	public ShareFacilities pdfShareFacilities(String bm);
	
	public void output(ByteArrayOutputStream ops,HttpServletResponse response);
	
	public void updateShareFacilities(Map<String, String> paramMap);
	
	public void shareFacilitiesI1(Map<String, String> paramMap);
	
	public List<ShareAD> shareFacilitiesI2(Map<String, String> paramMap);
	
	public void saveShareFacilitiesI(Map<String, String> paramMap);
	
	public List<ShareInterest> getShareInterest(Map<String, String> paramMap);
}

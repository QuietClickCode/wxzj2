package com.yaltec.wxzj2.biz.draw.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.yaltec.wxzj2.biz.draw.dao.BatchRefundDao;
import com.yaltec.wxzj2.biz.draw.entity.CodeName;
import com.yaltec.wxzj2.biz.draw.entity.ShareAD;
import com.yaltec.wxzj2.biz.draw.service.BatchRefundService;
import com.yaltec.wxzj2.biz.property.entity.Developer;

@Service
public class BatchRefundServiceImpl implements BatchRefundService{
	@Autowired
	private BatchRefundDao batchRefundDao;

	public List<CodeName> queryShareAD_DY(String lybh) {
		return batchRefundDao.queryShareAD_DY(lybh);
	}

	public List<CodeName> queryShareAD_FW(Map<String, String> parasMap) {
		return batchRefundDao.queryShareAD_FW(parasMap);
	}

	public List<CodeName> queryShareAD_LC(Map<String, String> parasMap) {
		return batchRefundDao.queryShareAD_LC(parasMap);
	}

	public List<CodeName> queryShareAD_LY(Map<String, String> parasMap) {
		return batchRefundDao.queryShareAD_LY(parasMap);
	}

	public List<CodeName> queryShareAD_LY2(Map<String, String> parasMap) {
		return batchRefundDao.queryShareAD_LY2(parasMap);
	}
	
	public void saveRefund_PL(Map<String, String> parasMap){
		 batchRefundDao.saveRefund_PL(parasMap);
	}

	public Developer getDeveloperBylybh(String lybh) {
		return batchRefundDao.getDeveloperBylybh(lybh);
	}

	public List<ShareAD> QryExportShareAD(Map<String, String> parasMap) {
		return batchRefundDao.QryExportShareAD(parasMap);
	}
}

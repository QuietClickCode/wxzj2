package com.yaltec.wxzj2.biz.draw.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.yaltec.wxzj2.biz.draw.dao.PreSplitDao;
import com.yaltec.wxzj2.biz.draw.entity.CodeName;
import com.yaltec.wxzj2.biz.draw.entity.ShareAD;
import com.yaltec.wxzj2.biz.draw.service.PreSplitService;

/**
 * 
 * @ClassName: PreSplitServiceImpl
 * @Description: 支取预分摊Service接口实现类
 * 
 * @author yangshanping
 * @date 2016-9-9 上午11:37:09
 */
@Service
public class PreSplitServiceImpl implements PreSplitService{

	@Autowired
	private PreSplitDao preSplitDao;
	
	public List<ShareAD> ExportFtFwInfo(String strsql) {
		return preSplitDao.ExportFtFwInfo(strsql);
	}

	public String queryIsTL() {
		return preSplitDao.queryIsTL();
	}

	public List<ShareAD> QryExportShareAD2(Map<String, String> map) {
		return preSplitDao.QryExportShareAD2(map);
	}

	public List<ShareAD> QryExportShareAD3(Map<String, String> map) {
		return preSplitDao.QryExportShareAD3(map);
	}

	public List<CodeName> QryExportShareADLYB(Map<String, String> map) {
		return preSplitDao.QryExportShareADLYB(map);
	}

}

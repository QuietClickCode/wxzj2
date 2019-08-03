package com.yaltec.wxzj2.biz.draw.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.draw.dao.CheckAD1Dao;
import com.yaltec.wxzj2.biz.draw.entity.ApplyDraw;
import com.yaltec.wxzj2.biz.draw.entity.ShareAD;
import com.yaltec.wxzj2.biz.draw.service.CheckAD1Service;

/**
 * 
 * @ClassName: CheckAD1ServiceImpl
 * @Description: 支取初审servcer接口实现类
 * 
 * @author yangshanping
 * @date 2016-8-31 下午04:42:31
 */
@Service
public class CheckAD1ServiceImpl implements CheckAD1Service{

	@Autowired
	private CheckAD1Dao checkAD1Dao;
	
	public void find(Page<ApplyDraw> page, Map<String, Object> paramMap) {
		List<ApplyDraw> resultList = null;
		resultList = checkAD1Dao.queryApplyDraw(paramMap);
		page.setDataByList(resultList, page.getPageNo(), page.getPageSize());
	}

	public List<ApplyDraw> queryApplyDraw(Map<String, Object> paramMap) {
		return checkAD1Dao.queryApplyDraw(paramMap);
	}

	public ApplyDraw getOpinionByBm(String bm) {
		return checkAD1Dao.getOpinionByBm(bm);
	}

	public int execute(Map<String, String> paramMap) {
		return checkAD1Dao.execute(paramMap);
	}
	
	public void findDrawForRe(Page<ShareAD> page,Map<String, Object> paramMap){
		List<ShareAD> resultList = null;
		resultList = checkAD1Dao.OpenQryDrawForRe(paramMap);
		page.setDataByList(resultList, page.getPageNo(), page.getPageSize());
	}
	
	public List<ShareAD> OpenQryDrawForRe(Map<String, Object> paramMap){
		return checkAD1Dao.OpenQryDrawForRe(paramMap);
	}
	
	public int  returnCheckAD1(Map<String, String> paramMap){
		return checkAD1Dao.returnCheckAD1(paramMap);
	}
}

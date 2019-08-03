package com.yaltec.wxzj2.biz.draw.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.draw.entity.ApplyDraw;
import com.yaltec.wxzj2.biz.draw.entity.ShareAD;

/**
 * 
 * @ClassName: CheckAD1Dao
 * @Description: 支取初审Dao接口
 * 
 * @author yangshanping
 * @date 2016-8-31 下午04:45:02
 */
@Repository
public interface CheckAD1Dao {

	public void find(Page<ApplyDraw> page,Map<String, Object> paramMap);
	
	public List<ApplyDraw> queryApplyDraw(Map<String, Object> paramMap);
	
	public ApplyDraw getOpinionByBm(String bm);
	
	public int execute(Map<String, String> paramMap);
	
	public void findDrawForRe(Page<ShareAD> page,Map<String, Object> paramMap);
	
	public List<ShareAD> OpenQryDrawForRe(Map<String, Object> paramMap);
	
	public int  returnCheckAD1(Map<String, String> paramMap);
}

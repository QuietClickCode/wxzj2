package com.yaltec.wxzj2.biz.draw.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.yaltec.wxzj2.biz.draw.dao.DrawDao;
import com.yaltec.wxzj2.biz.draw.entity.ApplyDraw;
import com.yaltec.wxzj2.biz.draw.service.DrawService;

/**
 * 支取申请 Service接口实现类
 * @author 亚亮科技有限公司.YL
 *
 * @version: 2016-8-29 上午11:33:38
 */
@Service
public class DrawServiceImpl implements DrawService{

	@Autowired
	private DrawDao dao;

	/**
	 * 根据申请单位、时间和金额 判断是否已经添加过该申请
	 * @param paramMap
	 * @return 返回结果为空则未添加过
	 */
	@Override
	public String getBmByContent(Map<String, Object> map) {
		return dao.getBmByContent(map);
	}
	/**
	 * 新建 
	 * @param ad
	 * @return 0 成功
	 */
	@Override
	public Integer add(Map<String,Object> map) {
		dao.add(map);
		Integer result = Integer.valueOf(map.get("result").toString());
		return result;
	}

	/**
	 * 查询
	 * @param paramMap
	 * @return
	 */
	@Override
	public List<ApplyDraw> query(Map<String, Object> paramMap) {
		return dao.query(paramMap);
	}
	/**
	 * 删除
	 * @param paramMap
	 * @return 0 成功
	 */
	@Override
	public Integer delete(Map<String, String> paramMap) {
		dao.delete(paramMap);
		Integer result = Integer.valueOf(paramMap.get("result").toString());
		return result;
	}

	/**
	 * 查询单个
	 */
	@Override
	public ApplyDraw get(String bm) {
		return dao.get(bm);
	}
	
	/**
	 * 根据编号获取支取申请信息
	 */
	public ApplyDraw getApplydrawWebByBm(String bm) {
		return dao.get(bm);
	}
	
	/**
	 * 判断支取是否已经分摊 
	 * @param z011
	 * @return >0 为已经分摊 
	 */
	@Override
	public Integer isShare(String z011) {
		return dao.isShare(z011);
	}
	/**
	 * 修改
	 * @param paramMap
	 * @return
	 */
	@Override
	public Integer update(Map<String, String> paramMap) {
		return dao.update(paramMap);
	}
}

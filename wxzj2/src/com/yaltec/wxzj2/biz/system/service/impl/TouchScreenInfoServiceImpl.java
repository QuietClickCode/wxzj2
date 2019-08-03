package com.yaltec.wxzj2.biz.system.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.github.pagehelper.PageHelper;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.comon.service.IdUtilService;
import com.yaltec.wxzj2.biz.system.dao.TouchScreenInfoDao;
import com.yaltec.wxzj2.biz.system.entity.TouchScreenInfo;
import com.yaltec.wxzj2.biz.system.service.TouchScreenInfoService;

/**
 * <p>
 * ClassName: TouchScreenInfoServiceImpl
 * </p>
 * <p>
 * Description: 触摸屏信息模块服务实现类(这里用一句话描述这个类的作用)
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author jiangyong
 * @date 2016-9-6下午04:32:14
 */
@Service
public class TouchScreenInfoServiceImpl implements TouchScreenInfoService {

	@Autowired
	private TouchScreenInfoDao touchScreenInfoDao;

	@Autowired
	private IdUtilService idUtilService;
	
	@Override
	public void findAll(Page<TouchScreenInfo> page) {
		PageHelper.startPage(page.getPageNo(), page.getPageSize());
		List<TouchScreenInfo> list = touchScreenInfoDao.findAll(page.getQuery());
		page.setData(list);
	}

	/**
	 * 保存触摸屏信息
	 */
	public void add(Map<String, String> map){
		try {
			// 获取当前数据库表可用BM
			String bm = idUtilService.getNextBm("cmplist");
			map.put("bm", bm);
			touchScreenInfoDao.save(map);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public TouchScreenInfo findByBm(String bm) {
		return touchScreenInfoDao.findByBm(bm);
	}

	public void update(Map<String, String> map) {
		touchScreenInfoDao.save(map);
	}
	
	@Override
	public int delete(String id) {
		// TODO Auto-generated method stub
		return touchScreenInfoDao.delete(id);
	}

	public int batchDelete(List<String> bmList) {
		return touchScreenInfoDao.batchDelete(bmList);
	}
}

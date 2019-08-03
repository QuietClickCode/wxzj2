package com.yaltec.wxzj2.biz.system.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.github.pagehelper.PageHelper;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.comon.log.entity.Log;
import com.yaltec.wxzj2.biz.system.dao.SysLogDao;
import com.yaltec.wxzj2.biz.system.service.SysLogService;

/**
 * <p>
 * ClassName: SysLogServiceImpl
 * </p>
 * <p>
 * Description: 系统日志查询模块服务实现类(这里用一句话描述这个类的作用)
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author jiangyong
 * @date 2016-8-20 上午10:16:14
 */
@Service
public class SysLogServiceImpl implements SysLogService {

	@Autowired
	private SysLogDao sysLogDao;

	@Override
	public void findAll(Page<Log> page, Map<String, Object> map) {
		PageHelper.startPage(page.getPageNo(), page.getPageSize());
		List<Log> list = sysLogDao.findAll(map);
		page.setData(list);
	}
	
	@Override
	public List<Log> findAll2(Map<String, Object> map) {			
		return  sysLogDao.findAll(map);
	}
	
	@Override
	public int batchAdd(List<Log> list) {
		return sysLogDao.batchAdd(list);
	}

	@Override
	public Log find(String id) {
		return sysLogDao.find(id);
	}

}

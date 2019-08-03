package com.yaltec.wxzj2.biz.system.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.yaltec.wxzj2.biz.system.dao.SysAnnualSetDao;
import com.yaltec.wxzj2.biz.system.entity.SysAnnualSet;
import com.yaltec.wxzj2.biz.system.service.SysAnnualSetService;

/**
 * <p>
 * ClassName: SysAnnualSetServiceImpl
 * </p>
 * <p>
 * Description: 系统年度设置模块服务实现类(这里用一句话描述这个类的作用)
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author jiangyong
 * @date 2016-7-18 下午04:32:14
 */
@Service
public class SysAnnualSetServiceImpl implements SysAnnualSetService {

	@Autowired
	private SysAnnualSetDao sysAnnualSetDao;

	@Override
	public SysAnnualSet find() {
		return sysAnnualSetDao.find();
	}

	@Override
	public void update(Map<String, String> map) {
		sysAnnualSetDao.update(map);
	}
}

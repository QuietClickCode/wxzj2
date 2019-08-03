package com.yaltec.wxzj2.biz.system.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.github.pagehelper.PageHelper;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.comon.service.IdUtilService;
import com.yaltec.wxzj2.biz.system.dao.FSConfigDao;
import com.yaltec.wxzj2.biz.system.entity.FSConfig;
import com.yaltec.wxzj2.biz.system.service.FSConfigService;

/**
 * <p>
 * ClassName: FSConfigServiceImpl
 * </p>
 * <p>
 * Description: 非税配置模块服务实现类(这里用一句话描述这个类的作用)
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author jiangyong
 * @date 2016-9-5 下午04:16:14
 */
@Service
public class FSConfigServiceImpl implements FSConfigService {

	@Autowired
	private FSConfigDao fsconfigDao;
	
	@Autowired
	private IdUtilService idUtilService;

	@Override
	public void findAll(Page<FSConfig> page) {
		PageHelper.startPage(page.getPageNo(), page.getPageSize());
		List<FSConfig> list = fsconfigDao.findAll(page.getQuery());
		page.setData(list);
	}
	
	/**
	 * 保存非税配置信息
	 */
	public int add(FSConfig fsconfig){
		try {
			// 获取当前数据库表可用Id
			String id = idUtilService.getNextId("Fsconfig");
			fsconfig.setId(id);
			return fsconfigDao.add(fsconfig);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return 0;
	}
	
	public FSConfig findById(String id) {
		return fsconfigDao.findById(id);
	}
	
	public int update(FSConfig fsconfig) {
		return fsconfigDao.update(fsconfig);
	}
	
	@Override
	public int delete(String id) {
		// TODO Auto-generated method stub
		return fsconfigDao.delete(id);
	}
}

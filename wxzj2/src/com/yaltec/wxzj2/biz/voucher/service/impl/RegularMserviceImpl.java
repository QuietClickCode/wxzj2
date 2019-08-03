package com.yaltec.wxzj2.biz.voucher.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.github.pagehelper.PageHelper;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.voucher.dao.RegularMDao;
import com.yaltec.wxzj2.biz.voucher.entity.RegularM;
import com.yaltec.wxzj2.biz.voucher.service.RegularMService;

/**
 * <p>
 * ClassName: DeveloperServiceImpl
 * </p>
 * <p>
 * Description: 定期管理模块服务实现类(这里用一句话描述这个类的作用)
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author chenxiaokuang
 * @date 2016-9-07 上午08:52:14
 */
@Service
public class RegularMserviceImpl implements RegularMService{

	@Autowired
	private RegularMDao regularMDao;

	@Override
	public void findAll(Page<RegularM> page) {
		PageHelper.startPage(page.getPageNo(), page.getPageSize());
		//查询之前更新定期管理信息的状态
		regularMDao.updateStatus();
		List<RegularM> list = regularMDao.findAll(page.getQuery());
		page.setData(list);
	}

	@Override
	public void add(Map<String, String> map) {
		try {
			regularMDao.save(map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}

	@Override
	public RegularM findById(String id) {
		RegularM regularM = regularMDao.findById(id);
		return regularM;
	}

	@Override
	public void update(Map<String, String> map) {
		regularMDao.save(map);
	}

	@Override
	public int delete(String id) {
		return regularMDao.delete(id);
	}

	@Override
	public int batchDelete(List<String> idList) {
		return regularMDao.batchDelete(idList);
	}

	@Override
	public void findExpireAll(Page<RegularM> page) {
		PageHelper.startPage(page.getPageNo(), page.getPageSize());
		List<RegularM> list = regularMDao.findExpireAll();
		page.setData(list);
	}

	@Override
	public int findExpireNum() {
		return regularMDao.findExpireNum();
	}
}

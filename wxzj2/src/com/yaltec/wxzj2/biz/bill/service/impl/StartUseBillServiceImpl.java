package com.yaltec.wxzj2.biz.bill.service.impl;


import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.github.pagehelper.PageHelper;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.bill.dao.StartUseBillDao;
import com.yaltec.wxzj2.biz.bill.entity.ReceiptInfoM;
import com.yaltec.wxzj2.biz.bill.service.StartUseBillService;


/**
 * <p>
 * ClassName: StartUseBillServiceImpl
 * </p>
 * <p>
 * Description: 票据启用模块服务实现类
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author moqian
 * @date 2016-7-18 下午04:32:14
 */

@Service
public class StartUseBillServiceImpl implements StartUseBillService {
	
	@Autowired
	private StartUseBillDao startUseBillDao;
	
	/**
	 * 查询所有启用票据信息
	 */
	public void find(Page<ReceiptInfoM> page,Map<String, Object> paramMap){
		PageHelper.startPage(page.getPageNo(), page.getPageSize());
		List<ReceiptInfoM> resultList = null;
		try {
			resultList = startUseBillDao.findAll(paramMap);
			page.setData(resultList);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * 查询所有启用票据信息
	 */
	public List<ReceiptInfoM> findAll(Map<String, Object> paramMap) {
		return startUseBillDao.findAll(paramMap);
	}
	
	/**
	 * 保存启用票据信息
	 */
	public int save(Map<String, Object> map) {
		return startUseBillDao.save(map);
	}
	
	/**
	 * 获取票据是否已启用，返回无效的最大票据号
	 */
	@Override
	public String check(Map<String, String> paramMap) {
		return startUseBillDao.check(paramMap);
	}

	/**
	 * 清除票据领用人
	 */
	@Override
	public int clearOwner(Map<String, String> paramMap) {
		return startUseBillDao.clearOwner(paramMap);
	}
}
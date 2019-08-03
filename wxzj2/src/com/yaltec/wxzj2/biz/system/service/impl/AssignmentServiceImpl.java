package com.yaltec.wxzj2.biz.system.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.github.pagehelper.PageHelper;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.comon.service.IdUtilService;
import com.yaltec.wxzj2.biz.system.dao.AssignmentDao;
import com.yaltec.wxzj2.biz.system.entity.Assignment;
import com.yaltec.wxzj2.biz.system.service.AssignmentService;

/**
 * <p>
 * ClassName: AssignmentServiceImpl
 * </p>
 * <p>
 * Description: 归集中心设置模块服务实现类(这里用一句话描述这个类的作用)
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author jiangyong
 * @date 2016-7-28 下午02:32:14
 */
@Service
public class AssignmentServiceImpl implements AssignmentService {

	@Autowired
	private AssignmentDao assignmentDao;
	 
	@Autowired
	private IdUtilService idUtilService;
	
	@Override
	public void findAll(Page<Assignment> page) {
		PageHelper.startPage(page.getPageNo(), page.getPageSize());
		List<Assignment> list = assignmentDao.findAll(page.getQuery());
		page.setData(list);
	}
	
	/**
	 * 保存归集中心信息
	 */
	public void add(Map<String, String> map){
		try {
			// 获取当前数据库表可用BM
			String bm = idUtilService.getNextBm("Assignment");
			map.put("bm", bm);
			assignmentDao.save(map);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public Assignment findByBm(String bm) {
		return assignmentDao.findByBm(bm);
	}
	
	public void update(Map<String, String> map){
		assignmentDao.save(map);
	}
	
	public int batchDelete(List<String> bmList) {
		return assignmentDao.batchDelete(bmList);
	}
}
package com.yaltec.wxzj2.biz.property.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.github.pagehelper.PageHelper;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.comon.service.IdUtilService;
import com.yaltec.wxzj2.biz.property.dao.ProjectDao;
import com.yaltec.wxzj2.biz.property.entity.Project;
import com.yaltec.wxzj2.biz.property.service.ProjectService;

/**
 * <p>
 * ClassName: ProjectServiceImpl
 * </p>
 * <p>
 * Description: 项目信息模块服务实现类(这里用一句话描述这个类的作用)
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author jiangyong
 * @date 2016-7-18 下午04:32:14
 */
@Service
public class ProjectServiceImpl implements ProjectService {

	@Autowired
	private ProjectDao projectDao;

	@Autowired
	private IdUtilService idUtilService;

	@Override
	public void findAll(Page<Project> page) {
		PageHelper.startPage(page.getPageNo(), page.getPageSize());
		List<Project> list = projectDao.findAll(page.getQuery());
		page.setData(list);
	}
	
	public int add(Project project) {
		try {
			// 获取当前数据库表可用BM
			String bm = idUtilService.getNextBm("Project");
			project.setBm(bm);
			return projectDao.add(project);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return 0;
	}

	public Project findByBm(String bm) {
		return projectDao.findByBm(bm);
	}
	
	public int update(Project project) {
		return projectDao.update(project);
	}
	
	@Override
	public int delete(Map<String, String> paramMap) {
		int result = 5;
		try {
			// 删除项目前检查项目下是否有小区信息
			String r = projectDao.checkForDelProject(paramMap);
			if (r.equals("1")) {
				result = -1;
				return result;
			}
			projectDao.batchDelete(paramMap);
			result = 0;
			return result;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	public int batchDelete(Map<String, String> paramMap) throws Exception {
		int result = 5;
		String bms = paramMap.get("bm");
		String[] paras = bms.split(",");
		// 删除数据
		for (String bm : paras) {
			paramMap.put("bm", bm);
			// 删除项目前检查项目下是否有小区信息
			String r = projectDao.checkForDelProject(paramMap);
			if (r.equals("1")) {
				result = -1;
				throw new Exception("删除失败,请先删除该项目下关联的小区信息！");
			}
		}
		for (String bm : paras) {
			paramMap.put("bm", bm);
			projectDao.batchDelete(paramMap);
			result = 0;
		}
		if (result == 5) {
			throw new Exception("删除失败！");
		}
		return result;
	}

	@Override
	public Project findByMc(Project project) {
		return projectDao.findByMc(project);
	}
	
}	

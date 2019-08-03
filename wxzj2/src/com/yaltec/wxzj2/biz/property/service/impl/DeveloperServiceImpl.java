package com.yaltec.wxzj2.biz.property.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.github.pagehelper.PageHelper;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.comon.service.IdUtilService;
import com.yaltec.wxzj2.biz.property.dao.DeveloperDao;
import com.yaltec.wxzj2.biz.property.entity.Developer;
import com.yaltec.wxzj2.biz.property.service.DeveloperService;
import com.yaltec.wxzj2.comon.data.DataHolder;
import com.yaltec.wxzj2.comon.data.service.DeveloperDataService;

/**
 * <p>
 * ClassName: DeveloperServiceImpl
 * </p>
 * <p>
 * Description: 开发单位模块服务实现类(这里用一句话描述这个类的作用)
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author jiangyong
 * @date 2016-7-18 下午04:32:14
 */
@Service
public class DeveloperServiceImpl implements DeveloperService {

	@Autowired
	private DeveloperDao developerDao;

	@Autowired
	private IdUtilService idUtilService;

	@Override
	public void findAll(Page<Developer> page) {
		PageHelper.startPage(page.getPageNo(), page.getPageSize());
		List<Developer> list = developerDao.findAll(page.getQuery());
		page.setData(list);
	}

	public void add(Map<String, String> map) {
		try {
			// 获取当前数据库表可用BM
			String bm = idUtilService.getNextBm("DeveloperCompany");
			map.put("bm", bm);
			developerDao.save(map);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public Developer findByBm(String bm) {
		return developerDao.findByBm(bm);
	}

	public void update(Map<String, String> map) {
		developerDao.save(map);
	}

	@Override
	public int delete(Map<String, String> map) {
		return developerDao.delDeveloper(map);
	}

	@Override
	public int batchDelete(Map<String, String> map) throws Exception {
		int result = -1;
		String bms = map.get("bm");
		String[] paras = bms.split(",");
		// 删除数据
		for (String bm : paras) {
			map.put("bm", bm);
			String r = developerDao.checkForDel(map);
			if (r.equals("1")) {
				result = 2; // 单位预交中已存在该开发单位信息
				throw new Exception("删除失败，单位预交中已存在该开发单位信息！");
			}
		}
		for (String bm : paras) {
			map.put("bm", bm);
			developerDao.delDeveloper(map);
			result = Integer.valueOf(map.get("result"));
			if (result == 0) {
				// 更新缓存
				DataHolder.updateDataMap(DeveloperDataService.KEY, bm);
			}
			if (result == 1) {
				throw new Exception("删除失败，该开发单位信息已启用！");
			} else if (result != 0) {
				throw new Exception("删除失败！");
			}
		}
		return result;
	}

	@Override
	public Developer findByMc(Developer developer) {
		return developerDao.findByMc(developer);
	}

	@Override
	public String checkForDel(Map<String, String> map) {
		return developerDao.checkForDel(map);
	}
	
}

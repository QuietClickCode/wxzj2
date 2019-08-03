package com.yaltec.wxzj2.biz.file.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.github.pagehelper.PageHelper;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.file.dao.ArchivesDao;
import com.yaltec.wxzj2.biz.file.entity.Archives;
import com.yaltec.wxzj2.biz.file.service.ArchivesService;


/**
 * 案卷service实现
 * @ClassName: ArchivesServiceImpl 
 * @author 重庆亚亮科技有限公司 txj 
 * @date 2016-9-6 下午02:21:45
 */
@Service
public class ArchivesServiceImpl implements ArchivesService {
	@Autowired
	private ArchivesDao archivesDao;
	/**
	 * 查询案卷信息
	 */
	@Override
	public void findAll(Page<Archives> page) {
		PageHelper.startPage(page.getPageNo(), page.getPageSize());
		List<Archives> list = archivesDao.findAll(page.getQuery());
		page.setData(list);
	}
	/**
	 * 保存案卷信息
	 */
	@Override
	public void save(Map<String, String> map) {
		archivesDao.save(map);
	}
	
	/**
	 * 根据编号获取案卷信息
	 */
	@Override
	public Archives findById(String id) {
		return archivesDao.findById(id);
	}
	
	/**
	 * 根据编号删除案卷信息
	 */
	@Override
	public int delete(String id) {
		return archivesDao.delete(id);
	}
	
	/**
	 * 批量删除
	 */
	@Override
	public int batchDelete(List<String> idList) {
		return archivesDao.batchDelete(idList);
	}
}

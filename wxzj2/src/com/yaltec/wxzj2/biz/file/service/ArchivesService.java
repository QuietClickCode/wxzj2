package com.yaltec.wxzj2.biz.file.service;

import java.util.List;
import java.util.Map;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.file.entity.Archives;

public interface ArchivesService {
	/**
	 * 查询案卷信息
	 * @param page
	 */
	public void findAll(Page<Archives> page);
	/**
	 * 保存案卷
	 * @param map
	 */
	public void save(Map<String, String> map);
	/**
	 * 根据编号获取案卷信息
	 * @param id
	 * @return
	 */
	public Archives findById(String id);
	/**
	 * 根据编号删除案卷信息
	 * @param id
	 * @return
	 */
	public int delete(String id);
	/**
	 * 批量删除案卷信息
	 * @param idList
	 * @return
	 */
	public int batchDelete(List<String> idList);
}

package com.yaltec.wxzj2.biz.file.service;

import java.util.List;
import java.util.Map;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.file.entity.Volumelibrary;

public interface VolumeLibraryService {
	/**
	 * 查询卷库信息
	 * @param page
	 */
	public void findAll(Page<Volumelibrary> page);
	/**
	 * 保存卷库
	 * @param map
	 */
	public void save(Map<String, String> map);
	/**
	 * 根据编号删除卷库信息
	 * @param id
	 * @return
	 */
	public int delete(String id);
	/**
	 * 批量删除
	 * @param idList
	 * @return
	 */
	public int batchDelete(List<String> idList);

}

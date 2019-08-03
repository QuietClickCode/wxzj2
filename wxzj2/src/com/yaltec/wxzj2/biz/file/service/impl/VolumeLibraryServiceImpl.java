package com.yaltec.wxzj2.biz.file.service.impl;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.github.pagehelper.PageHelper;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.file.dao.VolumeLibraryDao;
import com.yaltec.wxzj2.biz.file.entity.Archives;
import com.yaltec.wxzj2.biz.file.entity.Volumelibrary;
import com.yaltec.wxzj2.biz.file.service.VolumeLibraryService;
import com.yaltec.wxzj2.comon.data.DataHolder;
/**
 * 卷库service实现
 * @ClassName: VolumeLibraryServiceImpl 
 * @author 重庆亚亮科技有限公司 txj 
 * @date 2016-9-6 上午09:53:08
 */
@Service
public class VolumeLibraryServiceImpl implements VolumeLibraryService {
	@Autowired
	private VolumeLibraryDao volumeLibraryDao;
	/**
	 * 查询卷库信息
	 */
	@Override
	public void findAll(Page<Volumelibrary> page) {
		PageHelper.startPage(page.getPageNo(), page.getPageSize());
		List<Volumelibrary> list = volumeLibraryDao.findAll(page.getQuery());
		page.setData(list);
	}
	/**
	 * 保存卷库信息
	 */
	@Override
	public void save(Map<String, String> map) {
		volumeLibraryDao.save(map);
	}
	
	/**
	 * 根据编号删除卷库信息
	 */
	@Override
	public int delete(String id) {
		LinkedHashMap<String, Archives> ArchivesMap= DataHolder.volumelibraryArchivesMap.get(id);
		if(ArchivesMap !=null){
			return -1;
		}else{
			return volumeLibraryDao.delete(id);
		}
	}
	
	/**
	 * 批量删除
	 */
	@Override
	public int batchDelete(List<String> idList) {
		int result=0;
		//判断删除的卷库中是否存在有案卷的情况
		for (String id : idList) {
			LinkedHashMap<String, Archives> archivesMap= DataHolder.volumelibraryArchivesMap.get(id);						
			if(archivesMap !=null ){
				if(archivesMap.keySet().isEmpty()){
					DataHolder.volumelibraryArchivesMap.remove(id);
				}else{
					result=-1;
					continue;
				}
			}
		}
		//无案卷的情况下删除选中的卷库
		if(result==0){
			result= volumeLibraryDao.batchDelete(idList);
		}
		return result;
	}
}

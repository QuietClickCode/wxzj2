package com.yaltec.wxzj2.comon.data.service;

import java.util.LinkedHashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import com.yaltec.wxzj2.biz.file.dao.VolumeLibraryDao;
import com.yaltec.wxzj2.biz.file.entity.Volumelibrary;
import com.yaltec.wxzj2.comon.data.DataHolder;
import com.yaltec.wxzj2.comon.data.DataServie;

/**
 * 卷库缓存
 * @ClassName: VolumeLibraryDataService 
 * @author 重庆亚亮科技有限公司 txj 
 * @date 2016-9-6 下午04:32:36
 */
public class VolumeLibraryDataService extends DataServie {

	/**
	 * 缓存唯一标识
	 */
	public static final String KEY = "volumelibrary";
	
	/**
	 * 备注信息
	 */
	public static final String REMARK = "卷库缓存"; 
	
	@Autowired
	private VolumeLibraryDao volumeLibraryDao;

	public VolumeLibraryDataService() {		
		// 调用父类构造方法
		super(KEY, REMARK);
	}
	
	@Override
	public LinkedHashMap<String, String> init() {
		// 定义有序MAP集合
		LinkedHashMap<String, String> map = new LinkedHashMap<String, String>();
		
		// 查询数据
		List<Volumelibrary> list = volumeLibraryDao.findAll(new Volumelibrary());
		
		// 设置缓存数据条数
		super.setSize(list.size());
		// 先清空原有缓存数据
		DataHolder.volumelibraryMap.clear();
		for (Volumelibrary volumelibrary : list) {
			DataHolder.volumelibraryMap.put(volumelibrary.getId(), volumelibrary);
		}
		// 返回一个空的有序集合
		return map;
	}

}

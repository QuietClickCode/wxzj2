package com.yaltec.wxzj2.comon.data.service;

import java.util.LinkedHashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import com.yaltec.wxzj2.biz.file.dao.ArchivesDao;
import com.yaltec.wxzj2.biz.file.entity.Archives;
import com.yaltec.wxzj2.comon.data.DataHolder;
import com.yaltec.wxzj2.comon.data.DataServie;

/**
 * 案卷缓存
 * @ClassName: ArchivesDataService 
 * @author 重庆亚亮科技有限公司 txj 
 * @date 2016-9-6 下午04:32:36
 */
public class ArchivesDataService extends DataServie {

	/**
	 * 缓存唯一标识
	 */
	public static final String KEY = "archives";
	
	/**
	 * 备注信息
	 */
	public static final String REMARK = "案卷缓存"; 
	
	@Autowired
	private ArchivesDao archivesDao;

	public ArchivesDataService() {		
		// 调用父类构造方法
		super(KEY, REMARK);
	}
	
	@Override
	public LinkedHashMap<String, String> init() {	
		// 查询数据
		List<Archives> list = archivesDao.findAll(new Archives());		
		// 设置缓存数据条数
		super.setSize(list.size());
		// 先清空原有缓存数据
		DataHolder.archivesMap.clear();
		DataHolder.volumelibraryArchivesMap.clear();
		//循环卷库id
		for (String  volumelibraryId: DataHolder.volumelibraryMap.keySet()) {
			//定义有序案卷Map集合
			LinkedHashMap<String, Archives> archivesMap=new LinkedHashMap<String, Archives>();			
			//循环案卷信息（把卷库id下的所有案卷存放到archivesMap中）
			for (int i = 0; i < list.size(); i++) {
				Archives archives=list.get(i);
				//判断案卷是否是卷库id下
				if(archives.getVlid().equals(volumelibraryId)){
					//存放有序案卷Map集合
					archivesMap.put(archives.getId(), archives);					
				}
			}
			//判断该卷库下是否有案卷信息
			if(archivesMap.size()>0){
				// 存放每个卷库下面的案卷信息
				DataHolder.volumelibraryArchivesMap.put(volumelibraryId, archivesMap);
				// 案卷集合里面按卷库顺序依次添加卷库下面的案卷集合
				DataHolder.archivesMap.putAll(archivesMap);
			}
		}
		// 返回一个空的有序集合
		return null;
	}

}

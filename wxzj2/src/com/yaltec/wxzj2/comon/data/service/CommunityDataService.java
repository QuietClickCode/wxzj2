package com.yaltec.wxzj2.comon.data.service;

import java.util.LinkedHashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import com.yaltec.wxzj2.biz.property.dao.CommunityDao;
import com.yaltec.wxzj2.biz.property.entity.Community;
import com.yaltec.wxzj2.comon.data.DataHolder;
import com.yaltec.wxzj2.comon.data.DataServie;

/**
 * <p>ClassName: CommunityDataService</p>
 * <p>Description: 小区数据服务类(这里用一句话描述这个类的作用)</p>
 * <p>Company: YALTEC</p> 
 * @author jiangyong
 * @date 2016-7-29 下午03:39:14
 */
public class CommunityDataService extends DataServie {

	/**
	 * 缓存唯一标识
	 */
	public static final String KEY = "community";
	
	/**
	 * 备注信息
	 */
	public static final String REMARK = "小区数据缓存"; 
	
	@Autowired
	private CommunityDao communityDao;

	public CommunityDataService() {
		
		// 调用父类构造方法
		super(KEY, REMARK);
	}
	
	@Override
	public LinkedHashMap<String, String> init() {
		// 定义有序MAP集合
		LinkedHashMap<String, String> map = new LinkedHashMap<String, String>();
		
		// 查询数据
		List<Community> list = communityDao.findAll(new Community());
		
		// 设置缓存数据条数
		super.setSize(list.size());
		// 先清空原有缓存数据
		DataHolder.communityMap.clear();
		for (Community community : list) {
			
			community.clear();
			DataHolder.communityMap.put(community.getBm(), community);
			if(community.getXmbm() != null && !"".equals(community.getXmbm())){
				//装载项目和小区的关联
				if(DataHolder.projectCommunityMap.get(community.getXmbm()) == null){
					DataHolder.projectCommunityMap.put(community.getXmbm(), new LinkedHashMap<String, Community>());
				}
				DataHolder.projectCommunityMap.get(community.getXmbm()).put(community.getBm(), community);
			}
		}
		
		// 返回一个空的有序集合
		return map;
	}

}

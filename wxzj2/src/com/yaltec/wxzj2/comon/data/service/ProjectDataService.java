package com.yaltec.wxzj2.comon.data.service;

import java.util.LinkedHashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import com.yaltec.wxzj2.biz.property.dao.ProjectDao;
import com.yaltec.wxzj2.biz.property.entity.Project;
import com.yaltec.wxzj2.comon.data.DataServie;

/**
 * 
* @ClassName: ProjectDataService
* @Description: 项目数据服务类

* @author yangshanping
* @date 2016-8-31 下午05:28:45
 */
public class ProjectDataService extends DataServie{

	/**
	 * 缓存唯一标识
	 */
	public static final String KEY = "project";
	
	/**
	 * 备注信息
	 */
	public static final String REMARK = "项目数据缓存"; 
	
	@Autowired
	private ProjectDao projectDao;

	public ProjectDataService(){
		// 调用父类构造方法
		super(KEY, REMARK);
	}
	
	@Override
	public LinkedHashMap<String, String> init() {
		// 定义有序MAP集合
		LinkedHashMap<String, String> map = new LinkedHashMap<String, String>();
		map.put("", "请选择");
		// 查询数据
		List<Project> list = projectDao.findAll(new Project());
		// 设置缓存数据条数
		super.setSize(list.size());
		for (Project project : list) {
			map.put(project.getBm(), project.getMc());
		}
		return map;
	}

}

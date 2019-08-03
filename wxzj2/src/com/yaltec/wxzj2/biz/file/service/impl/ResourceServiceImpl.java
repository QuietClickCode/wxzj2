package com.yaltec.wxzj2.biz.file.service.impl;

import java.io.File;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.github.pagehelper.PageHelper;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.file.dao.ResourceDao;
import com.yaltec.wxzj2.biz.file.entity.QueryResource;
import com.yaltec.wxzj2.biz.file.entity.Resource;
import com.yaltec.wxzj2.biz.file.service.ResourceService;
import com.yaltec.wxzj2.biz.system.entity.User;
/**
 * 文件信息service实现类
 * @ClassName: ResourceServiceImpl 
 * @author 重庆亚亮科技有限公司 txj 
 * @date 2016-9-7 下午03:29:44
 */
@Service
public class ResourceServiceImpl implements ResourceService {
	@Autowired
	private ResourceDao resourceDao;
	@Value("${work.path}") //配置文件中定义的保存路径（永久保存）
	private String path;
	
	/**
	 * 保存
	 */
	@Override
	public void save(Map<String, Object> map) {
		resourceDao.save(map);		
	}
	/**
	 * 删除
	 */
	@Override
	public int deleteById(String id) {
		//根据id查询删除前文件名称
		String oldFileName =resourceDao.getResourceById(id).getUuid();
		//根据id逻辑删除文件
		int result=resourceDao.deleteById(id);
		if(result>0){
			//修改存放的文件名称（在原文件前加_）
			File oldFile = new File(path+oldFileName);
			if(oldFile.exists()){
				String rootPath = oldFile.getParent();
				String newFileName="_"+oldFileName;
				File newFile = new File(rootPath + File.separator + newFileName);
				oldFile.renameTo(newFile);
			}
		}
		return result; 
	}
	
	/**
	 * 修改案卷
	 */
	@Override
	public int updateArchive(Map<String, Object> paramMap) {
		return resourceDao.updateArchive(paramMap);
	}
	
	/**
	 * 根据编号获取文件信息
	 */
	@Override
	public Resource getResourceById(String id) {
		return resourceDao.getResourceById(id);
	}
	/**
	 *  根据module获取数据
	 */
	@Override
	public void getResourceByModule(Page<QueryResource> page) {
		PageHelper.startPage(page.getPageNo(), page.getPageSize());
		List<QueryResource> list = resourceDao.getResourceByModule(page.getQuery());
		page.setData(list);
	}
	
	/**
	 * 根据moduleid获取数据
	 */
	@Override
	public void findByModuleid(Page<QueryResource> page,
			Map<String, Object> paramMap) {
		try {
			// 根据页面传入的map查询数据
			List<QueryResource> list =resourceDao.findByModuleid(paramMap);
			page.setDataByList(list, page.getPageNo(), page.getPageSize());
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	/**
	 * 根据案卷编号获取文件
	 */
	@Override
	public List<Resource> getResourceByArchive(String archive) {
		return resourceDao.getResourceByArchive(archive);
	}
	
	/**
	 * 根据案卷编号获取文件
	 * @param idList
	 * @return
	 */
	@Override
	public List<Resource> getResourceByArchiveList(List<String> idList) {
		return resourceDao.getResourceByArchiveList(idList);
	}
}

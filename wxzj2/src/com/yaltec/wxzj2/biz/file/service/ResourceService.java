package com.yaltec.wxzj2.biz.file.service;

import java.util.List;
import java.util.Map;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.file.entity.QueryResource;
import com.yaltec.wxzj2.biz.file.entity.Resource;


/**
 * 文件信息service接口
 * @ClassName: ResourceService 
 * @author 重庆亚亮科技有限公司 txj 
 * @date 2016-9-7 下午03:28:01
 */
public interface ResourceService {
	/**
	 * 保存上传文件
	 * @param map
	 */
	public void save(Map<String, Object> map);

	/**
	 * 删除
	 * @param idList
	 * @return
	 */
	public int deleteById(String id);
	/**
	 * 修改案卷
	 * @param paramMap
	 * @return
	 */
	public int updateArchive(Map<String, Object> paramMap);
	/**
	 * 根据编号获取信息
	 * @param id
	 * @return
	 */
	public Resource getResourceById(String id);
	/**
	 * 根据paramMap获取数据
	 * @param module
	 * @return
	 */
	public void getResourceByModule(Page<QueryResource> page);
	/**
	 * 根据moduleid获取数据
	 * @param page
	 * @param paramMap
	 */
	public void findByModuleid(Page<QueryResource> page,
			Map<String, Object> paramMap);
	/**
	 * 根据案卷编号获取文件
	 * @param id
	 * @return
	 */
	public List<Resource> getResourceByArchive(String id);
	/**
	 * 根据案卷编号获取文件
	 * @param idList
	 * @return
	 */
	public List<Resource> getResourceByArchiveList(List<String> idList);
	

}

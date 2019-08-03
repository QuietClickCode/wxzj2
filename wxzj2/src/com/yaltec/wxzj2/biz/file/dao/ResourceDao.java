package com.yaltec.wxzj2.biz.file.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.yaltec.wxzj2.biz.file.entity.QueryResource;
import com.yaltec.wxzj2.biz.file.entity.Resource;

/**
 * 文件信息dao接口
 * @ClassName: ResourceDao 
 * @author 重庆亚亮科技有限公司 txj 
 * @date 2016-9-7 下午03:30:35
 */
@Repository
public interface ResourceDao {
	/**
	 * 保存
	 * @param map
	 */
	public void save(Map<String, Object> map);
	
	/**
	 * 批量删除
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
	 * 根据编号获取文件信息
	 * @param id
	 * @return
	 */
	public Resource getResourceById(String id);
	/**
	 *  根据paramMap获取数据
	 * @param module
	 * @return
	 */
	public List<QueryResource> getResourceByModule(QueryResource queryResource);
	/**
	 * 根据moduleid获取数据
	 * @param paramMap
	 * @return
	 */
	public List<QueryResource> findByModuleid(Map<String, Object> paramMap);
	
	/**
	 * 根据案卷编号获取文件
	 * @param archive
	 * @return
	 */
	public List<Resource> getResourceByArchive(String archive);
	/**
	 * 根据案卷编号获取文件
	 * @param idList
	 * @return
	 */
	public List<Resource> getResourceByArchiveList(List<String> idList);

}

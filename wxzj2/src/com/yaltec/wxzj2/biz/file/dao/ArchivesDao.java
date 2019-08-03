package com.yaltec.wxzj2.biz.file.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.yaltec.wxzj2.biz.file.entity.Archives;
/**
 * 案卷管理dao接口
 * @ClassName: ArchivesDao 
 * @author 重庆亚亮科技有限公司 txj 
 * @date 2016-9-6 下午03:15:31
 */
@Repository
public interface ArchivesDao {
	/**
	 * 查询卷库信息
	 * @param query
	 * @return
	 */
	public List<Archives> findAll(Archives query);
	/**
	 * 添加案卷
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

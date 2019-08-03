package com.yaltec.wxzj2.biz.file.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.yaltec.wxzj2.biz.file.entity.Volumelibrary;

/**
 * 卷库dao接口
 * @ClassName: VolumeLibraryDao 
 * @author 重庆亚亮科技有限公司 txj 
 * @date 2016-9-6 下午03:15:42
 */
@Repository
public interface VolumeLibraryDao {
	/**
	 * 查询卷库信息
	 * @param query
	 * @return
	 */
	public List<Volumelibrary> findAll(Volumelibrary query);
	/**
	 * 添加卷库
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
	 * 批量删除卷库信息
	 * @param idList
	 * @return
	 */
	public int batchDelete(List<String> idList);

}

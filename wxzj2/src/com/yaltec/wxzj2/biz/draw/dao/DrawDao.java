package com.yaltec.wxzj2.biz.draw.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.yaltec.wxzj2.biz.draw.entity.ApplyDraw;

/**
 * 支取申请操作接口
 * @author 亚亮科技有限公司.YL
 *
 * @version: 2016-8-29 上午11:29:19
 */
@Repository
public interface DrawDao {
	/**
	 * 根据申请单位、时间和金额 判断是否已经添加过该申请
	 * @param paramMap
	 * @return 返回结果为空则未添加过
	 */
	public String getBmByContent(Map<String,Object> map);
	/**
	 * 新建
	 * @param ad
	 * @return
	 */
	public Integer add(Map<String,Object> map);
	/**
	 * 查询
	 * @param paramMap
	 * @return
	 */
	public List<ApplyDraw> query(Map<String, Object> paramMap);
	/**
	 * 查询单个
	 * @param paramMap
	 * @return
	 */
	public ApplyDraw get(String bm);
	/**
	 * 删除
	 * @param paramMap
	 * @return
	 */
	public Integer delete(Map<String, String> paramMap);
	/**
	 * 判断支取是否已经分摊 
	 * @param z011
	 * @return >0 为已经分摊 
	 */
	public Integer isShare(String z011);
	
	/**
	 * 根据编号获取支取申请信息
	 * @param bm
	 * @return
	 */
	public ApplyDraw getApplydrawWebByBm(String bm);

	/**
	 * 修改
	 * @param paramMap
	 * @return
	 */
	public Integer update(Map<String, String> paramMap);
}

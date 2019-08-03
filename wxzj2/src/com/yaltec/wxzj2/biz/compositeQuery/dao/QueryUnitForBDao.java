package com.yaltec.wxzj2.biz.compositeQuery.dao;

import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Repository;

import com.yaltec.wxzj2.biz.compositeQuery.entity.QueryUnitForB;
import com.yaltec.wxzj2.biz.draw.entity.CodeName;
/**
 * 单元余额查询操作接口
 * @author 亚亮科技有限公司.YL
 *
 * @version: 2017-6-30 下午04:48:18
 */
@Repository
public interface QueryUnitForBDao {
	
	public List<QueryUnitForB> queryQueryUnitForB(Map<String, Object> paramMap);

	public List<QueryUnitForB> findQueryUnitForB(Map<String, Object> paramMap);
	/**
	 * 按银行查询项目
	 * @param yhbh
	 * @return
	 */
	public List<CodeName> queryProjectByBank(Map<String, String> paramMap);
	/**
	 * 按银行查询小区
	 * @param yhbh
	 * @return
	 */
	public List<CodeName> queryCommunityByBank(Map<String, String> paramMap);
}

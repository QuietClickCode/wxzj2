package com.yaltec.wxzj2.biz.compositeQuery.service.Impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.compositeQuery.dao.QueryUnitForBDao;
import com.yaltec.wxzj2.biz.compositeQuery.entity.QueryUnitForB;
import com.yaltec.wxzj2.biz.compositeQuery.service.QueryUnitForBService;
import com.yaltec.wxzj2.biz.draw.entity.CodeName;

/**
 * <p>
 * ClassName: QueryUnitForBServiceImpl
 * </p>
 * <p>
 * Description: 单元余额查询模块服务实现类
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author moqian
 * @date 2016-8-23 上午09:12:03
 */

@Service
public class QueryUnitForBServiceImpl implements QueryUnitForBService {
	
	@Autowired
	private QueryUnitForBDao queryUnitForBDao;	
	/**
	 * 查询所有单元余额信息
	 */
	@Override	
	public void queryQueryUnitForB(Page<QueryUnitForB> page, Map<String, Object> paramMap) {
		try {
			// 根据页面传入的map查询数据
			List<QueryUnitForB> list = queryUnitForBDao.queryQueryUnitForB(paramMap);
			page.setDataByList(list, page.getPageNo(), page.getPageSize());
		} catch (Exception e) {
			e.printStackTrace();
		}				
	}
	
	public List<QueryUnitForB> findQueryUnitForB(Map<String, Object> paramMap) {
		return queryUnitForBDao.findQueryUnitForB(paramMap);
	}
	/**
	 * 按银行查询小区
	 * @param yhbh
	 * @return
	 */
	@Override
	public List<CodeName> queryCommunityByBank(String yhbh) {
		Map<String, String> map = new HashMap<String, String>();
		map.put("yhbh", yhbh);
		return queryUnitForBDao.queryCommunityByBank(map);
	}
	/**
	 * 按银行查询项目
	 * @param yhbh
	 * @return
	 */
	@Override
	public List<CodeName> queryProjectByBank(String yhbh) {
		Map<String, String> map = new HashMap<String, String>();
		map.put("yhbh", yhbh);
		return queryUnitForBDao.queryProjectByBank(map);
	}

}

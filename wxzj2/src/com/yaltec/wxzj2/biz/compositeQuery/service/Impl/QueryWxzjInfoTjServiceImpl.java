package com.yaltec.wxzj2.biz.compositeQuery.service.Impl;

import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.compositeQuery.dao.QueryWxzjInfoTjDao;
import com.yaltec.wxzj2.biz.compositeQuery.entity.WxzjInfoTj;
import com.yaltec.wxzj2.biz.compositeQuery.service.QueryWxzjInfoTjService;

/**
 * <p>
 * ClassName: QueryWxzjInfoTjServiceImpl
 * </p>
 * <p>
 * Description: 信息统计查询模块服务实现类
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author moqian
 * @date 2016-8-29 上午09:12:03
 */

@Service
public class QueryWxzjInfoTjServiceImpl implements QueryWxzjInfoTjService {
	
	@Autowired
	private QueryWxzjInfoTjDao queryWxzjInfoTjDao;	
	/**
	 * 查询所有信息统计查询信息
	 */
	@Override	
	public void QueryWxzjInfoTj(Page<WxzjInfoTj> page, Map<String, Object> paramMap) {
		try {
			// 根据页面传入的map查询数据
			List<WxzjInfoTj> list = queryWxzjInfoTjDao.QueryWxzjInfoTj(paramMap);
			page.setDataByList(list, page.getPageNo(), page.getPageSize());
		} catch (Exception e) {
			e.printStackTrace();
		}				
	}
	
	public List<WxzjInfoTj> findWxzjInfoTj(Map<String, Object> map) {
		return queryWxzjInfoTjDao.findWxzjInfoTj(map);
	}

}

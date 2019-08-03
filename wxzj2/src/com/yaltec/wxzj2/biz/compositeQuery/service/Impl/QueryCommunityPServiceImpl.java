package com.yaltec.wxzj2.biz.compositeQuery.service.Impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.compositeQuery.dao.QueryCommunityPDao;
import com.yaltec.wxzj2.biz.compositeQuery.entity.ByCommunityForB;
import com.yaltec.wxzj2.biz.compositeQuery.entity.QueryCommunityP;
import com.yaltec.wxzj2.biz.compositeQuery.service.QueryCommunityPService;

/**
 * <p>
 * ClassName: QueryCommunityPServiceImpl
 * </p>
 * <p>
 * Description: 小区缴款查询服务实现类
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author jiangyong
 * @date 2018-8-3 上午10:44:58
 */
@Service
public class QueryCommunityPServiceImpl implements QueryCommunityPService {

	@Autowired
	private QueryCommunityPDao queryCommunityPDao;

	@Override
	public void findList(Page<QueryCommunityP> page,
			Map<String, Object> paramMap) {
		List<QueryCommunityP> list = queryCommunityPDao.findList(paramMap);
		page.setDataByList(list, page.getPageNo(), page.getPageSize());
	}

	@Override
	public List<QueryCommunityP> findList(Map<String, Object> paramMap) {
		return queryCommunityPDao.findList(paramMap);
	}

	public List<QueryCommunityP> findByCommunityP(Map<String, Object> paramMap) {
		return queryCommunityPDao.findList(paramMap);
	}
}

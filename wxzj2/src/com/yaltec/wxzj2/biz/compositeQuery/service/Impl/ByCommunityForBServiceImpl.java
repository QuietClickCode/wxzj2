package com.yaltec.wxzj2.biz.compositeQuery.service.Impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.compositeQuery.dao.ByCommunityForBDao;
import com.yaltec.wxzj2.biz.compositeQuery.entity.ByCommunityForB;
import com.yaltec.wxzj2.biz.compositeQuery.service.ByCommunityForBService;
import com.yaltec.wxzj2.biz.draw.entity.CodeName;

/**
 * <p>
 * ClassName: ByCommunityForBServiceImpl
 * </p>
 * <p>
 * Description: 小区余额查询模块服务实现类
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author moqian
 * @date 2016-8-9 下午14:12:03
 */

@Service
public class ByCommunityForBServiceImpl implements ByCommunityForBService {
	
	@Autowired
	private ByCommunityForBDao byCommunityForBDao;
	
	/**
	 * 小区余额查询
	 */
	@Override	
	public void queryByCommunityForB(Page<ByCommunityForB> page, Map<String, Object> paramMap) {
		try {
			// 根据页面传入的map查询数据
			List<ByCommunityForB> list = byCommunityForBDao.queryByCommunityForB(paramMap);
			page.setDataByList(list, page.getPageNo(), page.getPageSize());
		} catch (Exception e) {
			e.printStackTrace();
		}				
	}

	public List<CodeName> queryOpenCommunityByBank(Map<String, String> map) {
		return byCommunityForBDao.queryOpenCommunityByBank(map);
	}
	
	public List<ByCommunityForB> findByCommunityForB(Map<String, Object> paramMap) {
		return byCommunityForBDao.findByCommunityForB(paramMap);
	}

}

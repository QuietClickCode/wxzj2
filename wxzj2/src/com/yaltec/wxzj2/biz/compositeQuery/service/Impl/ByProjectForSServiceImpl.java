package com.yaltec.wxzj2.biz.compositeQuery.service.Impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.compositeQuery.dao.ByProjectForSDao;
import com.yaltec.wxzj2.biz.compositeQuery.entity.ByBuildingForC1;
import com.yaltec.wxzj2.biz.compositeQuery.service.ByProjectForSService;

/**
 * <p>
 * ClassName: ByProjectForSServiceImpl
 * </p>
 * <p>
 * Description: 项目台账查询模块服务实现类
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author moqian
 * @date 2016-8-23 下午16:12:03
 */

@Service
public class ByProjectForSServiceImpl implements ByProjectForSService {
	
	@Autowired
	private ByProjectForSDao byProjectForSDao;	
	/**
	 * 查询所有项目台账信息
	 */
	@Override	
	public void queryByProjectForS(Page<ByBuildingForC1> page, Map<String, Object> paramMap) {
		try {
			// 根据页面传入的map查询数据
			List<ByBuildingForC1> list = byProjectForSDao.queryByProjectForS(paramMap);
			page.setDataByList(list, page.getPageNo(), page.getPageSize());
		} catch (Exception e) {
			e.printStackTrace();
		}				
	}
	
	public List<ByBuildingForC1> findByProjectForS(Map<String, Object> paramMap) {
		return byProjectForSDao.findByProjectForS(paramMap);
	}

}

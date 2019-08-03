package com.yaltec.wxzj2.biz.compositeQuery.service.Impl;

import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.compositeQuery.dao.ByProjectBPSDao;
import com.yaltec.wxzj2.biz.compositeQuery.entity.ByProjectBPS;
import com.yaltec.wxzj2.biz.compositeQuery.service.ByProjectBPSService;
import com.yaltec.wxzj2.biz.property.entity.House;

/**
 * <p>
 * ClassName: ByProjectBPSServiceImpl
 * </p>
 * <p>
 * Description: 项目收支统计模块服务实现类
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author moqian
 * @date 2016-8-26 下午16:12:03
 */

@Service
public class ByProjectBPSServiceImpl implements ByProjectBPSService {
	
	@Autowired
	private ByProjectBPSDao byProjectBPSDao;	
	/**
	 * 查询所有项目收支统计信息
	 */
	@Override	
	public void queryByProjectBPS(Page<ByProjectBPS> page, Map<String, Object> paramMap) {
		try {
			// 根据页面传入的map查询数据
			List<ByProjectBPS> list = byProjectBPSDao.queryByProjectBPS(paramMap);
			page.setDataByList(list, page.getPageNo(), page.getPageSize());
		} catch (Exception e) {
			e.printStackTrace();
		}				
	}

	public List<ByProjectBPS> findProjectBPS(Map<String, String> paramMap) {
		return byProjectBPSDao.findProjectBPS(paramMap);
	}

}

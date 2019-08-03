package com.yaltec.wxzj2.biz.compositeQuery.service.Impl;

import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.compositeQuery.dao.CalBYAreaDao;
import com.yaltec.wxzj2.biz.compositeQuery.entity.MonthReportOfBank;
import com.yaltec.wxzj2.biz.compositeQuery.service.CalBYAreaService;

/**
 * <p>
 * ClassName: CalBYAreaServiceImpl
 * </p>
 * <p>
 * Description: 面积户数查询模块服务实现类
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author moqian
 * @date 2016-8-25 上午10:12:03
 */

@Service
public class CalBYAreaServiceImpl implements CalBYAreaService {
	
	@Autowired
	private CalBYAreaDao calBYAreaDao;	
	/**
	 * 查询所有面积户数查询信息
	 */
	@Override	
	public List<MonthReportOfBank> queryCalBYArea(Map<String, Object> paramMap) {
		List<MonthReportOfBank> list = null;
		try {
			// 根据页面传入的map查询数据
			list = calBYAreaDao.queryCalBYArea(paramMap);
		} catch (Exception e) {
			e.printStackTrace();
		}				
		return list;
	}
	
	public List<MonthReportOfBank> findCalBYArea(Map<String, String> map) {
		return calBYAreaDao.findCalBYArea(map);
	}

}

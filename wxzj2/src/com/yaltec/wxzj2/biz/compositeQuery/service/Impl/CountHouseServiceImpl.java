package com.yaltec.wxzj2.biz.compositeQuery.service.Impl;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.compositeQuery.dao.CountHouseDao;
import com.yaltec.wxzj2.biz.compositeQuery.entity.CountHouse;
import com.yaltec.wxzj2.biz.compositeQuery.service.CountHouseService;

/**
 * <p>
 * ClassName: CountHouseServiceImpl
 * </p>
 * <p>
 * Description: 户数统计查询模块服务实现类
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author moqian
 * @date 2016-8-25 上午09:12:03
 */

@Service
public class CountHouseServiceImpl implements CountHouseService {
	
	@Autowired
	private CountHouseDao countHouseDao;	
	/**
	 * 查询所有户数统计信息
	 */
	@Override	
	public void queryCountHouse(Page<CountHouse> page, Map<String, Object> paramMap) {
		try {
			// 根据页面传入的map查询数据
			List<CountHouse> list = countHouseDao.queryCountHouse(paramMap);
			page.setDataByList(list, page.getPageNo(), page.getPageSize());
		} catch (Exception e) {
			e.printStackTrace();
		}				
	}
	
	public List<CountHouse> findCountHouse(Map<String, Object> paramMap) {
		return countHouseDao.findCountHouse(paramMap);
	}

}

package com.yaltec.wxzj2.biz.property.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.github.pagehelper.PageHelper;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.comon.utils.StringUtil;
import com.yaltec.wxzj2.biz.comon.service.IdUtilService;
import com.yaltec.wxzj2.biz.property.dao.CommunityDao;
import com.yaltec.wxzj2.biz.property.dao.IndustryDao;
import com.yaltec.wxzj2.biz.property.entity.Community;
import com.yaltec.wxzj2.biz.property.entity.Industry;
import com.yaltec.wxzj2.biz.property.service.IndustryService;
import com.yaltec.wxzj2.comon.data.DataHolder;
import com.yaltec.wxzj2.comon.data.service.IndustryDataService;

/**
 * 
 * @ClassName: IndustryServiceImpl
 * @Description: TODO业委会service接口实现类
 * 
 * @author yangshanping
 * @date 2016-7-20 下午04:56:54
 */
@Service
public class IndustryServiceImpl implements IndustryService {

	@Autowired
	private IndustryDao industryDao;
	
	@Autowired
	private IdUtilService idUtilService;
	
	@Autowired
	private CommunityDao communityDao;
	
	@Override
	public void findAll(Page<Industry> page) {
		PageHelper.startPage(page.getPageNo(), page.getPageSize());
		List<Industry> list = industryDao.findAll(page.getQuery());
		page.setData(list);
	}
	public Industry find(Industry industry) {
		return industryDao.find(industry);
	}

	public Industry findByBm(Industry industry) {
		return industryDao.findByBm(industry);
	}

	public void save(Map<String, String> map) {
		try {
			industryDao.save(map);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void update(Map<String, String> map) {
		// 根据小区名称获取小区信息，并将小区编码赋给nbhdcame
		Community community=communityDao.findByMc(map.get("nbhdname"));
		map.put("nbhdcode", community.getBm());
		industryDao.save(map);
	}
	
	public int delIndustry(Map<String, String> paramMap) throws Exception {
		int result = -1;
		String bms = paramMap.get("bm");
		String[] paras = bms.split(",");
		// 删除数据
		for (String bm : paras) {
			paramMap.put("bm", bm);
			industryDao.delIndustry(paramMap);
			result = Integer.valueOf(paramMap.get("result"));
			if (result == 0) {
				// 更新缓存
				DataHolder.updateDataMap(IndustryDataService.KEY, bm);
			}
			if (result == 1) {
				throw new Exception("删除失败，该业委会信息已启用！");
			} else if (result != 0) {
				throw new Exception("删除失败！");
			}
		}
		return result;
	}

	public String IsYWHOnXQ(Map<String,String> map){
		String bm;
		try {
			// 判断Map集合中bm是否为空，如果为空，则获取业委会表中下一个bm
			if(StringUtil.isEmpty(map.get("bm"))){
				bm = idUtilService.getNextBm("CommitTee");
				map.put("bm",bm);
			}
			// 根据小区编码获取小区信息，并将小区名称赋给nbhdName
			Community community=communityDao.findByBm(map.get("nbhdcode"));
			map.put("nbhdname", community.getMc());
			return industryDao.IsYWHOnXQ(map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "";
	}
	
	public int delete(Map<String,String> paramMap) {
		return industryDao.delIndustry(paramMap);
	}
}

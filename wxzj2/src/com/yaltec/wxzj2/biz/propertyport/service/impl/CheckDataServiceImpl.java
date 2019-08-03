package com.yaltec.wxzj2.biz.propertyport.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.yaltec.wxzj2.biz.propertyport.dao.CheckDataDao;
import com.yaltec.wxzj2.biz.propertyport.service.CheckDataService;

/**
 * 产权接口 房屋审核 Service接口实现类
 * @author 亚亮科技有限公司.YL
 *
 * @version: 2016-9-13 上午11:09:28
 */
@Service
public class CheckDataServiceImpl implements CheckDataService{

	@Autowired
	private CheckDataDao dao;

	
	/**
	 * 房屋信息查询
	 * @param map
	 * @return
	 */
	@Override
	public List<Map<String, String>> query(Map<String, Object> map) {
		return dao.query(map);
	}
	
	/**
	 * 执行传入的sql语句
	 * @param parasMap
	 * @return
	 */
	@Override
	public Integer exec(Map<String, Object> parasMap) {
		return dao.exec(parasMap);
	}

	/**
	 * 审核产权接口新建房屋
	 * @param map
	 * @return
	 */
	@Override
	public int checkFW(Map<String, Object> map) {
		String sqlstr = " delete from fids where xqbh='"+map.get("xqbh").toString()+"' and userid='"+map.get("userid").toString()+"' " +
			" insert into fids (fid,xqbh,userid,username,sys_remark) " +
			" select h051,'"+map.get("xqbh").toString()+"','"+map.get("userid").toString()+"','"+map.get("username").toString()+"','' " +
			" from house_temp where h051 in ("+map.get("h051s").toString()+") ";
		if(!"".equals(map.get("h051s").toString())){
			Map<String, Object> parasMap = new HashMap<String, Object>();
			parasMap.put("sqlstr", sqlstr);
			exec(parasMap);
		}
		map.put("nret", "-1");
		dao.checkFW(map);
		return Integer.valueOf(map.get("nret").toString());
	}

	/**
	 * 产权接口退回新建房屋到房屋同步中
	 * @param map
	 * @return
	 */
	@Override
	public int returnFW(Map<String, Object> map) {
		String sqlstr = " delete from fids where xqbh='"+map.get("xqbh").toString()+"' and userid='"+map.get("userid").toString()+"' " +
			" insert into fids (fid,xqbh,userid,username,sys_remark) " +
			" select h051,'"+map.get("xqbh").toString()+"','"+map.get("userid").toString()+"','"+map.get("username").toString()+"','' " +
			" from house_temp where h051 in ("+map.get("h051s").toString()+") ";
		if(!"".equals(map.get("h051s").toString())){
			Map<String, Object> parasMap = new HashMap<String, Object>();
			parasMap.put("sqlstr", sqlstr);
			exec(parasMap);
		}
		map.put("nret", "-1");
		dao.returnFW(map);
		return Integer.valueOf(map.get("nret").toString());
	}
	
}

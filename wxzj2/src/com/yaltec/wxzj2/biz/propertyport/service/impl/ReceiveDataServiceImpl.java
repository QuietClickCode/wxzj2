package com.yaltec.wxzj2.biz.propertyport.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.yaltec.wxzj2.biz.comon.service.IdUtilService;
import com.yaltec.wxzj2.biz.propertyport.dao.ReceiveDataDao;
import com.yaltec.wxzj2.biz.propertyport.service.ReceiveDataService;

/**
 * 产权接口 Service接口实现类
 * @author 亚亮科技有限公司.YL
 *
 * @version: 2016-9-13 上午11:09:28
 */
@Service
public class ReceiveDataServiceImpl implements ReceiveDataService{

	@Autowired
	private ReceiveDataDao dao;
	@Autowired
	private IdUtilService idUtilService;

	/**
	 * 楼宇数据关联
	 * @param map
	 * @return
	 */
	@Override
	public int mergeLY(Map<String, Object> map) {
		return dao.mergeLY(map);
	}
	/**
	 * 小区数据关联
	 * @param map
	 * @return
	 */
	@Override
	public int mergeXQ(Map<String, Object> map) {
		return dao.mergeXQ(map);
	}
	/**
	 * 楼宇信息查询
	 * @param map
	 * @return
	 */
	@Override
	public List<Map<String, String>> queryPortReceiveDataB(Map<String, Object> map) {
		return dao.queryPortReceiveDataB(map);
	}
	/**
	 * 房屋信息查询
	 * @param map
	 * @return
	 */
	@Override
	public List<Map<String, String>> queryPortReceiveDataH(Map<String, Object> map) {
		return dao.queryPortReceiveDataH(map);
	}
	/**
	 * 小区信息查询
	 * @param map
	 * @return
	 */
	@Override
	public List<Map<String, String>> queryPortReceiveDataN(Map<String, Object> map) {
		return dao.queryPortReceiveDataN(map);
	}

	/**
	 * 项目信息查询
	 * @param map
	 * @return
	 */
	@Override
	public List<Map<String, String>> queryPortReceiveDataP(Map<String, Object> map) {
		return dao.queryPortReceiveDataP(map);
	}
	/**
	 * 楼宇数据新建
	 * @param map
	 * @return
	 */
	@Override
	public int addLY(Map<String, Object> map) {
		dao.addLY(map);
		return Integer.valueOf(map.get("nret").toString());
	}
	/**
	 * 小区数据新建
	 * @param map
	 * @return
	 */
	@Override
	public int addXQ(Map<String, Object> map) {
		dao.addXQ(map);
		return Integer.valueOf(map.get("nret").toString());
	}
	
	/**
	 * 项目数据新建
	 * @param map
	 * @return
	 */
	@Override
	public int addXM(Map<String, Object> map) {
		try {
			// 获取当前数据库表可用BM
			String bm = idUtilService.getNextBm("Project");
			map.put("bm", bm);
			return dao.addXM(map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return 0;
	}
	/**
	 * 提交新增房屋数据到临时表
	 * @param map
	 * @return
	 */
	@Override
	public int receiveFW(Map<String, Object> map) {
		String sqlstr = " delete from fids where xqbh='"+map.get("xqbh").toString()+"' and userid='"+map.get("userid").toString()+"' " +
			" insert into fids (fid,xqbh,userid,username,sys_remark) " +
			" select fid,'"+map.get("xqbh").toString()+"','"+map.get("userid").toString()+"','"+map.get("username").toString()+"','' " +
			" from port_house where tbid in ("+map.get("xhs").toString()+") and f_status='0' and F_UPDATE_TYPE='1' and isnull(h001,'')=''";
		if(!"".equals(map.get("xhs").toString())){
			Map<String, Object> parasMap = new HashMap<String, Object>();
			parasMap.put("sqlstr", sqlstr);
			exec(parasMap);
		}
		dao.receiveFW(map);
		return Integer.valueOf(map.get("nret").toString());
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
	 * 同步产权接口变更的房屋
	 * @param map
	 * @return
	 */
	@Override
	public int syncFW(Map<String, Object> map) {
		String sqlstr = " delete from fids where xqbh='"+map.get("xqbh").toString()+"' and userid='"+map.get("userid").toString()+"' " +
			" insert into fids (fid,xqbh,userid,username,sys_remark) " +
			" select fid,'"+map.get("xqbh").toString()+"','"+map.get("userid").toString()+"','"+map.get("username").toString()+"','' " +
			" from port_house where tbid in ("+map.get("xhs").toString()+") and f_status='0' and F_UPDATE_TYPE='2' and isnull(h001,'')<>''";
		if(!"".equals(map.get("xhs").toString())){
			Map<String, Object> parasMap = new HashMap<String, Object>();
			parasMap.put("sqlstr", sqlstr);
			exec(parasMap);
		}
		map.put("nret", "-1");
		dao.syncFW(map);
		return Integer.valueOf(map.get("nret").toString());
	}
	
	/**
	 * 房屋对照（本地与回备）查询 
	 * @param tbid
	 * @return
	 */
	@Override
	public Map<String, String> queryContrast(String tbid) {
		return dao.queryContrast(tbid);
	}
	
}

package com.yaltec.wxzj2.biz.propertymanager.service.impl;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.yaltec.wxzj2.biz.draw.service.export.NormalExport;
import com.yaltec.wxzj2.biz.propertymanager.dao.HouseChangeDao;
import com.yaltec.wxzj2.biz.propertymanager.service.HouseChangeService;
/**
 * 产权管理 房屋变更 
 * @author 亚亮科技有限公司.YL
 *
 * @version: 2016-10-11 下午05:16:54
 */
@Service
public class HouseChangeServiceImpl implements HouseChangeService {
	
	private static final Logger logger = Logger.getLogger("HouseChangeServiceImpl");

	@Autowired
	private HouseChangeDao dao;

	
	/**
	 * 执行查询语句
	 * @return
	 */
	@Override
	public List<Map<String, String>> execQuery(Map<String, String> map) {
		return dao.execQuery(map);
	}

	/**
	 * 执行修改或插入语句
	 * @return
	 */
	@Override
	public Integer execUpdate(Map<String, String> map) {
		return dao.execUpdate(map);
	}

	/**
	 * 执行变更
	 * @return
	 */
	@Override
	public Integer executeChange(Map<String, String> map) {
		map.put("result", "-1");
		dao.executeChange(map);
		return Integer.valueOf(map.get("result").toString());
	}

	/**
	 * 查询临时表中的数据
	 * @return
	 */
	@Override
	public List<Map<String, String>> query(Map<String, String> map) {
		return dao.query(map);
	}

	/**
	 * 资金分摊 
	 * @return
	 */
	@Override
	public Integer share(Map<String, String> map) {
		map.put("result", "-1");
		dao.share(map);
		return Integer.valueOf(map.get("result"));
	}

	/**
	 * 房屋变更记录查询
	 * @param map
	 * @return
	 */
	@Override
	public List<Map<String, String>> queryHouseChange(Map<String, Object> map) {
		map.put("result", "-1");
		return dao.queryHouseChange(map);
	}
	/**
	 * 导出房屋变更记录
	 */	
	@Override
	public void export(Map<String, Object> map, HttpServletResponse response) {
		response.setCharacterEncoding("utf-8");
		map.put("result", "-1");
		String title = "房屋变更记录";

		String[] ZHT = { "数据类型","业务编号","楼宇名称","房屋编号", "单元", "层", "房号","建筑面积", 
				"业主姓名", "身份证号","应交资金", "本金", "利息", "合计", "操作人","业务日期"};
		String[] ENT = { "datatype", "ywbh", "lymc", "h001", "h002", "h003",
				"h005", "h006", "h013", "h015", "h021","bj","lx","hj","username","ywrq"};// 输出例
		List<Map<String,String>> list = null;
		try {
			list = dao.queryHouseChange(map);
			if (list.size() == 0) {
				NormalExport.exeException("获取数据失败！",response);
				return;
			}
			NormalExport.export(response, list, title, ZHT, ENT);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * 按业务编号删除房屋变更业务
	 * @return
	 */
	@Override
	public Integer delBusinessByP004(Map<String, String> map) {
		map.put("result", "-1");
		dao.delBusinessByP004(map);
		return Integer.valueOf(map.get("result").toString());
	}
}

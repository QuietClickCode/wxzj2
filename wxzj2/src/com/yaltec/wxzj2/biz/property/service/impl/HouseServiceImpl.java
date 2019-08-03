package com.yaltec.wxzj2.biz.property.service.impl;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.github.pagehelper.PageHelper;
import com.yaltec.comon.auth.TokenHolder;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.comon.utils.ObjectUtil;
import com.yaltec.wxzj2.biz.property.dao.BuildingDao;
import com.yaltec.wxzj2.biz.property.dao.HouseDao;
import com.yaltec.wxzj2.biz.property.entity.Building;
import com.yaltec.wxzj2.biz.property.entity.House;
import com.yaltec.wxzj2.biz.property.service.HouseService;
import com.yaltec.wxzj2.biz.system.entity.Parameter;
import com.yaltec.wxzj2.biz.system.service.ParameterService;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 
 * @ClassName: HouseServiceImpl
 * @Description: 房屋service接口实现类
 * 
 * @author yangshanping
 * @date 2016-7-25 上午09:48:35
 */
@Service
public class HouseServiceImpl implements HouseService {

	@Autowired
	private HouseDao houseDao;
	@Autowired
	private BuildingDao buildingDao;
	@Autowired
	private ParameterService parameterService;
	/**
	 * 日志记录器.
	 */
	private static final Logger logger = Logger.getLogger("HousePrint");

	@Override
	public void findAll(Page<House> page) {
		PageHelper.startPage(page.getPageNo(), page.getPageSize());
		List<House> list = houseDao.findAll(page.getQuery());
		page.setData(list);
	}

	public House findByH001(String h001) {
		return houseDao.findByH001(h001);
	}

	public int checkForDelHouse(String h001) {
		return houseDao.checkForDelHouse(h001);
	}

	public int delHouse(Map<String, String> paramMap) throws Exception {
		int result = -1;
		String bms = paramMap.get("bm");
		String[] paras = bms.split(",");
		for (String bm : paras) {
			paramMap.put("bm", bm);
			// 删除房屋信息之前判断改房屋是否已做业务
			if (houseDao.checkForDelHouse(paramMap.get("bm")) > 0) {
				result = 5;
				throw new Exception("删除失败，本房屋已做业务，不允许删除！");
			}
		}
		for (String bm : paras) {
			paramMap.put("bm", bm);
			houseDao.delHouse(paramMap);
			result = Integer.valueOf(paramMap.get("result"));
			if (result == 3) {
				throw new Exception("删除失败，请检查该数据是否存在！");
			} else if (result != 0) {
				throw new Exception("删除失败！");
			}
		}
		return result;
	}

	public int delete(Map<String, String> paramMap) {
		// 删除之前判断当前房屋是否已交款
		int result = houseDao.checkForDelHouse(paramMap.get("bm"));
		if (result >= 1) {
			paramMap.put("result", "5");
			return 5;
		}
		return houseDao.delHouse(paramMap);
	}

	public House findByLybh(String lybh) {
		return houseDao.findByLybh(lybh);
	}

	public void save(Map<String, String> map) {
		try {
			// 获取房屋编号
			Map<String, String> newMap = new HashMap<String, String>();
			newMap.put("lybh", map.get("lybh"));
			newMap.put("bm", "");
			houseDao.getHouseBm(newMap);
			map.put("h001", newMap.get("bm"));
			// 房屋地址
			StringBuffer h047 = new StringBuffer();
			h047.append(buildingDao.getAddressForBuilding(map.get("lybh")));
			h047.append(map.get("h002")).append("单元 ").append(map.get("h003")).append("层 ");
			h047.append(map.get("h005")).append("号");
			map.put("h047", h047.toString());
			// 判断是否交款金额四舍五入到元
			Parameter sysParam = parameterService.findByBm("05");
			if (sysParam.getSf().equals("1")) {
				String h021 = String.valueOf(Math.round(Double.valueOf(map.get("h021").toString())));
				map.put("h021", h021);
			}
			houseDao.save(map);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public String update(Map<String, String> map) {
		Building building = buildingDao.findByLymc(map.get("lymc"));
		map.put("lybh", building.getLybh());
		// 判断是否交款金额四舍五入到元
		Parameter sysParam = parameterService.findByBm("05");
		if (sysParam.getSf().equals("1")) {
			String h021 = String.valueOf(Math.round(Double.valueOf(map.get("h021").toString())));
			map.put("h021", h021);
		}
		return houseDao.save(map);
	}

	// 输出PDF
	public void output(ByteArrayOutputStream ops, HttpServletResponse response) {
		response.setContentType("application/pdf");

		response.setHeader("Cache-Control", "must-revalidate, post-check=0, pre-check=0");
		response.setHeader("Pragma", "public");
		response.setDateHeader("Expires", (System.currentTimeMillis() + 1000));

		response.setContentLength(ops.size());
		ServletOutputStream out = null;
		try {
			out = response.getOutputStream();
			ops.writeTo(out);
		} catch (IOException e) {
			logger.error(e.getMessage());
		} finally {
			try {
				if(!ObjectUtil.isEmpty(out)){
					out.flush();
				}
				out.close();
			} catch (IOException e) {
				logger.error(e.getMessage());
			}
		}
	}

	/**
	 * 房屋编号为空，根据楼宇编号查询房屋信息(产权变更)
	 */
	public void changePropertyLybh(Page<House> page) {
		PageHelper.startPage(page.getPageNo(), page.getPageSize());
		List<House> list = houseDao.changePropertyLybh(page.getQuery());
		page.setData(list);
	}

	/**
	 * 查询房屋信息-房屋编号不为空，根据房屋编号查询(产权变更)
	 */
	public void changePropertyH001(Page<House> page) {
		PageHelper.startPage(page.getPageNo(), page.getPageSize());
		List<House> list = houseDao.changePropertyH001(page.getQuery());
		page.setData(list);
	}

	/**
	 * 根据h001查询变更信息
	 */
	public House changeProperty_h001(String h001) {
		return houseDao.changeProperty_h001(h001);
	}

	/**
	 * 获取产权变更打印的信息
	 * 
	 * @param h001
	 * @return
	 */
	public House pdfChangeProperty(String h001) {
		return houseDao.pdfChangeProperty(h001);
	}

	public String getHouseBm(Map<String, String> map) {
		return houseDao.getHouseBm(map);
	}

	public House queryHouseInfoCount(Map<String, String> map) {
		return houseDao.queryHouseInfoCount(map);
	}

	@Override
	public void find(Page<House> page, Map<String, Object> paramMap) {
		PageHelper.startPage(page.getPageNo(), page.getPageSize());
		List<House> list = houseDao.find(paramMap);
		page.setData(list);
	}

	public House findByH001ForPDF(String h001) {
		return houseDao.findByH001ForPDF(h001);
	}

	@Override
	public House getHouseByH001(String h001) {
		return houseDao.getHouseByH001(h001);
	}

	@Override
	public List<House> findForLogout(House house) {
		return houseDao.findForLogout(house);
	}

	@Override
	public void findFast(Page<House> page, Map<String, Object> paramMap) {
		String _status = "";

		String unitcode = TokenHolder.getUser().getUnitcode();
		//判断状态
		if (paramMap.get("cxlb").equals("3")) {
			// 所有
			_status = "";
		} else if (paramMap.get("cxlb").equals("1")) {
			// 已交款
			_status = "1";
		} else {
			// -1：不交；0：未选择未交；2：已选择未交款
			_status = paramMap.get("cxlb").toString();
		}
		paramMap.put("status", _status);
		paramMap.put("unitcode", unitcode);

		PageHelper.startPage(page.getPageNo(), page.getPageSize());
		List<House> list = houseDao.queryHouseUnit(paramMap);
		Map<String,String> dMap = DataHolder.dataMap.get("deposit");
		for (House house : list) {
			house.setH023(dMap.get(house.getH022()));
		}
		page.setData(list);
		
	}

	@Override
	public int sumDraw() {
		return houseDao.sumDraw();
	}
	
	
	/**
	 * 查询房屋信息-业主姓名不为空，根据业主姓名查询(产权变更)
	 */
	public void changePropertyH013(Page<House> page) {
		PageHelper.startPage(page.getPageNo(), page.getPageSize());
		List<House> list = houseDao.changePropertyH013(page.getQuery());
		page.setData(list);
	}
	
	
//	@Override
//	public void findFast(Page<House> page, Map<String, Object> paramMap) {
//		String sqlStr = "";
//		String sqlStrCount = "";
//		String sqlCondition = "";
//
//		String unitcode = TokenHolder.getUser().getUnitcode();
//
//		if (paramMap.get("cxlb").equals("3")) {
//			// 所有
//			sqlStr = "select a.*,c.status,(a.h030+a.h031) as ye, convert(char(10),a.h020,120) h0201,h0231= (case xm when '00' then '房款' when '01' then '面积' end)+'|'+convert(char(6),xs),a.h030 as sjje,c.h052,c.h053,(a.h041+a.h042) as ljje from house a,house_dw c, Deposit b ";
//			sqlStrCount = "select count(a.h001) from house a,house_dw c, Deposit b ";
//			if (paramMap.get("xqbh").equals("")) {
//				sqlCondition = "where a.h001=c.h001 and (a.lybh like '%" + paramMap.get("lybh")
//						+ "%') and (a.h035='正常') and (a.h013 like '%" + paramMap.get("h013")
//						+ "%')  and  (c.h047 like '%" + paramMap.get("h047") + "%') and  (a.h015 like '%"
//						+ paramMap.get("h015") + "%') and  (a.h022 like '%" + paramMap.get("h022")
//						+ "%') and  (c.h049 like '%" + paramMap.get("h049") + "%') and (a.h020>='"
//						+ paramMap.get("begindate") + "' and a.h020<=DateAdd(dd,1,'" + paramMap.get("enddate")
//						+ "')) and a.h022=b.bm";
//			} else if (paramMap.get("lybh").equals("")) {
//				sqlCondition = "where a.h001=c.h001 and a.lybh in (select lybh from SordineBuilding where xqbh='"
//						+ paramMap.get("xqbh") + "') and (a.h035='正常' ) and  (a.h013 like '%" + paramMap.get("h013")
//						+ "%') and  (c.h047 like '%" + paramMap.get("h047") + "%') and  (a.h015 like '%"
//						+ paramMap.get("h015") + "%') and  (a.h022 like '%" + paramMap.get("h022")
//						+ "%') and  (c.h049 like '%" + paramMap.get("h049") + "%') and (a.h020>='"
//						+ paramMap.get("begindate") + "' and a.h020<=DateAdd(dd,1,'" + paramMap.get("enddate")
//						+ "')) and a.h022=b.bm";
//			} else {
//				sqlCondition = "where a.h001=c.h001 and a.lybh='" + paramMap.get("lybh")
//						+ "' and (a.h035='正常') and (a.h013 like '%" + paramMap.get("h013")
//						+ "%')  and  (c.h047 like '%" + paramMap.get("h047") + "%') and  (a.h015 like '%"
//						+ paramMap.get("h015") + "%') and  (a.h022 like '%" + paramMap.get("h022")
//						+ "%') and  (c.h049 like '%" + paramMap.get("h049") + "%') and (a.h020>='"
//						+ paramMap.get("begindate") + "' and a.h020<=DateAdd(dd,1,'" + paramMap.get("enddate")
//						+ "')) and a.h022=b.bm";
//			}
//		} else if (paramMap.get("cxlb").equals("1")) {
//			// 已交款
//			sqlStr = "select a.*,c.status,(a.h030+a.h031) as ye, convert(char(10),a.h020,120) h0201,h0231= (case xm when '00' then '房款' when '01' then '面积' end)+'|'+convert(char(6),xs),a.h030 as sjje,c.h052,c.h053,(a.h041+a.h042) as ljje from house a,house_dw c, Deposit b ";
//			sqlStrCount = "select count(a.h001) from house a,house_dw c, Deposit b ";
//			if (paramMap.get("xqbh").equals("")) {
//				sqlCondition = "where a.h001=c.h001 and (a.lybh like '%" + paramMap.get("lybh")
//						+ "%') and (a.h035='正常') and  (a.h013 like '%" + paramMap.get("h013")
//						+ "%')  and (c.h047 like '%" + paramMap.get("h047") + "%') and  (a.h015 like '%"
//						+ paramMap.get("h015") + "%')  and (a.h022 like '%" + paramMap.get("h022")
//						+ "%') and  (c.h049 like '%" + paramMap.get("h049") + "%')  and  c.status=1   and a.h020>='"
//						+ paramMap.get("begindate") + "' and a.h020<=DateAdd(dd,1,'" + paramMap.get("enddate")
//						+ "') and a.h022=b.bm";
//			} else if (paramMap.get("lybh").equals("")) {
//				sqlCondition = "where a.h001=c.h001 and (a.lybh in (select lybh from SordineBuilding where xqbh='"
//						+ paramMap.get("xqbh") + "')) and (a.h035='正常') and  (a.h013 like '%" + paramMap.get("h013")
//						+ "%')  and (c.h047 like '%" + paramMap.get("h047") + "%') and  (a.h015 like '%"
//						+ paramMap.get("h015") + "%')  and (a.h022 like '%" + paramMap.get("h022")
//						+ "%') and  (c.h049 like '%" + paramMap.get("h049") + "%')  and  c.status=1  and a.h020>='"
//						+ paramMap.get("begindate") + "' and a.h020<=DateAdd(dd,1,'" + paramMap.get("enddate")
//						+ "') and a.h022=b.bm";
//			} else {
//				sqlCondition = "where a.h001=c.h001 and a.lybh='" + paramMap.get("lybh")
//						+ "' and (a.h035='正常') and  (a.h013 like '%" + paramMap.get("h013")
//						+ "%')  and (c.h047 like '%" + paramMap.get("h047") + "%') and  (a.h015 like '%"
//						+ paramMap.get("h015") + "%')  and (a.h022 like '%" + paramMap.get("h022")
//						+ "%') and  (c.h049 like '%" + paramMap.get("h049") + "%')  and  c.status=1  and a.h020>='"
//						+ paramMap.get("begindate") + "' and a.h020<=DateAdd(dd,1,'" + paramMap.get("enddate")
//						+ "') and a.h022=b.bm";
//			}
//		} else {
//			// -1：不交；0：未选择未交；2：已选择未交款
//			sqlStr = "select a.*,(a.h030+a.h031) as ye, convert(char(10),a.h020,120) h0201,h0231= (case xm when '00' then '房款' when '01' then '面积' end)+'|'+convert(char(6),xs),a.h030 as sjje,(a.h041+a.h042) as ljje from house_dw a, Deposit b ";
//			sqlStrCount = "select count(a.h001) from house_dw a, Deposit b ";
//			if (paramMap.get("xqbh").equals("")) {
//				sqlCondition = "where (a.lybh like '%" + paramMap.get("lybh")
//						+ "%') and (a.h035='正常') and  (a.h013 like '%" + paramMap.get("h013")
//						+ "%')  and (a.h047 like '%" + paramMap.get("h047") + "%') and  (a.h015 like '%"
//						+ paramMap.get("h015") + "%') and  (a.h022 like '%" + paramMap.get("h022")
//						+ "%') and  (a.h049 like '%" + paramMap.get("h049") + "%') and a.status="
//						+ paramMap.get("cxlb") + "  and a.h020>='" + paramMap.get("begindate")
//						+ "' and a.h020<=DateAdd(dd,1,'" + paramMap.get("enddate") + "') and a.h022=b.bm";
//			} else if (paramMap.get("lybh").equals("")) {
//				sqlCondition = "where (a.lybh in (select lybh from SordineBuilding where xqbh='" + paramMap.get("xqbh")
//						+ "')) and (a.h035='正常') and  (a.h013 like '%" + paramMap.get("h013")
//						+ "%')  and (a.h047 like '%" + paramMap.get("h047") + "%') and  (a.h015 like '%"
//						+ paramMap.get("h015") + "%') and  (a.h022 like '%" + paramMap.get("h022")
//						+ "%') and  (a.h049 like '%" + paramMap.get("h049") + "%') and a.status="
//						+ paramMap.get("cxlb") + "  and a.h020>='" + paramMap.get("begindate")
//						+ "' and a.h020<=DateAdd(dd,1,'" + paramMap.get("enddate") + "') and a.h022=b.bm ";
//			} else {
//				sqlCondition = "where a.lybh='" + paramMap.get("lybh") + "' and (a.h035='正常') and  (a.h013 like '%"
//						+ paramMap.get("h013") + "%')  and (a.h047 like '%" + paramMap.get("h047")
//						+ "%') and  (a.h015 like '%" + paramMap.get("h015") + "%') and  (a.h022 like '%"
//						+ paramMap.get("h022") + "%') and  (a.h049 like '%" + paramMap.get("h049")
//						+ "%') and a.status=" + paramMap.get("cxlb") + " and a.h020>='" + paramMap.get("begindate")
//						+ "' and a.h020<=DateAdd(dd,1,'" + paramMap.get("enddate") + "') and a.h022=b.bm";
//			}
//		}
//		// 公共条件
//		sqlCondition = sqlCondition + "  and a.h001 like '%" + paramMap.get("h001") + "%' and (" + unitcode
//				+ "='00' or h049=" + unitcode + ") ";
//		// 排序
//		sqlStr = sqlStr + sqlCondition
//				+ " order by a.h002,convert(int,isnull(h053,1)),convert(int,isnull(h052,1)),a.h003,a.h005,a.h001";
//
//		sqlStrCount = sqlStrCount + sqlCondition + " and a.h001 like '%" + paramMap.get("h001") + "%' and (" + unitcode
//				+ "='00' or h049=" + unitcode + ")";
//		Map<String, Object> map = new HashMap<String, Object>();
//		map.put("sqlStr", sqlStr);
//		List<House> resultList = houseDao.queryHouseUnit(map);
//		page.setDataByList(resultList, page.getPageNo(), page.getPageSize());
//		// String count = (String) logicService.getobject("queryHouseUnitCount",
//		// sqlStrCount);
//	}
}

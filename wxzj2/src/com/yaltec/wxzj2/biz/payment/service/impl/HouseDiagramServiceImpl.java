package com.yaltec.wxzj2.biz.payment.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.github.pagehelper.PageHelper;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.comon.utils.ObjectUtil;
import com.yaltec.comon.utils.StringUtil;
import com.yaltec.wxzj2.biz.payment.dao.HouseDiagramDao;
import com.yaltec.wxzj2.biz.payment.entity.Diagram;
import com.yaltec.wxzj2.biz.payment.entity.DiagramBuilding;
import com.yaltec.wxzj2.biz.payment.entity.DiagramFloor;
import com.yaltec.wxzj2.biz.payment.entity.DiagramH002;
import com.yaltec.wxzj2.biz.payment.entity.DiagramHouse;
import com.yaltec.wxzj2.biz.payment.entity.DiagramUnit;
import com.yaltec.wxzj2.biz.payment.entity.HouseDw;
import com.yaltec.wxzj2.biz.payment.service.HouseDiagramService;
import com.yaltec.wxzj2.biz.property.dao.HouseDwDao;

/**
 * 楼盘信息service实现
 * 
 * @ClassName: HouseDiagramServiceImpl
 * @author 重庆亚亮科技有限公司 txj
 * @date 2016-8-29 下午02:55:51
 */
@Service
public class HouseDiagramServiceImpl implements HouseDiagramService {
	@Autowired
	private HouseDwDao houseDwDao;
	@Autowired
	private HouseDiagramDao houseDiagramDao;
	public static List<List<?>> lists = new ArrayList<List<?>>();

	/**
	 * 楼盘显示信息
	 */
	@Override
	public Map<String, Object> getShowTableByLR(Map<String, Object> map) {
		List<DiagramH002> h002List = null;
		List<DiagramHouse> houselist = null;
		try {
			// 显示的楼宇数量
			int pageSize = Integer.valueOf(map.get("pageSize").toString());
			// 获取的次数
			int pageNum = Integer.valueOf(map.get("pageNum").toString());
			// 存放要显示的楼宇
			List<String> lyList = new ArrayList<String>();
			// 总页数
			int num_sum = 0;
			if(map.get("lybh").equals("")){		
				Page<String> page = new Page<String>(null, pageNum, pageSize);
				PageHelper.startPage(page.getPageNo(), page.getPageSize());
				lyList = houseDwDao.queryBuildingDiagram(map);
				page.setData(lyList);
				num_sum = page.getTotalPage();
			}else{
				num_sum = 1;
				lyList.add(map.get("lybh").toString());
			}			
			map.put("num_sum", num_sum);
			
			String lybhs = StringUtil.toDelimitedString(lyList, "','");
			lybhs = "'" + lybhs + "'";
			map.put("lybhs", lybhs);
			
			// 获取小区或者楼宇下所有的房屋信息
			if (map.get("status").toString().equals("0")) {// 未选择未交
				houselist = houseDwDao.getHouseInfoByXqLyByLr_status_0(map);
			} else {// 所有
				houselist = houseDwDao.getHouseInfoByXqLyByLr_all(map);
			}
			if (!ObjectUtil.isEmpty(houselist)) {
				// 取得小区或者楼宇下的单元列表信息
				if (map.get("isPropertyport").equals("1")) {
					h002List = houseDwDao.geth002ListByXqLy(map);
				} else {
					h002List = houseDwDao.geth002ListByXqLyByLr(map);
				}
				// 单元下某一层最大的房屋数量
				Map<String, String> h002Map = new HashMap<String, String>();
				for (DiagramH002 diagramH002: h002List) {
					h002Map.put(diagramH002.getLybh()+diagramH002.getH002(), diagramH002.getH005());
				}
				// 转换数据结构
				Diagram diagram = convert2Diagram(houselist, h002Map);
				
				map.put("diagram", diagram);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return map;
	}
	
	/**
	 * 房屋转换为特定结构的楼盘数据
	 * @param houses
	 */
	private Diagram convert2Diagram(List<DiagramHouse> houses, Map<String, String> h002Map) {
		Diagram diagram = new Diagram();
		List<DiagramBuilding> buildingList = new ArrayList<DiagramBuilding>();
		diagram.setBuildings(buildingList);
		List<DiagramUnit> unitList = null;
		List<DiagramFloor> floorList = null;
		List<DiagramHouse> houseList = null;
		
		Map<String, DiagramBuilding> buildingMap = new HashMap<String, DiagramBuilding>();
		Map<String, DiagramUnit> unitMap = new HashMap<String, DiagramUnit>();
		Map<String, DiagramFloor> floorMap = new HashMap<String, DiagramFloor>();
		
		for (DiagramHouse diagramHouse : houses) {
			// 新的楼宇
			if (!buildingMap.containsKey(diagramHouse.getLybh())) {
				
				// 新建楼宇
				DiagramBuilding building = new DiagramBuilding(diagramHouse.getLybh(),diagramHouse.getLymc());
				buildingMap.put(diagramHouse.getLybh(), building);
				// 添加到集合中
				buildingList.add(building);
				// 清空单元数据
				unitMap.clear();
				unitList = new ArrayList<DiagramUnit>();
				lists.add(unitList);
				building.setUnits(unitList);
			}
			
			// 新的单元
			if (!unitMap.containsKey(diagramHouse.getH002())) {
				
				// 新建单元
				DiagramUnit unit = new DiagramUnit(diagramHouse.getH002());
				// 设置单元层最大房屋数量
				if (h002Map.containsKey(diagramHouse.getLybh()+diagramHouse.getH002())) {
					String maxRoom = h002Map.get(diagramHouse.getLybh()+diagramHouse.getH002());
					unit.setMaxRoom(Integer.valueOf(maxRoom));
				}
				
				unitMap.put(diagramHouse.getH002(), unit);
				// 添加到集合
				unitList.add(unit);
				// 清空层数据
				floorMap.clear();
				floorList = new ArrayList<DiagramFloor>();
				lists.add(floorList);
				unit.setFloors(floorList);
			}
			
			// 新的层
			if (!floorMap.containsKey(diagramHouse.getH003())) {
				// 新建层
				DiagramFloor floor = new DiagramFloor(diagramHouse.getH003());
				floorMap.put(diagramHouse.getH003(), floor);
				// 添加到集合
				floorList.add(floor);
				// 清空房屋数据
				houseList = new ArrayList<DiagramHouse>();
				lists.add(houseList);
				floor.setHouses(houseList);
			}
			houseList.add(diagramHouse);
			// 状态为0, 判断楼宇、单元、层是否添加多选框(只对未选择未交的房屋生效)
			if (diagramHouse.getStatus().equals("0")) {
				if (floorList.get(floorList.size() -1).getIsCheck() == 0) {
					floorList.get(floorList.size() -1).setIsCheck(1);
					unitList.get(unitList.size() -1).setIsCheck(1);
					buildingList.get(buildingList.size() -1).setIsCheck(1);
				}
			}
			diagramHouse.setH013(diagramHouse.getH013().replace(",", "").
					replace(";", "").replace("，", "").replace("；", "").replace("、", ""));
		}
		buildingMap.clear();
		unitMap.clear();
		floorMap.clear();
		return diagram;
	}

	/**
	 * 显示合计
	 * 
	 * @param map
	 * @return
	 */
	public void getShowTableSum(Map<String, Object> map) {
		try {
			// 显示的楼宇数量
			int pageSize = Integer.valueOf(map.get("pageSize").toString());
			// 总页数
			int num_sum = 0;
			if(map.get("lybh").equals("")){
				Page<String> page = new Page<String>(null, 1, pageSize);
				PageHelper.startPage(page.getPageNo(), page.getPageSize());
				List<String> lyList = houseDwDao.queryBuildingDiagram(map);
				page.setData(lyList);
				num_sum = page.getTotalPage();
			}else{
				num_sum = 1;
			}			
			map.put("num_sum", num_sum);
			// 获取统计信息
			HouseDw house_sum = houseDwDao.getHouseDiagramSum_house(map);
			HouseDw _houseDw = houseDwDao.getHouseDiagramSum_h021(map);
			// 非物管房的应交资金、应交面积
			String h021 = _houseDw.getH021();
			String _h006 = _houseDw.getH006();
			String h014 = houseDwDao.getHouseDiagramSum_h014(map);
			List<Map<String, Short>> listMap = houseDwDao.getHouseDiagramSum_count(map);
			String h011 = "0";
			String h012 = "0";
			String h013 = "0";
			String h015 = "0";
			// 记录各种状态的房屋数量
			for(Map<String, Short> ctMap: listMap) {
				if (ctMap.get("status") == -1) {
					h011 = String.valueOf(ctMap.get("ct"));
				} else if (ctMap.get("status") == 0) {
					h012 = String.valueOf(ctMap.get("ct"));
				} else if (ctMap.get("status") == 2) {
					h013 = String.valueOf(ctMap.get("ct"));
				} else if (ctMap.get("status") == 1) {
					h015 = String.valueOf(ctMap.get("ct"));
				}
			}
			house_sum.setH011(h011);
			house_sum.setH012(h012);
			house_sum.setH013(h013);
			house_sum.setH015(h015);
			house_sum.setH014(h014);
			house_sum.setH021(h021);

			int num_yj = Integer.valueOf(house_sum.getH015())
					- Integer.valueOf(house_sum.getH014());
			map.put("num_yj", num_yj);
			map.put("num_yxwj", house_sum.getH013());
			map.put("num_wxwj", house_sum.getH012());
			map.put("num_bz", house_sum.getH014());
			map.put("num_bj", house_sum.getH011());

			map.put("sum_h001", house_sum.getH001());
			map.put("sum_h006", house_sum.getH006());
			// 非物管房的应交面积 ，应交户数
			map.put("_sum_h006", _h006);
			Integer _h001 = Integer.valueOf(house_sum.getH001()) - Integer.valueOf(h011);
			map.put("_sum_h001", _h001);
			map.put("sum_h030", house_sum.getH030());
			map.put("sum_h031", house_sum.getH031());
			map.put("sum_h021", house_sum.getH021());
			map.put("sum_h041", house_sum.getH041());
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 交款
	 */
	@Override
	public int savePaymentByJK(Map<String, String> paramMap) {
		int result = -1;
		houseDiagramDao.savePaymentByJK(paramMap);
		if (paramMap.get("result").equals("0")) {
			result = Integer.valueOf(paramMap.get("w008").trim());
		} else {
			result = Integer.valueOf(paramMap.get("result"));
		}
		return result;
	}

	/**
	 * 补交
	 */
	@Override
	public int savePaymentByBJ(Map<String, String> paramMap) {
		int result = -1;
		houseDiagramDao.savePaymentByBJ(paramMap);
		if (paramMap.get("result").equals("0")) {
			result = Integer.valueOf(paramMap.get("w008").trim());
		} else {
			result = Integer.valueOf(paramMap.get("result"));
		}
		return result;
	}

	public static void main(String[] args) {
		List<String> list = new ArrayList<String>();
		list.add("001");
		list.add("0021");
		// list.add("0031");
		// list.add("0041");
		String lybhs = StringUtil.toDelimitedString(list, "','");
		lybhs = "'" + lybhs + "'";
		System.out.println(lybhs);
	}
}

package com.yaltec.wxzj2.biz.property.service.impl;

import java.io.ByteArrayOutputStream;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.github.pagehelper.PageHelper;
import com.yaltec.comon.auth.TokenHolder;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.comon.utils.DateUtil;
import com.yaltec.comon.utils.StringUtil;
import com.yaltec.comon.utils.ValidateHouseUnit;
import com.yaltec.wxzj2.biz.payment.entity.BatchPayment;
import com.yaltec.wxzj2.biz.payment.entity.HouseDw;
import com.yaltec.wxzj2.biz.payment.entity.HouseUpdate;
import com.yaltec.wxzj2.biz.payment.entity.HousedwImport;
import com.yaltec.wxzj2.biz.property.dao.BuildingDao;
import com.yaltec.wxzj2.biz.property.dao.HouseDwDao;
import com.yaltec.wxzj2.biz.property.entity.Building;
import com.yaltec.wxzj2.biz.property.entity.House;
import com.yaltec.wxzj2.biz.property.entity.HouseInfoPrint;
import com.yaltec.wxzj2.biz.property.entity.HouseUnitPrint;
import com.yaltec.wxzj2.biz.property.service.HouseDwService;
import com.yaltec.wxzj2.biz.property.service.print.DepositCertificatePDF;
import com.yaltec.wxzj2.biz.property.service.print.HouseInfoPDF;
import com.yaltec.wxzj2.biz.property.service.print.HouseUnitPDF;
import com.yaltec.wxzj2.biz.property.service.print.NormalPrintPDF;
import com.yaltec.wxzj2.biz.system.entity.User;
import com.yaltec.wxzj2.biz.system.service.AssignmentService;
import com.yaltec.wxzj2.biz.system.service.PrintConfigService;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 
 * @ClassName: HouseDwServiceImpl
 * @Description: 房屋HouseDw的service接口实现类
 * 
 * @author yangshanping
 * @date 2016-7-27 上午11:29:30
 */
@Service
public class HouseDwServiceImpl implements HouseDwService {
	@Autowired
	private BuildingDao buildingDao;
	@Autowired
	private HouseDwDao houseDwDao;
	@Autowired
	private AssignmentService assignmentService;

	@Value("${work.temppath}")
	// 配置文件中定义的保存路径（临时保存）
	private String tempPath;
	@Autowired
	private PrintConfigService printConfigService;

	public int batchDel(List<String> bmList) {
		return houseDwDao.batchDel(bmList);
	}

	public House findByLymc(House house) {
		return houseDwDao.findByLymc(house);
	}

	public House findByH001(String h001) {
		return houseDwDao.findByH001(h001);
	}

	public int save(House house) {
		try {
			// 根据楼宇找到楼宇编号，然后在表中查找该楼宇下房屋最大编号，最后将8位的楼宇编号加上6位的房屋号，变成新的房号
			Building building = buildingDao.findByLymc(house.getLymc());
			house.setLybh(building.getLybh());
			House _house = houseDwDao.findByLymc(house);
			if (_house == null) {
				house.setH001(house.getLybh() + "000001");
			} else {
				int i = Integer.valueOf(_house.getH001());
				i = i + 1;
				// 编码的值显示为14位，位数不够左边加0
				house.setH001(String.format("%014d", i));
			}
			return houseDwDao.save(house);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return 0;
	}

	public int update(House house) {
		return houseDwDao.update(house);
	}

	/**
	 * 打印房屋交款通知书
	 */
	@Override
	public ByteArrayOutputStream toPrintHouseUnit(List<String> h001List) {
		ByteArrayOutputStream ops = null;
		try {
			List<HouseUnitPrint> list = houseDwDao
					.queryHouseUnitPrint(h001List);
			if (list == null || list.size() == 0) {
				// exeException("获取房屋信息发生错误，请检查归集中心等信息！");
				return null;
			}
			HouseUnitPDF pdf = new HouseUnitPDF();
			
			if (list.get(0).getH050().indexOf("光大银行") >=0) {
				ops = pdf.creatPDFDynamic_GDYH(list, printConfigService.get("cashprintset_gdyh"));
			} else {
				User user = TokenHolder.getUser();
				// 获取房管局归集中心
				String assignmentName = DataHolder.dataMap.get("assignment").get(
						"00");
				if (assignmentName == null) {
					assignmentName = assignmentService.findByBm("00").getMc();
				}
				// System.out.println(user.getUsername());
				
				String title = "物业专项维修资金交存通知书";
				// 判断是否江津
				if (DataHolder.customerInfo.isJJ()) {
					// 江津
					title = "重庆市江津区" + title;
				}
				ops = pdf.creatPDF(list, user, title, assignmentName);
			}
		} catch (Exception e) {
			e.printStackTrace();
			// exeException("生成PDF文件发生错误！");
			return null;
		}
		return ops;
	}

	/**
	 * 打印房屋信息
	 */
	@Override
	public ByteArrayOutputStream printHouseInfo(List<String> h001List) {
		ByteArrayOutputStream ops = null;
		try {
			List<HouseInfoPrint> list = houseDwDao.printHouseInfo(h001List);
			if (list == null || list.size() == 0) {
				// exeException("获取房屋信息发生错误，请检查归集中心等信息！");
				return null;
			}
			User user = TokenHolder.getUser();
			// System.out.println(user.getUsername());
			HouseInfoPDF pdf = new HouseInfoPDF();
			String title = "物业专项维修资金房屋信息";
			// 判断是否江津
			if (DataHolder.customerInfo.isJJ()) {
				// 江津
				title = "重庆市江津区" + title;
			}
			// 判断是否九龙坡
			if (DataHolder.customerInfo.isJLP()) {
				// 九龙坡
				ops = pdf.creatPDF_JLP(list, user, title);
			} else {
				ops = pdf.creatPDF(list, user, title);
			}
		} catch (Exception e) {
			e.printStackTrace();
			// exeException("生成PDF文件发生错误！");
			return null;
		}
		return ops;
	}

	/**
	 * 打印房屋清册
	 */
	@Override
	public ByteArrayOutputStream printHouseInfo2(HouseDw houseDw) {
		ByteArrayOutputStream ops = null;
		try {
			List<HouseDw> list = null;
			// list = houseDwDao.queryHouseUnitAllByXqbh(page.getQuery());
			// 根据查询类型判断调用方法(3：查询所有)
			if (houseDw.getCxlb().equals("3")) {
				// 根据楼宇是否为空
				if (!houseDw.getLybh().equals("")) {
					list = houseDwDao.queryHouseUnitAllByLybh(houseDw);
				} else {
					// 根据小区获取
					list = houseDwDao.queryHouseUnitAllByXqbh(houseDw);
				}
				// 根据查询类型判断调用方法(1：已选择已交)
			} else if (houseDw.getCxlb().equals("1")) {
				if (!houseDw.getLybh().equals("")) {
					list = houseDwDao.queryHouseUnitByYjByLybh(houseDw);
				} else {
					// 根据小区获取
					list = houseDwDao.queryHouseUnitByYjByXqbh(houseDw);
				}
				// 根据查询类型判断调用方法(-1：不交；0：未选择示交；2：已选择未交款)
			} else {
				if (!houseDw.getLybh().equals("")) {
					list = houseDwDao.queryHouseUnitByOtherByLybh(houseDw);
				} else {
					// 根据小区获取
					list = houseDwDao.queryHouseUnitByOtherByXqbh(houseDw);
				}
			}
			if (list == null || list.size() == 0) {
				// exeException("获取房屋信息发生错误，请检查归集中心等信息！");
				return null;
			}
			String[] title = { "楼宇名称", "房屋编号", "单元", "层", "房号", "建筑面积",
					"交存标准", "余额", "支取金额", "首交日期" };
			String[] propertys = { "lymc", "h001", "h002", "h003",
					"h005", "h006", "h022", "h030", "h028", "h020" };
			float[] widths = { 80f, 40f, 20f, 20f, 40f, 20f, 40f, 40f,
					40f, 40f };// 设置表格的列以及列宽

			NormalPrintPDF pdf = new NormalPrintPDF();
			Map<String, String> info = new HashMap<String, String>();
			HouseDw hj = new HouseDw();
			double h006Hj = 0;
			double h030Hj = 0;
			double h031Hj = 0;
			hj.setLymc("合计");
			for (HouseDw h : list) {
				h006Hj = add(h006Hj, h.getH006());
				h030Hj = add(h030Hj, h.getH030());
				h031Hj = add(h006Hj, h.getH031());
			}
			hj.setH006(String.valueOf(h006Hj));
			hj.setH030(String.valueOf(h030Hj));
			hj.setH031(String.valueOf(h031Hj));
			list.add(hj);

			info.put("left", "");
			info.put("right", "日期：" + DateUtil.getDate() + "  共"
					+ (list.size() - 1) + "条记录");

			ops = pdf.creatPDF(new HouseDw(), info, list, title, propertys,
					widths, "房屋信息清册");

		} catch (Exception e) {
			e.printStackTrace();
			// exeException("生成PDF文件发生错误！");
			return null;
		}
		return ops;
	}

	/**
	 * 根据楼宇编号获取该楼宇的所有房屋信息
	 */
	@Override
	public List<HouseDw> getHouseInfoByLybh(String lybh) {
		return houseDwDao.getHouseInfoByLybh(lybh);
	}

	@Override
	public int queryCapturePutsStatusBylybh(String lybh) {
		return houseDwDao.queryCapturePutsStatusBylybh(lybh);
	}

	/**
	 * 打印房屋交存证明
	 */
	@Override
	public ByteArrayOutputStream depositCertificate(String lybh) {
		ByteArrayOutputStream ops = null;
		try {
			HouseDw result = houseDwDao.getDepositCertificateInfo(lybh);
			DepositCertificatePDF pdf = new DepositCertificatePDF();
			String title = "物业专项维修资金交存证明";
			// 判断是否江津
			if (DataHolder.customerInfo.isJJ()) {
				// 江津
				title = "重庆市江津区" + title;
			}
			ops = pdf.creatFGPDF(result, title);
		} catch (Exception e) {
			e.printStackTrace();
			// exeException("生成PDF文件发生错误！");
			return null;
		}
		return ops;
	}

	/**
	 * 批量打印房屋交存证明
	 */
	@Override
	public ByteArrayOutputStream depositCertificateMany(String lybhs) {
		ByteArrayOutputStream ops = null;
		try {
			String[] _lybhs = lybhs.split(",");
			List<HouseDw> list = new ArrayList<HouseDw>();
			for (String lybh : _lybhs) {
				HouseDw result = houseDwDao.getDepositCertificateInfo(lybh);
				list.add(result);
			}
			if (list.size() <= 0) {
				return null;
			}
			DepositCertificatePDF pdf = new DepositCertificatePDF();
			String title = "物业专项维修资金交存证明";
			// 判断是否江津
			if (DataHolder.customerInfo.isJJ()) {
				// 江津
				title = "重庆市江津区" + title;
			}
			ops = pdf.creatFGPDFMany(list, title);
		} catch (Exception e) {
			e.printStackTrace();
			// exeException("生成PDF文件发生错误！");
			return null;
		}
		return ops;
	}

	/**
	 * 读取验证数据
	 * 
	 * @author txj
	 */
	@Override
	public java.util.Map<String, Object> readImportHousedw(
			BatchPayment batchPayment) {
		Map<String, Object> map = null;
		batchPayment.setFilename(tempPath + batchPayment.getFilename());
		try {
			List<HousedwImport> list = new ArrayList<HousedwImport>();

			// 获取临时编码最大值加1
			String tempCode = houseDwDao.getHousedwbsBM();
			tempCode = StringUtil.keepLen(tempCode, 8, false);
			batchPayment.setTempCode(tempCode);
			map = ValidateHouseUnit.convert(batchPayment, list);

			if (map.containsKey("msg")) {
				String msg = map.get("msg").toString();
				if (msg.equals("")) {
					// 删除当前用户以前导入的信息
					houseDwDao.delHouse_dwBSByUser(TokenHolder.getUser()
							.getUserid());
					// 单位房屋批量上报数据合法，则写入数据库表，并判断是否存在房屋表中以及是否有相同的交款业务
					// 添加信息到临时表house_dwBS中
					int j = list.size() - 1;
					List<HousedwImport> _list = new ArrayList<HousedwImport>();
					for (; j >= 0; j--) {
						_list.add(list.get(j));
						if ((j % 15) == 0) {
							houseDwDao.insertHousedwbs(_list);
							_list.clear();
						}
					}
					list.clear();

					map.put("result", "0");
					map.put("tempCode", tempCode);
					map.put("lybh", batchPayment.getLybh());
					// 验证导入的房屋数据
					houseDwDao.checkImportHousedw(map);
					int flag = Integer.valueOf(map.get("result").toString());
					map.put("flag", flag);
				} else {
					map.put("flag", -2);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return map;
	}

	/**
	 * 保存上报信息
	 */
	@Override
	public int saveImportHouseUnit(Map<String, String> map) {
		houseDwDao.saveImportHouseUnit(map);
		return Integer.valueOf(map.get("result"));
	}

	/**
	 * 单位房屋上报信息
	 */
	@Override
	public void queryHouseUnit(Page<HouseDw> page) {
		PageHelper.startPage(page.getPageNo(), page.getPageSize());
		List<HouseDw> list = null;
		// list = houseDwDao.queryHouseUnitAllByXqbh(page.getQuery());
		// 根据查询类型判断调用方法(3：查询所有)
		if (page.getQuery().getCxlb().equals("3")) {
			// 根据楼宇是否为空
			if (!page.getQuery().getLybh().equals("")) {
				list = houseDwDao.queryHouseUnitAllByLybh(page.getQuery());
			} else {
				// 根据小区获取
				list = houseDwDao.queryHouseUnitAllByXqbh(page.getQuery());
			}
			// 根据查询类型判断调用方法(1：已选择已交)
		} else if (page.getQuery().getCxlb().equals("1")) {
			if (!page.getQuery().getLybh().equals("")) {
				list = houseDwDao.queryHouseUnitByYjByLybh(page.getQuery());
			} else {
				// 根据小区获取
				list = houseDwDao.queryHouseUnitByYjByXqbh(page.getQuery());
			}
			// 根据查询类型判断调用方法(-1：不交；0：未选择示交；2：已选择未交款)
		} else {
			if (!page.getQuery().getLybh().equals("")) {
				list = houseDwDao.queryHouseUnitByOtherByLybh(page.getQuery());
			} else {
				// 根据小区获取
				list = houseDwDao.queryHouseUnitByOtherByXqbh(page.getQuery());
			}
		}
		page.setData(list);
	}

	@Override
	public HouseDw queryHouseCountBySearch(HouseDw houseDw) {
		if (houseDw.getCxlb().equals("3")) {
			// 根据楼宇是否为空
			if (!houseDw.getLybh().equals("")) {
				houseDw = houseDwDao.queryHouseUnitAllByLybhSum(houseDw);
			} else {
				// 根据小区获取
				houseDw = houseDwDao.queryHouseUnitAllByXqbhSum(houseDw);
			}
			// 根据查询类型判断调用方法(1：已选择已交)
		} else if (houseDw.getCxlb().equals("1")) {
			if (!houseDw.getLybh().equals("")) {
				houseDw = houseDwDao.queryHouseUnitByYjByLybhSum(houseDw);
			} else {
				// 根据小区获取
				houseDw = houseDwDao.queryHouseUnitByYjByXqbhSum(houseDw);
			}
			// 根据查询类型判断调用方法(-1：不交；0：未选择示交；2：已选择未交款)
		} else {
			if (!houseDw.getLybh().equals("")) {
				houseDw = houseDwDao.queryHouseUnitByOtherByLybhSum(houseDw);
			} else {
				// 根据小区获取
				houseDw = houseDwDao.queryHouseUnitByOtherByXqbhSum(houseDw);
			}
		}
		return houseDw;
	}

	@Override
	public List<HouseDw> queryHouseUnit(HouseDw houseDw) {
		return houseDwDao.queryHouseUnitAllByXqbh(houseDw);
	}

	/**
	 * 楼盘信息修改房屋 是否交款的设定(不交款)
	 */
	@Override
	public int updateHouseDwBJ(List<String> paramList) {
		int result = houseDwDao.queryJK_house_dw(paramList);
		if (result > 0) {
			result = -1;
		} else {
			result = houseDwDao.updateHouseDwBJ(paramList);
		}

		return result;
	}

	/**
	 * 楼盘信息修改房屋 是否交款的设定(交款)
	 */
	@Override
	public int updateHouseDwYJ(List<String> paramList) {
		return houseDwDao.updateHouseDwYJ(paramList);
	}

	/**
	 * 修改选中房屋的房屋类型及归集中心等
	 */
	@Override
	public HouseUpdate updateHouse(Map<String, String> paramMap) {
		return houseDwDao.updateHouse(paramMap);
	}

	/**
	 * 导出房屋信息
	 */
	@Override
	public List<HouseDw> exportHouseDw(String h001s, HouseDw houseDw) {
		houseDw.setEnddate(DateUtil.getDate());
		List<HouseDw> list = null;
		if (h001s.equals("")) {// 导出查询所有
			if (houseDw.getCxlb().equals("3")) {
				if (!houseDw.getLybh().equals("")) {
					list = houseDwDao.queryHouseUnitAllByLybh(houseDw);
				} else {
					// 根据小区获取
					list = houseDwDao.queryHouseUnitAllByXqbh(houseDw);
				}
				// 根据查询类型判断调用方法(1：已选择已交)
			} else if (houseDw.getCxlb().equals("1")) {
				list = houseDwDao.queryHouseUnitByYjByLybh(houseDw);
				// 根据查询类型判断调用方法(-1：不交；0：未选择示交；2：已选择未交款)
			} else {
				list = houseDwDao.queryHouseUnitByOtherByLybh(houseDw);
			}
		} else {// 导出查询结果中选中部分
			List<String> h001List = new ArrayList<String>();
			for (String h001 : h001s.split(",")) {
				if (!h001.equals("")) {
					h001List.add(h001);
				}
			}
			list = houseDwDao.queryExportHouse(h001List);

		}
		return list;
	}

	/**
	 * 读取临时表数据
	 */
	@Override
	public void readTemp(Page<HousedwImport> page, Map<String, Object> paramMap) {
		try {
			PageHelper.startPage(page.getPageNo(), page.getPageSize());
			List<HousedwImport> list = houseDwDao.readtemp(paramMap);
			page.setData(list);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@Override
	public HouseDw getTopHouseByXq(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return houseDwDao.getTopHouseByXq(map);
	}
	
	/**
	 * 累加计算合计
	 * @param v1
	 * @param v2
	 * @return
	 */
	private static double add(double v1, String v2) {
		BigDecimal b1 = new BigDecimal(Double.toString(v1));
		BigDecimal b2 = new BigDecimal(v2);
		return b1.add(b2).doubleValue();
	}

	public static void main(String[] args) {
		String tempCode = "1";
		tempCode = StringUtil.keepLen(tempCode, 8, false);
		System.out.println(tempCode);
	}

	@Override
	public Integer isHousesBylybh(String lybh) {
		return houseDwDao.isHousesBylybh(lybh);
	}

	/**
	 * 查询单位房屋上报（根据房屋编号查询单位房屋信息）
	 */
	@Override
	public List<HouseDw> queryHouseUnitByH001s(String h001s) {
		String[] h001 = h001s.split(",");
		Map<String, Object> map =  new HashMap<String, Object>();
		map.put("h001s", h001);
		return houseDwDao.queryHouseUnitByH001s(map);
	}
}

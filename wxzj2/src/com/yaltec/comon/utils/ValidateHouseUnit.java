package com.yaltec.comon.utils;

import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.log4j.Logger;

import com.yaltec.comon.auth.TokenHolder;
import com.yaltec.wxzj2.biz.payment.entity.BatchPayment;
import com.yaltec.wxzj2.biz.payment.entity.HousedwImport;
import com.yaltec.wxzj2.comon.data.DataHolder;
import com.yaltec.wxzj2.comon.data.service.DepositDataService;

/**
 * <p>
 * 文件名称: ValidateHouseUnit.java
 * </p>
 * <p>
 * 文件描述: 验证单位房屋上报字段，并对一些内容做相应的处理
 * </p>
 * <p>
 * 版权所有: 版权所有(C)2010
 * </p>
 * <p>
 * 公 司: yaltec
 * </p>
 * <p>
 * 内容摘要:
 * </p>
 * <p>
 * 其他说明:
 * </p>
 * <p>
 * 完成日期：Oct 18, 2012
 * </p>
 * <p>
 * 修改记录0：无
 * </p>
 * 
 * @version 1.0
 * @author jiangyong
 */
public class ValidateHouseUnit {

	private final static String ENDSTR = " \r\n";
	private static double h006hj = 0;
	private static double h021hj = 0;
	private static double h030hj = 0;
	private static double h031hj = 0;
	private static Set<String> set = new HashSet<String>();

	/**
	 * 日志记录器.
	 */
	private static final Logger logger = Logger
			.getLogger("biz.ValidateHouseUnit");

	/**
	 * 数据转换
	 */
	public static Map<String, Object> convert(BatchPayment batchPayment,
			List<HousedwImport> result) {
		// 返回集合
		Map<String, Object> map = new HashMap<String, Object>();
		// 错误信息
		StringBuffer errorMsg = new StringBuffer();
		if (result == null) {
			result = new ArrayList<HousedwImport>();
		}
		h006hj = 0;
		h021hj = 0;
		h030hj = 0;
		h031hj = 0;
		set.clear();
		try {
			// 解析EXCEL数据
			List<ArrayList<String>> dataList = ReadExcelExt.readExcel(batchPayment
					.getFilename(), Integer.valueOf(batchPayment.getSheet()));
			// 总户数
			int counts = Integer.valueOf(dataList.get(2).get(3).trim());
			String address = null;
			if (dataList.get(0).size() >= 11) {
				address = dataList.get(0).get(10);
			}

			long beginTime = System.currentTimeMillis();
			boolean flag = DataHolder.getParameter("05");
			for (int i = 0; i < counts; i++) {
				// 从第5行开始，读取每行数据
				int row = i + 4;
				ArrayList<String> line = dataList.get(row);
				if (ObjectUtil.isEmpty(line) || line.get(1).trim().equals("")) {
					break;
				}
				HousedwImport houseImport = verify(row, line, errorMsg,
						batchPayment, flag, address);
				result.add(houseImport);
			}
			// 结束时间
			long endTime = System.currentTimeMillis();
			logger.info("总数据: " + counts + "条，耗时：" + (endTime - beginTime)
					+ "ms");

			map.put("msg", errorMsg.toString());
			errorMsg.setLength(0);

			// 保留2位小数
			errorMsg.append("  总房屋：").append(counts).append(" 户，建筑面积：").append(
					MathUtil.format(h006hj));
			errorMsg.append(" 平方米，应交资金：").append(MathUtil.format(h021hj))
					.append(" 元，实交本金：");
			errorMsg.append(MathUtil.format(h030hj)).append(" 元，实交利息：").append(
					MathUtil.format(h031hj)).append(" 元");

			map.put("h030hj", h030hj);
			if (batchPayment.getYe() == null) {
				batchPayment.setYe("0");
			}
			Double ye = Double.valueOf(batchPayment.getYe())
					- Double.valueOf(map.get("h030hj").toString());
			map.put("ye", ye);
			map.put("tips", errorMsg.toString());
			errorMsg.setLength(0);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return map;
	}

	/**
	 * 数据验证
	 * 
	 * @param row
	 *            行数
	 * @param line
	 *            每行数据
	 * @param errorMsg
	 *            错误信息集合
	 * @param lymc
	 *            楼宇名称
	 * @param flag
	 *            应交资金是否取整
	 * @param dz
	 *            楼宇地址
	 */
	public static HousedwImport verify(int row, ArrayList<String> line,
			StringBuffer errorMsg, BatchPayment batchPayment, boolean flag,
			String dz) {
		HousedwImport housedwImport = new HousedwImport(row + 1);

		verifyH002(housedwImport, line.get(0).trim()); // 单元
		verifyH003(housedwImport, line.get(1).trim(), errorMsg); // 层
		verifyH005(housedwImport, line.get(2).trim(), errorMsg); // 房号
		verifyH013(housedwImport, line.get(3).trim(), errorMsg);// 姓名
		verifyH015(housedwImport, line.get(4).trim(), errorMsg);// 身份证号
		verifyH011(housedwImport, line.get(5).trim(), errorMsg);// 房屋性质编号
		verifyH044(housedwImport, line.get(6).trim(), errorMsg); // 房屋用途编码
		verifyH006(housedwImport, line.get(7).trim(), errorMsg); // 建筑面积
		verifyH010(housedwImport, line.get(8).trim(), errorMsg); // 房款
		verifyH017(housedwImport, line.get(9).trim(), errorMsg); // 房屋类型编号
		
		
		verifyH021(housedwImport, line.get(12).trim(), errorMsg); // 应交资金
		// 应交资金根据缴存标准计算		
		verifyH022(housedwImport, line.get(10).trim(), errorMsg, flag); // 交存标准编号
		verifyH020(housedwImport, line.get(11).trim(), errorMsg); // 上报日期-首交日期

		
		verifyH030(housedwImport, line.get(13).trim(), errorMsg); // 实交本金
		housedwImport.setH019(line.get(14).trim()); // 联系电话
		// 实交利息
		if (line.size() > 15) {
			verifyH031(housedwImport, line.get(15).trim(), errorMsg);
		} else {
			housedwImport.setH031("0");
		}
		// X、Y坐标
		// 判断房屋数据来源
		if (line.size() > 17 && DataHolder.getParameter("27")) {
			verify_X_Y(housedwImport, line.get(16).trim(), line.get(17).trim(),
					errorMsg);
		} else {
			housedwImport.setH052("1");// X坐标
			housedwImport.setH053("1");// Y坐标
		}

		StringBuffer address = new StringBuffer();
		// 房屋地址
		if (!StringUtil.isEmpty(dz)) {
			address.append(dz);
			address.append(batchPayment.getLymc()).append(housedwImport.getH002())
			.append("单元").append(housedwImport.getH003()).append("层")
			.append(housedwImport.getH005()).append("号");
		}else {
		address.append(batchPayment.getLymc()).append(housedwImport.getH002())
				.append("单元").append(housedwImport.getH003()).append("层")
				.append(housedwImport.getH005()).append("号");
		}
		housedwImport.setLydz(address.toString());
		address.setLength(0);

		// 合计
		h006hj = h006hj + Double.valueOf(housedwImport.getH006());
		h021hj = h021hj + Double.valueOf(housedwImport.getH021());
		h030hj = h030hj + Double.valueOf(housedwImport.getH030());
		h031hj = h031hj + Double.valueOf(housedwImport.getH031());
		// 判断是否有重复的房屋记录
		String key = housedwImport.getH002() + housedwImport.getH003()
				+ housedwImport.getH005();
		if (set.contains(key)) {
			address.append("存在单元号为：").append(housedwImport.getH002()).append(
					"，层号为：").append(housedwImport.getH003()).append("，房号为：")
					.append(housedwImport.getH005()).append(
							" 的相同记录，请检查上报文件！<br>");
			writeMsg(errorMsg, housedwImport.getRow(), address.toString());
			address.setLength(0);
		} else {
			set.add(key);
		}
		housedwImport.setTempCode(batchPayment.getTempCode());
		housedwImport.setXqbh(batchPayment.getXqbh());
		housedwImport.setLybh(batchPayment.getLybh());
		if (batchPayment.getUnitcode() == null
				|| batchPayment.getUnitcode().equals("")) {
			housedwImport.setUnitCode(batchPayment.getYhbh());
			housedwImport.setUnitName(batchPayment.getYhmc());
		} else {
			housedwImport.setUnitCode(batchPayment.getUnitcode());
			housedwImport.setUnitName(batchPayment.getUnitname());
		}
		housedwImport.setW003(batchPayment.getYwrq());
		housedwImport.setUserid(TokenHolder.getUser().getUserid());
		housedwImport.setUsername(TokenHolder.getUser().getUsername());
		return housedwImport;
	}

	// 给msg中添加错误信息
	public static void writeMsg(StringBuffer msg, int row, String content) {
		msg.append("上报文件第" + row + "行：").append(content).append(ENDSTR);
	}

	// 单元 为空"00",保留2位
	public static void verifyH002(HousedwImport houseImport, String h002) {
		if (StringUtil.isEmpty(h002)) {
			h002 = "00";
		} else {
			h002 = h002.length() == 1 ? "0" + h002 : h002;
		}
		houseImport.setH002(h002);
	}

	// 层 不能为空，保留2位
	public static void verifyH003(HousedwImport houseImport, String h003,
			StringBuffer msg) {
		if (StringUtil.isEmpty(h003)) {
			writeMsg(msg, houseImport.getRow(), "层不能为空，请检查上报文件！<br>");
		} else {
			h003 = h003.length() == 1 ? "0" + h003 : h003;
		}
		houseImport.setH003(h003);
	}

	// 房号 不能为空，保留2位
	public static void verifyH005(HousedwImport houseImport, String h005,
			StringBuffer msg) {
		if (StringUtil.isEmpty(h005)) {
			writeMsg(msg, houseImport.getRow(), "房号不能为空，请检查上报文件！<br>");
		} else {
			h005 = h005.length() == 1 ? "0" + h005 : h005;
		}
		houseImport.setH005(h005);
	}

	// 面积验证
	public static void verifyH006(HousedwImport houseImport, String h006,
			StringBuffer msg) {
		if (StringUtil.isEmpty(h006)) {
			h006 = "0";
		} else {
			if (!checkNumber(h006)) {
				writeMsg(msg, houseImport.getRow(), "面积存在非法数字，请检查上报文件！<br>");
			}
		}
		houseImport.setH006(h006);
	}

	// 房款验证
	public static void verifyH010(HousedwImport houseImport, String h010,
			StringBuffer msg) {
		if (StringUtil.isEmpty(h010)) {
			h010 = "0";
		} else {
			if (!checkNumber(h010)) {
				writeMsg(msg, houseImport.getRow(), "房款存在非法数字，请检查上报文件！<br>");
			}
		}
		houseImport.setH010(h010);
	}

	// 房屋性质
	public static void verifyH011(HousedwImport houseImport, String h011,
			StringBuffer msg) {
		if (StringUtil.isEmpty(h011)) {
			writeMsg(msg, houseImport.getRow(), "房屋性质编号不能为空，请检查上报文件！<br>");
		} else {
			h011 = h011.length() == 1 ? "0" + h011 : h011;
			if (!DataHolder.dataMap.get("houseproperty").containsKey(h011)) {
				writeMsg(msg, houseImport.getRow(), "房屋性质编号错误，请检查上报文件！<br>");
			} else {
				houseImport.setH012(DataHolder.dataMap.get("houseproperty")
						.get(h011));
			}
		}
		houseImport.setH011(h011);
	}

	// 业主姓名验证，长度不能超过50
	public static void verifyH013(HousedwImport houseImport, String h013,
			StringBuffer msg) {
		if (StringUtil.hasLength(h013)) {
			h013 = h013.replaceAll("\n", " ");
		}
		if (h013.length() > 50) {
			writeMsg(msg, houseImport.getRow(), "业主姓名(产权人)过长，请检查上报文件！<br>");
		}
		houseImport.setH013(h013);
	}

	// 身份证号验证，长度不能超过50
	public static void verifyH015(HousedwImport houseImport, String h015,
			StringBuffer msg) {
		if (h015.length() > 100) {
			writeMsg(msg, houseImport.getRow(), "身份证号过长，请检查上报文件！<br>");
		}
		houseImport.setH015(h015);
	}

	// 房屋类型
	public static void verifyH017(HousedwImport houseImport, String h017,
			StringBuffer msg) {
		if (StringUtil.isEmpty(h017)) {
			writeMsg(msg, houseImport.getRow(), "房屋类型编号不能为空，请检查上报文件！<br>");
		} else {
			h017 = h017.length() == 1 ? "0" + h017 : h017;
			if (!DataHolder.dataMap.get("housetype").containsKey(h017)) {
				writeMsg(msg, houseImport.getRow(), "房屋类型编号错误，请检查上报文件！<br>");
			} else {
				houseImport.setH018(DataHolder.dataMap.get("housetype").get(
						h017));
			}
		}
		houseImport.setH017(h017);
	}

	// 缴存标准, 计算应交金额
	public static void verifyH022(HousedwImport houseImport, String h022,
			StringBuffer msg, boolean flag) {
		if (StringUtil.isEmpty(h022)) {
			writeMsg(msg, houseImport.getRow(), "交存标准编号不能为空，请检查上报文件！<br>");
		} else {
			h022 = h022.length() == 1 ? "0" + h022 : h022;
			if (!DataHolder.dataMap.get(DepositDataService.KEY).containsKey(
					h022)) {
				writeMsg(msg, houseImport.getRow(), "交存标准编号错误，请检查上报文件！<br>");
				houseImport.setH021("0");
			} else {
				String jcbz = DataHolder.dataMap.get(DepositDataService.KEY)
						.get(h022);
				houseImport.setH023(jcbz);
				// 不用重新计算应缴资金
				String[] array = jcbz.split("\\|");
				String xs = array[array.length - 1];
				if (checkNumber(xs)) {
					if (Double.valueOf(xs) >= 1
							&& checkNumber(houseImport.getH006())) {
						double h021 = Double.valueOf(houseImport.getH006())
								* Double.valueOf(xs);
						if (flag) {
							houseImport.setH021(new BigDecimal(h021).setScale(
									0, BigDecimal.ROUND_HALF_UP).toString());
						} else {
							houseImport.setH021(String.format("%.2f", h021));
						}
					} else if (Double.valueOf(xs) < 1
							&& checkNumber(houseImport.getH010())) {
						double h021 = Double.valueOf(houseImport.getH010())
								* Double.valueOf(xs);
						if (flag) {
							houseImport.setH021(new BigDecimal(h021).setScale(
									0, BigDecimal.ROUND_HALF_UP).toString());
						} else {
							houseImport.setH021(String.format("%.2f", h021));
						}
					} else {
						houseImport.setH021("0");
					}
				}
			}
		}
		houseImport.setH022(h022);
	}

	public static void main(String[] args) {
		String d = "1970.4999999999998";
		System.out.println(new BigDecimal(d).setScale(
									0, BigDecimal.ROUND_HALF_UP).toString());
	}
	
	// 首交日期，验证日期
	public static void verifyH020(HousedwImport houseImport, String h020,
			StringBuffer msg) {
		if (StringUtil.isEmpty(h020)) {
			// writeMsg(msg, houseImport.getRow(), "首交日期不能为空，请检查上报文件！<br>");
			h020 = DateUtil.getDate();
		} else {
			h020 = h020.replaceAll("/", "-");
			SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
			format.setLenient(false);
			try {
				format.parse(h020);
			} catch (ParseException e) {
				writeMsg(msg, houseImport.getRow(), "首交日期格式错误，请检查上报文件！<br>");
			}
		}
		houseImport.setH020(h020);
	}

	// 应交金额
	public static void verifyH021(HousedwImport houseImport, String h021,
			StringBuffer msg) {
		if (StringUtil.isEmpty(h021)) {
			h021 = "0";
		} else {
			if (!checkNumber(h021)) {
				writeMsg(msg, houseImport.getRow(), "应交金额存在非法数字，请检查上报文件！<br>");
			}
		}
		houseImport.setH021(h021);
	}

	// 实缴金额
	public static void verifyH030(HousedwImport houseImport, String h030,
			StringBuffer msg) {
		if (StringUtil.isEmpty(h030)) {
			h030 = "0";
		} else {
			if (!checkNumber(h030)) {
				writeMsg(msg, houseImport.getRow(), "实缴金额存在非法数字，请检查上报文件！<br>");
			}
		}
		houseImport.setH030(h030);
	}

	// 实缴利息
	public static void verifyH031(HousedwImport houseImport, String h031,
			StringBuffer msg) {
		if (StringUtil.isEmpty(h031)) {
			h031 = "0";
		} else {
			if (!checkNumber(h031)) {
				writeMsg(msg, houseImport.getRow(), "实缴利息存在非法数字，请检查上报文件！<br>");
			}
		}
		houseImport.setH031(h031);
	}

	// X、Y坐标
	public static void verify_X_Y(HousedwImport houseImport, String x,
			String y, StringBuffer msg) {
		if (StringUtil.isEmpty(x)) {
			writeMsg(msg, houseImport.getRow(), "X坐标不能为空，请检查上报文件！<br>");
		} else {
			if (!checkNumber(x)) {
				writeMsg(msg, houseImport.getRow(), "X坐标存在非法数字，请检查上报文件！<br>");
			}
		}
		if (StringUtil.isEmpty(y)) {
			writeMsg(msg, houseImport.getRow(), "Y坐标不能为空，请检查上报文件！<br>");
		} else {
			if (!checkNumber(y)) {
				writeMsg(msg, houseImport.getRow(), "Y坐标存在非法数字，请检查上报文件！<br>");
			}
		}
		houseImport.setH052(x);
		houseImport.setH053(y);
	}

	// 房屋用途
	public static void verifyH044(HousedwImport houseImport, String h044,
			StringBuffer msg) {
		if (StringUtil.isEmpty(h044)) {
			writeMsg(msg, houseImport.getRow(), "房屋用途编号不能为空，请检查上报文件！<br>");
		} else {
			h044 = h044.length() == 1 ? "0" + h044 : h044;
			if (!DataHolder.dataMap.get("houseuse").containsKey(h044)) {
				writeMsg(msg, houseImport.getRow(), "房屋用途编号错误，请检查上报文件！<br>");
			} else {
				houseImport.setH045(DataHolder.dataMap.get("houseuse")
						.get(h044));
			}
		}
		houseImport.setH044(h044);
	}

	private static boolean checkNumber(String value) {
		String regex = "^(-?[1-9]\\d*\\.?\\d*)|(-?0\\.\\d*[1-9])|(-?[0])|(-?[0]\\.\\d*)$";
		return value.matches(regex);
	}
	
//	public static void main(String[] args) {
//		String regex = "2017/9/9";
//		System.out.println(regex.replaceAll("/", "-"));
//
//	}

}

package com.yaltec.wxzj2.biz.payment.service.print;

import java.text.DecimalFormat;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.lowagie.text.Document;
import com.lowagie.text.Rectangle;
import com.lowagie.text.pdf.PdfContentByte;
import com.lowagie.text.pdf.PdfWriter;
import com.yaltec.comon.utils.ChangeRMB;
import com.yaltec.comon.utils.StringUtil;
import com.yaltec.wxzj2.biz.comon.service.AbstractPDFService;
import com.yaltec.wxzj2.biz.property.entity.House;
import com.yaltec.wxzj2.biz.system.entity.PrintSet;
import com.yaltec.wxzj2.biz.system.entity.User;
import com.yaltec.wxzj2.comon.data.DataHolder;
import com.yaltec.wxzj2.comon.data.service.BankDataService;

/**
 * 交款查询—交款收据批量套打
 * 
 * @ClassName: QueryPaymentBDPDF
 * @author 重庆亚亮科技有限公司 txj
 * @date 2016-9-6 下午04:23:41
 */
public class QueryPaymentBDPDF extends AbstractPDFService {

	private DecimalFormat df = new DecimalFormat("###,##0.00"); // 补全小数点后的位数、三位一个逗号分割、四舍五入

	@SuppressWarnings("unchecked")
	@Override
	protected void buildPdfDocument(Map<String, Object> model,
			Document document, PdfWriter writer, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		// 调用父类初始化方法
		super.init(model);
		// 获取传入参数
		// 当前用户的打印配置
		Map<String, PrintSet> printConfig = getValue("printConfig", Map.class);
		List<House> listHouse = getValue("listHouse", List.class); // 交款时间
		String[] jksj = getValue("jksj", String[].class); // 交款时间
		String[] jkje = getValue("jkje", String[].class); // 交款金额
		String[] key = getValue("key", String[].class); // 数字指纹
		String[] pjh = getValue("pjh", String[].class); // 票据号
		List<String> w005s = getValue("w005", List.class); // 利息
		User user = getValue("user", User.class); // 当前操作用户

		// 房管局打票，则取action传递的值，银行帐号打票则取帐号对应的银行
		String bankName = "";
		if (DataHolder.customerInfo.isJLP() || DataHolder.customerInfo.isDZ()) {
			bankName = user.getUsername();
		} else {
			if (user.getUnitcode().equals("00")) {
				String _bankName = getValue("bankName", String.class);
				if (StringUtil.hasText(_bankName)) {
					bankName = _bankName;
				}
			} else {
				if (null != DataHolder.dataMap.get(BankDataService.KEY)) {
					if (DataHolder.dataMap.get(BankDataService.KEY)
							.containsKey(user.getBankId())) {
						bankName = DataHolder.dataMap.get(BankDataService.KEY)
								.get(user.getBankId());
					}
				}
			}
		}

		Rectangle pageSize = new Rectangle(268, 550);
		document.setPageSize(pageSize);
		document.setPageSize(pageSize.rotate());
		document.open();
		for (int i = 0; i < listHouse.size(); i++) {

			House house = listHouse.get(i);

			// 定点输出文字
			PdfContentByte cb = writer.getDirectContent();
			// 设置字体
			cb.beginText();
			cb.setFontAndSize(bfChinese, 11);
			// 截取时间，只保留年月日
			String[] date = jksj[i].substring(0, 10).split("-");
			// 设置字号
			cb.setFontAndSize(bfChinese, 12);
			if (DataHolder.customerInfo.isJJ()) {
				// 年月日
				cb.showTextAligned(PdfContentByte.ALIGN_RIGHT, date[0],
						printConfig.get("year").getX(), printConfig.get("year")
								.getY(), 0);
				cb.showTextAligned(PdfContentByte.ALIGN_RIGHT, date[1],
						printConfig.get("month").getX(), printConfig.get(
								"month").getY(), 0);
				cb.showTextAligned(PdfContentByte.ALIGN_RIGHT, date[2],
						printConfig.get("day").getX(), printConfig.get("day")
								.getY(), 0);
			} else {
				// 年月日
				cb.showTextAligned(PdfContentByte.ALIGN_RIGHT, date[0] + "-",
						printConfig.get("year").getX(), printConfig.get("year")
								.getY(), 0);
				cb.showTextAligned(PdfContentByte.ALIGN_RIGHT, date[1] + "-",
						printConfig.get("month").getX(), printConfig.get(
								"month").getY(), 0);
				cb.showTextAligned(PdfContentByte.ALIGN_RIGHT, date[2],
						printConfig.get("day").getX(), printConfig.get("day")
								.getY(), 0);
			}

			// 房屋编号
			cb.showTextAligned(PdfContentByte.ALIGN_LEFT, "房屋编号："
					+ house.getH001(), printConfig.get("h001").getX(),
					printConfig.get("h001").getY(), 0);

			// 业主
			cb.showTextAligned(PdfContentByte.ALIGN_LEFT, house.getH013(),
					printConfig.get("h013").getX(), printConfig.get("h013")
							.getY(), 0);
			
			// 面积1
			// 2018-07-03大足添加预测面积
			if (DataHolder.customerInfo.isDZ()) {
				cb.showTextAligned(PdfContentByte.ALIGN_RIGHT, String.valueOf(house
						.getH006())+"（预测面积）", printConfig.get("h0060").getX(), printConfig
						.get("h0060").getY(), 0);
			} else {
				cb.showTextAligned(PdfContentByte.ALIGN_RIGHT, String.valueOf(house
						.getH006()), printConfig.get("h0060").getX(), printConfig
						.get("h0060").getY(), 0);
			}
			// cb.showTextAligned(PdfContentByte.ALIGN_LEFT,
			// house.getH015(),
			// printConfig.get("h015")).getX(), printConfig
			// .get("h015")).getY(), 0);

			// 地址
			String address = "";
			if (DataHolder.customerInfo.isYC()
					&& StringUtil.hasText(house.getH047())) {
				address = house.getH047();
				if (StringUtil.hasText(house.getXqmc())) {
					address = address+" ("+house.getXqmc()+")";
				}
			} else {
				address = house.getLymc() + "--" + house.getH002() + "单元--"
						+ house.getH003() + "层--" + house.getH005() + "号";
			}

			cb.showTextAligned(PdfContentByte.ALIGN_LEFT, address, printConfig
					.get("address").getX(), printConfig.get("address").getY(),
					0);

			// 业主电话
			cb.showTextAligned(PdfContentByte.ALIGN_LEFT, house.getH019(),
					printConfig.get("h019").getX(), printConfig.get("h019")
							.getY(), 0);

			// 楼宇 单元 层 房号
			cb.showTextAligned(PdfContentByte.ALIGN_CENTER, house.getLymc(),
					printConfig.get("lymc").getX(), printConfig.get("lymc")
							.getY(), 0);
			cb.showTextAligned(PdfContentByte.ALIGN_CENTER, house.getH002(),
					printConfig.get("h002").getX(), printConfig.get("h002")
							.getY(), 0);
			cb.showTextAligned(PdfContentByte.ALIGN_CENTER, house.getH003(),
					printConfig.get("h003").getX(), printConfig.get("h003")
							.getY(), 0);
			cb.showTextAligned(PdfContentByte.ALIGN_CENTER, house.getH005(),
					printConfig.get("h005").getX(), printConfig.get("h005")
							.getY(), 0);

			// 单价
			cb.showTextAligned(PdfContentByte.ALIGN_CENTER, String
					.valueOf(house.getH009()), printConfig.get("h009").getX(),
					printConfig.get("h009").getY(), 0);
			// 房屋用途
			cb.showTextAligned(PdfContentByte.ALIGN_CENTER, house.getH045(),
					printConfig.get("h045").getX(), printConfig.get("h045")
							.getY(), 0);

			// 交存标准
			Double jcbz = Double.valueOf(0);
			String jcbzStr = "";
			if (Double.valueOf(house.getH022()) > 1) {
				jcbz = Double.valueOf(house.getH022());
				jcbzStr = jcbz.toString().substring(0, 2);
			} else {
				jcbz = Double.valueOf(house.getH022()) * 100;
				jcbzStr = jcbz.toString() + "%";
			}
			String h017 = house.getH017().trim();
			if (h017.equals("01")) {
				// 左侧 有电梯
				cb.showTextAligned(PdfContentByte.ALIGN_RIGHT, String
						.valueOf(house.getH006()), printConfig.get("h006left")
						.getX(), printConfig.get("h006left").getY(), 0);
				if (Double.valueOf(house.getH022()) < 1) {
					cb.showTextAligned(PdfContentByte.ALIGN_RIGHT, "按房款交存",
							printConfig.get("fkjcleft").getX(), printConfig
									.get("fkjcleft").getY(), 0);
				} else {
					cb.showTextAligned(PdfContentByte.ALIGN_RIGHT, jcbzStr,
							printConfig.get("h022left").getX(), printConfig
									.get("h022left").getY(), 0);
				}
			} else {
				// 右侧 无电梯
				cb.showTextAligned(PdfContentByte.ALIGN_RIGHT, String
						.valueOf(house.getH006()), printConfig.get("h006right")
						.getX(), printConfig.get("h006right").getY(), 0);
				if (Double.valueOf(house.getH022()) < 1) {
					cb.showTextAligned(PdfContentByte.ALIGN_RIGHT, "按房款交存",
							printConfig.get("fkjcright").getX(), printConfig
									.get("fkjcright").getY(), 0);
				} else {
					cb.showTextAligned(PdfContentByte.ALIGN_RIGHT, jcbzStr,
							printConfig.get("h022right").getX(), printConfig
									.get("h022right").getY(), 0);
				}
			}
			// 交存金额
			cb.showTextAligned(PdfContentByte.ALIGN_LEFT, ChangeRMB
					.doChangeRMB(jkje[i]), printConfig.get("u_jkje").getX(),
					printConfig.get("u_jkje").getY(), 0);
			// 添加利息
			String w005 = w005s.get(i);
			if (w005 == null || w005.equals("0.00")) {
				cb.showTextAligned(PdfContentByte.ALIGN_LEFT, "￥"
						+ df.format(Double.valueOf(jkje[i])), (printConfig
						.get("l_jkje")).getX(), (printConfig.get("l_jkje"))
						.getY(), 0);
			} else {
				cb.showTextAligned(PdfContentByte.ALIGN_LEFT, "￥"
						+ df.format(Double.valueOf(jkje[i])) + "(" + "其中利息:"
						+ "￥" + df.format(Double.valueOf(w005)) + ")",
						(printConfig.get("l_jkje")).getX(), (printConfig
								.get("l_jkje")).getY(), 0);
			}

			// 判断是否设置了非税打印
			if (printConfig.containsKey("deptcode")) {
				// 单位编码、数字指纹
				cb.showTextAligned(PdfContentByte.ALIGN_LEFT, user
						.getDeptCode() == null ? "" : user.getDeptCode(),
						printConfig.get("deptcode").getX(), printConfig.get(
								"deptcode").getY(), 0);
				cb.showTextAligned(PdfContentByte.ALIGN_LEFT,
						key[i] == null ? "" : key[i], printConfig.get(
								"fingerprintData").getX(), printConfig.get(
								"fingerprintData").getY(), 0);
				// 票据号
				cb.showTextAligned(PdfContentByte.ALIGN_LEFT,
						pjh[i] == null ? "" : "电子票号：" + pjh[i], printConfig
								.get("billNo").getX(), printConfig
								.get("billNo").getY(), 0);
			}
			// 判断是否设置了提示信息
			if (printConfig.containsKey("warnInfo")) {
				// 提示信息
				cb.showTextAligned(PdfContentByte.ALIGN_LEFT,
						"注：当电子票号与纸质票号不一致为无效票", (printConfig.get("warnInfo"))
								.getX(), (printConfig.get("warnInfo")).getY(),
						0);
			}
			cb.showTextAligned(PdfContentByte.ALIGN_LEFT, bankName, printConfig
					.get("username").getX(),
					printConfig.get("username").getY(), 0);

			cb.setFontAndSize(bfChinese, 8);

			String unitName = "";
			if (DataHolder.customerInfo != null) {
				unitName = DataHolder.customerInfo.getName();
			}

			cb.showTextAligned(PdfContentByte.ALIGN_LEFT, unitName, printConfig
					.get("skdy").getX(), printConfig.get("skdy").getY(), 0);
			cb.endText();
			document.newPage(); // 强制换页
		}
		document.close();
	}

}

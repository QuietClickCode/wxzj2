package com.yaltec.wxzj2.biz.payment.service.print;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.text.DecimalFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.lowagie.text.Document;
import com.lowagie.text.DocumentException;
import com.lowagie.text.Font;
import com.lowagie.text.PageSize;
import com.lowagie.text.Rectangle;
import com.lowagie.text.pdf.BaseFont;
import com.lowagie.text.pdf.PdfContentByte;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;
import com.yaltec.comon.utils.ChangeRMB;
import com.yaltec.comon.utils.DateUtil;
import com.yaltec.comon.utils.Dom4j;
import com.yaltec.comon.utils.PdfUtil;
import com.yaltec.wxzj2.biz.property.entity.House;
import com.yaltec.wxzj2.biz.system.entity.PrintSet;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 交款凭证打印
 * @ClassName: PaymentRegPDF 
 * @author 重庆亚亮科技有限公司 txj 
 * @date 2016-9-6 下午04:22:21
 */
public class PaymentRegPDF {
	private BaseFont bfChinese;
	private Font headFont1;
	private Font headFont2;
	private Font headFont3;
	private DecimalFormat df = new DecimalFormat("0.00"); // 保留2位小数

	static Logger logger = LoggerFactory.getLogger(PaymentRegPDF.class);

	public void init() throws DocumentException, IOException {
		bfChinese = BaseFont.createFont("STSong-Light", "UniGB-UCS2-H", BaseFont.NOT_EMBEDDED);// 设置中文字体
		headFont1 = new Font(bfChinese, 14, Font.BOLD);// 设置字体大小
		headFont2 = new Font(bfChinese, 12, Font.NORMAL);// 设置字体大小
		headFont3 = new Font(bfChinese, 10, Font.NORMAL);// 设置字体大小
	}

	// 套打【从配置文件中获取打印配置参数】
	public ByteArrayOutputStream creatPDFDynamic(House house, String jksj, String jkje, String w008, String username,
			String title, String xmlname) throws Exception {
		init();
		Document document = new Document();// 建立一个Document对象
		// document.setPageSize(PageSize.A4);// 设置页面大小,为A4纸
		Rectangle pageSize = new Rectangle(268, 550);
		document.setPageSize(pageSize);
		document.setPageSize(pageSize.rotate());

		ByteArrayOutputStream ops = new ByteArrayOutputStream();// 输出到客户段的流
		PdfWriter writer = PdfWriter.getInstance(document, ops);// 建立一个PdfWriter对象

		document.open();

		// 定点输出文字
		PdfContentByte cb = writer.getDirectContent();

		cb.beginText();
		// 设置字号
		cb.setFontAndSize(bfChinese, 11);

		// 读取XML配置文件定义标签坐标 xmlname
		// Map map = Dom4j.getNodeForPrintSet("wxzjprintset.xml", "PaymentReg");
		Map map = new HashMap();
		if (xmlname != null && !xmlname.trim().equals("")) {
			map = Dom4j.getNodeForPrintSet(xmlname, "PaymentReg");
		} else {
			map = Dom4j.getNodeForPrintSet("wxzjprintset.xml", "PaymentReg");
		}

		String[] date = jksj.split("-");
		// 设置字号
		cb.setFontAndSize(bfChinese, ((PrintSet) map.get("year")).getFontsize());
		// 年月日
		cb.showTextAligned(PdfContentByte.ALIGN_RIGHT, date[0], ((PrintSet) map.get("year")).getX(), ((PrintSet) map
				.get("year")).getY(), 0);
		cb.showTextAligned(PdfContentByte.ALIGN_RIGHT, date[1], ((PrintSet) map.get("month")).getX(), ((PrintSet) map
				.get("month")).getY(), 0);
		cb.showTextAligned(PdfContentByte.ALIGN_RIGHT, date[2], ((PrintSet) map.get("day")).getX(), ((PrintSet) map
				.get("day")).getY(), 0);

		// 房屋编号
		cb.showTextAligned(PdfContentByte.ALIGN_LEFT, "房屋编号：" + house.getH001(), ((PrintSet) map.get("h001")).getX(),
				((PrintSet) map.get("h001")).getY(), 0);

		// 业主
		cb.showTextAligned(PdfContentByte.ALIGN_LEFT, house.getH013(), ((PrintSet) map.get("h013")).getX(),
				((PrintSet) map.get("h013")).getY(), 0);
		// 面积1
		cb.showTextAligned(PdfContentByte.ALIGN_RIGHT, String.valueOf(house.getH006()), ((PrintSet) map.get("h0060"))
				.getX(), ((PrintSet) map.get("h0060")).getY(), 0);
		// cb.showTextAligned(PdfContentByte.ALIGN_LEFT, house.getH015(),
		// ((PrintSet)map.get("h015")).getX(),
		// ((PrintSet)map.get("h015")).getY(), 0);

		// 地址
		cb.showTextAligned(PdfContentByte.ALIGN_LEFT, house.getAddress(), ((PrintSet) map.get("address")).getX(),
				((PrintSet) map.get("address")).getY(), 0);
		if (DataHolder.customerInfo.isNC()) {
			String address=house.getLymc()+""+house.getH002()+"单元"+house.getH003()+"层"+house.getH005()+"号";
			cb.showTextAligned(PdfContentByte.ALIGN_LEFT, address, ((PrintSet) map.get("address")).getX(),
					((PrintSet) map.get("address")).getY(), 0);
		} else {
			cb.showTextAligned(PdfContentByte.ALIGN_LEFT, house.getAddress(), ((PrintSet) map.get("address")).getX(),
					((PrintSet) map.get("address")).getY(), 0);
		}
		
		// 业主电话
		cb.showTextAligned(PdfContentByte.ALIGN_LEFT, house.getH019(), ((PrintSet) map.get("h019")).getX(),
				((PrintSet) map.get("h019")).getY(), 0);

		// 楼宇 单元 层 房号
		cb.showTextAligned(PdfContentByte.ALIGN_CENTER, house.getLymc(), ((PrintSet) map.get("lymc")).getX(),
				((PrintSet) map.get("lymc")).getY(), 0);
		cb.showTextAligned(PdfContentByte.ALIGN_CENTER, house.getH002(), ((PrintSet) map.get("h002")).getX(),
				((PrintSet) map.get("h002")).getY(), 0);
		cb.showTextAligned(PdfContentByte.ALIGN_CENTER, house.getH003(), ((PrintSet) map.get("h003")).getX(),
				((PrintSet) map.get("h003")).getY(), 0);
		cb.showTextAligned(PdfContentByte.ALIGN_CENTER, house.getH005(), ((PrintSet) map.get("h005")).getX(),
				((PrintSet) map.get("h005")).getY(), 0);

		// 单价
		cb.showTextAligned(PdfContentByte.ALIGN_CENTER, String.valueOf(house.getH009()), ((PrintSet) map.get("h009"))
				.getX(), ((PrintSet) map.get("h009")).getY(), 0);
		// 房屋用途
		cb.showTextAligned(PdfContentByte.ALIGN_CENTER, house.getH045(), ((PrintSet) map.get("h045")).getX(),
				((PrintSet) map.get("h045")).getY(), 0);

		// 交存标准
		Double jcbz = Double.valueOf(0);
		String jcbzStr = "";
		if (Double.valueOf(house.getH022()) > 1) {
			jcbz = Double.valueOf(house.getH022());
			jcbzStr = jcbz.toString();
		} else {
			jcbz = Double.valueOf(house.getH022()) * 100;
			jcbzStr = jcbz.toString() + "%";
		}
		String h017 = house.getH017().trim();
		if (h017.equals("01")) {
			// 左侧 有电梯
			cb.showTextAligned(PdfContentByte.ALIGN_RIGHT, String.valueOf(house.getH006()), ((PrintSet) map
					.get("h006left")).getX(), ((PrintSet) map.get("h006left")).getY(), 0);
			if (Double.valueOf(house.getH022()) < 1) {
				cb.showTextAligned(PdfContentByte.ALIGN_RIGHT, "按房款交存", ((PrintSet) map.get("fkjcleft")).getX(),
						((PrintSet) map.get("fkjcleft")).getY(), 0);
			} else {
				cb.showTextAligned(PdfContentByte.ALIGN_RIGHT, jcbzStr, ((PrintSet) map.get("h022left")).getX(),
						((PrintSet) map.get("h022left")).getY(), 0);
			}
		} else {
			// 右侧 无电梯
			cb.showTextAligned(PdfContentByte.ALIGN_RIGHT, String.valueOf(house.getH006()), ((PrintSet) map
					.get("h006right")).getX(), ((PrintSet) map.get("h006right")).getY(), 0);
			if (Double.valueOf(house.getH022()) < 1) {
				cb.showTextAligned(PdfContentByte.ALIGN_RIGHT, "按房款交存", ((PrintSet) map.get("fkjcright")).getX(),
						((PrintSet) map.get("fkjcright")).getY(), 0);
			} else {
				cb.showTextAligned(PdfContentByte.ALIGN_RIGHT, jcbzStr, ((PrintSet) map.get("h022right")).getX(),
						((PrintSet) map.get("h022right")).getY(), 0);
			}
		}

		if (jkje.endsWith(".0"))
			jkje = jkje.substring(0, jkje.length() - 2);
		// 交存金额
		cb.showTextAligned(PdfContentByte.ALIGN_LEFT, ChangeRMB.doChangeRMB(jkje), ((PrintSet) map.get("u_jkje"))
				.getX(), ((PrintSet) map.get("u_jkje")).getY(), 0);
		cb.showTextAligned(PdfContentByte.ALIGN_LEFT, "￥" + jkje, ((PrintSet) map.get("l_jkje")).getX(),
				((PrintSet) map.get("l_jkje")).getY(), 0);

		cb.showTextAligned(PdfContentByte.ALIGN_LEFT, username, ((PrintSet) map.get("username")).getX(),
				((PrintSet) map.get("username")).getY(), 0);

		cb.setFontAndSize(bfChinese, 8);
		cb.showTextAligned(PdfContentByte.ALIGN_LEFT, title, ((PrintSet) map.get("skdy")).getX(), ((PrintSet) map
				.get("skdy")).getY(), 0);
		cb.endText();

		document.close();
		return ops;
	}

	// 套打【从数据库获取打印配置参数】
	public ByteArrayOutputStream creatPDFDynamicDB(House house, String jksj, String jkje, String w008, String username,
			String title, String deptcode, String fingerprintData,String pjh, Map map) throws Exception {
		init();
		Document document = new Document();// 建立一个Document对象
		// document.setPageSize(PageSize.A4);// 设置页面大小,为A4纸
		Rectangle pageSize = new Rectangle(268, 550);
		document.setPageSize(pageSize);
		document.setPageSize(pageSize.rotate());

		ByteArrayOutputStream ops = new ByteArrayOutputStream();// 输出到客户段的流
		PdfWriter writer = PdfWriter.getInstance(document, ops);// 建立一个PdfWriter对象

		document.open();

		// 定点输出文字
		PdfContentByte cb = writer.getDirectContent();

		cb.beginText();
		// 设置字号
		cb.setFontAndSize(bfChinese, 11);

		// 读取XML配置文件定义标签坐标 xmlname
		// Map map = Dom4j.getNodeForPrintSet("wxzjprintset.xml", "PaymentReg");

		String[] date = jksj.split("-");
		// 设置字号
		cb.setFontAndSize(bfChinese, ((PrintSet) map.get("year")).getFontsize());
		// 年月日
		cb.showTextAligned(PdfContentByte.ALIGN_RIGHT, date[0], ((PrintSet) map.get("year")).getX(), ((PrintSet) map
				.get("year")).getY(), 0);
		cb.showTextAligned(PdfContentByte.ALIGN_RIGHT, date[1], ((PrintSet) map.get("month")).getX(), ((PrintSet) map
				.get("month")).getY(), 0);
		cb.showTextAligned(PdfContentByte.ALIGN_RIGHT, date[2], ((PrintSet) map.get("day")).getX(), ((PrintSet) map
				.get("day")).getY(), 0);

		// 房屋编号
		cb.showTextAligned(PdfContentByte.ALIGN_LEFT, "房屋编号：" + house.getH001(), ((PrintSet) map.get("h001")).getX(),
				((PrintSet) map.get("h001")).getY(), 0);

		// 业主
		cb.showTextAligned(PdfContentByte.ALIGN_LEFT, house.getH013(), ((PrintSet) map.get("h013")).getX(),
				((PrintSet) map.get("h013")).getY(), 0);
		// 面积1
		cb.showTextAligned(PdfContentByte.ALIGN_RIGHT, String.valueOf(house.getH006()), ((PrintSet) map.get("h0060"))
				.getX(), ((PrintSet) map.get("h0060")).getY(), 0);
		// cb.showTextAligned(PdfContentByte.ALIGN_LEFT, house.getH015(),
		// ((PrintSet)map.get("h015")).getX(),
		// ((PrintSet)map.get("h015")).getY(), 0);

		// 地址
		cb.showTextAligned(PdfContentByte.ALIGN_LEFT, house.getAddress(), ((PrintSet) map.get("address")).getX(),
				((PrintSet) map.get("address")).getY(), 0);
		// 业主电话
		cb.showTextAligned(PdfContentByte.ALIGN_LEFT, house.getH019(), ((PrintSet) map.get("h019")).getX(),
				((PrintSet) map.get("h019")).getY(), 0);

		// 楼宇 单元 层 房号
		/*
		 * cb.showTextAligned(PdfContentByte.ALIGN_CENTER, house.getLymc(),
		 * ((PrintSet)map.get("lymc")).getX(),
		 * ((PrintSet)map.get("lymc")).getY(), 0);
		 * cb.showTextAligned(PdfContentByte.ALIGN_CENTER, house.getH002(),
		 * ((PrintSet)map.get("h002")).getX(),
		 * ((PrintSet)map.get("h002")).getY(), 0);
		 * cb.showTextAligned(PdfContentByte.ALIGN_CENTER, house.getH003(),
		 * ((PrintSet)map.get("h003")).getX(),
		 * ((PrintSet)map.get("h003")).getY(), 0);
		 * cb.showTextAligned(PdfContentByte.ALIGN_CENTER, house.getH005(),
		 * ((PrintSet)map.get("h005")).getX(),
		 * ((PrintSet)map.get("h005")).getY(), 0);
		 * 
		 * // 单价 cb.showTextAligned(PdfContentByte.ALIGN_CENTER,
		 * String.valueOf(house.getH009()), ((PrintSet)map.get("h009")).getX(),
		 * ((PrintSet)map.get("h009")).getY(), 0); //房屋用途
		 * cb.showTextAligned(PdfContentByte.ALIGN_CENTER, house.getH045(),
		 * ((PrintSet)map.get("h045")).getX(),
		 * ((PrintSet)map.get("h045")).getY(), 0);
		 */
		// 交存标准
		Double jcbz = Double.valueOf(0);
		String jcbzStr = "";
		if (Double.valueOf(house.getH022()) > 1) {
			jcbz = Double.valueOf(house.getH022());
			jcbzStr = jcbz.toString();
		} else {
			jcbz = Double.valueOf(house.getH022()) * 100;
			jcbzStr = jcbz.toString() + "%";
		}
		String h017 = house.getH017().trim();
		if (h017.equals("01")) {
			// 左侧 有电梯
			cb.showTextAligned(PdfContentByte.ALIGN_RIGHT, String.valueOf(house.getH006()), ((PrintSet) map
					.get("h006left")).getX(), ((PrintSet) map.get("h006left")).getY(), 0);
			if (Double.valueOf(house.getH022()) < 1) {
				cb.showTextAligned(PdfContentByte.ALIGN_RIGHT, "按房款交存", ((PrintSet) map.get("fkjcleft")).getX(),
						((PrintSet) map.get("fkjcleft")).getY(), 0);
			} else {
				cb.showTextAligned(PdfContentByte.ALIGN_RIGHT, jcbzStr, ((PrintSet) map.get("h022left")).getX(),
						((PrintSet) map.get("h022left")).getY(), 0);
			}
		} else {
			// 右侧 无电梯
			cb.showTextAligned(PdfContentByte.ALIGN_RIGHT, String.valueOf(house.getH006()), ((PrintSet) map
					.get("h006right")).getX(), ((PrintSet) map.get("h006right")).getY(), 0);
			if (Double.valueOf(house.getH022()) < 1) {
				cb.showTextAligned(PdfContentByte.ALIGN_RIGHT, "按房款交存", ((PrintSet) map.get("fkjcright")).getX(),
						((PrintSet) map.get("fkjcright")).getY(), 0);
			} else {
				cb.showTextAligned(PdfContentByte.ALIGN_RIGHT, jcbzStr, ((PrintSet) map.get("h022right")).getX(),
						((PrintSet) map.get("h022right")).getY(), 0);
			}
		}

		if (jkje.endsWith(".0"))
			jkje = jkje.substring(0, jkje.length() - 2);
		// 交存金额
		cb.showTextAligned(PdfContentByte.ALIGN_LEFT, ChangeRMB.doChangeRMB(jkje), ((PrintSet) map.get("u_jkje"))
				.getX(), ((PrintSet) map.get("u_jkje")).getY(), 0);
		cb.showTextAligned(PdfContentByte.ALIGN_LEFT, "￥" + jkje, ((PrintSet) map.get("l_jkje")).getX(),
				((PrintSet) map.get("l_jkje")).getY(), 0);

		cb.showTextAligned(PdfContentByte.ALIGN_LEFT, username, ((PrintSet) map.get("username")).getX(),
				((PrintSet) map.get("username")).getY(), 0);

		// 单位编码、数字指纹
		cb.showTextAligned(PdfContentByte.ALIGN_LEFT, deptcode==null?"":deptcode, ((PrintSet) map.get("deptcode")).getX(),
				((PrintSet) map.get("deptcode")).getY(), 0);
		cb.showTextAligned(PdfContentByte.ALIGN_LEFT, fingerprintData==null?"":fingerprintData, ((PrintSet) map.get("fingerprintData")).getX(),
				((PrintSet) map.get("fingerprintData")).getY(), 0);
		//票据号
		cb.showTextAligned(PdfContentByte.ALIGN_LEFT, pjh==null?"":pjh, ((PrintSet) map.get("billNo")).getX(),
				((PrintSet) map.get("billNo")).getY(), 0);

		cb.setFontAndSize(bfChinese, 8);
		cb.showTextAligned(PdfContentByte.ALIGN_LEFT, title, ((PrintSet) map.get("skdy")).getX(), ((PrintSet) map
				.get("skdy")).getY(), 0);
		cb.endText();

		document.close();
		return ops;
	}

	// 非套打
	public ByteArrayOutputStream creatPDFFixed(House house, String jksj, String jkje, String w008, String username,
			String title) throws Exception {
		init();
		Document document = new Document();// 建立一个Document对象
		document.setPageSize(PageSize.A4);// 设置页面大小,为A4纸

		ByteArrayOutputStream ops = new ByteArrayOutputStream();// 输出到客户段的流
		PdfWriter.getInstance(document, ops);// 建立一个PdfWriter对象

		document.open();
		float[] widths = { 60f, 150f, 80f, 120f };// 设置表格的列以及列宽
		PdfPTable table = new PdfPTable(widths);// 建立一个pdf表格

		table.setSpacingBefore(20f);// 设置表格上面空白宽度
		table.setTotalWidth(460);// 设置表格的宽度
		table.setLockedWidth(true);// 设置表格的宽度固定
		table.getDefaultCell().setBorder(1);// 设置表格默认为无边框

		PdfPCell cell = PdfUtil.createCell(title, headFont1, 0, 20, 4, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);// 增加单元格

		// 空行
		cell = PdfUtil.createCell("", headFont1, 0, 10, 4, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		// -------------br
		String[] date = jksj.split("-");
		cell = PdfUtil.createCell("交款日期：" + date[0] + "年   " + date[1] + "月   " + date[2] + "日", headFont2, 0, 20, 2,
				PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		String[] djDate = DateUtil.getDate(new Date()).split("-");
		cell = PdfUtil.createCell(" 打印日期：" + djDate[0] + "年   " + djDate[1] + "月   " + djDate[2] + "日", headFont2, 0,
				20, 2, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		// -------------br
		cell = PdfUtil.createCell("产  权  人", headFont2, 20);
		table.addCell(cell);
		cell = PdfUtil.createCell(house.getH013(), headFont3, 1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("身份证号码", headFont2, 20);
		table.addCell(cell);
		cell = PdfUtil.createCell(house.getH015(), headFont3, 1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		// -------------br
		cell = PdfUtil.createCell("房屋住址", headFont2, 20);
		table.addCell(cell);
		cell = PdfUtil.createCell("           " + house.getLymc() + "    " + house.getH002() + "单元  " + house.getH003()
				+ "层  " + house.getH005() + "号", headFont3, 1, 20, 3, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		// -------------br
		cell = PdfUtil.createCell("建筑面积", headFont2, 20);
		table.addCell(cell);
		cell = PdfUtil.createCell(house.getH006() + "平方米", headFont3, 1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("交存标准", headFont2, 20);
		table.addCell(cell);
		cell = PdfUtil.createCell(house.getH023(), headFont3, 1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		// -------------br
		cell = PdfUtil.createCell("房屋性质", headFont2, 20);
		table.addCell(cell);
		cell = PdfUtil.createCell(house.getH045(), headFont3, 1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("交款金额(元)", headFont2, 20);
		table.addCell(cell);
		cell = PdfUtil.createCell("￥" + jkje + "元", headFont3, 1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		// -------------br
		cell = PdfUtil.createCell("    金额（大写）    " + ChangeRMB.doChangeRMB(jkje), headFont2, 1, 20, 2, PdfUtil.LEFT_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("房屋编号", headFont2, 20);
		table.addCell(cell);
		cell = PdfUtil.createCell(house.getH001(), headFont3, 1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		// -------------br
		cell = PdfUtil.createCell("      收款单位（章）                        开票人（章） " + username
				+ "                      备注：  原收据作废", headFont2, 0, 20, 4, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		document.add(table);
		document.close();
		return ops;
	}

	// 非套打
	public ByteArrayOutputStream creatPDFFixed_JJ(House house, String jksj, String jkje, String w008, String username,
			String title) throws Exception {
		init();
		Document document = new Document();// 建立一个Document对象
		document.setPageSize(PageSize.A4);// 设置页面大小,为A4纸

		ByteArrayOutputStream ops = new ByteArrayOutputStream();// 输出到客户段的流
		PdfWriter.getInstance(document, ops);// 建立一个PdfWriter对象

		document.open();
		float[] widths = { 60f, 150f, 80f, 120f };// 设置表格的列以及列宽
		PdfPTable table = new PdfPTable(widths);// 建立一个pdf表格

		table.setSpacingBefore(20f);// 设置表格上面空白宽度
		table.setTotalWidth(460);// 设置表格的宽度
		table.setLockedWidth(true);// 设置表格的宽度固定
		table.getDefaultCell().setBorder(1);// 设置表格默认为无边框

		PdfPCell cell = PdfUtil.createCell(title, headFont1, 0, 20, 4, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);// 增加单元格

		// 空行
		cell = PdfUtil.createCell("", headFont1, 0, 10, 4, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		// -------------br
		String[] date = jksj.split("-");
		cell = PdfUtil.createCell("交款日期：" + date[0] + "年   " + date[1] + "月   " + date[2] + "日", headFont2, 0, 20, 2,
				PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		String[] djDate = DateUtil.getDate(new Date()).split("-");
		cell = PdfUtil.createCell(" 打印日期：" + djDate[0] + "年   " + djDate[1] + "月   " + djDate[2] + "日", headFont2, 0,
				20, 2, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		// -------------br
		cell = PdfUtil.createCell("产  权  人", headFont2, 20);
		table.addCell(cell);
		cell = PdfUtil.createCell(house.getH013(), headFont3, 1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("身份证号码", headFont2, 20);
		table.addCell(cell);
		cell = PdfUtil.createCell(house.getH015(), headFont3, 1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		// -------------br
		cell = PdfUtil.createCell("房屋住址", headFont2, 20);
		table.addCell(cell);
		cell = PdfUtil.createCell("           " + house.getLymc() + "    " + house.getH002() + "单元  " + house.getH003()
				+ "层  " + house.getH005() + "号", headFont3, 1, 20, 3, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		// -------------br
		cell = PdfUtil.createCell("产权住址", headFont2, 20);
		table.addCell(cell);
		cell = PdfUtil.createCell("           " + house.getH047(), headFont3, 1, 20, 3, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		// -------------br
		cell = PdfUtil.createCell("建筑面积", headFont2, 20);
		table.addCell(cell);
		cell = PdfUtil.createCell(house.getH006() + "平方米", headFont3, 1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("交存标准", headFont2, 20);
		table.addCell(cell);
		cell = PdfUtil.createCell(house.getH023(), headFont3, 1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		// -------------br
		cell = PdfUtil.createCell("房屋性质", headFont2, 20);
		table.addCell(cell);
		cell = PdfUtil.createCell(house.getH045(), headFont3, 1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("交款金额(元)", headFont2, 20);
		table.addCell(cell);
		cell = PdfUtil.createCell("￥" + jkje + "元", headFont3, 1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		// -------------br
		cell = PdfUtil.createCell("    金额（大写）    " + ChangeRMB.doChangeRMB(jkje), headFont2, 1, 20, 2, PdfUtil.LEFT_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("房屋编号", headFont2, 20);
		table.addCell(cell);
		cell = PdfUtil.createCell(house.getH001(), headFont3, 1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		// -------------br
		cell = PdfUtil.createCell("      收款单位（章）                        开票人（章） " + username
				+ "                      备注：  仅供办理产权证使用", headFont2, 0, 20, 4, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		document.add(table);
		document.close();
		return ops;
	}
}

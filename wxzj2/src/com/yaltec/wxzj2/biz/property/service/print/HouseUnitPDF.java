package com.yaltec.wxzj2.biz.property.service.print;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.text.DecimalFormat;
import java.util.Date;
import java.util.List;
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
import com.yaltec.comon.utils.PdfUtil;
import com.yaltec.wxzj2.biz.property.entity.HouseUnitPrint;
import com.yaltec.wxzj2.biz.system.entity.PrintSet;
import com.yaltec.wxzj2.biz.system.entity.User;

public class HouseUnitPDF {
	private static BaseFont bfChinese;
	private static Font headFont1;
	private static Font headFont2;
	private static Font headFont3;
	private static DecimalFormat df = new DecimalFormat("0.00"); // 保留2位小数

	// 光大银行现金打票配置
	private static final String UNIT_NAME = "重庆市九龙坡区物业专项维修资金管理中心";
	private static final String BANK = "光大银行九龙坡支行";
	private static final String BANKNO = "39420188000501921";

	static Logger logger = LoggerFactory.getLogger(HouseUnitPDF.class);

	public static void init() throws DocumentException, IOException {
		bfChinese = BaseFont.createFont("STSong-Light", "UniGB-UCS2-H",
				BaseFont.NOT_EMBEDDED);// 设置中文字体
		headFont1 = new Font(bfChinese, 20, Font.NORMAL);// 设置字体大小
		headFont2 = new Font(bfChinese, 10, Font.NORMAL);// 设置字体大小
		headFont3 = new Font(bfChinese, 9, Font.NORMAL);// 设置字体大小
	}

	public ByteArrayOutputStream creatPDF(List<HouseUnitPrint> list, User user,
			String title, String assignmentName) throws Exception {
		init();
		ByteArrayOutputStream ops = new ByteArrayOutputStream();// 输出到客户段的流

		Document document = new Document();// 建立一个Document对象
		document.setPageSize(PageSize.A4);// 设置页面大小,为A4纸
		/*
		 * Rectangle pageSize = new Rectangle(278, 550);// 设置页面大小
		 * document.setPageSize(pageSize);
		 * document.setPageSize(pageSize.rotate());
		 */
		PdfWriter.getInstance(document, ops);// 建立一个PdfWriter对象
		document.open();
		float[] widths = { 70f, 190f, 65f, 60f, 70f };// 设置表格的列以及列宽

		for (int i = 0; i < list.size(); i++) {
			PdfPTable table = new PdfPTable(widths);// 建立一个pdf表格
			table.setSpacingBefore(10f);// 设置表格上面空白宽度
			table.setTotalWidth(455);// 设置表格的宽度
			table.setLockedWidth(true);// 设置表格的宽度固定
			table.getDefaultCell().setBorder(1);// 设置表格默认为无边框

			PdfPCell cell = PdfUtil.createCell(title, headFont1, 0, 25, 5,
					PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);// 增加单元格

			// 空行
			cell = PdfUtil.createCell("", headFont3, 0, 5, 5, PdfUtil.CENTER_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);
			// -------------
			cell = PdfUtil.createCell("", headFont3, 0, 15, 3,
					PdfUtil.CENTER_H, PdfUtil.CENTER_H);
			table.addCell(cell);
			cell = PdfUtil.createCell("房屋编号：" + list.get(i).getH001(),
					headFont3, 0, 20, 2, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			// -------------
			cell = PdfUtil.createCell("业主姓名", headFont2, 1, 25, 1,
					PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(list.get(i).getH013(), headFont3, 1, 25,
					1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell("身份证号", headFont2, 1, 25, 1,
					PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(list.get(i).getH015(), headFont3, 1, 25,
					2, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			// -------------
			cell = PdfUtil.createCell("楼宇名称", headFont2, 1, 25, 1,
					PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(list.get(i).getLymc(), headFont3, 1, 25,
					1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell("交存标准", headFont2, 1, 25, 1,
					PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);

			cell = PdfUtil.createCell(list.get(i).getXm() + " * "
					+ list.get(i).getXs(), headFont3, 1, 25, 2, PdfUtil.LEFT_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);
			// -------------
			cell = PdfUtil.createCell("交存银行", headFont2, 1, 25, 1,
					PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(list.get(i).getYhmc(), headFont3, 1, 25,
					2, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell("建筑面积", headFont2, 1, 25, 1,
					PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(df.format(Double.valueOf(list.get(i)
					.getH006()))
					+ " ㎡", headFont3, 1, 25, 1, PdfUtil.LEFT_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);
			// -------------
			cell = PdfUtil.createCell("银行账号", headFont2, 1, 25, 1,
					PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(list.get(i).getBankno(), headFont3, 1,
					25, 2, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell("交存金额", headFont2, 1, 25, 1,
					PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell("￥"
					+ df.format(Double.valueOf(list.get(i).getH021())) + " 元",
					headFont3, 1, 25, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			// -------------
			cell = PdfUtil.createCell("房屋地址", headFont2, 1, 25, 1,
					PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(list.get(i).getH047(), headFont3, 1, 25,
					4, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			// -------------
			cell = PdfUtil.createCell("收款单位：" + assignmentName, headFont3, 0,
					30, 2, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell("操作员：" + user.getUsername()
					+ "        打印日期：" + list.get(i).getToday(), headFont3, 0,
					30, 3, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			// -------------
			document.add(table);
			document.newPage(); // 强制换页
		}
		document.close();

		return ops;
	}

	/**
	 * 光大银行套打
	 * 
	 * @param list
	 * @param user
	 * @param title
	 * @param assignmentName
	 * @return
	 * @throws Exception
	 */
	// 套打【从数据库获取打印配置参数】
	public ByteArrayOutputStream creatPDFDynamic_GDYH(
			List<HouseUnitPrint> list, Map map) throws Exception {
		init();
		Document document = new Document();// 建立一个Document对象
		Rectangle pageSize = new Rectangle(268, 550);
		document.setPageSize(pageSize);
		document.setPageSize(pageSize.rotate());

		ByteArrayOutputStream ops = new ByteArrayOutputStream();// 输出到客户段的流
		PdfWriter writer = PdfWriter.getInstance(document, ops);// 建立一个PdfWriter对象
		document.open();
		for (HouseUnitPrint house : list) {

			// 定点输出文字
			PdfContentByte cb = writer.getDirectContent();
			// 设置字体
			cb.beginText();
			cb.setFontAndSize(bfChinese, 11);

			String nowDate = DateUtil.getDate(new Date());
			String[] date = nowDate.split("-");

			// 年月日
			cb.showTextAligned(PdfContentByte.ALIGN_RIGHT, date[0].substring(0,
					4), ((PrintSet) map.get("year")).getX(), ((PrintSet) map
					.get("year")).getY(), 0);
			cb.showTextAligned(PdfContentByte.ALIGN_RIGHT, date[1],
					((PrintSet) map.get("month")).getX(), ((PrintSet) map
							.get("month")).getY(), 0);
			cb.showTextAligned(PdfContentByte.ALIGN_RIGHT, date[2],
					((PrintSet) map.get("day")).getX(), ((PrintSet) map
							.get("day")).getY(), 0);

			// 收款单位
			cb.showTextAligned(PdfContentByte.ALIGN_LEFT, UNIT_NAME,
					((PrintSet) map.get("unitname")).getX(), ((PrintSet) map
							.get("unitname")).getY(), 0);

			// 银行名称
			cb.showTextAligned(PdfContentByte.ALIGN_LEFT, BANK, ((PrintSet) map
					.get("yhmc")).getX(), ((PrintSet) map.get("yhmc")).getY(),
					0);

			// 银行帐号
			cb.showTextAligned(PdfContentByte.ALIGN_LEFT, BANKNO,
					((PrintSet) map.get("bankno")).getX(), ((PrintSet) map
							.get("bankno")).getY(), 0);

			StringBuffer remark = new StringBuffer();
			remark.append(house.getLymc()).append("         ");
			remark.append(house.getH002()).append("-").append(house.getH003())
					.append("-").append(house.getH005());
			remark.append("         ").append(house.getH013());
			// 摘要
			cb.showTextAligned(PdfContentByte.ALIGN_LEFT, remark.toString(),
					((PrintSet) map.get("remark")).getX(), ((PrintSet) map
							.get("remark")).getY(), 0);
			// 大写金额
			cb.showTextAligned(PdfContentByte.ALIGN_LEFT, ChangeRMB
					.doChangeRMB(house.getH021()), ((PrintSet) map
					.get("u_jkje")).getX(), ((PrintSet) map.get("u_jkje"))
					.getY(), 0);
			// 币种
			cb.showTextAligned(PdfContentByte.ALIGN_LEFT, "√", ((PrintSet) map
					.get("bz")).getX(), ((PrintSet) map.get("bz")).getY(), 0);

			// 交存金额
			cb.showTextAligned(PdfContentByte.ALIGN_LEFT, ChangeRMB
					.doChangeRMB(house.getH021()), ((PrintSet) map
					.get("u_jkje")).getX(), ((PrintSet) map.get("u_jkje"))
					.getY(), 0);
			String[] jkje = PdfUtil.convert(house.getH021());
			String[] str = { "千万", "百万", "十万", "万", "千", "百", "十", "元", "角",
					"分" };
			for (int i = 0; i < jkje.length; i++) {
				cb.showTextAligned(PdfContentByte.ALIGN_LEFT, jkje[i],
						((PrintSet) map.get(str[i])).getX(), ((PrintSet) map
								.get(str[i])).getY(), 0);
			}
			cb.endText();
			document.newPage();
		}

		document.close();
		return ops;
	}

}

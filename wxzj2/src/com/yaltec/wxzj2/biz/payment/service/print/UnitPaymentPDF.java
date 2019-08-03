package com.yaltec.wxzj2.biz.payment.service.print;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.text.DecimalFormat;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.lowagie.text.Document;
import com.lowagie.text.DocumentException;
import com.lowagie.text.Font;
import com.lowagie.text.PageSize;
import com.lowagie.text.pdf.BaseFont;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;
import com.yaltec.comon.utils.DateUtil;
import com.yaltec.comon.utils.PdfUtil;
import com.yaltec.wxzj2.biz.payment.entity.UnitToPrepay;
import com.yaltec.wxzj2.biz.property.entity.HouseUnitPrint;
import com.yaltec.wxzj2.biz.system.entity.User;


public class UnitPaymentPDF {
	private static BaseFont bfChinese;
	private static Font headFont1;
	private static Font headFont2;
	private static Font headFont3;
	private static Font headFont4;
	private static DecimalFormat df = new DecimalFormat("0.00"); // 保留2位小数

	static Logger logger = LoggerFactory.getLogger(UnitPaymentPDF.class);

	public static void init() throws DocumentException, IOException {
		bfChinese = BaseFont.createFont("STSong-Light", "UniGB-UCS2-H",
				BaseFont.NOT_EMBEDDED);// 设置中文字体
		headFont1 = new Font(bfChinese, 20, Font.NORMAL);// 设置字体大小
		headFont2 = new Font(bfChinese, 10, Font.NORMAL);// 设置字体大小
		headFont3 = new Font(bfChinese, 9, Font.NORMAL);// 设置字体大小
		headFont4 = new Font(bfChinese, 10, Font.NORMAL);// 设置字体大小
	}

	public ByteArrayOutputStream toPrintUnitPayment(List<UnitToPrepay> list,String title)
			throws Exception {
		init();
		ByteArrayOutputStream ops = new ByteArrayOutputStream();// 输出到客户段的流

		Document document = new Document();// 建立一个Document对象
		document.setPageSize(PageSize.A4);// 设置页面大小,为A4纸
		/*
		Rectangle pageSize = new Rectangle(278, 550);// 设置页面大小
		document.setPageSize(pageSize);
		document.setPageSize(pageSize.rotate());
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

			PdfPCell cell = PdfUtil.createCell(title, headFont1, 0,
					25, 5, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);// 增加单元格

			// 空行
			cell = PdfUtil.createCell("", headFont3, 0, 5, 5, PdfUtil.CENTER_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);
			// -------------
			cell = PdfUtil.createCell("", headFont3, 0, 15, 3,
					PdfUtil.CENTER_H, PdfUtil.CENTER_H);
			table.addCell(cell);
			cell = PdfUtil.createCell("",
					headFont3, 0, 20, 2, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			
			// -------------
			cell = PdfUtil.createCell("单位名称", headFont2, 1, 25, 1,
					PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(list.get(i).getDwmc(), headFont3, 1, 25,
					1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell("交款银行", headFont2, 1, 25, 1,
					PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(list.get(i).getYhmc(), headFont3, 1, 25,
					2, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			// -------------
			cell = PdfUtil.createCell("业务日期", headFont2, 1, 25, 1,
					PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(DateUtil.format(DateUtil.ZH_CN_DATE, list.get(i).getYwrq()), headFont3, 1, 25,
					1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell("交款金额", headFont2, 1, 25, 1,
					PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(list.get(i).getJkje(), headFont3, 1, 25,
					2, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			
			
			// -------------
			cell = PdfUtil.createCell("备注", headFont2, 1, 25, 1,
					PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell("开发建设单位需在交款当月内提供维修资金业主缴交明细，以方便我中心开具分户票据，因你单位原因未在当月内完善手续的，由你单位承担相应责任。", headFont3, 1, 25,
					4, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			
		
			// -------------
			document.add(table);
			document.newPage(); //强制换页
		}
		document.close();

		return ops;
	}
}

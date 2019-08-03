package com.yaltec.wxzj2.biz.property.service.print;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.lowagie.text.Document;
import com.lowagie.text.DocumentException;
import com.lowagie.text.Font;
import com.lowagie.text.PageSize;
import com.lowagie.text.Rectangle;
import com.lowagie.text.pdf.BaseFont;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;
import com.yaltec.comon.utils.PdfUtil;
import com.yaltec.wxzj2.biz.payment.entity.HouseDw;
import com.yaltec.wxzj2.comon.data.DataHolder;

public class DepositCertificatePDF {
	/**
	 *<p>
	 * 文件名称: MergeSeparatePDF.java
	 * </p>
	 * <p>
	 * 文件描述:
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
	 * 完成日期：Oct 8, 2011
	 * </p>
	 * <p>
	 * 修改记录0：无
	 * </p>
	 * 
	 * @version 1.0
	 * @author yilong
	 */
	private static BaseFont bfChinese;
	private static Font headFont1;
	private static Font headFont2;
	private static Font headFont3;
	private static Font headFont4;

	static Logger logger = LoggerFactory.getLogger(DepositCertificatePDF.class);

	public static void init() throws DocumentException, IOException {
		bfChinese = BaseFont.createFont("STSong-Light", "UniGB-UCS2-H",
				BaseFont.NOT_EMBEDDED);// 设置中文字体
		headFont1 = new Font(bfChinese, 20, Font.BOLD);// 设置字体大小
		headFont2 = new Font(bfChinese, 12, Font.BOLD);// 设置字体大小
		headFont3 = new Font(bfChinese, 11, Font.NORMAL);// 设置字体大小
		headFont4 = new Font(bfChinese, 16, Font.BOLD);// 设置字体大小
	}

	/**
	 * 楼宇交存证明（单个）
	 * 
	 * @param house
	 * @param title
	 * @return
	 * @throws Exception
	 */
	public ByteArrayOutputStream creatFGPDF(HouseDw house, String title)
			throws Exception {
		// 判断是否垫江DataHolder.customerInfo.isDJ()
		if (DataHolder.customerInfo.isDJ()) {
			// 垫江
			title = "重庆市垫江县" + title;
			return creatFGPDF_DJ(house,title);
		}
		init();
		Document document = new Document();// 建立一个Document对象
		// document.setPageSize(pageSize.rotate());//横向打印

		ByteArrayOutputStream ops = new ByteArrayOutputStream();// 输出到客户段的流

		PdfWriter.getInstance(document, ops);// 建立一个PdfWriter对象
		document.open();
		float[] widths = { 50f, 30f, 30f, 30f, 30f, 40f, 60f, 30f, 40f, 40f,
				40f, 30f, 40f, 40f };// 设置表格的列以及列宽

		PdfPTable table = new PdfPTable(widths);// 建立一个pdf表格

		table.setSpacingBefore(20f);// 设置表格上面空白宽度
		table.setTotalWidth(770);// 设置表格的宽度
		table.setLockedWidth(true);// 设置表格的宽度固定
		table.getDefaultCell().setBorder(1);// 设置表格默认为无边框

		PdfPCell cell = PdfUtil.createCell(title, headFont1, 0, 35, 14,
				PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);// 增加单元格

		StringBuffer buffer = new StringBuffer();
		buffer.append("          ").append(house.getKfgsmc());
		if (!house.getKfgsmc().trim().equals("")) {
			buffer.append("，开发建设的");
		}
		buffer.append(house.getLymc()).append("，共计").append(house.getH001());
		buffer.append("户、建筑面积").append(house.getH006()).append("㎡、交款金额");
		buffer.append(house.getH021()).append("，该栋楼宇物业专项维修资金已缴清。");

		// 空行
		cell = PdfUtil.createCell("", headFont3, 0, 30, 14, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		// -------------
		cell = PdfUtil.createCell("", headFont4, 0, 90, 4, 2, PdfUtil.LEFT_H,
				PdfUtil.TOP_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(buffer.toString(), headFont4, 0, 90, 4, 10, PdfUtil.LEFT_H,
				PdfUtil.TOP_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("", headFont4, 0, 90, 4, 2, PdfUtil.LEFT_H,
				PdfUtil.TOP_V);
		table.addCell(cell);
		// -------------
		cell = PdfUtil.createCell("", headFont4, 0, 25, 11, PdfUtil.LEFT_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		// ---------------
		cell = PdfUtil.createCell("", headFont4, 0, 25, 2, PdfUtil.LEFT_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("", headFont4, 0, 25, 12, PdfUtil.LEFT_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		// ---------------
		cell = PdfUtil.createCell("", headFont4, 0, 25, 2, PdfUtil.LEFT_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("", headFont4, 0, 25, 12, PdfUtil.LEFT_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		// -------------
		cell = PdfUtil.createCell("", headFont4, 0, 25, 14, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);

		// -------------
		cell = PdfUtil.createCell("", headFont4, 0, 25, 14, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);

		// -------------
		cell = PdfUtil.createCell("", headFont4, 0, 25, 14, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);

		// -------------
		cell = PdfUtil.createCell("", headFont4, 0, 25, 14, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);

		// -------------
		cell = PdfUtil.createCell("", headFont4, 0, 25, 9, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("经办人：", headFont4, 0, 25, 5, PdfUtil.LEFT_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);

		// -------------
		cell = PdfUtil.createCell("", headFont4, 0, 25, 14, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);

		// -------------
		cell = PdfUtil.createCell("", headFont4, 0, 25, 9, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("科       长：", headFont4, 0, 25, 5,
				PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		// -------------
		cell = PdfUtil.createCell("", headFont4, 0, 25, 14, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);

		// -------------
		cell = PdfUtil.createCell("", headFont4, 0, 25, 9, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		Date dt = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy年MM月dd日");
		cell = PdfUtil.createCell(sdf.format(dt), headFont4, 0, 25, 5,
				PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		document.add(table);
		document.close();

		return ops;
	}
	
	/**
	 * 楼宇交存证明（垫江单个）
	 * 
	 * @param house
	 * @param title
	 * @return
	 * @throws Exception
	 */
	public ByteArrayOutputStream creatFGPDF_DJ(HouseDw house, String title)
			throws Exception {
		init();
		Document document = new Document();// 建立一个Document对象
		// document.setPageSize(pageSize.rotate());//横向打印

		ByteArrayOutputStream ops = new ByteArrayOutputStream();// 输出到客户段的流

		PdfWriter.getInstance(document, ops);// 建立一个PdfWriter对象
		document.open();
		float[] widths = { 50f, 30f, 30f, 30f, 30f, 40f, 60f, 30f, 40f, 40f,
				40f, 30f, 40f, 40f };// 设置表格的列以及列宽

		PdfPTable table = new PdfPTable(widths);// 建立一个pdf表格

		table.setSpacingBefore(50f);// 设置表格上面空白宽度
		table.setTotalWidth(770);// 设置表格的宽度
		table.setLockedWidth(true);// 设置表格的宽度固定
		table.getDefaultCell().setBorder(1);// 设置表格默认为无边框

		// 空行
		PdfPCell cell = PdfUtil.createCell("", headFont3, 0, 80, 14, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(title, headFont4, 0, 50, 14,
				PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);// 增加单元格

		StringBuffer buffer = new StringBuffer();
		buffer.append("          ").append(house.getKfgsmc());
		if (!house.getKfgsmc().trim().equals("")) {
			buffer.append("，开发建设的");
		}
		buffer.append(house.getLymc()).append("，共计").append(house.getH001());
		buffer.append("户、建筑面积").append(house.getH006()).append("㎡、交款金额");
		buffer.append(house.getH021()).append("，该栋楼宇物业专项维修资金已缴清。");

		// 空行
		cell = PdfUtil.createCell("", headFont3, 0, 30, 14, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		// -------------
		cell = PdfUtil.createCell("", headFont4, 0, 90, 4, 2, PdfUtil.LEFT_H,
				PdfUtil.TOP_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(buffer.toString(), headFont4, 0, 90, 4, 10, PdfUtil.LEFT_H,
				PdfUtil.TOP_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("", headFont4, 0, 90, 4, 2, PdfUtil.LEFT_H,
				PdfUtil.TOP_V);
		table.addCell(cell);
		// -------------
		cell = PdfUtil.createCell("", headFont4, 0, 25, 11, PdfUtil.LEFT_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		// ---------------
		cell = PdfUtil.createCell("", headFont4, 0, 25, 2, PdfUtil.LEFT_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("", headFont4, 0, 25, 12, PdfUtil.LEFT_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		// ---------------
		cell = PdfUtil.createCell("", headFont4, 0, 25, 2, PdfUtil.LEFT_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("", headFont4, 0, 25, 12, PdfUtil.LEFT_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		// -------------
		cell = PdfUtil.createCell("", headFont4, 0, 25, 14, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);

		// -------------
		cell = PdfUtil.createCell("", headFont4, 0, 25, 14, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);

		// -------------
		cell = PdfUtil.createCell("", headFont4, 0, 25, 14, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);

		// -------------
		cell = PdfUtil.createCell("", headFont4, 0, 25, 14, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);

		// -------------
		cell = PdfUtil.createCell("", headFont4, 0, 25, 1, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("统计：", headFont4, 0, 25, 3, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("复核：", headFont4, 0, 25, 5, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("单位负责人：", headFont4, 0, 25, 5, PdfUtil.LEFT_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);

		// -------------
		cell = PdfUtil.createCell("", headFont4, 0, 25, 14, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);

		// -------------
		cell = PdfUtil.createCell("", headFont4, 0, 25, 9, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		Date dt = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy年MM月dd日");
		cell = PdfUtil.createCell(sdf.format(dt), headFont4, 0, 25, 5,
				PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		document.add(table);
		document.close();

		return ops;
	}

	/**
	 * 楼宇交存证明（批量）
	 * 
	 * @param house
	 * @param title
	 * @return
	 * @throws Exception
	 */
	public ByteArrayOutputStream creatFGPDFMany(List<HouseDw> houses,
			String title) throws Exception {

		// 判断是否垫江DataHolder.customerInfo.isDJ()
		if (DataHolder.customerInfo.isDJ()) {
			// 垫江
			title = "重庆市垫江县" + title;
			return creatFGPDFMany_DJ(houses,title);
		}
		init();
		Document document = new Document();// 建立一个Document对象
		Rectangle pageSize = new Rectangle(PageSize.A4);// 设置页面大小,为A4纸
		// document.setPageSize(pageSize.rotate());//横向打印

		ByteArrayOutputStream ops = new ByteArrayOutputStream();// 输出到客户段的流

		PdfWriter.getInstance(document, ops);// 建立一个PdfWriter对象
		document.open();
		float[] widths = { 50f, 30f, 30f, 30f, 30f, 40f, 60f, 30f, 40f, 40f,
				40f, 30f, 40f, 40f };// 设置表格的列以及列宽

		for (HouseDw house : houses) {
			PdfPTable table = new PdfPTable(widths);// 建立一个pdf表格

			table.setSpacingBefore(20f);// 设置表格上面空白宽度
			table.setTotalWidth(770);// 设置表格的宽度
			table.setLockedWidth(true);// 设置表格的宽度固定
			table.getDefaultCell().setBorder(1);// 设置表格默认为无边框

			PdfPCell cell = PdfUtil.createCell(title, headFont1, 0, 35, 14,
					PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);// 增加单元格

			
			StringBuffer buffer = new StringBuffer();
			buffer.append("          ").append(house.getKfgsmc());
			if (!house.getKfgsmc().trim().equals("")) {
				buffer.append("，开发建设的");
			}
			buffer.append(house.getLymc()).append("，共计").append(house.getH001());
			buffer.append("户、建筑面积").append(house.getH006()).append("㎡、交款金额");
			buffer.append(house.getH021()).append("，该栋楼宇物业专项维修资金已缴清。");
			
			// 空行
			cell = PdfUtil.createCell("", headFont3, 0, 30, 14,
					PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			// -------------
			cell = PdfUtil.createCell("", headFont4, 0, 90, 4, 2, PdfUtil.LEFT_H,
					PdfUtil.TOP_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(buffer.toString(), headFont4, 0, 90, 4, 10, PdfUtil.LEFT_H,
					PdfUtil.TOP_V);
			table.addCell(cell);
			cell = PdfUtil.createCell("", headFont4, 0, 90, 4, 2, PdfUtil.LEFT_H,
					PdfUtil.TOP_V);
			table.addCell(cell);
			// -------------
			cell = PdfUtil.createCell("", headFont4, 0, 25, 3, PdfUtil.LEFT_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell("", headFont4, 0, 25, 11,
					PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			// ---------------
			cell = PdfUtil.createCell("", headFont4, 0, 25, 2, PdfUtil.LEFT_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell("", headFont4, 0, 25, 12,
					PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			// ---------------
			cell = PdfUtil.createCell("", headFont4, 0, 25, 2, PdfUtil.LEFT_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell("", headFont4, 0, 25, 12,
					PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			// ---------------
			/*
			 * cell = PdfUtil.createCell(house.getKfgsmc()+"，开发建设的:", headFont4,
			 * 0, 25, 14, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			 * table.addCell(cell); //------------- cell =
			 * PdfUtil.createCell(house.getLymc()+"，", headFont4, 0, 25, 14,
			 * PdfUtil.CENTER_H, PdfUtil.MIDDLE_V); table.addCell(cell);
			 * //------------- cell =
			 * PdfUtil.createCell("共计"+house.getH001()+"户业主物业专项修改资金已缴清。",
			 * headFont4, 0, 25, 14, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			 * table.addCell(cell);
			 */
			// -------------
			cell = PdfUtil.createCell("", headFont4, 0, 25, 14,
					PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);

			// -------------
			cell = PdfUtil.createCell("", headFont4, 0, 25, 14,
					PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);

			// -------------
			cell = PdfUtil.createCell("", headFont4, 0, 25, 14,
					PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);

			// -------------
			cell = PdfUtil.createCell("", headFont4, 0, 25, 14,
					PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);

			// -------------
			cell = PdfUtil.createCell("", headFont4, 0, 25, 9,
					PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell("经办人：", headFont4, 0, 25, 5,
					PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);

			// -------------
			cell = PdfUtil.createCell("", headFont4, 0, 25, 14,
					PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);

			// -------------
			cell = PdfUtil.createCell("", headFont4, 0, 25, 9,
					PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell("科       长：", headFont4, 0, 25, 5,
					PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);

			// -------------
			cell = PdfUtil.createCell("", headFont4, 0, 25, 14,
					PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);

			// -------------
			cell = PdfUtil.createCell("", headFont4, 0, 25, 9,
					PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			Date dt = new Date();
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy年MM月dd日");
			cell = PdfUtil.createCell(sdf.format(dt), headFont4, 0, 25, 5,
					PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);

			table.addCell(cell);
			document.add(table);
			document.newPage();
		}
		document.close();

		return ops;
	}
	


	/**
	 * 楼宇交存证明（垫江批量）
	 * 
	 * @param house
	 * @param title
	 * @return
	 * @throws Exception
	 */
	public ByteArrayOutputStream creatFGPDFMany_DJ(List<HouseDw> houses,
			String title) throws Exception {
		init();
		Document document = new Document();// 建立一个Document对象
		Rectangle pageSize = new Rectangle(PageSize.A4);// 设置页面大小,为A4纸
		// document.setPageSize(pageSize.rotate());//横向打印

		ByteArrayOutputStream ops = new ByteArrayOutputStream();// 输出到客户段的流

		PdfWriter.getInstance(document, ops);// 建立一个PdfWriter对象
		document.open();
		float[] widths = { 50f, 30f, 30f, 30f, 30f, 40f, 60f, 30f, 40f, 40f,
				40f, 30f, 40f, 40f };// 设置表格的列以及列宽

		for (HouseDw house : houses) {
			PdfPTable table = new PdfPTable(widths);// 建立一个pdf表格

			table.setSpacingBefore(20f);// 设置表格上面空白宽度
			table.setTotalWidth(770);// 设置表格的宽度
			table.setLockedWidth(true);// 设置表格的宽度固定
			table.getDefaultCell().setBorder(1);// 设置表格默认为无边框
			// 空行
			PdfPCell cell = PdfUtil.createCell("", headFont3, 0, 80, 14, PdfUtil.CENTER_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(title, headFont4, 0, 35, 14,
					PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);// 增加单元格

			
			StringBuffer buffer = new StringBuffer();
			buffer.append("          ").append(house.getKfgsmc());
			if (!house.getKfgsmc().trim().equals("")) {
				buffer.append("，开发建设的");
			}
			buffer.append(house.getLymc()).append("，共计").append(house.getH001());
			buffer.append("户、建筑面积").append(house.getH006()).append("㎡、交款金额");
			buffer.append(house.getH021()).append("，该栋楼宇物业专项维修资金已缴清。");
			
			// 空行
			cell = PdfUtil.createCell("", headFont3, 0, 30, 14,
					PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			// -------------
			cell = PdfUtil.createCell("", headFont4, 0, 90, 4, 2, PdfUtil.LEFT_H,
					PdfUtil.TOP_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(buffer.toString(), headFont4, 0, 90, 4, 10, PdfUtil.LEFT_H,
					PdfUtil.TOP_V);
			table.addCell(cell);
			cell = PdfUtil.createCell("", headFont4, 0, 90, 4, 2, PdfUtil.LEFT_H,
					PdfUtil.TOP_V);
			table.addCell(cell);
			// -------------
			cell = PdfUtil.createCell("", headFont4, 0, 25, 3, PdfUtil.LEFT_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell("", headFont4, 0, 25, 11,
					PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			// ---------------
			cell = PdfUtil.createCell("", headFont4, 0, 25, 2, PdfUtil.LEFT_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell("", headFont4, 0, 25, 12,
					PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			// ---------------
			cell = PdfUtil.createCell("", headFont4, 0, 25, 2, PdfUtil.LEFT_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell("", headFont4, 0, 25, 12,
					PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			// ---------------
			/*
			 * cell = PdfUtil.createCell(house.getKfgsmc()+"，开发建设的:", headFont4,
			 * 0, 25, 14, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			 * table.addCell(cell); //------------- cell =
			 * PdfUtil.createCell(house.getLymc()+"，", headFont4, 0, 25, 14,
			 * PdfUtil.CENTER_H, PdfUtil.MIDDLE_V); table.addCell(cell);
			 * //------------- cell =
			 * PdfUtil.createCell("共计"+house.getH001()+"户业主物业专项修改资金已缴清。",
			 * headFont4, 0, 25, 14, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			 * table.addCell(cell);
			 */
			// -------------
			cell = PdfUtil.createCell("", headFont4, 0, 25, 14,
					PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);

			// -------------
			cell = PdfUtil.createCell("", headFont4, 0, 25, 14,
					PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);

			// -------------
			cell = PdfUtil.createCell("", headFont4, 0, 25, 14,
					PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);

			// -------------
			// -------------
			cell = PdfUtil.createCell("", headFont4, 0, 25, 1, PdfUtil.CENTER_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell("统计：", headFont4, 0, 25, 3, PdfUtil.CENTER_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell("复核：", headFont4, 0, 25, 5, PdfUtil.CENTER_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell("单位负责人：", headFont4, 0, 25, 5, PdfUtil.LEFT_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);


			// -------------
			cell = PdfUtil.createCell("", headFont4, 0, 25, 14,
					PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);

			// -------------
			cell = PdfUtil.createCell("", headFont4, 0, 25, 9,
					PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			Date dt = new Date();
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy年MM月dd日");
			cell = PdfUtil.createCell(sdf.format(dt), headFont4, 0, 25, 5,
					PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);

			table.addCell(cell);
			document.add(table);
			document.newPage();
		}
		document.close();

		return ops;
	}
}

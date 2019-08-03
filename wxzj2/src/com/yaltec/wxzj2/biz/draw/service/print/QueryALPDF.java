package com.yaltec.wxzj2.biz.draw.service.print;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.text.DecimalFormat;
import java.util.Date;
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
import com.yaltec.comon.utils.ChangeRMB;
import com.yaltec.comon.utils.DateUtil;
import com.yaltec.comon.utils.PdfUtil;
import com.yaltec.wxzj2.biz.draw.entity.QueryAL1;

public class QueryALPDF {

	private BaseFont bfChinese;
	private Font headFont1;
	private Font headFont2;
	private Font headFont3;
	
	static Logger logger = LoggerFactory.getLogger(QueryALPDF.class);
	
	public void init() throws DocumentException, IOException {
		bfChinese = BaseFont.createFont("STSong-Light",
				"UniGB-UCS2-H", BaseFont.NOT_EMBEDDED);// 设置中文字体
		headFont1 = new Font(bfChinese, 14, Font.BOLD);// 设置字体大小
		headFont2 = new Font(bfChinese, 12, Font.NORMAL);// 设置字体大小
		headFont3 = new Font(bfChinese, 10, Font.NORMAL);// 设置字体大小
	}
	
	public ByteArrayOutputStream creatPDF(QueryAL1 queryAD, String username, String title) throws Exception {
		init();
		Document document = new Document();// 建立一个Document对象
		document.setPageSize(PageSize.A4);// 设置页面大小,为A4纸
		String date = DateUtil.getDatetime(new Date());
		ByteArrayOutputStream ops = new ByteArrayOutputStream();// 输出到客户段的流
		PdfWriter.getInstance(document, ops);// 建立一个PdfWriter对象
		document.open();
		float[] widths = {60f,80f,50f,50f,50f,50f,50f,60f};// 设置表格的列以及列宽
		PdfPTable table = new PdfPTable(widths);// 建立一个pdf表格

		table.setSpacingBefore(20f);// 设置表格上面空白宽度
		table.setTotalWidth(460);// 设置表格的宽度
		table.setLockedWidth(true);// 设置表格的宽度固定
		table.getDefaultCell().setBorder(1);// 设置表格默认为无边框

		PdfPCell cell = PdfUtil.createCell(title, headFont1, 0, 20, 8,
				PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);// 增加单元格

		DecimalFormat df = new DecimalFormat("######0.00");   

		// 空行
		cell = PdfUtil.createCell("", headFont1, 0, 5, 8, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		//-------------br
		cell = PdfUtil.createCell("申请编号："+queryAD.getZ011(), headFont3, 0, 20, 4, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("打印日期："+date, headFont3, 0, 20, 4, PdfUtil.RIGHT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		//-------------br
		cell = PdfUtil.createCell("楼宇名称", headFont3, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(queryAD.getLymc(), headFont3, 1, 20, 4, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("业主姓名", headFont3, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(queryAD.getZ012(), headFont3, 1, 20, 2, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		

		//-------------br
		cell = PdfUtil.createCell("房屋编号", headFont3, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(queryAD.getH001(), headFont3, 1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("单元", headFont3, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(queryAD.getH002(), headFont3, 1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("层", headFont3, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(queryAD.getH003(), headFont3, 1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("房号", headFont3, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(queryAD.getH005(), headFont3, 1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		//-------------br
		cell = PdfUtil.createCell("房款", headFont3, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(queryAD.getH010(), headFont3, 1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("建筑面积", headFont3, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(queryAD.getH006(), headFont3, 1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("首交金额", headFont3, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(queryAD.getH039(), headFont3, 1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("首交日期", headFont3, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(queryAD.getH020(), headFont3, 1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		//-------------br
		cell = PdfUtil.createCell("支取本金", headFont3, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(queryAD.getH028(), headFont3, 1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("支取利息", headFont3, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(queryAD.getH029(), headFont3, 1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		Double zq = Double.valueOf(queryAD.getZ004())+Double.valueOf(queryAD.getZ005());
		cell = PdfUtil.createCell("本息余额", headFont3, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(df.format(zq), headFont3, 1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("经办人", headFont3, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(queryAD.getJbr(), headFont3, 1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		
		//-------------br
		cell = PdfUtil.createCell("总额大写", headFont3, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(ChangeRMB.doChangeRMB(zq), headFont3, 1, 20, 5, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("退取金额", headFont3, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(df.format(zq), headFont3, 1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		//-------------br
		cell = PdfUtil.createCell("备注", headFont3, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(queryAD.getApplyRemark(), headFont3, 1, 20, 7, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		//=============================
		/*
		float[] widths2 = {12f,12f,12f,12f,12f,12f,12f,12f,12f,12f};// 设置表格的列以及列宽
		PdfPTable iTable = new PdfPTable(widths2);

		cell = PdfUtil.createCell("千", headFont3, 1, 15, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		iTable.addCell(cell);
		cell = PdfUtil.createCell("百", headFont3, 1, 15, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		iTable.addCell(cell);
		cell = PdfUtil.createCell("十", headFont3, 1, 15, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		iTable.addCell(cell);
		cell = PdfUtil.createCell("万", headFont3, 1, 15, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		iTable.addCell(cell);
		cell = PdfUtil.createCell("千", headFont3, 1, 15, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		iTable.addCell(cell);
		cell = PdfUtil.createCell("百", headFont3, 1, 15, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		iTable.addCell(cell);
		cell = PdfUtil.createCell("十", headFont3, 1, 15, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		iTable.addCell(cell);
		cell = PdfUtil.createCell("元", headFont3, 1, 15, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		iTable.addCell(cell);
		cell = PdfUtil.createCell("角", headFont3, 1, 15, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		iTable.addCell(cell);
		cell = PdfUtil.createCell("分", headFont3, 1, 15, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		iTable.addCell(cell);
		//-------------br
		String[] zqje = PdfUtil.convert(zq.toString());
		for (int i = 0; i < zqje.length; i++) {
			System.out.println(""+zqje[i]);
			cell = PdfUtil.createCell(zqje[i], headFont3, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			iTable.addCell(cell);
		}
		
		cell = new PdfPCell(iTable);
		cell.setColspan(11);
		table.addCell(cell);
		*/
		//-------------br
		//============================================
		//cell = PdfUtil.createCell("", headFont3, 1, 15, 4, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		//table.addCell(cell);
		
		
		//cell = PdfUtil.createCell("3243567", headFont3, 1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		//table.addCell(cell);
		
		//-------------br
		cell = PdfUtil.createCell("  退款单位（章）", headFont3, 0, 25, 2, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("开票人："+username, headFont3, 0, 25, 4, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("业主签字：", headFont3, 0, 25, 2, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		
		document.add(table);
		document.close();
		
		return ops;
	}

	public ByteArrayOutputStream creatPDF2(List<QueryAL1> list, String username, String title) throws Exception {
		init();
		Document document = new Document();// 建立一个Document对象
		document.setPageSize(PageSize.A4);// 设置页面大小,为A4纸
		String date = DateUtil.getDatetime(new Date());
		ByteArrayOutputStream ops = new ByteArrayOutputStream();// 输出到客户段的流
		PdfWriter.getInstance(document, ops);// 建立一个PdfWriter对象
		document.open();
		float[] widths = {60f,80f,50f,50f,50f,50f,50f,60f};// 设置表格的列以及列宽

		for (QueryAL1 queryAD : list) {
			PdfPTable table = new PdfPTable(widths);// 建立一个pdf表格
	
			table.setSpacingBefore(20f);// 设置表格上面空白宽度
			table.setTotalWidth(460);// 设置表格的宽度
			table.setLockedWidth(true);// 设置表格的宽度固定
			table.getDefaultCell().setBorder(1);// 设置表格默认为无边框
	
			PdfPCell cell = PdfUtil.createCell(title, headFont1, 0, 20, 8,
					PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);// 增加单元格
	
			DecimalFormat df = new DecimalFormat("######0.00");   
	
			// 空行
			cell = PdfUtil.createCell("", headFont1, 0, 5, 8, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			//-------------br
			cell = PdfUtil.createCell("申请编号："+queryAD.getZ011(), headFont3, 0, 20, 4, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell("打印日期："+date, headFont3, 0, 20, 4, PdfUtil.RIGHT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
	
			//-------------br
			cell = PdfUtil.createCell("楼宇名称", headFont3, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(queryAD.getLymc(), headFont3, 1, 20, 4, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell("业主姓名", headFont3, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(queryAD.getZ012(), headFont3, 1, 20, 2, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			
	
			//-------------br
			cell = PdfUtil.createCell("房屋编号", headFont3, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(queryAD.getH001(), headFont3, 1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell("单元", headFont3, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(queryAD.getH002(), headFont3, 1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell("层", headFont3, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(queryAD.getH003(), headFont3, 1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell("房号", headFont3, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(queryAD.getH005(), headFont3, 1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
	
			//-------------br
			cell = PdfUtil.createCell("房款", headFont3, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(queryAD.getH010(), headFont3, 1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell("建筑面积", headFont3, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(queryAD.getH006(), headFont3, 1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell("首交金额", headFont3, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(queryAD.getH039(), headFont3, 1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell("首交日期", headFont3, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(queryAD.getH020(), headFont3, 1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
	
			//-------------br
			cell = PdfUtil.createCell("支取本金", headFont3, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(queryAD.getH028(), headFont3, 1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell("支取利息", headFont3, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(queryAD.getH029(), headFont3, 1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
	
			Double zq = Double.valueOf(queryAD.getZ004())+Double.valueOf(queryAD.getZ005());
			cell = PdfUtil.createCell("本息余额", headFont3, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(df.format(zq), headFont3, 1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell("经办人", headFont3, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(queryAD.getJbr(), headFont3, 1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			
			//-------------br
			cell = PdfUtil.createCell("总额大写", headFont3, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(ChangeRMB.doChangeRMB(zq), headFont3, 1, 20, 5, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell("退取金额", headFont3, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(df.format(zq), headFont3, 1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
	
			//-------------br
			cell = PdfUtil.createCell("备注", headFont3, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(queryAD.getApplyRemark(), headFont3, 1, 20, 7, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			//=============================
			
			//-------------br
			cell = PdfUtil.createCell("  退款单位（章）", headFont3, 0, 25, 2, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell("开票人："+username, headFont3, 0, 25, 4, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell("业主签字：", headFont3, 0, 25, 2, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			
			document.add(table);
			document.newPage();
		}
		document.close();
		
		return ops;
	}
}

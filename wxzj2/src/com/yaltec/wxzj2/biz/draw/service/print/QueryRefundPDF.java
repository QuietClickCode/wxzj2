package com.yaltec.wxzj2.biz.draw.service.print;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
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
import com.yaltec.comon.utils.PdfUtil;
import com.yaltec.wxzj2.biz.draw.entity.Refund;

/**
 * 
 * @ClassName: QueryRefundPDF
 * @Description: TODO 退款打印PDF设置类
 * 
 * @author yangshanping
 * @date 2016-8-4 上午10:58:49
 */
public class QueryRefundPDF {
	private BaseFont bfChinese;
	private Font headFont1;
	private Font headFont2;
	private Font headFont3;
	
	static Logger logger = LoggerFactory.getLogger(QueryRefundPDF.class);
	
	public void init() throws DocumentException, IOException {
		bfChinese = BaseFont.createFont("STSong-Light",
				"UniGB-UCS2-H", BaseFont.NOT_EMBEDDED);// 设置中文字体
		headFont1 = new Font(bfChinese, 14, Font.BOLD);// 设置字体大小
		headFont2 = new Font(bfChinese, 11, Font.NORMAL);// 设置字体大小
		headFont3 = new Font(bfChinese, 10, Font.NORMAL);// 设置字体大小
	}
	
	public ByteArrayOutputStream creatPDF(Refund refund,String title) throws Exception {
		init();
		Document document = new Document();// 建立一个Document对象
		document.setPageSize(PageSize.A4);// 设置页面大小,为A4纸
			
		ByteArrayOutputStream ops = new ByteArrayOutputStream();// 输出到客户段的流
		PdfWriter.getInstance(document, ops);// 建立一个PdfWriter对象
		document.open();
		float[] widths = { 60f, 80f, 60f, 60f, 60f, 60f, 60f, 100f};// 设置表格的列以及列宽
		
		
		PdfPTable table = new PdfPTable(widths);// 建立一个pdf表格

		table.setSpacingBefore(20f);// 设置表格上面空白宽度
		table.setTotalWidth(470);// 设置表格的宽度
		table.setLockedWidth(true);// 设置表格的宽度固定
		table.getDefaultCell().setBorder(1);// 设置表格默认为无边框

		PdfPCell cell = PdfUtil.createCell(title, headFont1, 0, 20, 8,
				PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);// 增加单元格

		// 空行
		cell = PdfUtil.createCell("", headFont1, 0, 5, 8, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		//-------------
		cell = PdfUtil.createCell("", headFont2, 0, 20, 5, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);

		cell = PdfUtil.createCell("          退款日期："+refund.getZ018().substring(0, 10), headFont2, 0, 20, 3, PdfUtil.LEFT_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		//-------------
		cell = PdfUtil.createCell("楼宇名称", headFont2, 1, 20, 1, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(refund.getLymc(), headFont3,
				1, 20, 4, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		cell = PdfUtil.createCell("业主姓名", headFont2, 1, 20, 1, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(refund.getZ012(), headFont3, 1, 20, 2, PdfUtil.LEFT_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		//-------------
		cell = PdfUtil.createCell("房屋编号", headFont2, 1, 20, 1, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(refund.getH001(), headFont3,
				1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		cell = PdfUtil.createCell("单元", headFont2, 1, 20, 1, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(refund.getH002(), headFont3,
				1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		cell = PdfUtil.createCell("层", headFont2, 1, 20, 1, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(refund.getH003(), headFont3,
				1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		
		cell = PdfUtil.createCell("房号", headFont2, 1, 20, 1, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(refund.getH005(), headFont3,
				1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		//-------------
		cell = PdfUtil.createCell("房款", headFont2, 1, 20, 1, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("￥"+refund.getH010()+" 元", headFont3,
				1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		cell = PdfUtil.createCell("退取本金", headFont2, 1, 20, 1, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("￥"+refund.getZ004()+" 元", headFont3,
				1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		cell = PdfUtil.createCell("退取利息", headFont2, 1, 20, 1, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("￥"+refund.getZ005()+" 元", headFont3,
				1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		
		cell = PdfUtil.createCell("退取总额", headFont2, 1, 20, 1, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("￥"+refund.getZ006()+" 元", headFont3,
				1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		//-------------
		cell = PdfUtil.createCell("总额大写", headFont2, 1, 20, 1, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(ChangeRMB.doChangeRMB(refund.getZ006()), headFont3,
				1, 20, 7, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		//-------------
		cell = PdfUtil.createCell("退款原因", headFont2, 1, 20, 1, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(refund.getZ017(), headFont3,
				1, 20, 7, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		//-------------
		cell = PdfUtil.createCell("退款单位（印章）", headFont2, 0, 20, 2, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);

		cell = PdfUtil.createCell("开票人（章）", headFont2, 0, 20, 2, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);

		cell = PdfUtil.createCell("退款人（章）", headFont2, 0, 20, 3, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);

		cell = PdfUtil.createCell("备注：", headFont2, 0, 20, 1, PdfUtil.LEFT_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		
		
		document.add(table);
		
		document.close();

		return ops;
	}
	

	public ByteArrayOutputStream creatPDFMany(List<Refund> list,String title) throws Exception {
		init();
		Document document = new Document();// 建立一个Document对象
		document.setPageSize(PageSize.A4);// 设置页面大小,为A4纸
			
		ByteArrayOutputStream ops = new ByteArrayOutputStream();// 输出到客户段的流
		PdfWriter.getInstance(document, ops);// 建立一个PdfWriter对象
		document.open();
		float[] widths = { 60f, 80f, 60f, 60f, 60f, 60f, 60f, 100f};// 设置表格的列以及列宽

		//for (int i = 0; i < list.size(); i++) {
		for (Refund refund : list) {
			PdfPTable table = new PdfPTable(widths);// 建立一个pdf表格
	
			table.setSpacingBefore(20f);// 设置表格上面空白宽度
			table.setTotalWidth(470);// 设置表格的宽度
			table.setLockedWidth(true);// 设置表格的宽度固定
			table.getDefaultCell().setBorder(1);// 设置表格默认为无边框
	
			PdfPCell cell = PdfUtil.createCell(title, headFont1, 0, 20, 8,
					PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);// 增加单元格
	
			// 空行
			cell = PdfUtil.createCell("", headFont1, 0, 5, 8, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			//-------------
			cell = PdfUtil.createCell("", headFont2, 0, 20, 5, PdfUtil.CENTER_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);
	
			cell = PdfUtil.createCell("          退款日期："+refund.getZ018().substring(0, 10), headFont2, 0, 20, 3, PdfUtil.LEFT_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);
			//-------------
			cell = PdfUtil.createCell("楼宇名称", headFont2, 1, 20, 1, PdfUtil.CENTER_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(refund.getLymc(), headFont3,
					1, 20, 4, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
	
			cell = PdfUtil.createCell("业主姓名", headFont2, 1, 20, 1, PdfUtil.CENTER_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(refund.getZ012(), headFont3, 1, 20, 2, PdfUtil.LEFT_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);
			//-------------
			cell = PdfUtil.createCell("房屋编号", headFont2, 1, 20, 1, PdfUtil.CENTER_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(refund.getH001(), headFont3,
					1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
	
			cell = PdfUtil.createCell("单元", headFont2, 1, 20, 1, PdfUtil.CENTER_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(refund.getH002(), headFont3,
					1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
	
			cell = PdfUtil.createCell("层", headFont2, 1, 20, 1, PdfUtil.CENTER_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(refund.getH003(), headFont3,
					1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			
			cell = PdfUtil.createCell("房号", headFont2, 1, 20, 1, PdfUtil.CENTER_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(refund.getH005(), headFont3,
					1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			//-------------
			cell = PdfUtil.createCell("房款", headFont2, 1, 20, 1, PdfUtil.CENTER_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell("￥"+refund.getH010()+" 元", headFont3,
					1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
	
			cell = PdfUtil.createCell("退取本金", headFont2, 1, 20, 1, PdfUtil.CENTER_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell("￥"+refund.getZ004()+" 元", headFont3,
					1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
	
			cell = PdfUtil.createCell("退取利息", headFont2, 1, 20, 1, PdfUtil.CENTER_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell("￥"+refund.getZ005()+" 元", headFont3,
					1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			
			cell = PdfUtil.createCell("退取总额", headFont2, 1, 20, 1, PdfUtil.CENTER_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell("￥"+refund.getZ006()+" 元", headFont3,
					1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			//-------------
			cell = PdfUtil.createCell("总额大写", headFont2, 1, 20, 1, PdfUtil.CENTER_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(ChangeRMB.doChangeRMB(refund.getZ006()), headFont3,
					1, 20, 7, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			//-------------
			cell = PdfUtil.createCell("退款原因", headFont2, 1, 20, 1, PdfUtil.CENTER_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(refund.getZ017(), headFont3,
					1, 20, 7, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			//-------------
			cell = PdfUtil.createCell("退款单位（印章）", headFont2, 0, 20, 2, PdfUtil.CENTER_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);
	
			cell = PdfUtil.createCell("开票人（章）", headFont2, 0, 20, 2, PdfUtil.CENTER_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);
	
			cell = PdfUtil.createCell("退款人（章）", headFont2, 0, 20, 3, PdfUtil.CENTER_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);
	
			cell = PdfUtil.createCell("备注：", headFont2, 0, 20, 1, PdfUtil.LEFT_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);
			
			
			document.add(table);
			document.newPage();
		}
		document.close();

		return ops;
	}
}

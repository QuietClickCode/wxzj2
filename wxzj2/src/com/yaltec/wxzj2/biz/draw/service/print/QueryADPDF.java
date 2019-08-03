package com.yaltec.wxzj2.biz.draw.service.print;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.Date;
import java.util.Map;

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
import com.yaltec.comon.utils.StringUtil;

public class QueryADPDF {
	/**
	 *<p>文件名称: QueryADPDF.java</p>
	 * <p>文件描述: 支取情况查询打印</p>
	 * <p>版权所有: 版权所有(C)2010</p>
	 * <p>公   司: yaltec</p>
	 * <p>内容摘要: </p>
	 * <p>其他说明: </p>
	 * <p>完成日期：Mar 11, 2011</p>
	 * <p>修改记录0：无</p>
	 * @version 1.0
	 * @author jiangyong
	 */
	
	private BaseFont bfChinese;
	private Font headFont1;
	private Font headFont2;
	private Font headFont3;
	
	static Logger logger = LoggerFactory.getLogger(QueryADPDF.class);
	
	public void init() throws DocumentException, IOException {
		bfChinese = BaseFont.createFont("STSong-Light",
				"UniGB-UCS2-H", BaseFont.NOT_EMBEDDED);// 设置中文字体
		headFont1 = new Font(bfChinese, 14, Font.BOLD);// 设置字体大小
		headFont2 = new Font(bfChinese, 12, Font.NORMAL);// 设置字体大小
		headFont3 = new Font(bfChinese, 10, Font.NORMAL);// 设置字体大小
	}
	
	public ByteArrayOutputStream creatPDF(Map<String,String> queryAD, String username,String title) throws Exception {
		init();
		Document document = new Document();// 建立一个Document对象
		document.setPageSize(PageSize.A4);// 设置页面大小,为A4纸

		ByteArrayOutputStream ops = new ByteArrayOutputStream();// 输出到客户段的流
		PdfWriter.getInstance(document, ops);// 建立一个PdfWriter对象
		document.open();
		float[] widths = { 55f, 90f, 45f, 60f, 45f, 40f, 80f};// 设置表格的列以及列宽
		PdfPTable table = new PdfPTable(widths);// 建立一个pdf表格

		table.setSpacingBefore(20f);// 设置表格上面空白宽度
		table.setTotalWidth(460);// 设置表格的宽度
		table.setLockedWidth(true);// 设置表格的宽度固定
		table.getDefaultCell().setBorder(1);// 设置表格默认为无边框

		PdfPCell cell = PdfUtil.createCell(title, headFont1, 0, 20, 13,
				PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);// 增加单元格

		// 空行
		cell = PdfUtil.createCell("", headFont1, 0, 5, 13, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		//-------------br
		cell = PdfUtil.createCell("       申请编号："+queryAD.get("bm"), headFont3, 0, 20, 7, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		//-------------br
		cell = PdfUtil.createCell("申请单位", headFont3, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(queryAD.get("sqdw"), headFont3, 1, 20, 3, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("经  办  人", headFont3, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(queryAD.get("jbr"), headFont3, 1, 20, 2, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		//-------------br
		cell = PdfUtil.createCell("项目名称", headFont3, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(queryAD.get("xmmc"), headFont3, 1, 20, 6, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		//-------------br
		cell = PdfUtil.createCell("小区名称", headFont3, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(queryAD.get("nbhdname"), headFont3, 1, 20, 6, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		//-------------br
		cell = PdfUtil.createCell("楼宇名称", headFont3, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(queryAD.get("bldgname"), headFont3, 1, 20, 6, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		//-------------br
		cell = PdfUtil.createCell("申请日期", headFont3, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(queryAD.get("sqrq1"), headFont3, 1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("申请金额", headFont3, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(StringUtil.valueOf(queryAD.get("sqje")), 
				headFont3, 1, 20, 2, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("划拨金额", headFont3, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(StringUtil.valueOf(queryAD.get("sjhbje"))+" 元", headFont3, 1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		//-------------br
		cell = PdfUtil.createCell("受理状态", headFont3, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(queryAD.get("slzt"), headFont3, 1, 20, 6, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		//-------------br
		cell = PdfUtil.createCell("维修项目", headFont3, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(queryAD.get("wxxm"), headFont3, 1, 20, 6, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		//-------------br
		cell = PdfUtil.createCell("领导意见", headFont3, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(queryAD.get("clsm"), headFont3, 1, 20, 6, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		//-------------br
		cell = PdfUtil.createCell("", headFont3, 0, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("操作员："+username, headFont3, 0, 20, 3, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("            打印日期："+DateUtil.getDate(), headFont3, 0, 20, 3, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		
		document.add(table);
		document.close();
		
		return ops;
	}
}

package com.yaltec.wxzj2.biz.compositeQuery.service.print;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
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
import com.yaltec.wxzj2.biz.compositeQuery.entity.QueryPaymentS;

public class QueryPaymentSPDF {

	private BaseFont bfChinese;
	private Font headFont1;
	private Font headFont2;
	private Font headFont3;

	static Logger logger = LoggerFactory.getLogger(QueryPaymentSPDF.class);

	public void init() throws DocumentException, IOException {
		bfChinese = BaseFont.createFont("STSong-Light", "UniGB-UCS2-H", BaseFont.NOT_EMBEDDED);// 设置中文字体
		headFont1 = new Font(bfChinese, 16, Font.BOLD);// 设置字体大小
		headFont2 = new Font(bfChinese, 11, Font.NORMAL);// 设置字体大小
		headFont3 = new Font(bfChinese, 10, Font.NORMAL);// 设置字体大小
	}

	public ByteArrayOutputStream creatPDF(List<QueryPaymentS> list, String xqmc) throws Exception {
		init();
		Document document = new Document();// 建立一个Document对象
		Rectangle pageSize = new Rectangle(PageSize.A4);
		document.setPageSize(pageSize.rotate());// 设置页面大小,为A4纸

		ByteArrayOutputStream ops = new ByteArrayOutputStream();// 输出到客户段的流

		PdfWriter.getInstance(document, ops);// 建立一个PdfWriter对象
		document.open();
		float[] widths = { 30f, 65f, 50f, 50f, 30f, 30f, 65f, 70f, 100f, 70f, 50f, 50f, 70f, 40f, 70f, 70f, 70f };// 设置表格的列以及列宽
		PdfPTable table = new PdfPTable(widths);// 建立一个pdf表格

		table.setSpacingBefore(20f);// 设置表格上面空白宽度
		table.setTotalWidth(800);// 设置表格的宽度
		table.setLockedWidth(true);// 设置表格的宽度固定
		table.getDefaultCell().setBorder(1);// 设置表格默认为无边框

		PdfPCell cell = PdfUtil.createCell("物业专项维修资金汇缴清册", headFont1, 0, 20, 17, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);// 增加单元格

		// 空行
		cell = PdfUtil.createCell("", headFont1, 0, 25, 17, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		// -------------
		cell = PdfUtil.createCell("   建设单位(售房单位)名称：", headFont2, 0, 15, 15, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("    共      " + list.size() + "     条记录", headFont2, 0, 15, 2, PdfUtil.LEFT_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		// -------------
		cell = PdfUtil.createCell("项目名称", headFont2, 1, 20, 2, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(xqmc, headFont3, 1, 20, 5, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("建筑结构", headFont2, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("", headFont3, 1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("房屋地址", headFont2, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("", headFont3, 1, 20, 5, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("房屋类型", headFont2, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("高层", headFont3, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		// -------------
		cell = PdfUtil.createCell("序号", headFont2, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("栋号", headFont2, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("总层数", headFont2, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("总建面", headFont2, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("单元", headFont2, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("层", headFont2, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("房号", headFont2, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("户型", headFont2, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("业主姓名", headFont2, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("产权证号", headFont2, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("建面", headFont2, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("套面", headFont2, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("购房总额", headFont2, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("比例", headFont2, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("汇缴金额", headFont2, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("房屋类别", headFont2, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("房屋性质", headFont2, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		// -------------
		for (int i = 0; i < list.size(); i++) {
			cell = PdfUtil.createCell(String.valueOf(i + 1), headFont3, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(list.get(i).getLymc(), headFont3, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(list.get(i).getCs(), headFont3, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(list.get(i).getZjzmj() == null ? "" : list.get(i).getZjzmj().toString(),
					headFont3, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(list.get(i).getH002(), headFont3, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(list.get(i).getH003(), headFont3, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(list.get(i).getH005(), headFont3, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(list.get(i).getH033(), headFont3, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(list.get(i).getH013(), headFont3, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(list.get(i).getH016(), headFont3, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(list.get(i).getH006() == null ? "" : list.get(i).getH006().toString(), headFont3,
					1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(list.get(i).getH007() == null ? "" : list.get(i).getH007().toString(), headFont3,
					1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(list.get(i).getH010() == null ? "" : list.get(i).getH010().toString(), headFont3,
					1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(list.get(i).getBl() == null ? "" : list.get(i).getBl().toString(), headFont3, 1,
					25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(list.get(i).getH030() == null ? "" : list.get(i).getH030().toString(), headFont3,
					1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(list.get(i).getH045(), headFont3, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(list.get(i).getH012(), headFont3, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
		}

		document.add(table);
		document.close();

		return ops;
	}

}

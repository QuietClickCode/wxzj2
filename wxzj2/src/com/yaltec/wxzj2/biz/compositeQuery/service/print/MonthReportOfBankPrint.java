package com.yaltec.wxzj2.biz.compositeQuery.service.print;

import java.io.ByteArrayOutputStream;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.lowagie.text.Document;
import com.lowagie.text.PageSize;
import com.lowagie.text.Rectangle;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;
import com.yaltec.comon.utils.DateUtil;
import com.yaltec.comon.utils.PdfUtil;
import com.yaltec.wxzj2.biz.comon.service.AbstractPDFService;
import com.yaltec.wxzj2.biz.compositeQuery.entity.MonthReportOfBank;

public class MonthReportOfBankPrint extends AbstractPDFService{
	@SuppressWarnings("unchecked")
	@Override
	protected void buildPdfDocument(Map<String, Object> model, Document document, PdfWriter writer,
			HttpServletRequest request, HttpServletResponse response) throws Exception {
		// 调用父类初始化方法
		super.init(model);
		// 获取传入参数
		List<MonthReportOfBank> list = getValue("list", List.class); // 房屋信息
		
		Rectangle pageSize = new Rectangle(PageSize.A4);
		document.setPageSize(pageSize.rotate());// 设置页面大小,为A4纸

		ByteArrayOutputStream ops = new ByteArrayOutputStream();// 输出到客户段的流

		
		PdfWriter.getInstance(document, ops);// 建立一个PdfWriter对象
		document.open();
	
		float[] widths = { 130f, 100f, 60f, 60f, 60f  };// 设置表格的列以及列宽
		PdfPTable table = new PdfPTable(widths);// 建立一个pdf表格
		
		table.setSpacingBefore(20f);// 设置表格上面空白宽度
		table.setTotalWidth(754);// 设置表格的宽度
		table.setLockedWidth(true);// 设置表格的宽度固定
		table.getDefaultCell().setBorder(1);// 设置表格默认为无边框
		
		PdfPCell cell = PdfUtil.createCell("按银行统计月报", headFont1, 0,
				55, widths.length, PdfUtil.CENTER_H, PdfUtil.BOTTOM_V);
		table.addCell(cell);// 增加单元格
		
		// 空行(名称下面显示两条信息，左边显示统计月度，右边显示日期)
		cell = PdfUtil.createCell("", headFont1, 0, 20, widths.length, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		int w1 = widths.length/2;
		int w2 = widths.length - w1;
		// 设置打印表格显示信息
		cell = PdfUtil.createCell("统计日期：" +model.get("begindate")+ "  至  " +model.get("enddate"), headFont3, 0, 20, w1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("打印日期：" + DateUtil.getDate() + "        共" + (list.size() - 1) + "条交款记录", headFont3, 
				0, 20, w2, PdfUtil.RIGHT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		// -------------
		// 打印显示列名
		cell = PdfUtil.createCell("项目名称", headFont2, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("银行简称", headFont2, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("本期户数", headFont2, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("增加本金", headFont2, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("有效发票", headFont2, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		

		// 填充数据
		for (int i = 0; i < list.size(); i++) {
			cell = PdfUtil.createCell(list.get(i).getXqmc(), headFont3, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			//根据银行编号获取银行简称
			String yhjc = "";
			String yhbh = list.get(i).getYhbh();
			if (yhbh.trim().equals("00")) {
				yhjc = "重行";
			} else if (yhbh.trim().equals("01")) {
				yhjc = "中行";
			} else if (yhbh.trim().equals("02")) {
				yhjc = "农商行";
			} else if (yhbh.trim().equals("03")) {
				yhjc = "建行";
			} else if (yhbh.trim().equals("04")) {
				yhjc = "农行";
			} else if (yhbh.trim().equals("05")) {
				yhjc = "工行";
			} else if (yhbh.trim().equals("06")) {
				yhjc = "邮政";
			} else if (yhbh.trim().equals("07")) {
				yhjc = "三峡";
			} else if (yhbh.trim().equals("08")) {
				yhjc = "浦发";
			} else if (yhbh.trim().equals("%")) {
				yhjc = "";
				yhbh = "";
			}
			list.get(i).setYhjc(yhjc);
			cell = PdfUtil.createCell(list.get(i).getYhjc(), headFont3, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(list.get(i).getByhs(), headFont3, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(list.get(i).getZjje(), headFont3, 1, 25, 1, PdfUtil.CENTER_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);
			
			cell = PdfUtil.createCell(list.get(i).getYxfp(), headFont3, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
		}
		
		cell = PdfUtil.createCell("", headFont3, 0, 50, 14, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		document.add(table);
		document.close();
	}
}

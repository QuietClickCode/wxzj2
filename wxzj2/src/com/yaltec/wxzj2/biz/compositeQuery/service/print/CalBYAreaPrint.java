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

public class CalBYAreaPrint extends AbstractPDFService{
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
	
		float[] widths = { 100f, 100f, 60f, 30f, 60f, 60f, 30f, 60f, 60f, 60f, 60f, 30f, 60f, 60f };// 设置表格的列以及列宽
		PdfPTable table = new PdfPTable(widths);// 建立一个pdf表格
		
		table.setSpacingBefore(20f);// 设置表格上面空白宽度
		table.setTotalWidth(754);// 设置表格的宽度
		table.setLockedWidth(true);// 设置表格的宽度固定
		table.getDefaultCell().setBorder(1);// 设置表格默认为无边框
		
		PdfPCell cell = PdfUtil.createCell("面积户数统计清册", headFont1, 0,
				55, widths.length, PdfUtil.CENTER_H, PdfUtil.BOTTOM_V);
		table.addCell(cell);// 增加单元格
		
		cell = PdfUtil.createCell("日期：" + DateUtil.getDate() + "        共" + (list.size() - 1) + "条交款记录", headFont3, 
				0, 20, widths.length, PdfUtil.RIGHT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		// -------------
		// 打印显示列名
		cell = PdfUtil.createCell("单位名称", headFont3, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("楼宇名称", headFont3, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("期初面积", headFont3, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("期初户数", headFont3, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("期初金额", headFont3, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("本期面积", headFont3, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("本期户数", headFont3, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("本期金额", headFont3, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("增加金额", headFont3, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("减少金额", headFont3, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("累计面积", headFont3, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("累计户数", headFont3, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("累计本金", headFont3, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("累计金额", headFont3, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		

		// 填充数据
		for (int i = 0; i < list.size(); i++) {
			cell = PdfUtil.createCell(list.get(i).getKfgsmc(), headFont3, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(list.get(i).getLymc(), headFont3, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(list.get(i).getQcmj(), headFont3, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(list.get(i).getQchs(), headFont3, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(list.get(i).getQcje(), headFont3, 1, 25, 1, PdfUtil.CENTER_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(list.get(i).getBymj(), headFont3, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(list.get(i).getByhs(), headFont3, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(list.get(i).getByje(), headFont3, 1, 25, 1, PdfUtil.CENTER_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(list.get(i).getZjje(), headFont3, 1, 25, 1, PdfUtil.CENTER_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(list.get(i).getJsje(), headFont3, 1, 25, 1, PdfUtil.CENTER_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(list.get(i).getBqmj(), headFont3, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(list.get(i).getBqhs(), headFont3, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(list.get(i).getBjye(), headFont3, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(list.get(i).getBqje(), headFont3, 1, 25, 1, PdfUtil.CENTER_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);
		}
		
		cell = PdfUtil.createCell("", headFont3, 0, 50, 14, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		document.add(table);
		document.close();
	}
}

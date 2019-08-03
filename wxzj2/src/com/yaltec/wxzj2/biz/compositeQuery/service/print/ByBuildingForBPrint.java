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
import com.yaltec.wxzj2.biz.compositeQuery.entity.ByCommunityForB;

public class ByBuildingForBPrint extends AbstractPDFService {
	@SuppressWarnings("unchecked")
	@Override
	protected void buildPdfDocument(Map<String, Object> model, Document document, PdfWriter writer,
			HttpServletRequest request, HttpServletResponse response) throws Exception {
		// 调用父类初始化方法
		super.init(model);
		// 获取传入参数
		List<ByCommunityForB> list = getValue("list", List.class); // 楼宇余额查询结果信息

		Rectangle pageSize = new Rectangle(PageSize.A4);
		document.setPageSize(pageSize.rotate());// 设置页面大小,为A4纸

		ByteArrayOutputStream ops = new ByteArrayOutputStream();// 输出到客户段的流

		PdfWriter.getInstance(document, ops);// 建立一个PdfWriter对象
		document.open();

		float[] widths = { 50f, 120f, 60f, 60f, 60f, 60f, 60f, 60f, 60f, 60f };// 设置表格的列以及列宽
		PdfPTable table = new PdfPTable(widths);// 建立一个pdf表格

		table.setSpacingBefore(20f);// 设置表格上面空白宽度
		table.setTotalWidth(754);// 设置表格的宽度
		table.setLockedWidth(true);// 设置表格的宽度固定
		table.getDefaultCell().setBorder(1);// 设置表格默认为无边框

		PdfPCell cell = PdfUtil.createCell("楼宇余额查询结果", headFont1, 0, 55, widths.length, PdfUtil.CENTER_H,
				PdfUtil.BOTTOM_V);
		table.addCell(cell);// 增加单元格

		// 空行(名称下面显示两条信息，左边显示所属楼宇，右边显示日期)
		cell = PdfUtil.createCell("", headFont1, 0, 20, widths.length, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		int w1 = widths.length / 2;
		int w2 = widths.length - w1;
		// 设置打印表格显示信息
		String xqmc = "所有小区";
		if (!request.getParameter("xqbh").trim().equals("")) {
			xqmc = list.get(0).getXqmc();
		}
		cell = PdfUtil.createCell("所属小区：" + xqmc, headFont3, 0, 20, w1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("日期：" + DateUtil.getDate() + "        共" + (list.size() - 1) + "条交款记录", headFont3, 0,
				20, w2, PdfUtil.RIGHT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		// -------------
		// 打印显示列名
		cell = PdfUtil.createCell("楼宇编号", headFont2, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("楼宇名称", headFont2, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("交款本金", headFont2, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("交款利息", headFont2, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("支出本金", headFont2, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("支出利息", headFont2, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("剩余本金", headFont2, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("剩余利息", headFont2, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("余额", headFont2, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("截止日期", headFont2, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		// 填充数据
		for (int i = 0; i < list.size(); i++) {
			cell = PdfUtil.createCell(list.get(i).getLybh(), headFont3, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(list.get(i).getLymc(), headFont3, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(list.get(i).getJkje(), headFont3, 1, 25, 1, PdfUtil.CENTER_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(list.get(i).getJklx(), headFont3, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(list.get(i).getZqje(), headFont3, 1, 25, 1, PdfUtil.CENTER_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(list.get(i).getZqlx(), headFont3, 1, 25, 1, PdfUtil.CENTER_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(list.get(i).getBj(), headFont3, 1, 25, 1, PdfUtil.CENTER_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil
					.createCell(list.get(i).getLx(), headFont3, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(list.get(i).getYe(), headFont3, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			
			if(list.get(i).getMdate().length()>10){
				String li = list.get(i).getMdate().substring(0,10);
				cell = PdfUtil.createCell(li, headFont3, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			}else {
				cell = PdfUtil.createCell(list.get(i).getMdate(), headFont3, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			}
			table.addCell(cell);
		}

		cell = PdfUtil.createCell("", headFont3, 0, 50, 14, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		document.add(table);
		document.close();
	}
}

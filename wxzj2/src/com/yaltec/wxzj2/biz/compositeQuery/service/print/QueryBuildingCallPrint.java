package com.yaltec.wxzj2.biz.compositeQuery.service.print;

import java.io.ByteArrayOutputStream;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.lowagie.text.Document;
import com.lowagie.text.Element;
import com.lowagie.text.PageSize;
import com.lowagie.text.Rectangle;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;
import com.yaltec.comon.utils.ChangeRMB;
import com.yaltec.comon.utils.PdfUtil;
import com.yaltec.wxzj2.biz.comon.service.AbstractPDFService;
import com.yaltec.wxzj2.biz.compositeQuery.entity.BuildingCall;

public class QueryBuildingCallPrint extends AbstractPDFService{
	@SuppressWarnings("unchecked")
	@Override
	protected void buildPdfDocument(Map<String, Object> model, Document document, PdfWriter writer,
			HttpServletRequest request, HttpServletResponse response) throws Exception {
		// 调用父类初始化方法
		super.init(model);
		// 获取传入参数
		List<BuildingCall> list = getValue("list", List.class); // 房屋信息
		
		Rectangle pageSize = new Rectangle(PageSize.A4);
		document.setPageSize(pageSize.rotate());// 设置页面大小,为A4纸

		ByteArrayOutputStream ops = new ByteArrayOutputStream();// 输出到客户段的流

		
		PdfWriter.getInstance(document, ops);// 建立一个PdfWriter对象
		document.open();
	
		float[] widths = { 52f, 52f, 52f, 52f, 52f, 20f, 20f, 20f, 20f, 20f, 20f,
				20f, 20f, 20f, 20f };// 设置表格的列以及列宽
		
		for (BuildingCall bc : list) {
		PdfPTable table = new PdfPTable(widths);// 建立一个pdf表格
		
		table.setSpacingBefore(20f);// 设置表格上面空白宽度
		table.setTotalWidth(754);// 设置表格的宽度
		table.setLockedWidth(true);// 设置表格的宽度固定
		table.getDefaultCell().setBorder(1);// 设置表格默认为无边框
		
		PdfPCell cell = PdfUtil.createCell("物业专项维修资金征缴通知书", headFont1, 0,
				55, widths.length, PdfUtil.CENTER_H, PdfUtil.BOTTOM_V);
		table.addCell(cell);// 增加单元格
		
		// 空行
		cell = PdfUtil.createCell("", headFont1, 0, 15, 15, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		// -------------
		// 打印显示列名

		cell = PdfUtil.createCell("楼宇名称", headFont2, 1, 20, 1, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);

		cell = PdfUtil.createCell(bc.getLymc(), headFont3,
				1, 20, 4, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		cell = PdfUtil.createCell("楼宇编号", headFont2, 1, 20, 3, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);

		cell = PdfUtil.createCell(bc.getLybh(), headFont3, 1, 20, 7, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		
		// ----------------------
		cell = PdfUtil.createCell("应交金额", headFont2, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(bc.getYjje()+"元", headFont3, 1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		cell = PdfUtil.createCell("实交金额", headFont2, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(bc.getSjje()+"元", headFont3, 1, 20, 1, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);

		cell = PdfUtil.createCell("支取金额", headFont2, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(bc.getZqje()+"元", headFont3, 1, 20, 3, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);

		cell = PdfUtil.createCell("可用金额", headFont2, 1, 20, 3, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		cell = PdfUtil.createCell(bc.getKyje(), headFont3, 1, 20, 4, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		
		// ----------------------
		float[] ifloat = { 52f };
		PdfPTable itable = new PdfPTable(ifloat);
		cell = PdfUtil.createCell("征缴金额", headFont2, 1, 20, 1, PdfUtil.CENTER_H,
				Element.ALIGN_BOTTOM);
		cell.setBorder(1);
		cell.setBorderWidthBottom(0);
		itable.addCell(cell);

		cell = PdfUtil.createCell("（大写）", headFont2, 1, 20, 1, PdfUtil.CENTER_H,
				Element.ALIGN_TOP);
		cell.setBorder(1);
		cell.setBorderWidthTop(0);
		itable.addCell(cell);

		cell = new PdfPCell(itable);
		cell.setFixedHeight(40);
		cell.setColspan(1);
		table.addCell(cell);

		//cell = PdfUtil.createCell(ChangeRMB.doChangeRMB(df.format(applyDraw.getPzje())), headFont2, 1, 40, 2, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		cell = PdfUtil.createCell(ChangeRMB.doChangeRMB(df.format(Double.valueOf(bc.getZjje()))), headFont2, 1, 40, 4, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		float[] temp_float = { 20f, 20f, 20f, 20f, 20f, 20f, 20f, 20f, 20f,
				20f };
		PdfPTable temp_itable = new PdfPTable(temp_float);
		table.getDefaultCell().setBorder(1);// 设置表格默认为无边框
		
		String[] str = {"千","佰","十","万","千","佰","十","元","角","分"};
		for (int i = 0; i < str.length; i++) {
			cell = PdfUtil.createCell(str[i], headFont2, 20);
			temp_itable.addCell(cell);
		}
		//bcsqje
		//String[] sqje = PdfUtil.convert(df.format(applyDraw.getSqje()));
		String[] zcje = PdfUtil.convert(df.format(Double.valueOf(bc.getZjje())));
		for (int i = 0; i < str.length; i++) {
			cell = PdfUtil.createCell(zcje[i], headFont3, 20);
			temp_itable.addCell(cell);
		}

		cell = new PdfPCell(temp_itable);
		cell.setFixedHeight(40);
		cell.setColspan(10);
		table.addCell(cell);
		// ----------------------
		cell = PdfUtil.createCell("征缴原因", headFont2, 1, 40, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		cell = PdfUtil.createCell("该楼宇的可用金额不足应交金额的30%。", headFont3, 1, 40, 4, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		
		cell = PdfUtil.createCell("主管单位", headFont2, 1, 40, 3, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("", headFont3, 1, 40, 7, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		
		document.add(table);
		document.newPage();
		}
		document.close();
	}
}

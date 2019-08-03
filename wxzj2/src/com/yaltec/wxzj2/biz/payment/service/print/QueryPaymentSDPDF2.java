package com.yaltec.wxzj2.biz.payment.service.print;

import java.io.ByteArrayOutputStream;
import java.util.Date;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.lowagie.text.Document;
import com.lowagie.text.PageSize;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;
import com.yaltec.comon.utils.ChangeRMB;
import com.yaltec.comon.utils.DateUtil;
import com.yaltec.comon.utils.PdfUtil;
import com.yaltec.wxzj2.biz.comon.service.AbstractPDFService;
import com.yaltec.wxzj2.biz.property.entity.House;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 交款交款证明(非套打)
 * @author Administrator
 */
public class QueryPaymentSDPDF2 extends AbstractPDFService{
	

	@Override
	protected void buildPdfDocument(Map<String, Object> model, Document document, PdfWriter writer,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		// 调用父类初始化方法
		super.init(model);
		// 获取传入参数
		// 当前用户的打印配置
		String jksj = getValue("jksj", String.class); // 交款时间
		String jkje = getValue("jkje", String.class); // 交款金额
		//String w008 = getValue("w008", String.class); //业务编号
		String username = getValue("username", String.class); // 当前操作用户
		House house = getValue("house", House.class); // 房屋信息
			
		document.setPageSize(PageSize.A4);// 设置页面大小,为A4纸

		ByteArrayOutputStream ops = new ByteArrayOutputStream();// 输出到客户段的流
		PdfWriter.getInstance(document, ops);// 建立一个PdfWriter对象

		document.open();
		float[] widths = { 60f, 150f, 80f, 120f };// 设置表格的列以及列宽
		PdfPTable table = new PdfPTable(widths);// 建立一个pdf表格

		table.setSpacingBefore(20f);// 设置表格上面空白宽度
		table.setTotalWidth(460);// 设置表格的宽度
		table.setLockedWidth(true);// 设置表格的宽度固定
		table.getDefaultCell().setBorder(1);// 设置表格默认为无边框

		PdfPCell cell = PdfUtil.createCell(DataHolder.customerInfo.getName(), headFont1, 0, 20, 4, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);// 增加单元格

		// 空行
		cell = PdfUtil.createCell("", headFont1, 0, 10, 4, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		// -------------br
		String[] date = jksj.split("-");
		cell = PdfUtil.createCell("交款日期：" + date[0] + "年   " + date[1] + "月   " + date[2] + "日", headFont2, 0, 20, 2,
				PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		String[] djDate = DateUtil.getDate(new Date()).split("-");
		cell = PdfUtil.createCell(" 打印日期：" + djDate[0] + "年   " + djDate[1] + "月   " + djDate[2] + "日", headFont2, 0,
				20, 2, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		// -------------br
		cell = PdfUtil.createCell("产  权  人", headFont2, 20);
		table.addCell(cell);
		cell = PdfUtil.createCell(house.getH013(), headFont3, 1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("身份证号码", headFont2, 20);
		table.addCell(cell);
		cell = PdfUtil.createCell(house.getH015(), headFont3, 1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		// -------------br
		cell = PdfUtil.createCell("房屋住址", headFont2, 20);
		table.addCell(cell);
		cell = PdfUtil.createCell("           " + house.getLymc() + "    " + house.getH002() + "单元  " + house.getH003()
				+ "层  " + house.getH005() + "号", headFont3, 1, 20, 3, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		// -------------br
		cell = PdfUtil.createCell("建筑面积", headFont2, 20);
		table.addCell(cell);
		cell = PdfUtil.createCell(house.getH006() + "平方米", headFont3, 1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("交存标准", headFont2, 20);
		table.addCell(cell);
		cell = PdfUtil.createCell(house.getH023(), headFont3, 1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		// -------------br
		cell = PdfUtil.createCell("房屋性质", headFont2, 20);
		table.addCell(cell);
		cell = PdfUtil.createCell(house.getH045(), headFont3, 1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("交款金额(元)", headFont2, 20);
		table.addCell(cell);
		cell = PdfUtil.createCell("￥" + jkje + "元", headFont3, 1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		// -------------br
		cell = PdfUtil.createCell("    金额（大写）    " + ChangeRMB.doChangeRMB(jkje), headFont2, 1, 20, 2, PdfUtil.LEFT_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("房屋编号", headFont2, 20);
		table.addCell(cell);
		cell = PdfUtil.createCell(house.getH001(), headFont3, 1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		// -------------br
		cell = PdfUtil.createCell("      收款单位（章）                        开票人（章） " + username
				+ "                      备注：  仅供办理产权证使用", headFont2, 0, 20, 4, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		document.add(table);
		document.close();
		
	}
	
}

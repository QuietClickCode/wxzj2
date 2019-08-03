package com.yaltec.wxzj2.biz.propertymanager.entity;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.text.DecimalFormat;
import java.util.Date;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.lowagie.text.Document;
import com.lowagie.text.DocumentException;
import com.lowagie.text.Element;
import com.lowagie.text.Font;
import com.lowagie.text.PageSize;
import com.lowagie.text.pdf.BaseFont;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;
import com.yaltec.comon.core.entity.Entity;
import com.yaltec.comon.utils.ChangeRMB;
import com.yaltec.comon.utils.DateUtil;
import com.yaltec.comon.utils.PdfUtil;
import com.yaltec.wxzj2.biz.draw.service.print.QueryRefundPDF;
import com.yaltec.wxzj2.biz.propertymanager.entity.Redemption;

/**
 * 房屋换购的补交书打印
 * @author hqx
 *
 */
public class RedemptionPDF extends Entity{
	/**
	 * 序列化版本标示.
	 */
	private static final long serialVersionUID = 1L;
	private BaseFont bfChinese;
	private Font headFont1;
	private Font headFont2;
	private Font headFont3;
	private Font headFont4;
	private DecimalFormat df=new DecimalFormat("0.00"); //保留2位小数
	static Logger logger = LoggerFactory.getLogger(QueryRefundPDF.class);
	
	public void init() throws DocumentException, IOException {
		bfChinese = BaseFont.createFont("STSong-Light",
				"UniGB-UCS2-H", BaseFont.NOT_EMBEDDED);// 设置中文字体
		headFont1 = new Font(bfChinese, 14, Font.BOLD);// 设置字体大小
		headFont2 = new Font(bfChinese, 11, Font.NORMAL);// 设置字体大小
		headFont3 = new Font(bfChinese, 10, Font.NORMAL);// 设置字体大小
		headFont4 = new Font(bfChinese, 8, Font.NORMAL);// 设置字体大小
	}
	
	public ByteArrayOutputStream creatPDF(String h001, String w003, String sbje, String h013, String lymc, String username,String title) throws Exception {
		init();
		Document document = new Document();// 建立一个Document对象
		document.setPageSize(PageSize.A4);// 设置页面大小,为A4纸
		
		ByteArrayOutputStream ops = new ByteArrayOutputStream();// 输出到客户段的流
		
		PdfWriter.getInstance(document, ops);// 建立一个PdfWriter对象
		document.open();
		float[] widths = { 55f, 35f, 100f, 55f, 40f, 20f, 20f, 20f, 20f, 20f, 20f, 20f,
				20f, 20f, 20f, 20f };// 设置表格的列以及列宽
		PdfPTable table = new PdfPTable(widths);// 建立一个pdf表格

		table.setSpacingBefore(20f);// 设置表格上面空白宽度
		table.setTotalWidth(460);// 设置表格的宽度
		table.setLockedWidth(true);// 设置表格的宽度固定
		table.getDefaultCell().setBorder(1);// 设置表格默认为无边框

		PdfPCell cell = PdfUtil.createCell(title, headFont1, 0, 20, 16,
				PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);// 增加单元格

		// 空行
		cell = PdfUtil.createCell("", headFont1, 0, 15, 16, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		//-------------
		cell = PdfUtil.createCell("楼宇名称", headFont2, 1, 20, 1, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(lymc, headFont3,
				1, 20, 4, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		cell = PdfUtil.createCell("房屋编号", headFont2, 1, 20, 3, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		
		StringBuffer buffer = new StringBuffer();
		buffer.append(h001).append("（").append(h013).append("）");
		
		cell = PdfUtil.createCell(buffer.toString(), headFont3, 1, 20, 8, PdfUtil.LEFT_H,
				PdfUtil.MIDDLE_V);
		buffer.setLength(0);
		table.addCell(cell);

		// ----------------------
		cell = PdfUtil.createCell("交款日期", headFont2, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		cell = PdfUtil.createCell(w003, headFont3, 1, 20, 2, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		cell = PdfUtil.createCell("交款项目", headFont2, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("物业专项维修资金换购补交", headFont3, 1, 20, 12, PdfUtil.LEFT_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		// ----------------------
		float[] ifloat = { 90f };
		PdfPTable itable = new PdfPTable(ifloat);
		cell = PdfUtil.createCell("交款金额", headFont2, 1, 20, 1, PdfUtil.CENTER_H,
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
		cell.setColspan(2);
		table.addCell(cell);
		
		cell = PdfUtil.createCell(ChangeRMB.doChangeRMB(df.format(Double.valueOf(sbje))), headFont3, 1, 40, 4, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
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

		String[] sqje = PdfUtil.convert(df.format(Double.valueOf(sbje)));
		for (int i = 0; i < str.length; i++) {
			cell = PdfUtil.createCell(sqje[i], headFont3, 20);
			temp_itable.addCell(cell);
		}

		cell = new PdfPCell(temp_itable);
		cell.setFixedHeight(40);
		cell.setColspan(10);
		table.addCell(cell);
		// ----------------------
		float[] tfloat1 = { 90f };
		float[] tfloat2 = { 60f };
		itable = new PdfPTable(tfloat1);
		cell = PdfUtil.createCell("资金管理中心", headFont2, 1, 20, 1, PdfUtil.CENTER_H,
				PdfUtil.BOTTOM_V);
		cell.setBorder(1);
		cell.setBorderWidthBottom(0);
		cell.setBorderWidthTop(0);
		itable.addCell(cell);

		cell = PdfUtil.createCell("(盖章)", headFont2, 1, 20, 1,
				PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		cell.setBorder(1);
		cell.setBorderWidthTop(0);
		itable.addCell(cell);

		cell = new PdfPCell(itable);
		cell.setFixedHeight(40);
		cell.setColspan(2);
		table.addCell(cell);

		cell = PdfUtil.createCell("", headFont3, 1, 40, 2, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		itable = new PdfPTable(tfloat2);
		cell = PdfUtil.createCell("交款人", headFont2, 1, 20, 1, PdfUtil.CENTER_H,
				PdfUtil.BOTTOM_V);
		cell.setBorder(1);
		cell.setBorderWidthBottom(0);
		cell.setBorderWidthTop(0);
		itable.addCell(cell);

		cell = PdfUtil.createCell("签字",
				headFont2, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		cell.setBorder(1);
		cell.setBorderWidthTop(0);
		itable.addCell(cell);

		cell = new PdfPCell(itable);
		cell.setFixedHeight(40);
		cell.setColspan(2);
		table.addCell(cell);

		cell = PdfUtil.createCell("", headFont2, 1, 40, 10, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		// ---------------------
		cell = PdfUtil.createCell("     收款人："+ username, headFont3, 0, 20, 16, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);


		document.add(table);
		document.close();
		return ops;
	}
	

	public ByteArrayOutputStream creatPDF2(Redemption r,String title) throws Exception {
		init();
		Document document = new Document();// 建立一个Document对象
		document.setPageSize(PageSize.A4);// 设置页面大小,为A4纸
		
		ByteArrayOutputStream ops = new ByteArrayOutputStream();// 输出到客户段的流
		
		PdfWriter.getInstance(document, ops);// 建立一个PdfWriter对象
		document.open();
		float[] widths = { 60f, 75f,75f, 75f, 60f, 100f};// 设置表格的列以及列宽
		PdfPTable table = new PdfPTable(widths);// 建立一个pdf表格

		table.setSpacingBefore(20f);// 设置表格上面空白宽度
		table.setTotalWidth(400);// 设置表格的宽度
		table.setLockedWidth(true);// 设置表格的宽度固定
		table.getDefaultCell().setBorder(1);// 设置表格默认为无边框

		PdfPCell cell = PdfUtil.createCell(title, headFont1, 0, 20, 6,
				PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);// 增加单元格

		// 空行
		cell = PdfUtil.createCell("", headFont1, 0, 15, 6, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		// 
		cell = PdfUtil.createCell(DateUtil.getDate(new Date()), headFont2, 0, 15, 6, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		//-------------
		cell = PdfUtil.createCell("原房屋地址", headFont2, 1, 20, 1, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(r.getO047(), headFont3,1, 20, 3, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		cell = PdfUtil.createCell("原房屋编号", headFont2, 1, 20, 1, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(r.getH001a(), headFont3,1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		//-------------
		cell = PdfUtil.createCell("现房屋地址", headFont2, 1, 20, 1, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(r.getN047(), headFont3,1, 20, 3, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		cell = PdfUtil.createCell("现房屋编号", headFont2, 1, 20, 1, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(r.getH001b(), headFont3,1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		//-------------
		cell = PdfUtil.createCell("业主姓名", headFont2, 1, 20, 1, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(r.getW012(), headFont3,1, 20, 2, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		cell = PdfUtil.createCell("身份证号", headFont2, 1, 20, 1, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(r.getH015(), headFont3,1, 20, 2, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		//-------------
		cell = PdfUtil.createCell("原房屋本金", headFont2, 1, 20, 1, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(r.getW004().toString(), headFont3,1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		cell = PdfUtil.createCell("原房屋利息", headFont2, 1, 20, 1, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(r.getW005().toString(), headFont3,1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		
		cell = PdfUtil.createCell("本息合计", headFont2, 1, 20, 1, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(String.valueOf(r.getW004()+r.getW005()), headFont3,1, 20, 2, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		//-------------
		cell = PdfUtil.createCell("原房屋面积", headFont2, 1, 20, 1, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(r.getO006(), headFont3,1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		cell = PdfUtil.createCell("现房屋面积", headFont2, 1, 20, 1, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(r.getN006().toString(), headFont3,1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		
		cell = PdfUtil.createCell("交存标准", headFont2, 1, 20, 1, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(r.getH023(), headFont3,1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		//-------------
		cell = PdfUtil.createCell("应交金额", headFont2, 1, 20, 1, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(r.getH021(), headFont3,1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		cell = PdfUtil.createCell("补交金额", headFont2, 1, 20, 1, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(r.getCe().toString(), headFont3,1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		
		cell = PdfUtil.createCell("换购日期", headFont2, 1, 20, 1, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(r.getYwrq(), headFont3,1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		
		// ---------------------
		cell = PdfUtil.createCell("     主管部门（章）：", headFont2, 0, 20, 2, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("     开票人（章）：", headFont2, 0, 20, 2, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("     备注：", headFont2, 0, 20, 2, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);


		document.add(table);
		document.close();
		return ops;
	}
}

package com.yaltec.wxzj2.biz.draw.service.print;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.text.DecimalFormat;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

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
import com.yaltec.comon.utils.ChangeRMB;
import com.yaltec.comon.utils.PdfUtil;
import com.yaltec.wxzj2.biz.draw.entity.ApplyDraw;

public class ApplyDrawPDF {
	/**
	 *<p>文件名称: ApplyDrawPDF.java</p>
	 * <p>文件描述: 支取申请打印</p>
	 * <p>版权所有: 版权所有(C)2010</p>
	 * <p>公   司: yaltec</p>
	 * <p>内容摘要: </p>
	 * <p>其他说明: </p>
	 * <p>完成日期：Mar 11, 2011</p>
	 * <p>修改记录0：无</p>
	 * @version 1.0
	 * @author jiangyong
	 * @throws IOException 
	 * @throws DocumentException 
	 */
	private BaseFont bfChinese;
	private Font headFont1;
	private Font headFont2;
	private Font headFont3;
	private DecimalFormat df=new DecimalFormat("0.00"); //保留2位小数
	private HttpServletResponse response;
	
	static Logger logger = LoggerFactory.getLogger(ApplyDrawPDF.class);
	
	public void init() throws DocumentException, IOException {
		bfChinese = BaseFont.createFont("STSong-Light",
				"UniGB-UCS2-H", BaseFont.NOT_EMBEDDED);// 设置中文字体
		headFont1 = new Font(bfChinese, 14, Font.BOLD);// 设置字体大小
		headFont2 = new Font(bfChinese, 12, Font.NORMAL);// 设置字体大小
		headFont3 = new Font(bfChinese, 10, Font.NORMAL);// 设置字体大小
	}

	// 输出PDF
	public void output(ByteArrayOutputStream ops) {
		response.setContentType("application/pdf");

		// response.setHeader("Content-disposition","attachment; filename="+"report.pdf"
		// );
		response.setHeader("Cache-Control", "must-revalidate, post-check=0, pre-check=0");
		response.setHeader("Pragma", "public");
		response.setDateHeader("Expires", (System.currentTimeMillis() + 1000));

		response.setContentLength(ops.size());
		ServletOutputStream out = null;
		try {
			out = response.getOutputStream();
			ops.writeTo(out);
		} catch (IOException e) {
			logger.error(e.getMessage());
		} finally {
			try {
				out.flush();
				out.close();
			} catch (IOException e) {
				logger.error(e.getMessage());
			}
		}
	}
	
	public void creatPDF(ApplyDraw applyDraw,HttpServletResponse rep) throws Exception {
		init();
		response = rep;
		Document document = new Document();// 建立一个Document对象
		document.setPageSize(PageSize.A4);// 设置页面大小,为A4纸
			
		ByteArrayOutputStream ops = new ByteArrayOutputStream();// 输出到客户段的流
		PdfWriter.getInstance(document, ops);// 建立一个PdfWriter对象
		document.open();
		float[] widths = { 55f, 75f, 130f, 20f, 20f, 20f, 20f, 20f, 20f,
				20f, 20f, 20f, 20f };// 设置表格的列以及列宽
		PdfPTable table = new PdfPTable(widths);// 建立一个pdf表格

		table.setSpacingBefore(20f);// 设置表格上面空白宽度
		table.setTotalWidth(460);// 设置表格的宽度
		table.setLockedWidth(true);// 设置表格的宽度固定
		table.getDefaultCell().setBorder(1);// 设置表格默认为无边框

		PdfPCell cell = PdfUtil.createCell("支取申请受理单", headFont1, 0, 20, 13,
				PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);// 增加单元格

		// 空行
		cell = PdfUtil.createCell("", headFont1, 0, 15, 13, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		//-------------
		cell = PdfUtil.createCell("编号：", headFont2, 0, 20, 1, PdfUtil.RIGHT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		cell = PdfUtil.createCell(" "+applyDraw.getBm(), headFont3, 0, 20, 12, PdfUtil.LEFT_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		//-------------
		
		cell = PdfUtil.createCell("建  筑  物", headFont2, 1, 20, 1, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);

		StringBuffer buffer = new StringBuffer("    ");
		buffer.append(applyDraw.getNbhdcode()).append("(").
				append(applyDraw.getNbhdname()).append(")").append("/");
		buffer.append(applyDraw.getBldgcode()).append("(").append(applyDraw.getBldgname()).append(")");
		
		cell = PdfUtil.createCell(buffer.toString(), headFont3,
				1, 20, 6, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		buffer.setLength(0);
		table.addCell(cell);

		cell = PdfUtil.createCell("经  办  人", headFont2, 1, 20, 3, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);

		cell = PdfUtil.createCell(applyDraw.getJbr(), headFont3, 1, 20, 3, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		// ----------------------
		cell = PdfUtil.createCell("申请单位", headFont2, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		cell = PdfUtil.createCell(applyDraw.getSqdw(), headFont3, 1, 20, 6, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		cell = PdfUtil.createCell("申请日期", headFont2, 1, 20, 3, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		cell = PdfUtil.createCell(applyDraw.getSqrq().substring(0, 10), headFont3, 1, 20, 3, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		// ----------------------
		float[] ifloat = { 60f };
		PdfPTable itable = new PdfPTable(ifloat);
		cell = PdfUtil.createCell("申请金额", headFont2, 1, 20, 1, PdfUtil.CENTER_H,
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

		cell = PdfUtil.createCell(ChangeRMB.doChangeRMB(df.format(applyDraw.getSqje())), headFont2, 1, 40, 2, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
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

		String[] sqje = PdfUtil.convert(df.format(applyDraw.getSqje()));
		for (int i = 0; i < str.length; i++) {
			cell = PdfUtil.createCell(sqje[i], headFont3, 20);
			temp_itable.addCell(cell);
		}

		cell = new PdfPCell(temp_itable);
		cell.setFixedHeight(40);
		cell.setColspan(10);
		table.addCell(cell);
		// ----------------------
		cell = PdfUtil.createCell("维修项目", headFont2, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		cell = PdfUtil.createCell(applyDraw.getWxxm(), headFont3, 1, 20, 12, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		// ----------------------
		float[] tfloat1 = { 130f };
		float[] tfloat2 = { 150f };
		float[] tfloat3 = { 180f };
		itable = new PdfPTable(tfloat1);
		cell = PdfUtil.createCell("单位盖章预留印鉴", headFont2, 1, 25, 1, PdfUtil.CENTER_H,
				Element.ALIGN_BOTTOM);
		cell.setBorder(1);
		cell.setBorderWidthBottom(0);
		cell.setBorderWidthTop(0);
		itable.addCell(cell);

		cell = PdfUtil.createCell("年          月         日", headFont2, 1, 25, 1,
				PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		cell.setBorder(1);
		cell.setBorderWidthTop(0);
		itable.addCell(cell);

		cell = new PdfPCell(itable);
		cell.setFixedHeight(50);
		cell.setColspan(2);
		table.addCell(cell);

		itable = new PdfPTable(tfloat2);
		cell = PdfUtil.createCell("物业管理处中心盖章", headFont2, 1, 25, 1, PdfUtil.CENTER_H,
				PdfUtil.BOTTOM_V);
		cell.setBorder(1);
		cell.setBorderWidthBottom(0);
		cell.setBorderWidthTop(0);
		itable.addCell(cell);

		cell = PdfUtil.createCell("年          月         日", headFont2, 1, 25, 1,
				PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		cell.setBorder(1);
		cell.setBorderWidthTop(0);
		itable.addCell(cell);

		cell = new PdfPCell(itable);
		cell.setFixedHeight(50);
		cell.setColspan(2);
		table.addCell(cell);

		itable = new PdfPTable(tfloat3);
		cell = PdfUtil.createCell("付款银行盖章", headFont2, 1, 25, 1, PdfUtil.CENTER_H,
				PdfUtil.BOTTOM_V);
		cell.setBorder(1);
		cell.setBorderWidthBottom(0);
		cell.setBorderWidthTop(0);
		itable.addCell(cell);

		cell = PdfUtil.createCell("       审核           记账            接柜",
				headFont2, 1, 25, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		cell.setBorder(1);
		cell.setBorderWidthTop(0);
		itable.addCell(cell);

		cell = new PdfPCell(itable);
		cell.setFixedHeight(50);
		cell.setColspan(9);
		table.addCell(cell);

		// ---------------------
		cell = PdfUtil.createCell("操作员：", headFont2, 0, 20, 1, PdfUtil.RIGHT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		cell = PdfUtil.createCell(" "+applyDraw.getUsername(), headFont3, 0, 20, 12, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		document.add(table);
		document.close();

		if (ops != null) {
			output(ops);
		}
	}
	
}

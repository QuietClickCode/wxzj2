package com.yaltec.wxzj2.biz.draw.service.print;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.Date;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

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
import com.yaltec.comon.utils.ObjectUtil;
import com.yaltec.comon.utils.PdfUtil;
import com.yaltec.wxzj2.biz.draw.entity.TransferAD;

public class TransferAD2PDF {
	private static BaseFont bfChinese;
	private static Font headFont1;
	private static Font headFont2;
	private static Font headFont3;

	static Logger logger = LoggerFactory.getLogger(ShareADPDF.class);
	private HttpServletResponse response;

	public void init() throws DocumentException, IOException {
		bfChinese = BaseFont.createFont("STSong-Light", "UniGB-UCS2-H", BaseFont.NOT_EMBEDDED);// 设置中文字体
		headFont1 = new Font(bfChinese, 14, Font.BOLD);// 设置字体大小
		headFont2 = new Font(bfChinese, 11, Font.NORMAL);// 设置字体大小
		headFont3 = new Font(bfChinese, 10, Font.NORMAL);// 设置字体大小
	}

	// 输出PDF
	public void output(ByteArrayOutputStream ops) {
		response.setContentType("application/pdf");

		// response.setHeader("Content-disposition","attachment;
		// filename="+"report.pdf"
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
				if (!ObjectUtil.isEmpty(out)) {
					out.flush();
				}
				out.close();
			} catch (IOException e) {
				logger.error(e.getMessage());
			}
		}
	}

	public void creatPDF(List<TransferAD> list, String bm, String xqmc, HttpServletResponse rep) throws Exception {
		init();
		response = rep;
		Document document = new Document();// 建立一个Document对象
		document.setPageSize(PageSize.A4);// 设置页面大小,为A4纸

		ByteArrayOutputStream ops = new ByteArrayOutputStream();// 输出到客户段的流

		PdfWriter.getInstance(document, ops);// 建立一个PdfWriter对象
		document.open();
		float[] widths = { 80f, 120f, 30f, 40f, 100f, 60f, 60f, 60f };// 设置表格的列以及列宽
		PdfPTable table = new PdfPTable(widths);// 建立一个pdf表格

		table.setSpacingBefore(20f);// 设置表格上面空白宽度
		table.setTotalWidth(540);// 设置表格的宽度
		table.setLockedWidth(true);// 设置表格的宽度固定
		table.getDefaultCell().setBorder(1);// 设置表格默认为无边框

		PdfPCell cell = PdfUtil.createCell("物业专项维修资金支取分摊清册", headFont1, 0, 20, 8, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);// 增加单元格

		// 空行
		cell = PdfUtil.createCell("", headFont1, 0, 15, 8, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		// -------------
		if (list.get(0).getLymc().equals(list.get(list.size() - 2).getLymc())) {
			cell = PdfUtil.createCell("建筑物名称：" + list.get(0).getLymc(), headFont2, 0, 20, 3, PdfUtil.LEFT_H,
					PdfUtil.MIDDLE_V);
		} else {
			cell = PdfUtil.createCell("建筑物名称：" + xqmc, headFont2, 0, 20, 3, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		}
		table.addCell(cell);

		cell = PdfUtil.createCell("支取业务编号：" + bm, headFont2, 0, 20, 2, PdfUtil.RIGHT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		cell = PdfUtil.createCell("日期：" + DateUtil.getDate(new Date()), headFont2, 0, 20, 3, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		// ----------------------
		cell = PdfUtil.createCell("房屋编号", headFont2, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		cell = PdfUtil.createCell("业主姓名", headFont2, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		cell = PdfUtil.createCell("单元", headFont2, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		cell = PdfUtil.createCell("层", headFont2, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		cell = PdfUtil.createCell("房号", headFont2, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		cell = PdfUtil.createCell("支取本金", headFont2, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		cell = PdfUtil.createCell("支取利息", headFont2, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		cell = PdfUtil.createCell("支取金额", headFont2, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		// ----------------------
		for (int i = 0; i < list.size(); i++) {
			cell = PdfUtil.createCell(list.get(i).getH001(), headFont3, 25);
			table.addCell(cell);

			cell = PdfUtil.createCell(list.get(i).getH013(), headFont3, 25);
			table.addCell(cell);

			cell = PdfUtil.createCell(list.get(i).getH002(), headFont3, 25);
			table.addCell(cell);

			cell = PdfUtil.createCell(list.get(i).getH003(), headFont3, 25);
			table.addCell(cell);

			cell = PdfUtil.createCell(list.get(i).getH005(), headFont3, 25);
			table.addCell(cell);

			cell = PdfUtil.createCell(list.get(i).getZ004().toString(), headFont3, 25);
			table.addCell(cell);

			cell = PdfUtil.createCell(list.get(i).getZ005().toString(), headFont3, 25);
			table.addCell(cell);

			cell = PdfUtil.createCell(list.get(i).getZ006().toString(), headFont3, 25);
			table.addCell(cell);
		}

		document.add(table);
		document.close();
		if (ops != null) {
			output(ops);
		}
	}
}

package com.yaltec.wxzj2.biz.draw.service.print;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.text.DecimalFormat;
import java.util.List;

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
import com.yaltec.comon.utils.ObjectUtil;
import com.yaltec.comon.utils.PdfUtil;
import com.yaltec.wxzj2.biz.draw.entity.ShareAD;

public class ShareADPDF {
	private static BaseFont bfChinese;
	private static Font headFont1;
	private static Font headFont2;
	private static Font headFont3;
	private DecimalFormat df = new DecimalFormat("0.00"); // 保留2位小数
	private HttpServletResponse response;

	static Logger logger = LoggerFactory.getLogger(ShareADPDF.class);

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

	// 清册
	public void creatPDF(List<ShareAD> list, String xqmc, HttpServletResponse rep) throws Exception {
		init();
		response = rep;
		Document document = new Document();// 建立一个Document对象
		document.setPageSize(PageSize.A4);// 设置页面大小,为A4纸

		ByteArrayOutputStream ops = new ByteArrayOutputStream();// 输出到客户段的流

		PdfWriter.getInstance(document, ops);// 建立一个PdfWriter对象
		document.open();
		float[] widths = { 80f, 30f, 40f, 50f, 100f, 60f, 60f, 60f, 60f, 60f };// 设置表格的列以及列宽
		PdfPTable table = new PdfPTable(widths);// 建立一个pdf表格

		table.setSpacingBefore(20f);// 设置表格上面空白宽度
		table.setTotalWidth(540);// 设置表格的宽度
		table.setLockedWidth(true);// 设置表格的宽度固定
		table.getDefaultCell().setBorder(1);// 设置表格默认为无边框

		PdfPCell cell = PdfUtil.createCell("物业专项维修资金支取分摊清册", headFont1, 0, 20, 10, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);// 增加单元格

		// 空行
		cell = PdfUtil.createCell("", headFont1, 0, 15, 10, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		// -------------
		cell = PdfUtil.createCell("支取业务编号：", headFont2, 0, 20, 3, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		if (list.get(0).getLymc().equals(list.get(list.size() - 2).getLymc())) {
			cell = PdfUtil.createCell("            支取楼宇：" + list.get(0).getLymc(), headFont2, 0, 20, 2, PdfUtil.LEFT_H,
					PdfUtil.MIDDLE_V);
		} else {
			cell = PdfUtil.createCell("支取小区：" + xqmc, headFont2, 0, 20, 2, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		}
		table.addCell(cell);

		cell = PdfUtil.createCell("分摊日期：" + list.get(0).getZ003().substring(0, 10), headFont2, 0, 20, 5,
				PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		// ----------------------
		cell = PdfUtil.createCell("房屋编号", headFont2, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		cell = PdfUtil.createCell("单元", headFont3, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		cell = PdfUtil.createCell("层", headFont2, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		cell = PdfUtil.createCell("房号", headFont3, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		cell = PdfUtil.createCell("业主姓名", headFont2, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		cell = PdfUtil.createCell("面积", headFont2, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		cell = PdfUtil.createCell("分摊金额", headFont2, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		cell = PdfUtil.createCell("支取本金", headFont2, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		cell = PdfUtil.createCell("自筹本金", headFont2, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		cell = PdfUtil.createCell("可用本金", headFont2, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		// ----------------------
		for (int i = 0; i < list.size(); i++) {
			cell = PdfUtil.createCell(list.get(i).getH001(), headFont3, 25);
			table.addCell(cell);

			cell = PdfUtil.createCell(list.get(i).getH002(), headFont3, 25);
			table.addCell(cell);

			cell = PdfUtil.createCell(list.get(i).getH003(), headFont3, 25);
			table.addCell(cell);

			cell = PdfUtil.createCell(list.get(i).getH005(), headFont3, 25);
			table.addCell(cell);

			cell = PdfUtil.createCell(list.get(i).getH013(), headFont3, 25);
			table.addCell(cell);

			cell = PdfUtil.createCell(list.get(i).getH006(), headFont3, 25);
			table.addCell(cell);

			cell = PdfUtil.createCell(list.get(i).getFtje().toString(), headFont3, 25);
			table.addCell(cell);

			cell = PdfUtil.createCell(list.get(i).getZqbj().toString(), headFont3, 25);
			table.addCell(cell);

			cell = PdfUtil.createCell(list.get(i).getZcje().toString(), headFont3, 25);
			table.addCell(cell);

			cell = PdfUtil.createCell(list.get(i).getH030(), headFont3, 25);
			table.addCell(cell);
		}

		document.add(table);
		document.close();
		if (ops != null) {
			output(ops);
		}
	}

	// 征缴打印
	public void creatPDFCollectsPay(List<ShareAD> list, HttpServletResponse rep) throws Exception {
		init();
		response = rep;
		Document document = new Document();// 建立一个Document对象
		document.setPageSize(PageSize.A4);// 设置页面大小,为A4纸

		ByteArrayOutputStream ops = new ByteArrayOutputStream();// 输出到客户段的流

		PdfWriter.getInstance(document, ops);// 建立一个PdfWriter对象
		document.open();
		float[] widths = { 52f, 52f, 52f, 52f, 52f, 20f, 20f, 20f, 20f, 20f, 20f, 20f, 20f, 20f, 20f };// 设置表格的列以及列宽

		for (ShareAD sad : list) {
			PdfPTable table = new PdfPTable(widths);// 建立一个pdf表格
			table.setSpacingBefore(20f);// 设置表格上面空白宽度
			table.setTotalWidth(460);// 设置表格的宽度
			table.setLockedWidth(true);// 设置表格的宽度固定
			table.getDefaultCell().setBorder(1);// 设置表格默认为无边框

			PdfPCell cell = PdfUtil.createCell("物业专项维修资金征缴通知书", headFont1, 0, 20, 15, PdfUtil.CENTER_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);// 增加单元格

			// 空行
			cell = PdfUtil.createCell("", headFont1, 0, 15, 15, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			// -------------

			cell = PdfUtil.createCell("地址", headFont2, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);

			cell = PdfUtil.createCell(sad.getLymc(), headFont3, 1, 20, 4, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);

			cell = PdfUtil.createCell("房屋编号", headFont2, 1, 20, 3, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);

			cell = PdfUtil.createCell(sad.getH001(), headFont3, 1, 20, 7, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);

			// ----------------------
			cell = PdfUtil.createCell("业主姓名", headFont2, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(sad.getH013(), headFont3, 1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);

			cell = PdfUtil.createCell("分摊金额", headFont2, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(sad.getFtje().toString() + "元", headFont3, 1, 20, 1, PdfUtil.CENTER_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);

			cell = PdfUtil.createCell("业主余额", headFont2, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(sad.getH030() + "元", headFont3, 1, 20, 3, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);

			cell = PdfUtil.createCell("征缴日期", headFont2, 1, 20, 3, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);

			cell = PdfUtil.createCell(sad.getZ003(), headFont3, 1, 20, 4, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);

			// ----------------------
			float[] ifloat = { 52f };
			PdfPTable itable = new PdfPTable(ifloat);
			cell = PdfUtil.createCell("征缴金额", headFont2, 1, 20, 1, PdfUtil.CENTER_H, Element.ALIGN_BOTTOM);
			cell.setBorder(1);
			cell.setBorderWidthBottom(0);
			itable.addCell(cell);

			cell = PdfUtil.createCell("（大写）", headFont2, 1, 20, 1, PdfUtil.CENTER_H, Element.ALIGN_TOP);
			cell.setBorder(1);
			cell.setBorderWidthTop(0);
			itable.addCell(cell);

			cell = new PdfPCell(itable);
			cell.setFixedHeight(40);
			cell.setColspan(1);
			table.addCell(cell);

			// cell =
			// PdfUtil.createCell(ChangeRMB.doChangeRMB(df.format(applyDraw.getPzje())),
			// headFont2, 1, 40, 2, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			cell = PdfUtil.createCell(ChangeRMB.doChangeRMB(df.format(sad.getZcje())), headFont2, 1, 40, 4,
					PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);

			float[] temp_float = { 20f, 20f, 20f, 20f, 20f, 20f, 20f, 20f, 20f, 20f };
			PdfPTable temp_itable = new PdfPTable(temp_float);
			table.getDefaultCell().setBorder(1);// 设置表格默认为无边框

			String[] str = { "千", "佰", "十", "万", "千", "佰", "十", "元", "角", "分" };
			for (int i = 0; i < str.length; i++) {
				cell = PdfUtil.createCell(str[i], headFont2, 20);
				temp_itable.addCell(cell);
			}
			// bcsqje
			// String[] sqje = PdfUtil.convert(df.format(applyDraw.getSqje()));
			String[] zcje = PdfUtil.convert(df.format(sad.getZcje()));
			for (int i = 0; i < str.length; i++) {
				cell = PdfUtil.createCell(zcje[i], headFont3, 20);
				temp_itable.addCell(cell);
			}

			cell = new PdfPCell(temp_itable);
			cell.setFixedHeight(40);
			cell.setColspan(10);
			table.addCell(cell);
			// ----------------------
			cell = PdfUtil.createCell("支取原因", headFont2, 1, 40, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			String z002 = "";
			z002 = sad.getZ002();
			if (sad.getZ002().length() > 59) {
				z002 = sad.getZ002().substring(0, 58) + "……";
			}
			cell = PdfUtil.createCell(z002, headFont3, 1, 40, 4, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);

			cell = PdfUtil.createCell("主管单位", headFont2, 1, 40, 3, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell("", headFont3, 1, 40, 7, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);

			document.add(table);
			document.newPage();
		}
		document.close();

		if (ops != null) {
			output(ops);
		}
	}
}

package com.yaltec.wxzj2.biz.propertymanager.entity;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.Date;
import java.util.List;

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
import com.yaltec.comon.core.entity.Entity;
import com.yaltec.comon.utils.DateUtil;
import com.yaltec.comon.utils.PdfUtil;
import com.yaltec.wxzj2.biz.property.entity.House;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 产权变更打印实体类
 * @author hqx
 *
 */
public class ChangePropertyPDF extends Entity{
	/**
	 * 序列化版本标示.
	 */
	private static final long serialVersionUID = 1L;
	private BaseFont bfChinese;
	private Font headFont1;
	private Font headFont2;
	private Font headFont3;

	static Logger logger = LoggerFactory.getLogger(ChangePropertyPDF.class);

	public void init() throws DocumentException, IOException {
		bfChinese = BaseFont.createFont("STSong-Light", "UniGB-UCS2-H", BaseFont.NOT_EMBEDDED);// 设置中文字体
		headFont1 = new Font(bfChinese, 16, Font.BOLD);// 设置字体大小
		headFont2 = new Font(bfChinese, 12, Font.NORMAL);// 设置字体大小
		headFont3 = new Font(bfChinese, 10, Font.NORMAL);// 设置字体大小
	}

	public ByteArrayOutputStream creatPDF(House house, String O013, String N013, String O015, String N015,
			String title, String dw) throws Exception {
		init();
		Document document = new Document();// 建立一个Document对象
		document.setPageSize(PageSize.A4);// 设置页面大小,为A4纸

		ByteArrayOutputStream ops = new ByteArrayOutputStream();// 输出到客户段的流

		PdfWriter.getInstance(document, ops);// 建立一个PdfWriter对象
		document.open();
		float[] widths = { 75f, 155f, 75f, 155f };// 设置表格的列以及列宽
		PdfPTable table = new PdfPTable(widths);// 建立一个pdf表格

		table.setSpacingBefore(20f);// 设置表格上面空白宽度
		table.setTotalWidth(460);// 设置表格的宽度
		table.setLockedWidth(true);// 设置表格的宽度固定
		table.getDefaultCell().setBorder(1);// 设置表格默认为无边框

		// 第一个
		PdfPCell cell = PdfUtil.createCell(title + "物业专项维修资金转移证明", headFont1, 0, 20, 4, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);// 增加单元格

		// 空行
		cell = PdfUtil.createCell("", headFont1, 0, 20, 4, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		// -------------
		cell = PdfUtil.createCell("现 产 权 人", headFont2, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(N013, headFont3, 1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		cell = PdfUtil.createCell("原 产 权 人", headFont2, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(O013, headFont3, 1, 25, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		// -------------
		cell = PdfUtil.createCell("现身份证号", headFont2, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(N015, headFont3, 1, 25, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		cell = PdfUtil.createCell("原身份证号", headFont2, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(O015, headFont3, 1, 25, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		// -------------
		cell = PdfUtil.createCell("房屋编号", headFont2, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(house.getH001(), headFont3, 1, 25, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		cell = PdfUtil.createCell("小          区", headFont2, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(house.getXqmc(), headFont3, 1, 25, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		// -------------
		cell = PdfUtil.createCell("房屋地址", headFont2, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(house.getLymc() + "      " + house.getH002() + "单元" + house.getH003() + "层"
				+ house.getH005() + "号", headFont3, 1, 25, 3, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		// -------------
		cell = PdfUtil.createCell("业主余额", headFont2, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("￥" + house.getH030() + " 元", headFont3, 1, 25, 3, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		// -------------------
		float[] tfloat = { 460f };
		PdfPTable itable = new PdfPTable(tfloat);
		cell = PdfUtil.createCell("     现已将原产权人物业专项维修资金余额悉数转至现产权人名下", headFont2, 1, 25, 1, PdfUtil.LEFT_H,
				PdfUtil.TOP_V);
		cell.setBorder(1);
		cell.setBorderWidthBottom(0);
		cell.setBorderWidthTop(0);
		itable.addCell(cell);

		cell = PdfUtil.createCell(
				"                                                                    " + dw
						+ "（盖章）", headFont2, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		cell.setBorder(1);
		cell.setBorderWidthTop(0);
		itable.addCell(cell);

		cell = new PdfPCell(itable);
		cell.setFixedHeight(50);
		cell.setColspan(4);
		table.addCell(cell);
		// -------------
		cell = PdfUtil.createCell("业主签字：", headFont2, 0, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("经办人：      ", headFont2, 0, 20, 1, PdfUtil.RIGHT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		cell = PdfUtil.createCell("", headFont2, 0, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("交存日期", headFont2, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		cell = PdfUtil.createCell("打印日期：" + DateUtil.getDate(new Date()).substring(0, 10), headFont2, 0, 20, 1,
				PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		// 空格

		// 空行
		cell = PdfUtil.createCell("", headFont1, 0, 20, 4, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		// 空行
		cell = PdfUtil.createCell("", headFont1, 0, 20, 4, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		// 空行
		cell = PdfUtil.createCell("", headFont1, 0, 20, 4, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		// 空行
		cell = PdfUtil.createCell("", headFont1, 0, 20, 4, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		// 第二个
		cell = PdfUtil.createCell(title + "物业专项维修资金转移证明", headFont1, 0, 20, 4, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);// 增加单元格

		// 空行
		cell = PdfUtil.createCell("", headFont1, 0, 20, 4, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		// -------------
		cell = PdfUtil.createCell("现 产 权 人", headFont2, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(N013, headFont3, 1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		cell = PdfUtil.createCell("原 产 权 人", headFont2, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(O013, headFont3, 1, 25, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		// -------------
		cell = PdfUtil.createCell("现身份证号", headFont2, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(N015, headFont3, 1, 25, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		cell = PdfUtil.createCell("原身份证号", headFont2, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(O015, headFont3, 1, 25, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		// -------------
		cell = PdfUtil.createCell("房屋编号", headFont2, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(house.getH001(), headFont3, 1, 25, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		cell = PdfUtil.createCell("小          区", headFont2, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(house.getXqmc(), headFont3, 1, 25, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		// -------------
		cell = PdfUtil.createCell("房屋地址", headFont2, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(house.getLymc() + "      " + house.getH002() + "单元" + house.getH003() + "层"
				+ house.getH005() + "号", headFont3, 1, 25, 3, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		// -------------
		cell = PdfUtil.createCell("业主余额", headFont2, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("￥" + house.getH030() + " 元", headFont3, 1, 25,3, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		// -------------------
		// float[] tfloat = { 460f };
		// PdfPTable itable = new PdfPTable(tfloat);
		cell = PdfUtil.createCell("     现已将原产权人物业专项维修资金余额悉数转至现产权人名下", headFont2, 1, 25, 1, PdfUtil.LEFT_H,
				PdfUtil.TOP_V);
		cell.setBorder(1);
		cell.setBorderWidthBottom(0);
		cell.setBorderWidthTop(0);
		itable.addCell(cell);

		cell = PdfUtil.createCell(
				"                                                                    " + dw
						+ "（盖章）", headFont2, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		cell.setBorder(1);
		cell.setBorderWidthTop(0);
		itable.addCell(cell);

		cell = new PdfPCell(itable);
		cell.setFixedHeight(50);
		cell.setColspan(4);
		table.addCell(cell);
		// -------------
		cell = PdfUtil.createCell("业主签字：", headFont2, 0, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("经办人：      ", headFont2, 0, 20, 1, PdfUtil.RIGHT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		cell = PdfUtil.createCell("", headFont2, 0, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("打印日期：" + DateUtil.getDate(new Date()).substring(0, 10), headFont2, 0, 20, 1,
				PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		document.add(table);
		document.close();

		return ops;
	}

	public ByteArrayOutputStream creatPDF2(List<ChangeProperty> list, String title, String dw) throws Exception {
		init();
		Document document = new Document();// 建立一个Document对象
		document.setPageSize(PageSize.A4);// 设置页面大小,为A4纸

		ByteArrayOutputStream ops = new ByteArrayOutputStream();// 输出到客户段的流

		PdfWriter.getInstance(document, ops);// 建立一个PdfWriter对象
		document.open();
		float[] widths = { 75f, 155f, 75f, 155f };// 设置表格的列以及列宽

		for (ChangeProperty c : list) {

			PdfPTable table = new PdfPTable(widths);// 建立一个pdf表格

			table.setSpacingBefore(20f);// 设置表格上面空白宽度
			table.setTotalWidth(460);// 设置表格的宽度
			table.setLockedWidth(true);// 设置表格的宽度固定
			table.getDefaultCell().setBorder(1);// 设置表格默认为无边框

			// 第一个
			PdfPCell cell = PdfUtil.createCell(title + "物业专项维修资金转移证明", headFont1, 0, 20, 4, PdfUtil.CENTER_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);// 增加单元格

			// 空行
			cell = PdfUtil.createCell("", headFont1, 0, 20, 4, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			// -------------
			cell = PdfUtil.createCell("现 产 权 人", headFont2, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(c.getN013(), headFont3, 1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);

			cell = PdfUtil.createCell("原 产 权 人", headFont2, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(c.getO013(), headFont3, 1, 25, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			// -------------
			cell = PdfUtil.createCell("现身份证号", headFont2, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(c.getN015(), headFont3, 1, 25, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);

			cell = PdfUtil.createCell("原身份证号", headFont2, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(c.getO015(), headFont3, 1, 25, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			// -------------
			cell = PdfUtil.createCell("房屋编号", headFont2, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(c.getH001(), headFont3, 1, 25, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);

			cell = PdfUtil.createCell("小          区", headFont2, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(c.getXqmc(), headFont3, 1, 25, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			// -------------
			cell = PdfUtil.createCell("房屋地址", headFont2, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(c.getLymc() + "      " + c.getH002() + "单元" + c.getH003() + "层" + c.getH005()
					+ "号", headFont3, 1, 25, 3, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			// -------------

			if (!DataHolder.customerInfo.isJLP()) {
				cell = PdfUtil.createCell("业主余额", headFont2, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
				table.addCell(cell);
				cell = PdfUtil.createCell("￥" + c.getH030() + " 元", headFont3, 1, 25, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
				table.addCell(cell);
				cell = PdfUtil.createCell("合计余额", headFont2, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
				table.addCell(cell);
				cell = PdfUtil.createCell("￥" + c.getH030() + " 元", headFont3, 1, 25, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
				table.addCell(cell);
			} else {
				// 九龙坡不显示合计余额
				cell = PdfUtil.createCell("业主余额", headFont2, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
				table.addCell(cell);
				cell = PdfUtil.createCell("￥" + c.getH030() + " 元", headFont3, 1, 25, 3, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
				table.addCell(cell);
			}
			// -------------------
			float[] tfloat = { 460f };
			PdfPTable itable = new PdfPTable(tfloat);
			cell = PdfUtil.createCell("     现已将原产权人物业专项维修资金余额悉数转至现产权人名下", headFont2, 1, 25, 1, PdfUtil.LEFT_H,
					PdfUtil.TOP_V);
			cell.setBorder(1);
			cell.setBorderWidthBottom(0);
			cell.setBorderWidthTop(0);
			itable.addCell(cell);

			if (DataHolder.customerInfo.isJLP()) {
				dw = "                                                                    重庆市九龙坡区物业专项维修资金管理中心";
			} else {
				dw = "                                                                                          " + dw;
			}
			cell = PdfUtil.createCell(dw+ "（盖章）", headFont2, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			cell.setBorder(1);
			cell.setBorderWidthTop(0);
			itable.addCell(cell);

			cell = new PdfPCell(itable);
			cell.setFixedHeight(50);
			cell.setColspan(4);
			table.addCell(cell);
			// -------------
			cell = PdfUtil.createCell("业主签字：", headFont2, 0, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell("经办人：      ", headFont2, 0, 20, 1, PdfUtil.RIGHT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);

			cell = PdfUtil.createCell("", headFont2, 0, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell("打印日期：" + DateUtil.getDate(new Date()).substring(0, 10), headFont2, 0, 20, 1,
					PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);

			// 空格

			// 空行
			cell = PdfUtil.createCell("", headFont1, 0, 20, 4, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			// 空行
			cell = PdfUtil.createCell("", headFont1, 0, 20, 4, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			// 空行
			cell = PdfUtil.createCell("", headFont1, 0, 20, 4, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			// 空行
			cell = PdfUtil.createCell("", headFont1, 0, 20, 4, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);

			// 第二个
			cell = PdfUtil.createCell(title + "物业专项维修资金转移证明", headFont1, 0, 20, 4, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);// 增加单元格

			// 空行
			cell = PdfUtil.createCell("", headFont1, 0, 20, 4, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			// -------------
			cell = PdfUtil.createCell("现 产 权 人", headFont2, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(c.getN013(), headFont3, 1, 20, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);

			cell = PdfUtil.createCell("原 产 权 人", headFont2, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(c.getO013(), headFont3, 1, 25, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			// -------------
			cell = PdfUtil.createCell("现身份证号", headFont2, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(c.getN015(), headFont3, 1, 25, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);

			cell = PdfUtil.createCell("原身份证号", headFont2, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(c.getO015(), headFont3, 1, 25, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			// -------------
			cell = PdfUtil.createCell("房屋编号", headFont2, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(c.getH001(), headFont3, 1, 25, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);

			cell = PdfUtil.createCell("小          区", headFont2, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(c.getXqmc(), headFont3, 1, 25, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			// -------------
			cell = PdfUtil.createCell("房屋地址", headFont2, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(c.getLymc() + "      " + c.getH002() + "单元" + c.getH003() + "层" + c.getH005()
					+ "号", headFont3, 1, 25, 3, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			// -------------
			if (!DataHolder.customerInfo.isJLP()) {
				cell = PdfUtil.createCell("业主余额", headFont2, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
				table.addCell(cell);
				cell = PdfUtil.createCell("￥" + c.getH030() + " 元", headFont3, 1, 25, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
				table.addCell(cell);
				cell = PdfUtil.createCell("合计余额", headFont2, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
				table.addCell(cell);
				cell = PdfUtil.createCell("￥" + c.getH030() + " 元", headFont3, 1, 25, 1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
				table.addCell(cell);
			} else {
				// 九龙坡不显示合计余额
				cell = PdfUtil.createCell("业主余额", headFont2, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
				table.addCell(cell);
				cell = PdfUtil.createCell("￥" + c.getH030() + " 元", headFont3, 1, 25, 3, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
				table.addCell(cell);
			}
			
			// -------------------
			// float[] tfloat = { 460f };
			// PdfPTable itable = new PdfPTable(tfloat);
			cell = PdfUtil.createCell("     现已将原产权人物业专项维修资金余额悉数转至现产权人名下", headFont2, 1, 25, 1, PdfUtil.LEFT_H,
					PdfUtil.TOP_V);
			cell.setBorder(1);
			cell.setBorderWidthBottom(0);
			cell.setBorderWidthTop(0);
			itable.addCell(cell);

			cell = PdfUtil.createCell(dw + "（盖章）", headFont2, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			cell.setBorder(1);
			cell.setBorderWidthTop(0);
			itable.addCell(cell);

			cell = new PdfPCell(itable);
			cell.setFixedHeight(50);
			cell.setColspan(4);
			table.addCell(cell);
			// -------------
			cell = PdfUtil.createCell("业主签字：", headFont2, 0, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell("经办人：      ", headFont2, 0, 20, 1, PdfUtil.RIGHT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);

			cell = PdfUtil.createCell("", headFont2, 0, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell("打印日期：" + DateUtil.getDate(new Date()).substring(0, 10), headFont2, 0, 20, 1,
					PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);

			document.add(table);
			document.newPage(); // 强制换页
		}
		document.close();

		return ops;
	}
}

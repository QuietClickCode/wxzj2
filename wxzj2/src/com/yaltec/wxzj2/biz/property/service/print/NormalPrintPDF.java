package com.yaltec.wxzj2.biz.property.service.print;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.lang.reflect.Method;
import java.text.DecimalFormat;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.lowagie.text.Document;
import com.lowagie.text.DocumentException;
import com.lowagie.text.Font;
import com.lowagie.text.PageSize;
import com.lowagie.text.Rectangle;
import com.lowagie.text.pdf.BaseFont;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;
import com.yaltec.comon.utils.PdfUtil;


public class NormalPrintPDF {
	private static BaseFont bfChinese;
	private static Font headFont1;
	private static Font headFont2;
	private static Font headFont3;
	private static Font headFont4;
	private static DecimalFormat df = new DecimalFormat("0.00"); // 保留2位小数

	static Logger logger = LoggerFactory.getLogger(NormalPrintPDF.class);

	public static void init() throws DocumentException, IOException {
		bfChinese = BaseFont.createFont("STSong-Light", "UniGB-UCS2-H",
				BaseFont.NOT_EMBEDDED);// 设置中文字体
		headFont1 = new Font(bfChinese, 20, Font.NORMAL);// 设置字体大小
		headFont2 = new Font(bfChinese, 12, Font.NORMAL);// 设置字体大小
		headFont3 = new Font(bfChinese, 10, Font.NORMAL);// 设置字体大小
		headFont4 = new Font(bfChinese, 16, Font.BOLD);// 设置字体大小
	}

	public ByteArrayOutputStream creatPDF(Object object,Map info, List list0,
					String[] title, String[] propertys,float[] widths, String fileName)
			throws Exception {
		init();
		Document document = new Document();// 建立一个Document对象
		document.setPageSize(PageSize.A4);// 设置页面大小,为A4纸
		Rectangle pageSize = new Rectangle(PageSize.A4);// 设置页面大小,为A4纸
		document.setPageSize(pageSize.rotate());// 横打
		
		ByteArrayOutputStream ops = new ByteArrayOutputStream();// 输出到客户段的流
		//OutputStream out = new FileOutputStream(new File("e:/a.pdf"));
		
		PdfWriter.getInstance(document, ops);// 建立一个PdfWriter对象
		document.open();
		int len = propertys.length;
	
		PdfPTable table = new PdfPTable(widths);// 建立一个pdf表格
		
		table.setSpacingBefore(20f);// 设置表格上面空白宽度
		table.setTotalWidth(754);// 设置表格的宽度
		table.setLockedWidth(true);// 设置表格的宽度固定
		table.getDefaultCell().setBorder(1);// 设置表格默认为无边框
		
		PdfPCell cell = PdfUtil.createCell(fileName, headFont1, 0,
				55, widths.length, PdfUtil.CENTER_H, PdfUtil.BOTTOM_V);
		table.addCell(cell);// 增加单元格
		
		// 空行
		cell = PdfUtil.createCell("xzdgfasdgasdgv", headFont1, 0, 20, widths.length, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		int w1 = widths.length/2;
		int w2 = widths.length - w1;
		// info
		cell = PdfUtil.createCell(info.get("left").toString(), headFont3, 0, 20, w1, PdfUtil.LEFT_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(info.get("right").toString(), headFont3, 0, 20, w2, PdfUtil.RIGHT_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		
		
		Method[] methods = new Method[len];
		for (int i = 0; i < len; i++) {
			cell = PdfUtil.createCell(title[i], headFont3, 1, 20, 1, PdfUtil.CENTER_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);
			
			methods[i] = object.getClass().getMethod(
					"get" + propertys[i].substring(0, 1).toUpperCase()
					+ propertys[i].substring(1), null);
		}
		
		for (int rowId = 0; rowId < list0.size(); rowId++) {
			// 得到对应行的数据列表
			Object exportobject = list0.get(rowId);
			// 循环每一个单元格
			for (int column = 0; column < len; column++) {
				String propertyString = null;
				Object propertyObject = methods[column].invoke(
						exportobject, null);
				if (propertyObject == null) {
					propertyString = "";
				} else {
					propertyString = propertyObject.toString();
				}
				cell = PdfUtil.createCell(propertyString, headFont3, 1, 20, 1, PdfUtil.CENTER_H,
						PdfUtil.MIDDLE_V);
				table.addCell(cell);
			}
		}
		// -------------
		
	
		// -------------
		document.add(table);
		
		document.close();
		return ops;
	}
}

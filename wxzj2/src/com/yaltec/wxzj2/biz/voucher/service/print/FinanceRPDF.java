package com.yaltec.wxzj2.biz.voucher.service.print;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.lang.reflect.Method;
import java.text.DecimalFormat;
import java.util.ArrayList;
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
//import com.yaltec.wxzj.dto.FinanceR;
//import com.yaltec.wxzj.printpdf.logic_pdf.FinanceRPDF;
//import com.yaltec.wxzj.util.PdfUtil;
import com.yaltec.comon.utils.PdfUtil;
import com.yaltec.wxzj2.biz.voucher.entity.FinanceR;

public class FinanceRPDF {
	private static BaseFont bfChinese;
	private static Font headFont1;
	private static Font headFont2;
	private static Font headFont3;
	private static Font headFont4;
	private static DecimalFormat df = new DecimalFormat("0.00"); // 保留2位小数

	static Logger logger = LoggerFactory.getLogger(FinanceRPDF.class);

	public static void init() throws DocumentException, IOException {
		bfChinese = BaseFont.createFont("STSong-Light", "UniGB-UCS2-H",
				BaseFont.NOT_EMBEDDED);// 设置中文字体
		headFont1 = new Font(bfChinese, 20, Font.NORMAL);// 设置字体大小
		headFont2 = new Font(bfChinese, 12, Font.NORMAL);// 设置字体大小
		headFont3 = new Font(bfChinese, 10, Font.NORMAL);// 设置字体大小
		headFont4 = new Font(bfChinese, 16, Font.BOLD);// 设置字体大小
	}
	
	public ByteArrayOutputStream creatPDF(Map<String, String> map,FinanceR object,ArrayList<FinanceR> list1,ArrayList<FinanceR> list2,
					String[] title, String[] propertys,float[] widths,String fileName)
			throws Exception {
		init();
		Document document = new Document();// 建立一个Document对象
		document.setPageSize(PageSize.A4);// 设置页面大小,为A4纸
		Rectangle pageSize = new Rectangle(PageSize.A4);// 设置页面大小,为A4纸
		document.setPageSize(pageSize.rotate());// 横打
		
		ByteArrayOutputStream ops = new ByteArrayOutputStream();// 输出到客户段的流
		
		PdfWriter.getInstance(document, ops);// 建立一个PdfWriter对象
		document.open();
		int len = propertys.length;
		int len2 = title.length;

		PdfPTable table = new PdfPTable(widths);// 建立一个pdf表格
		
		table.setSpacingBefore(20f);// 设置表格上面空白宽度
		table.setTotalWidth(754);// 设置表格的宽度
		table.setLockedWidth(true);// 设置表格的宽度固定
		table.getDefaultCell().setBorder(1);// 设置表格默认为无边框

		PdfPCell cell = PdfUtil.createCell(map.get("bankmc").toString()+"： "+map.get("begindate").toString()+"~"+map.get("enddate").toString()+
				"  "+(map.get("flag").toString().equals("0") ? "未" : "已") +"核对财务对账单", headFont2, 0, 30, 11, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		
		/*PdfPCell cell = PdfUtil.createCell(fileName, headFont1, 0,
				55, 11, PdfUtil.CENTER_H, PdfUtil.BOTTOM_V);
		table.addCell(cell);// 增加单元格
		
		// 空行
		cell = PdfUtil.createCell("", headFont1, 0, 20, 6, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("", headFont1, 0, 20, 5,
				PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);*/
		Method[] methods = new Method[len];
		for (int i = 0; i < len; i++) {
			methods[i] = object.getClass().getMethod(
					"get" + propertys[i].substring(0, 1).toUpperCase()
					+ propertys[i].substring(1), null);
		}
		
		cell = PdfUtil.createCell("单位日记账", headFont2, 0, 30, 5, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("", headFont2, 0, 30, 1, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("银行对账单", headFont2, 0, 30, 5, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		for (int i = 0; i < len2; i++) {
			cell = PdfUtil.createCell(title[i], headFont3, 1, 20, 1, PdfUtil.CENTER_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);
		}
		//单位日记账
		int count1 = 0;
		double sum1 = 0;
		//银行对账单
		int count2 = 0;
		double sum2 = 0;
		DecimalFormat df = new DecimalFormat("######0.00");   

		for (int rowId = 0; rowId < list1.size(); rowId++) {
			// 得到对应行的数据列表
			Object exportobject = list1.get(rowId);
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

			cell = PdfUtil.createCell("", headFont3, 1, 20, 1, PdfUtil.CENTER_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);

			count1 ++;
			sum1 = sum1+Double.valueOf(((FinanceR)exportobject).getP009());
			
			Object exportobject2;
			try {
				exportobject2 = list2.get(rowId);
				// 循环每一个单元格
				for (int column = 0; column < len; column++) {
					String propertyString = null;
					Object propertyObject = methods[column].invoke(
							exportobject2, null);
					if (propertyObject == null) {
						propertyString = "";
					} else {
						propertyString = propertyObject.toString();
					}
					cell = PdfUtil.createCell(propertyString, headFont3, 1, 20, 1, PdfUtil.CENTER_H,
							PdfUtil.MIDDLE_V);
					table.addCell(cell);
				}
				count2 ++;
				sum2 = sum2+Double.valueOf(((FinanceR)exportobject2).getP009());
			} catch (IndexOutOfBoundsException e) {

				// 循环每一个单元格
				for (int column = 0; column < len; column++) {
					
					cell = PdfUtil.createCell("", headFont3, 1, 20, 1, PdfUtil.CENTER_H,
							PdfUtil.MIDDLE_V);
					table.addCell(cell);
				}
			}
		}

		cell = PdfUtil.createCell( "单位日记账共有："+count1+" 条记录，总额为："+df.format(sum1)+" 元" , headFont2, 1, 30, 5, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("", headFont2, 1, 30, 1, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("银行对账单共有："+count2+" 条记录，总额为："+df.format(sum2)+" 元", headFont2, 1, 30, 5, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		
		document.add(table);
		
		document.close();
		return ops;
	}
}

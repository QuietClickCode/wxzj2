package com.yaltec.wxzj2.biz.compositeQuery.service.export;

import java.io.IOException;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.util.CellRangeAddress;

import com.yaltec.comon.utils.StringUtil;
import com.yaltec.wxzj2.biz.compositeQuery.entity.MonthReportOfBank;

/**
 * 
 * @ClassName: MonthReportOfBankExport
 * @Description: 导出银行统计月报信息
 * 
 * @author yangshanping
 * @date 2016-9-24 下午03:26:48
 */
public class MonthReportOfBankExport {
	private static OutputStream setStream(String filename,
			HttpServletResponse response) throws IOException {
		OutputStream os = null;
		try {
			os = response.getOutputStream(); // 取得输出流
			response.reset(); // 清空输出流
			response.setHeader("Content-disposition", "filename="
					+ URLEncoder.encode(filename, "UTF-8") + ".xls"); // 设定输出文件头
			response.setContentType("application/excel"); // 可以在浏览器中打，定义输出类型
		} catch (IOException e) {
			e.printStackTrace();
		}
		return os;
	}
	
	// 导出银行统计月报信息
	public static void exportReportOfBank(List<MonthReportOfBank> list,
			HttpServletResponse response) throws IOException {
		OutputStream os = setStream("按银行统计月报信息", response);
		// 第一步，创建一个webbook，对应一个Excel文件
		HSSFWorkbook wb = new HSSFWorkbook();
		// 第二步，在webbook中添加一个sheet,对应Excel文件中的sheet
		HSSFSheet sheet = wb.createSheet("按银行统计月报信息");
		// 第三步，在sheet中添加表头第0行,注意老版本poi对Excel的行数列数有限制short
		// 设置行宽
		sheet.setColumnWidth(0, 15 * 256);
		sheet.setColumnWidth(1, 15 * 256);
		sheet.setColumnWidth(3, 10 * 256);
		sheet.setColumnWidth(5, 10 * 256);
		sheet.setColumnWidth(10, 15 * 256);
		// 第一行
		HSSFRow row = sheet.createRow((int) 0);
		// 第四步，创建单元格，并设置值表头 设置表头居中
		HSSFFont titleFont = wb.createFont();// 字体
		titleFont.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
		titleFont.setFontHeightInPoints((short) 10);

		// 创建样式1：字体加粗、居中，单元格背景色为灰色
		HSSFCellStyle style = wb.createCellStyle();
		style.setAlignment(HSSFCellStyle.ALIGN_CENTER); // 创建一个居中格式
		style.setFont(titleFont);
		
		style.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());// 设置背景色
		style.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
		// 设置边框
		style.setBorderBottom(HSSFCellStyle.BORDER_THIN); //下边框
		style.setBorderLeft(HSSFCellStyle.BORDER_THIN);//左边框
		style.setBorderTop(HSSFCellStyle.BORDER_THIN);//上边框
		style.setBorderRight(HSSFCellStyle.BORDER_THIN);//右边框
		
		// 创建样式2：字体居中，单元格无背景色
		HSSFCellStyle style1 = (HSSFCellStyle) wb.createCellStyle();
		style1.setAlignment(HSSFCellStyle.ALIGN_CENTER); // 创建一个居中格式
		style1.setWrapText(true);// 自动换行
		style1.setBorderBottom(HSSFCellStyle.BORDER_THIN); //下边框
		style1.setBorderLeft(HSSFCellStyle.BORDER_THIN);//左边框
		style1.setBorderTop(HSSFCellStyle.BORDER_THIN);//上边框
		style1.setBorderRight(HSSFCellStyle.BORDER_THIN);//右边框
		
		
		HSSFCell cell = row.createCell(0);
		cell.setCellStyle(style1);
		cell.setCellValue("按银行统计月报信息");
		sheet.addMergedRegion(CellRangeAddress.valueOf("$A$1:$L$1"));
		cell = row.createCell(1);
		cell.setCellStyle(style1);
		cell = row.createCell(2);
		cell.setCellStyle(style1);
		cell = row.createCell(3);
		cell.setCellStyle(style1);
		cell = row.createCell(4);
		cell.setCellStyle(style1);
		cell = row.createCell(5);
		cell.setCellStyle(style1);
		cell = row.createCell(6);
		cell.setCellStyle(style1);
		cell = row.createCell(7);
		cell.setCellStyle(style1);
		cell = row.createCell(8);
		cell.setCellStyle(style1);
		cell = row.createCell(9);
		cell.setCellStyle(style1);
		cell = row.createCell(10);
		cell.setCellStyle(style1);
		cell = row.createCell(11);
		cell.setCellStyle(style1);
		
		// 第二行
		row = sheet.createRow((int) 1);

		cell = row.createCell(0);
		cell.setCellValue("银行编号");
		cell.setCellStyle(style);

		cell = row.createCell(1);
		cell.setCellValue("项目名称");
		cell.setCellStyle(style);

		cell = row.createCell(2);
		cell.setCellValue("本期户数");
		cell.setCellStyle(style);

		cell = row.createCell(3);
		cell.setCellValue("增加本金");
		cell.setCellStyle(style);

		cell = row.createCell(4);
		cell.setCellValue("增加利息");
		cell.setCellStyle(style);

		cell = row.createCell(5);
		cell.setCellValue("户数");
		cell.setCellStyle(style);

		cell = row.createCell(6);
		cell.setCellValue("减少金额");
		cell.setCellStyle(style);

		cell = row.createCell(7);
		cell.setCellValue("累计户数");
		cell.setCellStyle(style);

		cell = row.createCell(8);
		cell.setCellValue("累计本金");
		cell.setCellStyle(style);
		
		cell = row.createCell(9);
		cell.setCellValue("累计利息");
		cell.setCellStyle(style);

		cell = row.createCell(10);
		cell.setCellValue("累计金额");
		cell.setCellStyle(style);

		cell = row.createCell(11);
		cell.setCellValue("有效发票");
		cell.setCellStyle(style);

		// 第五步，写入实体数据 实际应用中这些数据从数据库得到
		for (int i = 0; i < list.size(); i++) {
			row = sheet.createRow((int) i + 2);
			MonthReportOfBank ad = (MonthReportOfBank) list.get(i);
			
			// 第四步，创建单元格，并设置值
			cell=row.createCell(0);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getYhbh()));
			
			cell=row.createCell(1);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getXqmc()));
			
			cell=row.createCell(2);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getByhs()));
			
			cell=row.createCell(3);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getZjje()));
			
			cell=row.createCell(4);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getZjlx()));
			
			cell=row.createCell(5);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getJshs()));
			
			cell=row.createCell(6);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getJsje()));
			
			cell=row.createCell(7);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getBqhs()));
			
			cell=row.createCell(8);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getBjye()));
			
			cell=row.createCell(9);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getLxye()));
			
			cell=row.createCell(10);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getBqje()));
			
			cell=row.createCell(11);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getYxfp()));
			
		}
		// 第六步，将文件存到指定位置
		try {

			wb.write(os);
			os.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}

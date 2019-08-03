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
import com.yaltec.wxzj2.biz.compositeQuery.entity.QueryUnitForB;

/**
 * 
 * @ClassName: QueryUnitForBExport
 * @Description: 单元余额的导出数据
 * 
 * @author moqian
 * @date 2016-10-21 下午14:50:54
 */
public class QueryUnitForBExport {
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
	
	// 导出单元余额信息
	public static void exportQueryUnitForB(List<QueryUnitForB> list,
			HttpServletResponse response) throws IOException {
		OutputStream os = setStream("单元余额信息", response);
		// 第一步，创建一个webbook，对应一个Excel文件
		HSSFWorkbook wb = new HSSFWorkbook();
		// 第二步，在webbook中添加一个sheet,对应Excel文件中的sheet
		HSSFSheet sheet = wb.createSheet("单元余额信息");
		// 第三步，在sheet中添加表头第0行,注意老版本poi对Excel的行数列数有限制short
		// 设置行宽
		sheet.setColumnWidth(0, 15 * 256);
		sheet.setColumnWidth(1, 20 * 256);
		sheet.setColumnWidth(2, 15 * 256);
		sheet.setColumnWidth(3, 15 * 256);
		sheet.setColumnWidth(4, 15 * 256);
		sheet.setColumnWidth(5, 15 * 256);
		sheet.setColumnWidth(6, 15 * 256);
		sheet.setColumnWidth(7, 15 * 256);
		sheet.setColumnWidth(8, 15 * 256);
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
		cell.setCellValue("单元余额信息");
		sheet.addMergedRegion(CellRangeAddress.valueOf("$A$1:$I$1"));
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
		
		// 第二行
		row = sheet.createRow((int) 1);

		cell = row.createCell(0);
		cell.setCellValue("楼宇编号");
		cell.setCellStyle(style);

		cell = row.createCell(1);
		cell.setCellValue("楼宇名称");
		cell.setCellStyle(style);

		cell = row.createCell(2);
		cell.setCellValue("单元名称");
		cell.setCellStyle(style);

		cell = row.createCell(3);
		cell.setCellValue("交款金额");
		cell.setCellStyle(style);

		cell = row.createCell(4);
		cell.setCellValue("支出金额");
		cell.setCellStyle(style);

		cell = row.createCell(5);
		cell.setCellValue("剩余本金");
		cell.setCellStyle(style);

		cell = row.createCell(6);
		cell.setCellValue("剩余利息");
		cell.setCellStyle(style);

		cell = row.createCell(7);
		cell.setCellValue("余额");
		cell.setCellStyle(style);

		cell = row.createCell(8);
		cell.setCellValue("截止日期");
		cell.setCellStyle(style);
		
		// 第五步，写入实体数据 实际应用中这些数据从数据库得到
		for (int i = 0; i < list.size(); i++) {
			row = sheet.createRow((int) i + 2);
			QueryUnitForB ad = (QueryUnitForB) list.get(i);
			
			// 第四步，创建单元格，并设置值
			cell=row.createCell(0);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getLybh()));
			
			cell=row.createCell(1);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getLymc()));
			
			cell=row.createCell(2);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getH002()));
			
			cell=row.createCell(3);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getJkje()));
			
			cell=row.createCell(4);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getZqje()));
			
			cell=row.createCell(5);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getBj()));
			
			cell=row.createCell(6);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getLx()));
			
			cell=row.createCell(7);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getYe()));
			
			cell=row.createCell(8);
			cell.setCellStyle(style1);
			if (ad.getMdate().length()>10) {
				String ads = ad.getMdate().substring(0,10);
				cell.setCellValue(StringUtil.valueOf(ads));
			} else {
				cell.setCellValue(StringUtil.valueOf(ad.getMdate()));
			}
			
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

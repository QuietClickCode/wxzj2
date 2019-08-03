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
import com.yaltec.wxzj2.biz.compositeQuery.entity.ByProjectBPS;
import com.yaltec.wxzj2.biz.property.entity.House;

/**
 * 
 * @ClassName: QueryArrearExport
 * @Description: 欠费催交数据导出
 * 
 * @author yangshanping
 * @date 2016-9-24 下午02:36:27
 */
public class QueryArrearExport {
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
	
	// 导出欠费催交信息
	public static void exportQueryArrear(List<House> list,
			HttpServletResponse response) throws IOException {
		OutputStream os = setStream("欠费催交信息", response);
		// 第一步，创建一个webbook，对应一个Excel文件
		HSSFWorkbook wb = new HSSFWorkbook();
		// 第二步，在webbook中添加一个sheet,对应Excel文件中的sheet
		HSSFSheet sheet = wb.createSheet("欠费催交信息");
		// 第三步，在sheet中添加表头第0行,注意老版本poi对Excel的行数列数有限制short
		// 设置行宽
		sheet.setColumnWidth(0, 15 * 256);
		sheet.setColumnWidth(1, 15 * 256);
		sheet.setColumnWidth(3, 10 * 256);
		sheet.setColumnWidth(5, 10 * 256);
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
		cell.setCellValue("欠费催交信息");
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
		
		// 第二行
		row = sheet.createRow((int) 1);

		cell = row.createCell(0);
		cell.setCellValue("房屋编号");
		cell.setCellStyle(style);

		cell = row.createCell(1);
		cell.setCellValue("所属楼宇");
		cell.setCellStyle(style);

		cell = row.createCell(2);
		cell.setCellValue("业主姓名");
		cell.setCellStyle(style);

		cell = row.createCell(3);
		cell.setCellValue("建筑面积");
		cell.setCellStyle(style);

		cell = row.createCell(4);
		cell.setCellValue("房款");
		cell.setCellStyle(style);

		cell = row.createCell(5);
		cell.setCellValue("交存标准");
		cell.setCellStyle(style);

		cell = row.createCell(6);
		cell.setCellValue("应交资金");
		cell.setCellStyle(style);

		cell = row.createCell(7);
		cell.setCellValue("可用本金");
		cell.setCellStyle(style);

		cell = row.createCell(8);
		cell.setCellValue("地址");
		cell.setCellStyle(style);

		// 第五步，写入实体数据 实际应用中这些数据从数据库得到
		for (int i = 0; i < list.size(); i++) {
			row = sheet.createRow((int) i + 2);
			House ad = (House) list.get(i);
			
			// 第四步，创建单元格，并设置值
			cell=row.createCell(0);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getH001()));
			
			cell=row.createCell(1);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getLymc()));
			
			cell=row.createCell(2);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getH013()));
			
			cell=row.createCell(3);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getH006()));
			
			cell=row.createCell(4);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getH010()));
			
			cell=row.createCell(5);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getH023()));
			
			cell=row.createCell(6);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getH021()));
			
			cell=row.createCell(7);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getH030()));
			
			cell=row.createCell(8);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getAddress()));
			
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

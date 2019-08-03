package com.yaltec.wxzj2.biz.draw.service.export;

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
import com.yaltec.wxzj2.biz.draw.entity.QueryAL;
import com.yaltec.wxzj2.biz.draw.entity.QueryAL1;

/**
 * 
 * @ClassName: QueryalExport
 * @Description: 销户查询数据导出
 * 
 * @author yangshanping
 * @date 2016-10-9 上午11:09:14
 */
public class QueryalExport {
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
	
	// 导出模糊查询销户信息
	public static void exportQueryal(List<QueryAL> list,
			HttpServletResponse response) throws IOException {
		OutputStream os = setStream("销户信息", response);
		// 第一步，创建一个webbook，对应一个Excel文件
		HSSFWorkbook wb = new HSSFWorkbook();
		// 第二步，在webbook中添加一个sheet,对应Excel文件中的sheet
		HSSFSheet sheet = wb.createSheet("销户信息");
		// 第三步，在sheet中添加表头第0行,注意老版本poi对Excel的行数列数有限制short
		// 设置行宽
		sheet.setColumnWidth(0, 20 * 256);
		sheet.setColumnWidth(1, 20 * 256);
		sheet.setColumnWidth(2, 20 * 256);
		sheet.setColumnWidth(4, 15 * 256);
		sheet.setColumnWidth(8, 20 * 256);
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
		cell.setCellValue("销户信息");
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
		cell.setCellValue("申请编号");
		cell.setCellStyle(style);

		cell = row.createCell(1);
		cell.setCellValue("小区名称");
		cell.setCellStyle(style);

		cell = row.createCell(2);
		cell.setCellValue("楼宇名称");
		cell.setCellStyle(style);

		cell = row.createCell(3);
		cell.setCellValue("经办人");
		cell.setCellStyle(style);

		cell = row.createCell(4);
		cell.setCellValue("申请日期");
		cell.setCellStyle(style);

		cell = row.createCell(5);
		cell.setCellValue("申请金额");
		cell.setCellStyle(style);

		cell = row.createCell(6);
		cell.setCellValue("受理状态");
		cell.setCellStyle(style);

		cell = row.createCell(7);
		cell.setCellValue("操作员");
		cell.setCellStyle(style);

		cell = row.createCell(8);
		cell.setCellValue("销户原因");
		cell.setCellStyle(style);
		
		// 第五步，写入实体数据 实际应用中这些数据从数据库得到
		for (int i = 0; i < list.size(); i++) {
			row = sheet.createRow((int) i + 2);
			QueryAL ad = (QueryAL) list.get(i);
			
			// 第四步，创建单元格，并设置值
			cell=row.createCell(0);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getBm()));
			
			cell=row.createCell(1);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getNbhdname()));
			
			cell=row.createCell(2);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getBldgname()));
			
			cell=row.createCell(3);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getJbr()));
			
			cell=row.createCell(4);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getSqrq()));
			
			cell=row.createCell(5);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getPzje()));
			
			cell=row.createCell(6);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getSlzt()));
			
			cell=row.createCell(7);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getUsername()));
			
			cell=row.createCell(8);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getApplyRemark()));
			
		}
		// 第六步，将文件存到指定位置
		try {

			wb.write(os);
			os.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	// 导出明细查询销户信息
	public static void exportQueryal1(List<QueryAL1> list,
			HttpServletResponse response) throws IOException {
		OutputStream os = setStream("销户信息", response);
		// 第一步，创建一个webbook，对应一个Excel文件
		HSSFWorkbook wb = new HSSFWorkbook();
		// 第二步，在webbook中添加一个sheet,对应Excel文件中的sheet
		HSSFSheet sheet = wb.createSheet("销户信息");
		// 第三步，在sheet中添加表头第0行,注意老版本poi对Excel的行数列数有限制short
		// 设置行宽
		sheet.setColumnWidth(0, 15 * 256);
		sheet.setColumnWidth(1, 10 * 256);
		sheet.setColumnWidth(5, 15 * 256);
		sheet.setColumnWidth(6, 15 * 256);
		sheet.setColumnWidth(7, 20 * 256);
		sheet.setColumnWidth(8, 20 * 256);
		sheet.setColumnWidth(10, 15 * 256);
		sheet.setColumnWidth(11, 15 * 256);
		sheet.setColumnWidth(12, 15 * 256);
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
		cell.setCellValue("销户信息");
		sheet.addMergedRegion(CellRangeAddress.valueOf("$A$1:$M$1"));
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
		cell = row.createCell(12);
		cell.setCellStyle(style1);
		// 第二行
		row = sheet.createRow((int) 1);

		cell = row.createCell(0);
		cell.setCellValue("房屋编号");
		cell.setCellStyle(style);

		cell = row.createCell(1);
		cell.setCellValue("单元");
		cell.setCellStyle(style);

		cell = row.createCell(2);
		cell.setCellValue("层");
		cell.setCellStyle(style);

		cell = row.createCell(3);
		cell.setCellValue("房号");
		cell.setCellStyle(style);

		cell = row.createCell(4);
		cell.setCellValue("业主姓名");
		cell.setCellStyle(style);

		cell = row.createCell(5);
		cell.setCellValue("支取本金");
		cell.setCellStyle(style);

		cell = row.createCell(6);
		cell.setCellValue("支取利息");
		cell.setCellStyle(style);

		cell = row.createCell(7);
		cell.setCellValue("小区名称");
		cell.setCellStyle(style);

		cell = row.createCell(8);
		cell.setCellValue("楼宇名称");
		cell.setCellStyle(style);

		cell = row.createCell(9);
		cell.setCellValue("操作员");
		cell.setCellStyle(style);

		cell = row.createCell(10);
		cell.setCellValue("申请编号");
		cell.setCellStyle(style);

		cell = row.createCell(11);
		cell.setCellValue("业务编号");
		cell.setCellStyle(style);

		cell = row.createCell(12);
		cell.setCellValue("销户日期");
		cell.setCellStyle(style);
		
		// 第五步，写入实体数据 实际应用中这些数据从数据库得到
		for (int i = 0; i < list.size(); i++) {
			row = sheet.createRow((int) i + 2);
			QueryAL1 ad = (QueryAL1) list.get(i);
			
			// 第四步，创建单元格，并设置值
			cell=row.createCell(0);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getH001()));
			
			cell=row.createCell(1);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getH002()));
			
			cell=row.createCell(2);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getH003()));
			
			cell=row.createCell(3);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getH005()));
			
			cell=row.createCell(4);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getZ012()));
			
			cell=row.createCell(5);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getZ004()));
			
			cell=row.createCell(6);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getZ005()));
			
			cell=row.createCell(7);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getXqmc()));
			
			cell=row.createCell(8);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getLymc()));
			
			cell=row.createCell(9);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getUsername()));
			
			cell=row.createCell(10);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getZ011()));
			
			cell=row.createCell(11);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getZ007()));
			
			cell=row.createCell(12);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getZ018()));
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

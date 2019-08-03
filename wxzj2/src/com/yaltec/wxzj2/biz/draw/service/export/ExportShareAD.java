package com.yaltec.wxzj2.biz.draw.service.export;

import java.io.IOException;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.ArrayList;
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
import com.yaltec.wxzj2.biz.draw.entity.ShareAD;

/**
 * 
 * @ClassName: ExportExcel
 * @Description: 导出excel
 * 
 * @author yangshanping
 * @date 2016-9-9 上午09:21:09
 */
public class ExportShareAD {
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

	// 批量退款分摊明细导出
	public static void exportBachRefund(List<ShareAD> list,
			HttpServletResponse response) throws IOException {
		OutputStream os = setStream("退款分摊明细", response);
		// 第一步，创建一个webbook，对应一个Excel文件
		HSSFWorkbook wb = new HSSFWorkbook();
		// 第二步，在webbook中添加一个sheet,对应Excel文件中的sheet
		HSSFSheet sheet = wb.createSheet("退款分摊明细");
		// 第三步，在sheet中添加表头第0行,注意老版本poi对Excel的行数列数有限制short
		// 设置行宽
		sheet.setColumnWidth(0, 20 * 256);
		sheet.setColumnWidth(5, 10 * 256);
		sheet.setColumnWidth(8, 10 * 256);
		sheet.setColumnWidth(9, 10 * 256);
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
		//style1.setWrapText(true);// 自动换行
		style1.setBorderBottom(HSSFCellStyle.BORDER_THIN); //下边框
		style1.setBorderLeft(HSSFCellStyle.BORDER_THIN);//左边框
		style1.setBorderTop(HSSFCellStyle.BORDER_THIN);//上边框
		style1.setBorderRight(HSSFCellStyle.BORDER_THIN);//右边框
		

		HSSFCell cell = row.createCell(0);
		cell.setCellValue("退款分摊明细");
		cell.setCellStyle(style1);

		sheet.addMergedRegion(CellRangeAddress.valueOf("$A$1:$B$1"));

		cell = row.createCell(2);
		cell.setCellValue("共有");
		cell.setCellStyle(style1);

		cell = row.createCell(3);
		cell.setCellValue(list.size());
		cell.setCellStyle(style1);

		cell = row.createCell(4);
		cell.setCellValue("条记录");
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
		cell.setCellValue("面积");
		cell.setCellStyle(style);

		cell = row.createCell(6);
		cell.setCellValue("身份证号");
		cell.setCellStyle(style);

		cell = row.createCell(7);
		cell.setCellValue("分摊金额");
		cell.setCellStyle(style);

		cell = row.createCell(8);
		cell.setCellValue("应退本金");
		cell.setCellStyle(style);

		cell = row.createCell(9);
		cell.setCellValue("应退利息");
		cell.setCellStyle(style);

		cell = row.createCell(10);
		cell.setCellValue("可用本金");
		cell.setCellStyle(style);

		cell = row.createCell(11);
		cell.setCellValue("可用利息");
		cell.setCellStyle(style);

		cell = row.createCell(12);
		cell.setCellValue("楼宇名称");
		cell.setCellStyle(style);


		// 第五步，写入实体数据 实际应用中这些数据从数据库得到

		for (int i = 0; i < list.size(); i++) {
			row = sheet.createRow((int) i + 2);
			ShareAD ad = (ShareAD) list.get(i);
			
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
			cell.setCellValue(StringUtil.valueOf(ad.getH013()));
			
			cell=row.createCell(5);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getH006()));
			
			cell=row.createCell(6);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getH015()));
			
			cell=row.createCell(7);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getFtje()));
			
			cell=row.createCell(8);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getZqbj()));
			
			cell=row.createCell(9);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getZqlx()));
			
			cell=row.createCell(10);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getH030()));
			
			cell=row.createCell(11);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getH031()));
			
			cell=row.createCell(12);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getLymc()));
		}
		// 第六步，将文件存到指定位置
		try {

			wb.write(os);
			os.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	// 支取预分摊明细导出
	public static void exportPreShareAD(List<ShareAD> list,
			HttpServletResponse response,String xqmc) throws IOException {
		OutputStream os = setStream(xqmc+"物业专项维修资金支取分摊明细", response);
		// 第一步，创建一个webbook，对应一个Excel文件
		HSSFWorkbook wb = new HSSFWorkbook();
		// 第二步，在webbook中添加一个sheet,对应Excel文件中的sheet
		HSSFSheet sheet = wb.createSheet(xqmc+"物业专项维修资金支取分摊明细");
		// 第三步，在sheet中添加表头第0行,注意老版本poi对Excel的行数列数有限制short
		// 设置行宽
		sheet.setColumnWidth(0, 20 * 256);
		sheet.setColumnWidth(5, 10 * 256);
		sheet.setColumnWidth(8, 10 * 256);
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
		//style1.setWrapText(true);// 自动换行
		style1.setBorderBottom(HSSFCellStyle.BORDER_THIN); //下边框
		style1.setBorderLeft(HSSFCellStyle.BORDER_THIN);//左边框
		style1.setBorderTop(HSSFCellStyle.BORDER_THIN);//上边框
		style1.setBorderRight(HSSFCellStyle.BORDER_THIN);//右边框
		
		HSSFCell cell = row.createCell(0);
		cell.setCellValue(xqmc+"物业专项维修资金支取分摊明细");
		cell.setCellStyle(style1);

		sheet.addMergedRegion(CellRangeAddress.valueOf("$A$1:$B$1"));

		cell = row.createCell(2);
		cell.setCellValue("共有");
		cell.setCellStyle(style1);

		cell = row.createCell(3);
		cell.setCellValue(list.size()-1);
		cell.setCellStyle(style1);

		cell = row.createCell(4);
		cell.setCellValue("条记录");
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
		cell.setCellValue("面积");
		cell.setCellStyle(style);

		cell = row.createCell(6);
		cell.setCellValue("身份证号");
		cell.setCellStyle(style);

		cell = row.createCell(7);
		cell.setCellValue("分摊金额");
		cell.setCellStyle(style);
		
		cell = row.createCell(8);
		cell.setCellValue("支取本金");
		cell.setCellStyle(style);
		
		cell = row.createCell(9);
		cell.setCellValue("支取利息");
		cell.setCellStyle(style);
		
		cell = row.createCell(10);
		cell.setCellValue("自筹金额");
		cell.setCellStyle(style);
		
		cell = row.createCell(11);
		cell.setCellValue("可用本金");
		cell.setCellStyle(style);

		cell = row.createCell(12);
		cell.setCellValue("可用利息");
		cell.setCellStyle(style);

		cell = row.createCell(13);
		cell.setCellValue("本金余额");
		cell.setCellStyle(style);

		cell = row.createCell(14);
		cell.setCellValue("利息余额");
		cell.setCellStyle(style);

		cell = row.createCell(15);
		cell.setCellValue("楼宇名称");
		cell.setCellStyle(style);


		// 第五步，写入实体数据 实际应用中这些数据从数据库得到
		for (int i = 0; i < list.size(); i++) {
			row = sheet.createRow((int) i + 2);
			ShareAD ad = (ShareAD) list.get(i);
			
			// 创建单元格，并设置值
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
			cell.setCellValue(StringUtil.valueOf(ad.getH013()));
			
			cell=row.createCell(5);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getH006()));
			
			cell=row.createCell(6);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getH015()));
			
			cell=row.createCell(7);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getFtje()));
			
			cell=row.createCell(8);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getZqbj()));
			
			cell=row.createCell(9);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getZqlx()));
			
			cell=row.createCell(10);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getZcje()));
			
			cell=row.createCell(11);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getH030()));
			
			cell=row.createCell(12);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getH031()));
			
			cell=row.createCell(13);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getBjye()));
			
			cell=row.createCell(14);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getLxye()));
			
			cell=row.createCell(15);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getLymc()));
		}
		// 第六步，将文件存到指定位置
		try {

			wb.write(os);
			os.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	// 支取预分摊明细导出
	// 该方法是初始的支取预分摊导出方法，由于在2017-02-08调整支取预分摊导出方法时，不确定改方法被其他方法调用，暂时保留
	public static void exportShareAD(List<ShareAD> list,
			HttpServletResponse response,String xqmc) throws IOException {
		OutputStream os = setStream(xqmc+"物业专项维修资金支取分摊明细", response);
		// 第一步，创建一个webbook，对应一个Excel文件
		HSSFWorkbook wb = new HSSFWorkbook();
		// 第二步，在webbook中添加一个sheet,对应Excel文件中的sheet
		HSSFSheet sheet = wb.createSheet(xqmc+"物业专项维修资金支取分摊明细");
		// 第三步，在sheet中添加表头第0行,注意老版本poi对Excel的行数列数有限制short
		// 设置行宽
		sheet.setColumnWidth(0, 20 * 256);
		sheet.setColumnWidth(5, 10 * 256);
		sheet.setColumnWidth(8, 10 * 256);
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
		//style1.setWrapText(true);// 自动换行
		style1.setBorderBottom(HSSFCellStyle.BORDER_THIN); //下边框
		style1.setBorderLeft(HSSFCellStyle.BORDER_THIN);//左边框
		style1.setBorderTop(HSSFCellStyle.BORDER_THIN);//上边框
		style1.setBorderRight(HSSFCellStyle.BORDER_THIN);//右边框
		
		HSSFCell cell = row.createCell(0);
		cell.setCellValue(xqmc+"物业专项维修资金支取分摊明细");
		cell.setCellStyle(style1);

		sheet.addMergedRegion(CellRangeAddress.valueOf("$A$1:$B$1"));

		cell = row.createCell(2);
		cell.setCellValue("共有");
		cell.setCellStyle(style1);

		cell = row.createCell(3);
		cell.setCellValue(list.size());
		cell.setCellStyle(style1);

		cell = row.createCell(4);
		cell.setCellValue("条记录");
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
		cell.setCellValue("面积");
		cell.setCellStyle(style);

		cell = row.createCell(6);
		cell.setCellValue("身份证号");
		cell.setCellStyle(style);

		cell = row.createCell(7);
		cell.setCellValue("分摊金额");
		cell.setCellStyle(style);

		cell = row.createCell(8);
		cell.setCellValue("应退本金");
		cell.setCellStyle(style);

		cell = row.createCell(9);
		cell.setCellValue("应退利息");
		cell.setCellStyle(style);

		cell = row.createCell(10);
		cell.setCellValue("可用本金");
		cell.setCellStyle(style);

		cell = row.createCell(11);
		cell.setCellValue("可用利息");
		cell.setCellStyle(style);

		cell = row.createCell(12);
		cell.setCellValue("楼宇名称");
		cell.setCellStyle(style);


		// 第五步，写入实体数据 实际应用中这些数据从数据库得到
		for (int i = 0; i < list.size(); i++) {
			row = sheet.createRow((int) i + 2);
			ShareAD ad = (ShareAD) list.get(i);
			
			// 创建单元格，并设置值
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
			cell.setCellValue(StringUtil.valueOf(ad.getH013()));
			
			cell=row.createCell(5);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getH006()));
			
			cell=row.createCell(6);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getH015()));
			
			cell=row.createCell(7);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getFtje()));
			
			cell=row.createCell(8);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getZqbj()));
			
			cell=row.createCell(9);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getZqlx()));
			
			cell=row.createCell(10);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getH030()));
			
			cell=row.createCell(11);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getH031()));
			
			cell=row.createCell(12);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getLymc()));
		}
		// 第六步，将文件存到指定位置
		try {

			wb.write(os);
			os.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	// 业主意见表导出
	public static void exportShareADToExcel2(List<ArrayList> list0,
			HttpServletResponse response,String xqmc) throws IOException {
		OutputStream os = setStream(xqmc+"物业专项维修资金使用业主意见表", response);
		// 第一步，创建一个webbook，对应一个Excel文件
		HSSFWorkbook wb = new HSSFWorkbook();

		for (ArrayList<ShareAD> list : list0) {
			// 第二步，在webbook中添加一个sheet,对应Excel文件中的sheet
			HSSFSheet sheet = wb.createSheet(list.get(0).getLymc()+"物业专项维修资金使用业主意见表");
			// 第三步，在sheet中添加表头第0行,注意老版本poi对Excel的行数列数有限制short
			// 设置行宽
			sheet.setColumnWidth(3, 10 * 256);
			sheet.setColumnWidth(5, 10 * 256);
			sheet.setColumnWidth(6, 15 * 256);
			sheet.setColumnWidth(9, 10 * 256);
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
			
			// 创建样式2：字体居左，单元格无背景色
			HSSFCellStyle style1 = (HSSFCellStyle) wb.createCellStyle();
			style1.setBorderBottom(HSSFCellStyle.BORDER_THIN); //下边框
			style1.setBorderLeft(HSSFCellStyle.BORDER_THIN);//左边框
			style1.setBorderTop(HSSFCellStyle.BORDER_THIN);//上边框
			style1.setBorderRight(HSSFCellStyle.BORDER_THIN);//右边框
			
			
			HSSFCell cell = row.createCell(0);
			cell.setCellStyle(style);
			cell.setCellValue("物业专项维修资金使用业主意见表");
			sheet.addMergedRegion(CellRangeAddress.valueOf("$A$1:$J$1"));
			cell = row.createCell(1);
			cell.setCellStyle(style);
			cell = row.createCell(2);
			cell.setCellStyle(style);
			cell = row.createCell(3);
			cell.setCellStyle(style);
			cell = row.createCell(4);
			cell.setCellStyle(style);
			cell = row.createCell(5);
			cell.setCellStyle(style);
			cell = row.createCell(6);
			cell.setCellStyle(style);
			cell = row.createCell(7);
			cell.setCellStyle(style);
			cell = row.createCell(8);
			cell.setCellStyle(style);
			cell = row.createCell(9);
			cell.setCellStyle(style);
			// 第二行
			row = sheet.createRow((int) 1);
			
			cell = row.createCell(0);
			cell.setCellStyle(style1);
			cell.setCellValue("楼宇名称："+list.get(0).getLymc());
			sheet.addMergedRegion(CellRangeAddress.valueOf("$A$2:$F$2"));
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
			cell.setCellValue("房屋坐落："+list.get(0).getLyaddress());
			sheet.addMergedRegion(CellRangeAddress.valueOf("$G$2:$J$2"));
			cell = row.createCell(7);
			cell.setCellStyle(style1);
			cell = row.createCell(8);
			cell.setCellStyle(style1);
			cell = row.createCell(9);
			cell.setCellStyle(style1);
			
			// 第三行
			row = sheet.createRow((int) 2);
			
			cell = row.createCell(0);
			cell.setCellStyle(style1);
			cell.setCellValue("业委会名称："+list.get(0).getYwhmc());
			sheet.addMergedRegion(CellRangeAddress.valueOf("$A$3:$F$3"));
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
			cell.setCellValue("物业公司名称："+list.get(0).getWygsmc());
			sheet.addMergedRegion(CellRangeAddress.valueOf("$G$3:$J$3"));
			cell = row.createCell(7);
			cell.setCellStyle(style1);
			cell = row.createCell(8);
			cell.setCellStyle(style1);
			cell = row.createCell(9);
			cell.setCellStyle(style1);
			
			// 第四行
			row = sheet.createRow((int) 3);
			
			cell = row.createCell(0);
			cell.setCellStyle(style1);
			cell.setCellValue("维修分摊面积（㎡）："+list.get(list.size()-1).getH006());
			sheet.addMergedRegion(CellRangeAddress.valueOf("$A$4:$F$4"));
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
			cell.setCellValue("使用金额（元）："+list.get(list.size()-1).getFtje());
			sheet.addMergedRegion(CellRangeAddress.valueOf("$G$4:$J$4"));
			cell = row.createCell(7);
			cell.setCellStyle(style1);
			cell = row.createCell(8);
			cell.setCellStyle(style1);
			cell = row.createCell(9);
			cell.setCellStyle(style1);
			// 第五行
			row = sheet.createRow((int) 4);
			
			cell = row.createCell(0);
			cell.setCellStyle(style1);
			cell.setCellValue("维修项目：");
			sheet.addMergedRegion(CellRangeAddress.valueOf("$A$5:$J$5"));
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
			// 第六行
			row = sheet.createRow((int) 5);
	
			cell = row.createCell(0);
			cell.setCellValue("序号");
			cell.setCellStyle(style);
	
			cell = row.createCell(1);
			cell.setCellValue("业主姓名");
			cell.setCellStyle(style);
	
			cell = row.createCell(2);
			cell.setCellValue("单元");
			cell.setCellStyle(style);
	
			cell = row.createCell(3);
			cell.setCellValue("层");
			cell.setCellStyle(style);
	
			cell = row.createCell(4);
			cell.setCellValue("房号");
			cell.setCellStyle(style);
	
			cell = row.createCell(5);
			cell.setCellValue("建筑面积");
			cell.setCellStyle(style);
	
			cell = row.createCell(6);
			cell.setCellValue("预计分摊金额");
			cell.setCellStyle(style);
	
			cell = row.createCell(7);
			cell.setCellValue("业主签名");
			cell.setCellStyle(style);
	
			cell = row.createCell(8);
			cell.setCellValue("签名时间");
			cell.setCellStyle(style);
	
			cell = row.createCell(9);
			cell.setCellValue("联系电话");
			cell.setCellStyle(style);
	
			// 第五步，写入实体数据 实际应用中这些数据从数据库得到
			for (int i = 0; i < list.size(); i++) {
				row = sheet.createRow((int) i + 6);
				ShareAD ad = (ShareAD) list.get(i);
				
				// 第四步，创建单元格，并设置值
				cell=row.createCell(0);
				cell.setCellStyle(style1);
				cell.setCellValue(StringUtil.valueOf(i+1));
				
				cell=row.createCell(1);
				cell.setCellStyle(style1);
				cell.setCellValue(StringUtil.valueOf(ad.getH013()));
				
				cell=row.createCell(2);
				cell.setCellStyle(style1);
				cell.setCellValue(StringUtil.valueOf(ad.getH002()));
				
				cell=row.createCell(3);
				cell.setCellStyle(style1);
				cell.setCellValue(StringUtil.valueOf(ad.getH003()));
				
				if(ad.getH001().equals("99999999999999")){
					cell=row.createCell(4);
					cell.setCellStyle(style1);
					cell.setCellValue("合计");
				}else{
					cell=row.createCell(4);
					cell.setCellStyle(style1);
					cell.setCellValue(StringUtil.valueOf(ad.getH005()));
				}
				
				cell=row.createCell(5);
				cell.setCellStyle(style1);
				cell.setCellValue(StringUtil.valueOf(ad.getH006()));
				
				cell=row.createCell(6);
				cell.setCellStyle(style1);
				cell.setCellValue(StringUtil.valueOf(ad.getFtje()));
				
				cell=row.createCell(7);
				cell.setCellStyle(style1);
				cell.setCellValue(StringUtil.valueOf(""));
				
				cell=row.createCell(8);
				cell.setCellStyle(style1);
				cell.setCellValue(StringUtil.valueOf(""));
				
				cell=row.createCell(9);
				cell.setCellStyle(style1);
				cell.setCellValue(StringUtil.valueOf(""));
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
	
	// 业主意见表导出【铜梁专用】
	public static void exportShareADToExcel3(List<ShareAD> list,
			HttpServletResponse response,String xqmc) throws IOException {
		OutputStream os = setStream(xqmc+"物业专项维修资金使用业主意见表", response);
		// 第一步，创建一个webbook，对应一个Excel文件
		HSSFWorkbook wb = new HSSFWorkbook();
		// 第二步，在webbook中添加一个sheet,对应Excel文件中的sheet
		HSSFSheet sheet = wb.createSheet(list.get(0).getLymc()+"物业专项维修资金使用业主意见表");
		// 第三步，在sheet中添加表头第0行,注意老版本poi对Excel的行数列数有限制short
		// 设置行宽
		sheet.setColumnWidth(3, 10 * 256);
		sheet.setColumnWidth(5, 10 * 256);
		sheet.setColumnWidth(8, 10 * 256);
		sheet.setColumnWidth(9, 10 * 256);
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
		
		// 创建样式2：字体居左，单元格无背景色
		HSSFCellStyle style1 = (HSSFCellStyle) wb.createCellStyle();
		style1.setBorderBottom(HSSFCellStyle.BORDER_THIN); //下边框
		style1.setBorderLeft(HSSFCellStyle.BORDER_THIN);//左边框
		style1.setBorderTop(HSSFCellStyle.BORDER_THIN);//上边框
		style1.setBorderRight(HSSFCellStyle.BORDER_THIN);//右边框
		
		
		HSSFCell cell = row.createCell(0);
		cell.setCellStyle(style);
		cell.setCellValue("物业专项维修资金使用业主意见表");
		sheet.addMergedRegion(CellRangeAddress.valueOf("$A$1:$K$1"));
		cell = row.createCell(1);
		cell.setCellStyle(style);
		cell = row.createCell(2);
		cell.setCellStyle(style);
		cell = row.createCell(3);
		cell.setCellStyle(style);
		cell = row.createCell(4);
		cell.setCellStyle(style);
		cell = row.createCell(5);
		cell.setCellStyle(style);
		cell = row.createCell(6);
		cell.setCellStyle(style);
		cell = row.createCell(7);
		cell.setCellStyle(style);
		cell = row.createCell(8);
		cell.setCellStyle(style);
		cell = row.createCell(9);
		cell.setCellStyle(style);
		cell = row.createCell(10);
		cell.setCellStyle(style);
		// 第二行
		row = sheet.createRow((int) 1);
		
		cell = row.createCell(0);
		cell.setCellStyle(style1);
		cell.setCellValue("小区名称："+xqmc);
		sheet.addMergedRegion(CellRangeAddress.valueOf("$A$2:$F$2"));
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
		cell.setCellValue("房屋坐落："+list.get(0).getLyaddress());
		sheet.addMergedRegion(CellRangeAddress.valueOf("$G$2:$K$2"));
		cell = row.createCell(7);
		cell.setCellStyle(style1);
		cell = row.createCell(8);
		cell.setCellStyle(style1);
		cell = row.createCell(9);
		cell.setCellStyle(style1);
		cell = row.createCell(10);
		cell.setCellStyle(style1);
		
		// 第三行
		row = sheet.createRow((int) 2);
		
		cell = row.createCell(0);
		cell.setCellStyle(style1);
		cell.setCellValue("业委会名称："+list.get(0).getYwhmc());
		sheet.addMergedRegion(CellRangeAddress.valueOf("$A$3:$F$3"));
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
		cell.setCellValue("物业公司名称："+list.get(0).getWygsmc());
		sheet.addMergedRegion(CellRangeAddress.valueOf("$G$3:$K$3"));
		cell = row.createCell(7);
		cell.setCellStyle(style1);
		cell = row.createCell(8);
		cell.setCellStyle(style1);
		cell = row.createCell(9);
		cell.setCellStyle(style1);
		cell = row.createCell(10);
		cell.setCellStyle(style1);
		
		// 第四行
		row = sheet.createRow((int) 3);
		
		cell = row.createCell(0);
		cell.setCellStyle(style1);
		cell.setCellValue("公示材料：1、物业专项维修资金使用方案；2、施工单位的选定确认书；3、施工合同；4、分摊方式说明；5、会议记录；6、审核报告。");
		sheet.addMergedRegion(CellRangeAddress.valueOf("$A$4:$F$4"));
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
		cell.setCellValue("公示时间：");
		sheet.addMergedRegion(CellRangeAddress.valueOf("$G$4:$K$4"));
		cell = row.createCell(7);
		cell.setCellStyle(style1);
		cell = row.createCell(8);
		cell.setCellStyle(style1);
		cell = row.createCell(9);
		cell.setCellStyle(style1);
		cell = row.createCell(10);
		cell.setCellStyle(style1);
		// 第五行
		row = sheet.createRow((int) 4);
		
		cell = row.createCell(0);
		cell.setCellStyle(style1);
		cell.setCellValue("维修范围：");
		sheet.addMergedRegion(CellRangeAddress.valueOf("$A$5:$F$5"));
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
		cell.setCellValue("使用金额（元）："+list.get(list.size()-1).getFtje());
		sheet.addMergedRegion(CellRangeAddress.valueOf("$G$5:$K$5"));
		cell = row.createCell(7);
		cell.setCellStyle(style1);
		cell = row.createCell(8);
		cell.setCellStyle(style1);
		cell = row.createCell(9);
		cell.setCellStyle(style1);
		cell = row.createCell(10);
		cell.setCellStyle(style1);
		
		// 第六行
		row = sheet.createRow((int) 5);

		cell = row.createCell(0);
		cell.setCellValue("序号");
		cell.setCellStyle(style);

		cell = row.createCell(1);
		cell.setCellValue("业主姓名");
		cell.setCellStyle(style);

		cell = row.createCell(2);
		cell.setCellValue("单元");
		cell.setCellStyle(style);

		cell = row.createCell(3);
		cell.setCellValue("层");
		cell.setCellStyle(style);

		cell = row.createCell(4);
		cell.setCellValue("房号");
		cell.setCellStyle(style);

		cell = row.createCell(5);
		cell.setCellValue("建筑面积");
		cell.setCellStyle(style);

		cell = row.createCell(6);
		cell.setCellValue("预计分摊金额");
		cell.setCellStyle(style);

		cell = row.createCell(7);
		cell.setCellValue("业主签名");
		cell.setCellStyle(style);

		cell = row.createCell(8);
		cell.setCellValue("签名时间");
		cell.setCellStyle(style);

		cell = row.createCell(9);
		cell.setCellValue("联系电话");
		cell.setCellStyle(style);
		
		cell = row.createCell(10);
		cell.setCellValue("楼宇名称");
		cell.setCellStyle(style);

		// 第五步，写入实体数据 实际应用中这些数据从数据库得到
		for (int i = 0; i < list.size(); i++) {
			row = sheet.createRow((int) i + 6);
			ShareAD ad = (ShareAD) list.get(i);
			
			// 第四步，创建单元格，并设置值
			cell=row.createCell(0);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(i+1));
			
			cell=row.createCell(1);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getH013()));
			
			cell=row.createCell(2);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getH002()));
			
			cell=row.createCell(3);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getH003()));
			
			if(ad.getH001().equals("99999999999999")){
				cell=row.createCell(4);
				cell.setCellStyle(style1);
				cell.setCellValue("合计");
			}else{
				cell=row.createCell(4);
				cell.setCellStyle(style1);
				cell.setCellValue(StringUtil.valueOf(ad.getH005()));
			}
			
			cell=row.createCell(5);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getH006()));
			
			cell=row.createCell(6);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getFtje()));
			
			cell=row.createCell(7);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(""));
			
			cell=row.createCell(8);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(""));
			
			cell=row.createCell(9);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(""));
			
			cell=row.createCell(10);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getLymc()));
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

package com.yaltec.wxzj2.biz.compositeQuery.service.export;

import java.io.IOException;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.util.CellRangeAddress;

import com.yaltec.comon.log.entity.Log;
import com.yaltec.comon.utils.DateUtil;
import com.yaltec.comon.utils.StringUtil;
import com.yaltec.wxzj2.biz.compositeQuery.entity.BuildingCall;
import com.yaltec.wxzj2.biz.compositeQuery.entity.BuildingInterestF;
import com.yaltec.wxzj2.biz.compositeQuery.entity.ByBuildingForC1;
import com.yaltec.wxzj2.biz.compositeQuery.entity.ByCommunityForB;
import com.yaltec.wxzj2.biz.compositeQuery.entity.ByProjectBPS;
import com.yaltec.wxzj2.biz.compositeQuery.entity.ByProjectForB;
import com.yaltec.wxzj2.biz.compositeQuery.entity.CountHouse;
import com.yaltec.wxzj2.biz.compositeQuery.entity.DetailBuildingI;
import com.yaltec.wxzj2.biz.compositeQuery.entity.ProjectInterestF;
import com.yaltec.wxzj2.biz.compositeQuery.entity.QueryBalance;
import com.yaltec.wxzj2.biz.compositeQuery.entity.QueryCommunityP;
import com.yaltec.wxzj2.biz.compositeQuery.entity.QueryPaymentS;
import com.yaltec.wxzj2.biz.payment.entity.UnitToPrepay;
import com.yaltec.wxzj2.biz.property.entity.House;
import com.yaltec.wxzj2.biz.system.entity.BankLog;

/**
 * 
 * @ClassName: DataExport
 * @Description: 综合查询模块中，数据导出模版
 * 
 * @author yangshanping
 * @date 2016-9-21 下午03:00:07
 */
public class DataExport {
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
	// 导出资金预警信息
	public static void exportMoneyWarning(List<House> list,
			HttpServletResponse response) throws IOException {
		OutputStream os = setStream("资金预警信息", response);
		// 第一步，创建一个webbook，对应一个Excel文件
		HSSFWorkbook wb = new HSSFWorkbook();
		// 第二步，在webbook中添加一个sheet,对应Excel文件中的sheet
		HSSFSheet sheet = wb.createSheet("资金预警信息");
		// 第三步，在sheet中添加表头第0行,注意老版本poi对Excel的行数列数有限制short
		// 设置行宽
		sheet.setColumnWidth(0, 20 * 256);
		sheet.setColumnWidth(1, 20 * 256);
		sheet.setColumnWidth(3, 10 * 256);
		sheet.setColumnWidth(5, 20 * 256);
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
		style1.setBorderBottom(HSSFCellStyle.BORDER_THIN); //下边框
		style1.setBorderLeft(HSSFCellStyle.BORDER_THIN);//左边框
		style1.setBorderTop(HSSFCellStyle.BORDER_THIN);//上边框
		style1.setBorderRight(HSSFCellStyle.BORDER_THIN);//右边框
		
		
		HSSFCell cell = row.createCell(0);
		cell.setCellStyle(style1);
		cell.setCellValue("资金预警信息");
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
		cell.setCellValue("房屋编号");
		cell.setCellStyle(style);

		cell = row.createCell(1);
		cell.setCellValue("所属楼宇");
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
		cell.setCellValue("业主姓名");
		cell.setCellStyle(style);

		cell = row.createCell(6);
		cell.setCellValue("建筑面积");
		cell.setCellStyle(style);

		cell = row.createCell(7);
		cell.setCellValue("应交资金");
		cell.setCellStyle(style);

		cell = row.createCell(8);
		cell.setCellValue("可用本金");
		cell.setCellStyle(style);

		cell = row.createCell(9);
		cell.setCellValue("可用利息");
		cell.setCellStyle(style);
		
		cell = row.createCell(10);
		cell.setCellValue("首交金额");
		cell.setCellStyle(style);
		
		cell = row.createCell(11);
		cell.setCellValue("应续交金额");
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
			cell.setCellValue(StringUtil.valueOf(ad.getH002()));
			
			cell=row.createCell(3);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getH003()));
			
			cell=row.createCell(4);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getH005()));
			
			cell=row.createCell(5);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getH013()));
			
			cell=row.createCell(6);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getH006()));
			
			cell=row.createCell(7);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getH021()));
			
			cell=row.createCell(8);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getH030()));
			
			cell=row.createCell(9);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getH031()));
			
			cell=row.createCell(10);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getH039()));
			
			cell=row.createCell(11);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getH0301()));
		}
		// 第六步，将文件存到指定位置
		try {

			wb.write(os);
			os.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	// 导出项目收支统计信息
	public static void exportProjectBPS(List<ByProjectBPS> list,
			HttpServletResponse response) throws IOException {
		OutputStream os = setStream("项目收支统计信息", response);
		// 第一步，创建一个webbook，对应一个Excel文件
		HSSFWorkbook wb = new HSSFWorkbook();
		// 第二步，在webbook中添加一个sheet,对应Excel文件中的sheet
		HSSFSheet sheet = wb.createSheet("项目收支统计信息");
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
		
		// 创建样式2：字体居中，单元格无背景色
		HSSFCellStyle style1 = (HSSFCellStyle) wb.createCellStyle();
		style1.setAlignment(HSSFCellStyle.ALIGN_CENTER); // 创建一个居中格式
		style1.setBorderBottom(HSSFCellStyle.BORDER_THIN); //下边框
		style1.setBorderLeft(HSSFCellStyle.BORDER_THIN);//左边框
		style1.setBorderTop(HSSFCellStyle.BORDER_THIN);//上边框
		style1.setBorderRight(HSSFCellStyle.BORDER_THIN);//右边框
		
		
		HSSFCell cell = row.createCell(0);
		cell.setCellStyle(style1);
		cell.setCellValue("项目收支统计信息");
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
		cell.setCellValue("财务编码");
		cell.setCellStyle(style);

		cell = row.createCell(1);
		cell.setCellValue("项目编码");
		cell.setCellStyle(style);

		cell = row.createCell(2);
		cell.setCellValue("项目名称");
		cell.setCellStyle(style);

		cell = row.createCell(3);
		cell.setCellValue("期初本金");
		cell.setCellStyle(style);

		cell = row.createCell(4);
		cell.setCellValue("期初利息");
		cell.setCellStyle(style);

		cell = row.createCell(5);
		cell.setCellValue("增加本金");
		cell.setCellStyle(style);

		cell = row.createCell(6);
		cell.setCellValue("增加利息");
		cell.setCellStyle(style);

		cell = row.createCell(7);
		cell.setCellValue("减少本金");
		cell.setCellStyle(style);

		cell = row.createCell(8);
		cell.setCellValue("减少利息");
		cell.setCellStyle(style);

		cell = row.createCell(9);
		cell.setCellValue("期末本金余额");
		cell.setCellStyle(style);
		
		cell = row.createCell(10);
		cell.setCellValue("期末利息余额");
		cell.setCellStyle(style);
		
		cell = row.createCell(11);
		cell.setCellValue("期末本息合计");
		cell.setCellStyle(style);

		// 第五步，写入实体数据 实际应用中这些数据从数据库得到
		for (int i = 0; i < list.size(); i++) {
			row = sheet.createRow((int) i + 2);
			ByProjectBPS ad = (ByProjectBPS) list.get(i);
			
			// 第四步，创建单元格，并设置值
			cell=row.createCell(0);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getOther()));
			
			cell=row.createCell(1);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getBm()));
			
			cell=row.createCell(2);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getMc()));
			
			cell=row.createCell(3);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getQcbj()));
			
			cell=row.createCell(4);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getQclx()));
			
			cell=row.createCell(5);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getZjbj()));
			
			cell=row.createCell(6);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getZjlx()));
			
			cell=row.createCell(7);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getJsbj()));
			
			cell=row.createCell(8);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getJslx()));
			
			cell=row.createCell(9);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getBjye()));
			
			cell=row.createCell(10);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getLxye()));
			
			cell=row.createCell(11);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getBxhj()));
		}
		// 第六步，将文件存到指定位置
		try {

			wb.write(os);
			os.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	// 导出单位交支信息
	public static void exportUnitToPrepay(List<UnitToPrepay> list,
			HttpServletResponse response) throws IOException {
		OutputStream os = setStream("单位交支信息", response);
		// 第一步，创建一个webbook，对应一个Excel文件
		HSSFWorkbook wb = new HSSFWorkbook();
		// 第二步，在webbook中添加一个sheet,对应Excel文件中的sheet
		HSSFSheet sheet = wb.createSheet("单位交支信息");
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
		
		// 创建样式2：字体居中，单元格无背景色
		HSSFCellStyle style1 = (HSSFCellStyle) wb.createCellStyle();
		style1.setAlignment(HSSFCellStyle.ALIGN_CENTER); // 创建一个居中格式
		style1.setBorderBottom(HSSFCellStyle.BORDER_THIN); //下边框
		style1.setBorderLeft(HSSFCellStyle.BORDER_THIN);//左边框
		style1.setBorderTop(HSSFCellStyle.BORDER_THIN);//上边框
		style1.setBorderRight(HSSFCellStyle.BORDER_THIN);//右边框
		
		
		HSSFCell cell = row.createCell(0);
		cell.setCellStyle(style1);
		cell.setCellValue("单位交支信息");
		sheet.addMergedRegion(CellRangeAddress.valueOf("$A$1:$F$1"));
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
		
		// 第二行
		row = sheet.createRow((int) 1);

		cell = row.createCell(0);
		cell.setCellValue("日期");
		cell.setCellStyle(style);

		cell = row.createCell(1);
		cell.setCellValue("业务编号");
		cell.setCellStyle(style);

		cell = row.createCell(2);
		cell.setCellValue("交存金额");
		cell.setCellStyle(style);

		cell = row.createCell(3);
		cell.setCellValue("支取金额");
		cell.setCellStyle(style);

		cell = row.createCell(4);
		cell.setCellValue("小区名称");
		cell.setCellStyle(style);

		cell = row.createCell(5);
		cell.setCellValue("余额");
		cell.setCellStyle(style);

		// 第五步，写入实体数据 实际应用中这些数据从数据库得到
		for (int i = 0; i < list.size(); i++) {
			row = sheet.createRow((int) i + 2);
			UnitToPrepay ad = (UnitToPrepay) list.get(i);
			
			// 第四步，创建单元格，并设置值
			cell=row.createCell(0);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getRq()));
			
			cell=row.createCell(1);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getYwbh()));
			
			cell=row.createCell(2);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getJk()));
			
			cell=row.createCell(3);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getZq()));
			
			cell=row.createCell(4);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getXqmc()));
			
			cell=row.createCell(5);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getYe()));
			
		}
		// 第六步，将文件存到指定位置
		try {

			wb.write(os);
			os.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	// 导出续筹催交信息
	public static void exportDunningDate(List<House> list,
			HttpServletResponse response) throws IOException {
		OutputStream os = setStream(list.get(0).getLymc()+"_续筹催交信息", response);
		// 第一步，创建一个webbook，对应一个Excel文件
		HSSFWorkbook wb = new HSSFWorkbook();
		// 第二步，在webbook中添加一个sheet,对应Excel文件中的sheet
		HSSFSheet sheet = wb.createSheet(list.get(0).getLymc()+"_续筹催交信息");
		// 第三步，在sheet中添加表头第0行,注意老版本poi对Excel的行数列数有限制short
		// 设置行宽
		sheet.setColumnWidth(0, 15 * 256);
		sheet.setColumnWidth(1, 15 * 256);
		sheet.setColumnWidth(3, 15 * 256);
		sheet.setColumnWidth(9, 15 * 256);
		sheet.setColumnWidth(14, 20 * 256);
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
		cell.setCellValue(list.get(0).getLymc()+"_续筹催交信息");
		sheet.addMergedRegion(CellRangeAddress.valueOf("$A$1:$T$1"));
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
		cell = row.createCell(13);
		cell.setCellStyle(style1);
		cell = row.createCell(14);
		cell.setCellStyle(style1);
		cell = row.createCell(15);
		cell.setCellStyle(style1);
		cell = row.createCell(16);
		cell.setCellStyle(style1);
		cell = row.createCell(17);
		cell.setCellStyle(style1);
		cell = row.createCell(18);
		cell.setCellStyle(style1);
		cell = row.createCell(19);
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
		cell.setCellValue("单元");
		cell.setCellStyle(style);

		cell = row.createCell(3);
		cell.setCellValue("层");
		cell.setCellStyle(style);

		cell = row.createCell(4);
		cell.setCellValue("房号");
		cell.setCellStyle(style);

		cell = row.createCell(5);
		cell.setCellValue("业主姓名");
		cell.setCellStyle(style);
		
		cell = row.createCell(6);
		cell.setCellValue("建筑面积");
		cell.setCellStyle(style);
		
		cell = row.createCell(7);
		cell.setCellValue("房款");
		cell.setCellStyle(style);
		
		cell = row.createCell(8);
		cell.setCellValue("标准编码");
		cell.setCellStyle(style);
		
		cell = row.createCell(9);
		cell.setCellValue("交存标准");
		cell.setCellStyle(style);
		
		cell = row.createCell(10);
		cell.setCellValue("应交资金");
		cell.setCellStyle(style);
		
		cell = row.createCell(11);
		cell.setCellValue("可用本金");
		cell.setCellStyle(style);
		
		cell = row.createCell(12);
		cell.setCellValue("首交金额");
		cell.setCellStyle(style);
		
		cell = row.createCell(13);
		cell.setCellValue("应续交金额");
		cell.setCellStyle(style);
		
		cell = row.createCell(14);
		cell.setCellValue("地址");
		cell.setCellStyle(style);
		
		cell = row.createCell(15);
		cell.setCellValue("性质");
		cell.setCellStyle(style);
		
		cell = row.createCell(16);
		cell.setCellValue("身份证号");
		cell.setCellStyle(style);
		
		cell = row.createCell(17);
		cell.setCellValue("房屋类型");
		cell.setCellStyle(style);
		
		cell = row.createCell(18);
		cell.setCellValue("联系电话");
		cell.setCellStyle(style);
		
		cell = row.createCell(19);
		cell.setCellValue("房屋用途");
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
			cell.setCellValue(StringUtil.valueOf(ad.getH002()));
			
			cell=row.createCell(3);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getH003()));
			
			cell=row.createCell(4);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getH005()));
			
			cell=row.createCell(5);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getH013()));
			
			cell=row.createCell(6);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getH006()));

			cell=row.createCell(7);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getH010()));

			cell=row.createCell(8);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getH022()));

			cell=row.createCell(9);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getH023()));

			cell=row.createCell(10);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getH021()));

			cell=row.createCell(11);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getH030()));

			cell=row.createCell(12);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getSjje()));

			cell=row.createCell(13);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getQjje()));

			cell=row.createCell(14);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getAddress()));

			cell=row.createCell(15);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getH011()));

			cell=row.createCell(16);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getH015()));

			cell=row.createCell(17);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getH017()));

			cell=row.createCell(18);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getH019()));

			cell=row.createCell(19);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getH044()));

		}
		// 第六步，将文件存到指定位置
		try {

			wb.write(os);
			os.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	// 导出楼宇催交信息
	public static void exportBuildingCall(List<BuildingCall> list,
			HttpServletResponse response) throws IOException {
		OutputStream os = setStream("楼宇催交信息", response);
		// 第一步，创建一个webbook，对应一个Excel文件
		HSSFWorkbook wb = new HSSFWorkbook();
		// 第二步，在webbook中添加一个sheet,对应Excel文件中的sheet
		HSSFSheet sheet = wb.createSheet("楼宇催交信息");
		// 第三步，在sheet中添加表头第0行,注意老版本poi对Excel的行数列数有限制short
		// 设置行宽
		sheet.setColumnWidth(0, 15 * 256);
		sheet.setColumnWidth(1, 15 * 256);
		sheet.setColumnWidth(2, 15 * 256);
		sheet.setColumnWidth(3, 15 * 256);
		sheet.setColumnWidth(4, 15 * 256);
		sheet.setColumnWidth(5, 15 * 256);
		sheet.setColumnWidth(6, 15 * 256);
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
		cell.setCellValue("楼宇催交信息");
		sheet.addMergedRegion(CellRangeAddress.valueOf("$A$1:$G$1"));
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
		
		// 第二行
		row = sheet.createRow((int) 1);

		cell = row.createCell(0);
		cell.setCellValue("小区名称");
		cell.setCellStyle(style);

		cell = row.createCell(1);
		cell.setCellValue("楼宇名称");
		cell.setCellStyle(style);

		cell = row.createCell(2);
		cell.setCellValue("应交金额");
		cell.setCellStyle(style);

		cell = row.createCell(3);
		cell.setCellValue("实交金额");
		cell.setCellStyle(style);

		cell = row.createCell(4);
		cell.setCellValue("支取金额");
		cell.setCellStyle(style);

		cell = row.createCell(5);
		cell.setCellValue("可用余额");
		cell.setCellStyle(style);
		
		cell = row.createCell(6);
		cell.setCellValue("截止日期");
		cell.setCellStyle(style);

		// 第五步，写入实体数据 实际应用中这些数据从数据库得到
		for (int i = 0; i < list.size(); i++) {
			row = sheet.createRow((int) i + 2);
			BuildingCall ad = (BuildingCall) list.get(i);
			
			// 第四步，创建单元格，并设置值
			cell=row.createCell(0);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getXqmc()));
			
			cell=row.createCell(1);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getLymc()));
			
			cell=row.createCell(2);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getYjje()));
			
			cell=row.createCell(3);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getSjje()));
			
			cell=row.createCell(4);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getZqje()));
			
			cell=row.createCell(5);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getKyje()));
			
			cell=row.createCell(6);
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

	
	// 导出续筹催交补交信息
	public static void exportDunningBJDate(List<House> list,
			HttpServletResponse response) throws IOException {
		OutputStream os = setStream(list.get(0).getLymc()+"_续筹催交补交信息", response);
		
		// 第一步，创建一个webbook，对应一个Excel文件
		HSSFWorkbook wb = new HSSFWorkbook();
		// 第二步，在webbook中添加一个sheet,对应Excel文件中的sheet
		HSSFSheet sheet = wb.createSheet();
		//HSSFSheet sheet = wb.createSheet("单位房屋上报");
		
		// 第三步，在sheet中添加表头第0行,注意老版本poi对Excel的行数列数有限制short
		// 设置行宽
		sheet.setColumnWidth(0, 5*256);
		sheet.setColumnWidth(1, 5*256);
		sheet.setColumnWidth(2, 5*256);
		sheet.setColumnWidth(11, 12 * 256);
		//获取房屋的统计信息
		//House housedw =list.get(list.size()-1);
		// 第一行
		HSSFRow row = sheet.createRow((int) 0);
		// 第四步，创建单元格，并设置值表头 设置表头居中
		HSSFFont titleFont = wb.createFont();// 字体
		titleFont.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
		titleFont.setFontHeightInPoints((short) 10);

		HSSFCellStyle style = wb.createCellStyle();
		style.setAlignment(HSSFCellStyle.ALIGN_CENTER); // 创建一个居中格式
		style.setFont(titleFont);

		HSSFCell cell = row.createCell(0);
		cell.setCellValue("开发单位名称");
		cell.setCellStyle(style);
		sheet.addMergedRegion(CellRangeAddress.valueOf("$A$1:$C$1"));
		
		cell = row.createCell(3);
		cell.setCellValue("");
		sheet.addMergedRegion(CellRangeAddress.valueOf("$D$1:$E$1"));
	
		cell = row.createCell(5);
		cell.setCellValue("楼宇名称");
		cell.setCellStyle(style);

		cell = row.createCell(6);
		cell.setCellValue(list.get(0).getLymc());
		sheet.addMergedRegion(CellRangeAddress.valueOf("$G$1:$I$1"));

		cell = row.createCell(9);
		cell.setCellValue("楼宇地址");
		cell.setCellStyle(style);

		cell = row.createCell(10);
		cell.setCellValue("");
		sheet.addMergedRegion(CellRangeAddress.valueOf("$K$1:$R$1"));

		

		// 第二行
		row = sheet.createRow((int) 1);
		cell = row.createCell(0);
		cell.setCellValue("房屋性质");
		cell.setCellStyle(style);
		sheet.addMergedRegion(CellRangeAddress.valueOf("$A$2:$C$2"));
		
		cell = row.createCell(3);
		cell.setCellValue("01_商品房、02_拆迁房");		
		sheet.addMergedRegion(CellRangeAddress.valueOf("$D$2:$E$2"));
	
		cell = row.createCell(5);
		cell.setCellValue("房屋类型");
		cell.setCellStyle(style);

		cell = row.createCell(6);
		cell.setCellValue("01_电梯、02_非电梯");		
		sheet.addMergedRegion(CellRangeAddress.valueOf("$G$2:$H$2"));

		cell = row.createCell(8);
		cell.setCellValue("房屋用途");
		cell.setCellStyle(style);

		cell = row.createCell(9);
		cell.setCellValue("01_成套住宅、02_其他用房、03_商服用房、04_物业用房、05_仓储用房、06_办公用房、07_停车用房、08_非成套住宅");		
		sheet.addMergedRegion(CellRangeAddress.valueOf("$J$2:$R$2"));
		
		// 第三行
		row = sheet.createRow((int) 2);
		cell = row.createCell(0);
		cell.setCellValue("总户数");
		cell.setCellStyle(style);
		sheet.addMergedRegion(CellRangeAddress.valueOf("$A$3:$C$3"));		
		cell = row.createCell(3);
		cell.setCellValue(list.size()-1);	
		cell = row.createCell(4);
		cell.setCellValue("总面积");
		cell.setCellStyle(style);
		cell = row.createCell(5);
		cell.setCellValue(list.get(list.size()-1).getH006());		
		cell = row.createCell(6);
		cell.setCellValue("总交款");
		cell.setCellStyle(style);
		cell = row.createCell(7);
		cell.setCellValue(list.get(list.size()-1).getQjje());	
		sheet.addMergedRegion(CellRangeAddress.valueOf("$H$3:$I$3"));	
		cell = row.createCell(9);
		cell.setCellValue("交存标准");
		cell.setCellStyle(style);
		sheet.addMergedRegion(CellRangeAddress.valueOf("$J$3:$K$3"));	
		cell = row.createCell(11);
		cell.setCellValue("01_电梯_75元/㎡、02_非电梯_45元/㎡、03_房款的1%、04_暂无");		
		sheet.addMergedRegion(CellRangeAddress.valueOf("$L$3:$R$3"));	
		

		// 第四行
		row = sheet.createRow((int) 3);
		cell = row.createCell(0);
		cell.setCellValue("单元");
		cell.setCellStyle(style);			
		cell = row.createCell(1);
		cell.setCellValue("层");
		cell.setCellStyle(style);
		cell = row.createCell(2);
		cell.setCellValue("房号");
		cell.setCellStyle(style);
		cell = row.createCell(3);
		cell.setCellValue("产权人");
		cell.setCellStyle(style);
		cell = row.createCell(4);
		cell.setCellValue("身份证号");
		cell.setCellStyle(style);
		cell = row.createCell(5);
		cell.setCellValue("房屋性质");
		cell.setCellStyle(style);
		cell = row.createCell(6);
		cell.setCellValue("房屋用途");
		cell.setCellStyle(style);
		cell = row.createCell(7);
		cell.setCellValue("建筑面积");
		cell.setCellStyle(style);
		cell = row.createCell(8);
		cell.setCellValue("房款");
		cell.setCellStyle(style);
		cell = row.createCell(9);
		cell.setCellValue("房屋类型");
		cell.setCellStyle(style);
		cell = row.createCell(10);
		cell.setCellValue("交存标准");
		cell.setCellStyle(style);
		cell = row.createCell(11);
		cell.setCellValue("上报日期");
		cell.setCellStyle(style);
		cell = row.createCell(12);
		cell.setCellValue("应交金额");
		cell.setCellStyle(style);
		cell = row.createCell(13);
		cell.setCellValue("实交金额");
		cell.setCellStyle(style);
		cell = row.createCell(14);
		cell.setCellValue("联系电话");
		cell.setCellStyle(style);
		cell = row.createCell(15);
		cell.setCellValue("实缴利息");
		cell.setCellStyle(style);
		cell = row.createCell(16);
		cell.setCellValue("X坐标");
		cell.setCellStyle(style);
		cell = row.createCell(17);
		cell.setCellValue("Y坐标");
		cell.setCellStyle(style);
		// 第五步，写入实体数据 实际应用中这些数据从数据库得到
		for (int i = 0; i < list.size()-1; i++) {
			row = sheet.createRow((int) i + 4);
			House h = (House) list.get(i);
			
			// 第四步，创建单元格，并设置值			
			row.createCell(0).setCellValue(StringUtil.valueOf(h.getH002()));
			row.createCell(1).setCellValue(StringUtil.valueOf(h.getH003()));
			row.createCell(2).setCellValue(StringUtil.valueOf(h.getH005()));
			row.createCell(3).setCellValue(StringUtil.valueOf(h.getH013()));
			row.createCell(4).setCellValue(StringUtil.valueOf(h.getH015()));
			row.createCell(5).setCellValue(StringUtil.valueOf(h.getH011()));
			row.createCell(6).setCellValue(StringUtil.valueOf(h.getH044()));
			row.createCell(7).setCellValue(StringUtil.valueOf(h.getH006()));
			row.createCell(8).setCellValue(StringUtil.valueOf(h.getH010()));
			row.createCell(9).setCellValue(StringUtil.valueOf(h.getH017()));
			row.createCell(10).setCellValue(StringUtil.valueOf(h.getH022()));
			row.createCell(11).setCellValue(DateUtil.format(DateUtil.ZH_CN_DATE, h.getH020()));
			row.createCell(12).setCellValue(StringUtil.valueOf(h.getH021()));
			row.createCell(13).setCellValue(StringUtil.valueOf(h.getQjje()));
			row.createCell(14).setCellValue(StringUtil.valueOf(h.getH019()));
			row.createCell(15).setCellValue(StringUtil.valueOf(h.getH031()));
			row.createCell(16).setCellValue(StringUtil.valueOf(h.getH052()));
			row.createCell(17).setCellValue(StringUtil.valueOf(h.getH053()));
		}
		// 第六步，将文件存到指定位置
		try {
			wb.write(os);
			os.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
//	// 导出续筹催交补交信息
//	public static void exportDunningBJDate(List<House> list,
//			HttpServletResponse response) throws IOException {
//		OutputStream os = setStream(list.get(0).getLymc()+"_续筹催交补交信息", response);
//		// 第一步，创建一个webbook，对应一个Excel文件
//		HSSFWorkbook wb = new HSSFWorkbook();
//		// 第二步，在webbook中添加一个sheet,对应Excel文件中的sheet
//		HSSFSheet sheet = wb.createSheet(list.get(0).getLymc()+"_续筹催交补交信息");
//		// 第三步，在sheet中添加表头第0行,注意老版本poi对Excel的行数列数有限制short
//		// 设置行宽
//		sheet.setColumnWidth(0, 15 * 256);
//		sheet.setColumnWidth(1, 15 * 256);
//		sheet.setColumnWidth(3, 15 * 256);
//		sheet.setColumnWidth(6, 15 * 256);
//		// 第一行
//		HSSFRow row = sheet.createRow((int) 0);
//		// 第四步，创建单元格，并设置值表头 设置表头居中
//		HSSFFont titleFont = wb.createFont();// 字体
//		titleFont.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
//		titleFont.setFontHeightInPoints((short) 10);
//
//		// 创建样式1：字体加粗、居中，单元格背景色为灰色
//		HSSFCellStyle style = wb.createCellStyle();
//		style.setAlignment(HSSFCellStyle.ALIGN_CENTER); // 创建一个居中格式
//		style.setFont(titleFont);
//		
//		style.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());// 设置背景色
//		style.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
//		// 设置边框
//		style.setBorderBottom(HSSFCellStyle.BORDER_THIN); //下边框
//		style.setBorderLeft(HSSFCellStyle.BORDER_THIN);//左边框
//		style.setBorderTop(HSSFCellStyle.BORDER_THIN);//上边框
//		style.setBorderRight(HSSFCellStyle.BORDER_THIN);//右边框
//		
//		// 创建样式2：字体居中，单元格无背景色
//		HSSFCellStyle style1 = (HSSFCellStyle) wb.createCellStyle();
//		style1.setAlignment(HSSFCellStyle.ALIGN_CENTER); // 创建一个居中格式
//		style1.setWrapText(true);// 自动换行
//		style1.setBorderBottom(HSSFCellStyle.BORDER_THIN); //下边框
//		style1.setBorderLeft(HSSFCellStyle.BORDER_THIN);//左边框
//		style1.setBorderTop(HSSFCellStyle.BORDER_THIN);//上边框
//		style1.setBorderRight(HSSFCellStyle.BORDER_THIN);//右边框
//		
//		
//		HSSFCell cell = row.createCell(0);
//		cell.setCellStyle(style1);
//		cell.setCellValue(list.get(0).getLymc()+"_续筹催交补交信息");
//		sheet.addMergedRegion(CellRangeAddress.valueOf("$A$1:$P$1"));
//		cell = row.createCell(1);
//		cell.setCellStyle(style1);
//		cell = row.createCell(2);
//		cell.setCellStyle(style1);
//		cell = row.createCell(3);
//		cell.setCellStyle(style1);
//		cell = row.createCell(4);
//		cell.setCellStyle(style1);
//		cell = row.createCell(5);
//		cell.setCellStyle(style1);
//		cell = row.createCell(6);
//		cell.setCellStyle(style1);
//		cell = row.createCell(7);
//		cell.setCellStyle(style1);
//		cell = row.createCell(8);
//		cell.setCellStyle(style1);
//		cell = row.createCell(9);
//		cell.setCellStyle(style1);
//		cell = row.createCell(10);
//		cell.setCellStyle(style1);
//		cell = row.createCell(11);
//		cell.setCellStyle(style1);
//		cell = row.createCell(12);
//		cell.setCellStyle(style1);
//		cell = row.createCell(13);
//		cell.setCellStyle(style1);
//		cell = row.createCell(14);
//		cell.setCellStyle(style1);
//		cell = row.createCell(15);
//		cell.setCellStyle(style1);
//		
//		// 第二行
//		row = sheet.createRow((int) 1);
//
//		cell = row.createCell(0);
//		cell.setCellValue("单元");
//		cell.setCellStyle(style);
//
//		cell = row.createCell(1);
//		cell.setCellValue("层");
//		cell.setCellStyle(style);
//
//		cell = row.createCell(2);
//		cell.setCellValue("房号");
//		cell.setCellStyle(style);
//
//		cell = row.createCell(3);
//		cell.setCellValue("产权人");
//		cell.setCellStyle(style);
//
//		cell = row.createCell(4);
//		cell.setCellValue("身份证号");
//		cell.setCellStyle(style);
//
//		cell = row.createCell(5);
//		cell.setCellValue("房屋性质");
//		cell.setCellStyle(style);
//		
//		cell = row.createCell(6);
//		cell.setCellValue("房屋用途");
//		cell.setCellStyle(style);
//
//		cell = row.createCell(7);
//		cell.setCellValue("建筑面积");
//		cell.setCellStyle(style);
//
//		cell = row.createCell(8);
//		cell.setCellValue("房款");
//		cell.setCellStyle(style);
//
//		cell = row.createCell(9);
//		cell.setCellValue("房屋类型");
//		cell.setCellStyle(style);
//
//		cell = row.createCell(10);
//		cell.setCellValue("交存标准");
//		cell.setCellStyle(style);
//
//		cell = row.createCell(11);
//		cell.setCellValue("上报日期");
//		cell.setCellStyle(style);
//
//		cell = row.createCell(12);
//		cell.setCellValue("应交资金");
//		cell.setCellStyle(style);
//
//		cell = row.createCell(13);
//		cell.setCellValue("实交本金");
//		cell.setCellStyle(style);
//
//		cell = row.createCell(14);
//		cell.setCellValue("联系电话");
//		cell.setCellStyle(style);
//
//		cell = row.createCell(15);
//		cell.setCellValue("实交利息");
//		cell.setCellStyle(style);
//
//		// 第五步，写入实体数据 实际应用中这些数据从数据库得到
//		for (int i = 0; i < list.size(); i++) {
//			row = sheet.createRow((int) i + 2);
//			House ad = (House) list.get(i);
//			
//			// 第四步，创建单元格，并设置值
//			cell=row.createCell(0);
//			cell.setCellStyle(style1);
//			cell.setCellValue(StringUtil.valueOf(ad.getH002()));
//			
//			cell=row.createCell(1);
//			cell.setCellStyle(style1);
//			cell.setCellValue(StringUtil.valueOf(ad.getH003()));
//			
//			cell=row.createCell(2);
//			cell.setCellStyle(style1);
//			cell.setCellValue(StringUtil.valueOf(ad.getH005()));
//			
//			cell=row.createCell(3);
//			cell.setCellStyle(style1);
//			cell.setCellValue(StringUtil.valueOf(ad.getH013()));
//			
//			cell=row.createCell(4);
//			cell.setCellStyle(style1);
//			cell.setCellValue(StringUtil.valueOf(ad.getH015()));
//			
//			cell=row.createCell(5);
//			cell.setCellStyle(style1);
//			cell.setCellValue(StringUtil.valueOf(ad.getH011()));
//			
//			cell=row.createCell(6);
//			cell.setCellStyle(style1);
//			cell.setCellValue(StringUtil.valueOf(ad.getH044()));
//
//			cell=row.createCell(7);
//			cell.setCellStyle(style1);
//			cell.setCellValue(StringUtil.valueOf(ad.getH006()));
//
//			cell=row.createCell(8);
//			cell.setCellStyle(style1);
//			cell.setCellValue(StringUtil.valueOf(ad.getH010()));
//
//			cell=row.createCell(9);
//			cell.setCellStyle(style1);
//			cell.setCellValue(StringUtil.valueOf(ad.getH017()));
//
//			cell=row.createCell(10);
//			cell.setCellStyle(style1);
//			cell.setCellValue(StringUtil.valueOf(ad.getH022()));
//			
//
//			cell=row.createCell(11);
//			cell.setCellStyle(style1);
//			cell.setCellValue(StringUtil.valueOf(ad.getH020()));
//
//			cell=row.createCell(12);
//			cell.setCellStyle(style1);
//			cell.setCellValue(StringUtil.valueOf(ad.getH021()));
//
//			cell=row.createCell(13);
//			cell.setCellStyle(style1);
//			cell.setCellValue(StringUtil.valueOf(ad.getH030()));
//
//			cell=row.createCell(14);
//			cell.setCellStyle(style1);
//			cell.setCellValue(StringUtil.valueOf(ad.getH019()));
//
//			cell=row.createCell(15);
//			cell.setCellStyle(style1);
//			cell.setCellValue(StringUtil.valueOf(ad.getH031()));
//		}
//		// 第六步，将文件存到指定位置
//		try {
//
//			wb.write(os);
//			os.close();
//		} catch (Exception e) {
//			e.printStackTrace();
//		}
//	}
	
	
	// 导出分户台账信息
	public static void exportByBuildingForC1(List<ByBuildingForC1> list,
			HttpServletResponse response, String items, House house) throws IOException {
		OutputStream os = setStream("分户台账信息", response);
		// 第一步，创建一个webbook，对应一个Excel文件
		HSSFWorkbook wb = new HSSFWorkbook();
		// 第二步，在webbook中添加一个sheet,对应Excel文件中的sheet
		HSSFSheet sheet = wb.createSheet("分户台账信息");
		// 第三步，在sheet中添加表头第0行,注意老版本poi对Excel的行数列数有限制short
		// 设置行宽
		sheet.setColumnWidth(0, 20 * 256);
		sheet.setColumnWidth(1, 20 * 256);
		sheet.setColumnWidth(2, 15 * 256);
		sheet.setColumnWidth(3, 15 * 256);
		sheet.setColumnWidth(4, 15 * 256);
		sheet.setColumnWidth(5, 15 * 256);
		sheet.setColumnWidth(6, 15 * 256);
		sheet.setColumnWidth(7, 15 * 256);
		sheet.setColumnWidth(8, 15 * 256);
		sheet.setColumnWidth(9, 15 * 256);
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
		style1.setBorderBottom(HSSFCellStyle.BORDER_THIN); //下边框
		style1.setBorderLeft(HSSFCellStyle.BORDER_THIN);//左边框
		style1.setBorderTop(HSSFCellStyle.BORDER_THIN);//上边框
		style1.setBorderRight(HSSFCellStyle.BORDER_THIN);//右边框
		
		
		HSSFCell cell = row.createCell(0);
		cell.setCellStyle(style1);
		String address = house.getLymc()+house.getH002()+"单元"+house.getH003()+"层"+house.getH005()+"号房";
		cell.setCellValue(address+"分户台账信息");
		sheet.addMergedRegion(CellRangeAddress.valueOf("$A$1:$J$1"));
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
		cell.setCellValue("日期");
		cell.setCellStyle(style);

		cell = row.createCell(1);
		cell.setCellValue("业主姓名");
		cell.setCellStyle(style);

		cell = row.createCell(2);
		cell.setCellValue("摘要");
		cell.setCellStyle(style);
		
		List<String> itemList = StringUtil.tokenize(items, ",");
		int i = 3;
		for (String item: itemList) {
			if (StringUtil.isEmpty(item)) {
				continue;
			} 
			cell = row.createCell(i);
			cell.setCellStyle(style);
			
			if (item.equals("w004")) {
				cell.setCellValue("增加本金");
			}
			if (item.equals("w005")) {
				cell.setCellValue("增加利息");
			}
			if (item.equals("z004")) {
				cell.setCellValue("减少本金");
			}
			if (item.equals("z005")) {
				cell.setCellValue("减少利息");
			}
			if (item.equals("bjye")) {
				cell.setCellValue("本金余额");
			}
			if (item.equals("lxye")) {
				cell.setCellValue("利息余额");
			}
			if (item.equals("xj")) {
				cell.setCellValue("小计");
			}
			i++;
		}

		// 第五步，写入实体数据 实际应用中这些数据从数据库得到
		int k = 0;
		for (i = 0; i < list.size(); i++) {
			// 验证打印的金额是否都为0，为0当前行则不打印
			if (!isPrintRow(itemList, list.get(i))) {
				// 不输入当前行
				continue;
			}
			
			row = sheet.createRow((int) k + 2);
			ByBuildingForC1 ad = (ByBuildingForC1) list.get(i);
			
			// 第四步，创建单元格，并设置值
			cell=row.createCell(0);
			cell.setCellStyle(style1);
			if(ad.getW003().length()>10){
				String ads = ad.getW003().substring(0,10);
				cell.setCellValue(StringUtil.valueOf(ads));
			}else{
				cell.setCellValue(StringUtil.valueOf(ad.getW003()));
			}
			
			cell=row.createCell(1);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getW012()));
			
			cell=row.createCell(2);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getW002()));
			
			
			int j = 3;
			for (String item: itemList) {
				if (StringUtil.isEmpty(item)) {
					continue;
				} 
				cell=row.createCell(j);
				cell.setCellStyle(style1);
				if (item.equals("w004")) {
					cell.setCellValue(ad.getW004());
				}
				if (item.equals("w005")) {
					cell.setCellValue(ad.getW005());
				}
				if (item.equals("z004")) {
					cell.setCellValue(ad.getZ004());
				}
				if (item.equals("z005")) {
					cell.setCellValue(ad.getZ005());
				}
				if (item.equals("bjye")) {
					cell.setCellValue(ad.getBjye());
				}
				if (item.equals("lxye")) {
					cell.setCellValue(ad.getLxye());
				}
				if (item.equals("xj")) {
					cell.setCellValue(ad.getXj());
				}
				j++;
			}
			k++;
		}
		// 第六步，将文件存到指定位置
		try {
			wb.write(os);
			os.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	// 导出按栋汇总台账信息(楼宇台账信息)
	public static void exportByBuildingForS(String lymc,List<ByBuildingForC1> list,
			HttpServletResponse response, String items) throws IOException {
		OutputStream os = setStream(lymc+"汇总台账信息", response);
		// 第一步，创建一个webbook，对应一个Excel文件
		HSSFWorkbook wb = new HSSFWorkbook();
		// 第二步，在webbook中添加一个sheet,对应Excel文件中的sheet
		HSSFSheet sheet = wb.createSheet(lymc+"汇总台账信息");
		// 第三步，在sheet中添加表头第0行,注意老版本poi对Excel的行数列数有限制short
		// 设置行宽
		sheet.setColumnWidth(0, 20 * 256);
		sheet.setColumnWidth(1, 20 * 256);
		sheet.setColumnWidth(2, 15 * 256);
		sheet.setColumnWidth(3, 15 * 256);
		sheet.setColumnWidth(4, 15 * 256);
		sheet.setColumnWidth(5, 15 * 256);
		sheet.setColumnWidth(6, 15 * 256);
		sheet.setColumnWidth(7, 15 * 256);
		sheet.setColumnWidth(8, 15 * 256);
		sheet.setColumnWidth(9, 15 * 256);
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
		style1.setBorderBottom(HSSFCellStyle.BORDER_THIN); //下边框
		style1.setBorderLeft(HSSFCellStyle.BORDER_THIN);//左边框
		style1.setBorderTop(HSSFCellStyle.BORDER_THIN);//上边框
		style1.setBorderRight(HSSFCellStyle.BORDER_THIN);//右边框
		
		
		HSSFCell cell = row.createCell(0);
		cell.setCellStyle(style1);
		cell.setCellValue(lymc+"汇总台账信息");
		sheet.addMergedRegion(CellRangeAddress.valueOf("$A$1:$K$1"));
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
		
		// 第二行
		row = sheet.createRow((int) 1);

		cell = row.createCell(0);
		cell.setCellValue("日期");
		cell.setCellStyle(style);

		cell = row.createCell(1);
		cell.setCellValue("摘要");
		cell.setCellStyle(style);
		
		List<String> itemList = StringUtil.tokenize(items, ",");
		int i = 2;
		for (String item: itemList) {
			if (item.equals("w004")) {
				cell = row.createCell(i);
				cell.setCellValue("增加本金");
				cell.setCellStyle(style);
			}
			if (item.equals("w005")) {
				cell = row.createCell(i);
				cell.setCellValue("增加利息");
				cell.setCellStyle(style);
			}
			if (item.equals("xj1")) {
				cell = row.createCell(i);
				cell.setCellValue("小计");
				cell.setCellStyle(style);
			}
			if (item.equals("z004")) {
				cell = row.createCell(i);
				cell.setCellValue("减少本金");
				cell.setCellStyle(style);
			}
			if (item.equals("z005")) {
				cell = row.createCell(i);
				cell.setCellValue("减少利息");
				cell.setCellStyle(style);
			}
			if (item.equals("xj2")) {
				cell = row.createCell(i);
				cell.setCellValue("小计");
				cell.setCellStyle(style);
			}
			if (item.equals("bjye")) {
				cell = row.createCell(i);
				cell.setCellValue("本金余额");
				cell.setCellStyle(style);
			}
			if (item.equals("lxye")) {
				cell = row.createCell(i);
				cell.setCellValue("利息余额");
				cell.setCellStyle(style);
			}
			if (item.equals("xj")) {
				cell = row.createCell(i);
				cell.setCellValue("小计");
				cell.setCellStyle(style);
			}
			i++;
		}

		// 第五步，写入实体数据 实际应用中这些数据从数据库得到
		int k = 0;
		for (i = 0; i < list.size(); i++) {
			// 验证打印的金额是否都为0，为0当前行则不打印
			if (!isPrintRow(itemList, list.get(i))) {
				// 不输入当前行
				continue;
			}
			
			row = sheet.createRow((int) k + 2);
			ByBuildingForC1 ad = (ByBuildingForC1) list.get(i);
			
			// 第四步，创建单元格，并设置值
			cell=row.createCell(0);
			cell.setCellStyle(style1);
			if(ad.getW003().length()>10){
				String ads = ad.getW003().substring(0,10);
				cell.setCellValue(StringUtil.valueOf(ads));
			}else{
				cell.setCellValue(StringUtil.valueOf(ad.getW003()));
			}
			
			cell=row.createCell(1);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getW002()));
			
			int j = 2;
			for (String item: itemList) {
				if (item.equals("w004")) {
					cell=row.createCell(j);
					cell.setCellStyle(style1);
					cell.setCellValue(ad.getW004());
				}
				if (item.equals("w005")) {
					cell=row.createCell(j);
					cell.setCellStyle(style1);
					cell.setCellValue(ad.getW005());
				}
				if (item.equals("xj1")) {
					cell=row.createCell(j);
					cell.setCellStyle(style1);
					cell.setCellValue(ad.getXj1());
				}
				if (item.equals("z004")) {
					cell=row.createCell(j);
					cell.setCellStyle(style1);
					cell.setCellValue(ad.getZ004());
				}
				if (item.equals("z005")) {
					cell=row.createCell(j);
					cell.setCellStyle(style1);
					cell.setCellValue(ad.getZ005());
				}
				if (item.equals("xj2")) {
					cell=row.createCell(j);
					cell.setCellStyle(style1);
					cell.setCellValue(ad.getXj2());
				}
				if (item.equals("bjye")) {
					cell=row.createCell(j);
					cell.setCellStyle(style1);
					cell.setCellValue(ad.getBjye());
				}
				if (item.equals("lxye")) {
					cell=row.createCell(j);
					cell.setCellStyle(style1);
					cell.setCellValue(ad.getLxye());
				}
				if (item.equals("xj")) {
					cell=row.createCell(j);
					cell.setCellStyle(style1);
					cell.setCellValue(ad.getXj());
				}
				j++;
			}
			k++;
		}
		// 第六步，将文件存到指定位置
		try {

			wb.write(os);
			os.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	
	// 导出按小区汇总台账信息
	public static void exportByCommunityForS(List<ByBuildingForC1> list,
			HttpServletResponse response) throws IOException {
		OutputStream os = setStream("按小区汇总台账信息", response);
		// 第一步，创建一个webbook，对应一个Excel文件
		HSSFWorkbook wb = new HSSFWorkbook();
		// 第二步，在webbook中添加一个sheet,对应Excel文件中的sheet
		HSSFSheet sheet = wb.createSheet("按小区汇总台账信息");
		// 第三步，在sheet中添加表头第0行,注意老版本poi对Excel的行数列数有限制short
		// 设置行宽
		sheet.setColumnWidth(0, 20 * 256);
		sheet.setColumnWidth(1, 20 * 256);
		sheet.setColumnWidth(2, 15 * 256);
		sheet.setColumnWidth(3, 15 * 256);
		sheet.setColumnWidth(4, 15 * 256);
		sheet.setColumnWidth(5, 15 * 256);
		sheet.setColumnWidth(6, 15 * 256);
		sheet.setColumnWidth(7, 15 * 256);
		sheet.setColumnWidth(8, 15 * 256);
		sheet.setColumnWidth(9, 15 * 256);
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
		style1.setBorderBottom(HSSFCellStyle.BORDER_THIN); //下边框
		style1.setBorderLeft(HSSFCellStyle.BORDER_THIN);//左边框
		style1.setBorderTop(HSSFCellStyle.BORDER_THIN);//上边框
		style1.setBorderRight(HSSFCellStyle.BORDER_THIN);//右边框
		
		
		HSSFCell cell = row.createCell(0);
		cell.setCellStyle(style1);
		cell.setCellValue("按小区汇总台账信息");
		sheet.addMergedRegion(CellRangeAddress.valueOf("$A$1:$K$1"));
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
		
		// 第二行
		row = sheet.createRow((int) 1);

		cell = row.createCell(0);
		cell.setCellValue("日期");
		cell.setCellStyle(style);

		cell = row.createCell(1);
		cell.setCellValue("摘要");
		cell.setCellStyle(style);

		cell = row.createCell(2);
		cell.setCellValue("增加本金");
		cell.setCellStyle(style);

		cell = row.createCell(3);
		cell.setCellValue("增加利息");
		cell.setCellStyle(style);

		cell = row.createCell(4);
		cell.setCellValue("小计");
		cell.setCellStyle(style);

		cell = row.createCell(5);
		cell.setCellValue("减少本金");
		cell.setCellStyle(style);

		cell = row.createCell(6);
		cell.setCellValue("减少利息");
		cell.setCellStyle(style);

		cell = row.createCell(7);
		cell.setCellValue("小计");
		cell.setCellStyle(style);

		cell = row.createCell(8);
		cell.setCellValue("本金余额");
		cell.setCellStyle(style);

		cell = row.createCell(9);
		cell.setCellValue("利息余额");
		cell.setCellStyle(style);
		
		cell = row.createCell(10);
		cell.setCellValue("小计");
		cell.setCellStyle(style);

		// 第五步，写入实体数据 实际应用中这些数据从数据库得到
		for (int i = 0; i < list.size(); i++) {
			row = sheet.createRow((int) i + 2);
			ByBuildingForC1 ad = (ByBuildingForC1) list.get(i);
			
			// 第四步，创建单元格，并设置值
			cell=row.createCell(0);
			cell.setCellStyle(style1);
			if(ad.getW003().length()>10){
				String ads = ad.getW003().substring(0,10);
				cell.setCellValue(StringUtil.valueOf(ads));
			}else{
				cell.setCellValue(StringUtil.valueOf(ad.getW003()));
			}
			
			cell=row.createCell(1);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getW002()));
			
			cell=row.createCell(2);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getW004()));
			
			cell=row.createCell(3);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getW005()));
			
			cell=row.createCell(4);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getXj1()));
			
			cell=row.createCell(5);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getZ004()));
			
			cell=row.createCell(6);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getZ005()));
			
			cell=row.createCell(7);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getXj2()));
			
			cell=row.createCell(8);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getBjye()));
			
			cell=row.createCell(9);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getLxye()));
			
			cell=row.createCell(10);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getXj()));

		}
		// 第六步，将文件存到指定位置
		try {

			wb.write(os);
			os.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	// 导出按项目汇总台账信息
	public static void exportProjectForS(List<ByBuildingForC1> list,
			HttpServletResponse response) throws IOException {
		OutputStream os = setStream("按项目汇总台账信息", response);
		// 第一步，创建一个webbook，对应一个Excel文件
		HSSFWorkbook wb = new HSSFWorkbook();
		// 第二步，在webbook中添加一个sheet,对应Excel文件中的sheet
		HSSFSheet sheet = wb.createSheet("按项目汇总台账信息");
		// 第三步，在sheet中添加表头第0行,注意老版本poi对Excel的行数列数有限制short
		// 设置行宽
		sheet.setColumnWidth(0, 20 * 256);
		sheet.setColumnWidth(1, 20 * 256);
		sheet.setColumnWidth(2, 20 * 256);
		sheet.setColumnWidth(3, 20 * 256);
		sheet.setColumnWidth(4, 20 * 256);
		sheet.setColumnWidth(5, 20 * 256);
		sheet.setColumnWidth(6, 20 * 256);
		sheet.setColumnWidth(7, 20 * 256);
		sheet.setColumnWidth(8, 20 * 256);
		sheet.setColumnWidth(9, 20 * 256);
		sheet.setColumnWidth(10, 20 * 256);
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
		style1.setBorderBottom(HSSFCellStyle.BORDER_THIN); //下边框
		style1.setBorderLeft(HSSFCellStyle.BORDER_THIN);//左边框
		style1.setBorderTop(HSSFCellStyle.BORDER_THIN);//上边框
		style1.setBorderRight(HSSFCellStyle.BORDER_THIN);//右边框
		
		
		HSSFCell cell = row.createCell(0);
		cell.setCellStyle(style1);
		cell.setCellValue("按项目汇总台账信息");
		sheet.addMergedRegion(CellRangeAddress.valueOf("$A$1:$K$1"));
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
		
		// 第二行
		row = sheet.createRow((int) 1);

		cell = row.createCell(0);
		cell.setCellValue("日期");
		cell.setCellStyle(style);

		cell = row.createCell(1);
		cell.setCellValue("摘要");
		cell.setCellStyle(style);

		cell = row.createCell(2);
		cell.setCellValue("增加本金");
		cell.setCellStyle(style);

		cell = row.createCell(3);
		cell.setCellValue("增加利息");
		cell.setCellStyle(style);

		cell = row.createCell(4);
		cell.setCellValue("小计");
		cell.setCellStyle(style);

		cell = row.createCell(5);
		cell.setCellValue("减少本金");
		cell.setCellStyle(style);

		cell = row.createCell(6);
		cell.setCellValue("减少利息");
		cell.setCellStyle(style);

		cell = row.createCell(7);
		cell.setCellValue("小计");
		cell.setCellStyle(style);

		cell = row.createCell(8);
		cell.setCellValue("本金余额");
		cell.setCellStyle(style);

		cell = row.createCell(9);
		cell.setCellValue("利息余额");
		cell.setCellStyle(style);
		
		cell = row.createCell(10);
		cell.setCellValue("小计");
		cell.setCellStyle(style);

		// 第五步，写入实体数据 实际应用中这些数据从数据库得到
		for (int i = 0; i < list.size(); i++) {
			row = sheet.createRow((int) i + 2);
			ByBuildingForC1 ad = (ByBuildingForC1) list.get(i);
			
			// 第四步，创建单元格，并设置值
			cell=row.createCell(0);
			cell.setCellStyle(style1);
			if(ad.getW003().length()>10){
				String ads = ad.getW003().substring(0,10);
				cell.setCellValue(StringUtil.valueOf(ads));
			}else{
				cell.setCellValue(StringUtil.valueOf(ad.getW003()));
			}
			
			cell=row.createCell(1);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getW002()));
			
			cell=row.createCell(2);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getW004()));			
			
			cell=row.createCell(3);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getW005()));
			
			cell=row.createCell(4);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getXj1()));
			
			cell=row.createCell(5);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getZ004()));
			
			cell=row.createCell(6);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getZ005()));
			
			cell=row.createCell(7);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getXj2()));
			
			cell=row.createCell(8);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getBjye()));
			
			cell=row.createCell(9);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getLxye()));
			
			cell=row.createCell(10);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getXj()));

		}
		// 第六步，将文件存到指定位置
		try {

			wb.write(os);
			os.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	
	// 导出汇总台账信息
	public static void exportQuerySummary(List<ByBuildingForC1> list,
			HttpServletResponse response) throws IOException {
		OutputStream os = setStream("汇总台账信息", response);
		// 第一步，创建一个webbook，对应一个Excel文件
		HSSFWorkbook wb = new HSSFWorkbook();
		// 第二步，在webbook中添加一个sheet,对应Excel文件中的sheet
		HSSFSheet sheet = wb.createSheet("汇总台账信息");
		// 第三步，在sheet中添加表头第0行,注意老版本poi对Excel的行数列数有限制short
		// 设置行宽
		sheet.setColumnWidth(0, 20 * 256);
		sheet.setColumnWidth(1, 20 * 256);
		sheet.setColumnWidth(2, 20 * 256);
		sheet.setColumnWidth(3, 20 * 256);
		sheet.setColumnWidth(4, 20 * 256);
		sheet.setColumnWidth(5, 20 * 256);
		sheet.setColumnWidth(6, 20 * 256);
		sheet.setColumnWidth(7, 20 * 256);
		sheet.setColumnWidth(8, 20 * 256);
		sheet.setColumnWidth(9, 20 * 256);
		sheet.setColumnWidth(10, 20 * 256);
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
		style1.setBorderBottom(HSSFCellStyle.BORDER_THIN); //下边框
		style1.setBorderLeft(HSSFCellStyle.BORDER_THIN);//左边框
		style1.setBorderTop(HSSFCellStyle.BORDER_THIN);//上边框
		style1.setBorderRight(HSSFCellStyle.BORDER_THIN);//右边框
		
		
		HSSFCell cell = row.createCell(0);
		cell.setCellStyle(style1);
		cell.setCellValue("汇总台账信息");
		sheet.addMergedRegion(CellRangeAddress.valueOf("$A$1:$K$1"));
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
		
		// 第二行
		row = sheet.createRow((int) 1);

		cell = row.createCell(0);
		cell.setCellValue("日期");
		cell.setCellStyle(style);

		cell = row.createCell(1);
		cell.setCellValue("摘要");
		cell.setCellStyle(style);

		cell = row.createCell(2);
		cell.setCellValue("增加本金");
		cell.setCellStyle(style);

		cell = row.createCell(3);
		cell.setCellValue("增加利息");
		cell.setCellStyle(style);

		cell = row.createCell(4);
		cell.setCellValue("小计");
		cell.setCellStyle(style);

		cell = row.createCell(5);
		cell.setCellValue("减少本金");
		cell.setCellStyle(style);

		cell = row.createCell(6);
		cell.setCellValue("减少利息");
		cell.setCellStyle(style);

		cell = row.createCell(7);
		cell.setCellValue("小计");
		cell.setCellStyle(style);

		cell = row.createCell(8);
		cell.setCellValue("本金余额");
		cell.setCellStyle(style);

		cell = row.createCell(9);
		cell.setCellValue("利息余额");
		cell.setCellStyle(style);
		
		cell = row.createCell(10);
		cell.setCellValue("小计");
		cell.setCellStyle(style);

		// 第五步，写入实体数据 实际应用中这些数据从数据库得到
		for (int i = 0; i < list.size(); i++) {
			row = sheet.createRow((int) i + 2);
			ByBuildingForC1 ad = (ByBuildingForC1) list.get(i);
			
			// 第四步，创建单元格，并设置值
			cell=row.createCell(0);
			cell.setCellStyle(style1);
			if(ad.getW003().length()>10){
				String ads = ad.getW003().substring(0,10);
				cell.setCellValue(StringUtil.valueOf(ads));
			}else{
				cell.setCellValue(StringUtil.valueOf(ad.getW003()));
			}
			
			cell=row.createCell(1);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getW002()));
			
			cell=row.createCell(2);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getW004()));
			
			cell=row.createCell(3);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getW005()));
			
			cell=row.createCell(4);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getXj1()));
			
			cell=row.createCell(5);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getZ004()));
			
			cell=row.createCell(6);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getZ005()));
			
			cell=row.createCell(7);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getXj2()));
			
			cell=row.createCell(8);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getBjye()));
			
			cell=row.createCell(9);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getLxye()));
			
			cell=row.createCell(10);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getXj()));

		}
		// 第六步，将文件存到指定位置
		try {

			wb.write(os);
			os.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	
	// 项目余额的导出数据
	public static void exportByProjectForB(List<ByProjectForB> list,
			HttpServletResponse response) throws IOException {
		OutputStream os = setStream("项目余额信息", response);
		// 第一步，创建一个webbook，对应一个Excel文件
		HSSFWorkbook wb = new HSSFWorkbook();
		// 第二步，在webbook中添加一个sheet,对应Excel文件中的sheet
		HSSFSheet sheet = wb.createSheet("项目余额信息");
		// 第三步，在sheet中添加表头第0行,注意老版本poi对Excel的行数列数有限制short
		// 设置行宽
		sheet.setColumnWidth(0, 20 * 256);
		sheet.setColumnWidth(1, 20 * 256);
		sheet.setColumnWidth(2, 20 * 256);
		sheet.setColumnWidth(3, 20 * 256);
		sheet.setColumnWidth(4, 20 * 256);
		sheet.setColumnWidth(5, 20 * 256);
		sheet.setColumnWidth(6, 20 * 256);
		sheet.setColumnWidth(7, 20 * 256);
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
		style1.setBorderBottom(HSSFCellStyle.BORDER_THIN); //下边框
		style1.setBorderLeft(HSSFCellStyle.BORDER_THIN);//左边框
		style1.setBorderTop(HSSFCellStyle.BORDER_THIN);//上边框
		style1.setBorderRight(HSSFCellStyle.BORDER_THIN);//右边框
		
		
		HSSFCell cell = row.createCell(0);
		cell.setCellStyle(style1);
		cell.setCellValue("项目余额信息");
		sheet.addMergedRegion(CellRangeAddress.valueOf("$A$1:$H$1"));
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
		
		// 第二行
		row = sheet.createRow((int) 1);

		cell = row.createCell(0);
		cell.setCellValue("项目编号");
		cell.setCellStyle(style);

		cell = row.createCell(1);
		cell.setCellValue("项目名称");
		cell.setCellStyle(style);

		cell = row.createCell(2);
		cell.setCellValue("交款金额");
		cell.setCellStyle(style);

		cell = row.createCell(3);
		cell.setCellValue("支出金额");
		cell.setCellStyle(style);

		cell = row.createCell(4);
		cell.setCellValue("剩余本金");
		cell.setCellStyle(style);

		cell = row.createCell(5);
		cell.setCellValue("剩余利息");
		cell.setCellStyle(style);

		cell = row.createCell(6);
		cell.setCellValue("余额");
		cell.setCellStyle(style);

		cell = row.createCell(7);
		cell.setCellValue("截止日期");
		cell.setCellStyle(style);

		// 第五步，写入实体数据 实际应用中这些数据从数据库得到
		for (int i = 0; i < list.size(); i++) {
			row = sheet.createRow((int) i + 2);
			ByProjectForB ad = (ByProjectForB) list.get(i);
			
			// 第四步，创建单元格，并设置值
			cell=row.createCell(0);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getXmbh()));
			
			cell=row.createCell(1);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getXmmc()));
			
			cell=row.createCell(2);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getJkje()));
			
			cell=row.createCell(3);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getZqje()));
			
			cell=row.createCell(4);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getBj()));
			
			cell=row.createCell(5);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getLx()));
			
			cell=row.createCell(6);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getYe()));
			
			cell=row.createCell(7);
			cell.setCellStyle(style1);
			if(ad.getMdate().length()>10){
				String ads = ad.getMdate().substring(0,10);
				cell.setCellValue(StringUtil.valueOf(ads));
			}else{
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
	
	
	// 小区余额的导出数据
	public static void exportByCommunityForB(List<ByCommunityForB> list,
			HttpServletResponse response) throws IOException {
		OutputStream os = setStream("小区余额信息", response);
		// 第一步，创建一个webbook，对应一个Excel文件
		HSSFWorkbook wb = new HSSFWorkbook();
		// 第二步，在webbook中添加一个sheet,对应Excel文件中的sheet
		HSSFSheet sheet = wb.createSheet("小区余额信息");
		// 第三步，在sheet中添加表头第0行,注意老版本poi对Excel的行数列数有限制short
		// 设置行宽
		sheet.setColumnWidth(0, 15 * 256);
		sheet.setColumnWidth(1, 15 * 256);
		sheet.setColumnWidth(2, 15 * 256);
		sheet.setColumnWidth(3, 15 * 256);
		sheet.setColumnWidth(4, 15 * 256);
		sheet.setColumnWidth(5, 15 * 256);
		sheet.setColumnWidth(6, 15 * 256);
		sheet.setColumnWidth(7, 15 * 256);
		sheet.setColumnWidth(8, 15 * 256);
		sheet.setColumnWidth(9, 15 * 256);
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
		style1.setBorderBottom(HSSFCellStyle.BORDER_THIN); //下边框
		style1.setBorderLeft(HSSFCellStyle.BORDER_THIN);//左边框
		style1.setBorderTop(HSSFCellStyle.BORDER_THIN);//上边框
		style1.setBorderRight(HSSFCellStyle.BORDER_THIN);//右边框
		
		
		HSSFCell cell = row.createCell(0);
		cell.setCellStyle(style1);
		cell.setCellValue("小区余额信息");
		sheet.addMergedRegion(CellRangeAddress.valueOf("$A$1:$J$1"));
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
		cell.setCellValue("小区编号");
		cell.setCellStyle(style);

		cell = row.createCell(1);
		cell.setCellValue("小区名称");
		cell.setCellStyle(style);

		cell = row.createCell(2);
		cell.setCellValue("交款本金");
		cell.setCellStyle(style);

		cell = row.createCell(3);
		cell.setCellValue("交款利息");
		cell.setCellStyle(style);

		cell = row.createCell(4);
		cell.setCellValue("支出本金");
		cell.setCellStyle(style);

		cell = row.createCell(5);
		cell.setCellValue("支出利息");
		cell.setCellStyle(style);

		cell = row.createCell(6);
		cell.setCellValue("剩余本金");
		cell.setCellStyle(style);

		cell = row.createCell(7);
		cell.setCellValue("剩余利息");
		cell.setCellStyle(style);

		cell = row.createCell(8);
		cell.setCellValue("余额");
		cell.setCellStyle(style);

		cell = row.createCell(9);
		cell.setCellValue("截止日期");
		cell.setCellStyle(style);

		// 第五步，写入实体数据 实际应用中这些数据从数据库得到
		for (int i = 0; i < list.size(); i++) {
			row = sheet.createRow((int) i + 2);
			ByCommunityForB ad = (ByCommunityForB) list.get(i);
			
			// 第四步，创建单元格，并设置值
			cell=row.createCell(0);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getXqbh()));
			
			cell=row.createCell(1);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getXqmc()));
			
			cell=row.createCell(2);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getJkje()));
			
			cell=row.createCell(3);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getJklx()));
			
			cell=row.createCell(4);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getZqje()));
			
			cell=row.createCell(5);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getZqlx()));
			
			cell=row.createCell(6);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getBj()));
			
			cell=row.createCell(7);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getLx()));
			
			cell=row.createCell(8);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getYe()));
			
			cell=row.createCell(9);
			cell.setCellStyle(style1);
			if(ad.getMdate().length()>10){
				String ads = ad.getMdate().substring(0,10);
				cell.setCellValue(StringUtil.valueOf(ads));
			}else{
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
	
	
	// 小区余额的导出数据
	public static void exportBuildingForB(List<ByCommunityForB> list,
			HttpServletResponse response) throws IOException {
		OutputStream os = setStream("楼宇余额信息", response);
		// 第一步，创建一个webbook，对应一个Excel文件
		HSSFWorkbook wb = new HSSFWorkbook();
		// 第二步，在webbook中添加一个sheet,对应Excel文件中的sheet
		HSSFSheet sheet = wb.createSheet("楼宇余额信息");
		// 第三步，在sheet中添加表头第0行,注意老版本poi对Excel的行数列数有限制short
		// 设置行宽
		sheet.setColumnWidth(0, 15 * 256);
		sheet.setColumnWidth(1, 15 * 256);
		sheet.setColumnWidth(2, 15 * 256);
		sheet.setColumnWidth(3, 15 * 256);
		sheet.setColumnWidth(4, 15 * 256);
		sheet.setColumnWidth(5, 15 * 256);
		sheet.setColumnWidth(6, 15 * 256);
		sheet.setColumnWidth(7, 15 * 256);
		sheet.setColumnWidth(8, 15 * 256);
		sheet.setColumnWidth(9, 15 * 256);
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
		style1.setBorderBottom(HSSFCellStyle.BORDER_THIN); //下边框
		style1.setBorderLeft(HSSFCellStyle.BORDER_THIN);//左边框
		style1.setBorderTop(HSSFCellStyle.BORDER_THIN);//上边框
		style1.setBorderRight(HSSFCellStyle.BORDER_THIN);//右边框
		
		
		HSSFCell cell = row.createCell(0);
		cell.setCellStyle(style1);
		cell.setCellValue("楼宇余额信息");
		sheet.addMergedRegion(CellRangeAddress.valueOf("$A$1:$J$1"));
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
		cell.setCellValue("交款本金");
		cell.setCellStyle(style);

		cell = row.createCell(3);
		cell.setCellValue("交款利息");
		cell.setCellStyle(style);

		cell = row.createCell(4);
		cell.setCellValue("支出本金");
		cell.setCellStyle(style);

		cell = row.createCell(5);
		cell.setCellValue("支出利息");
		cell.setCellStyle(style);

		cell = row.createCell(6);
		cell.setCellValue("剩余本金");
		cell.setCellStyle(style);

		cell = row.createCell(7);
		cell.setCellValue("剩余利息");
		cell.setCellStyle(style);

		cell = row.createCell(8);
		cell.setCellValue("余额");
		cell.setCellStyle(style);

		cell = row.createCell(9);
		cell.setCellValue("截止日期");
		cell.setCellStyle(style);

		// 第五步，写入实体数据 实际应用中这些数据从数据库得到
		for (int i = 0; i < list.size(); i++) {
			row = sheet.createRow((int) i + 2);
			ByCommunityForB ad = (ByCommunityForB) list.get(i);
			
			// 第四步，创建单元格，并设置值
			cell=row.createCell(0);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getLybh()));
			
			cell=row.createCell(1);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getLymc()));
			
			cell=row.createCell(2);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getJkje()));
			
			cell=row.createCell(3);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getJklx()));
			
			cell=row.createCell(4);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getZqje()));
			
			cell=row.createCell(5);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getZqlx()));
			
			cell=row.createCell(6);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getBj()));
			
			cell=row.createCell(7);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getLx()));
			
			cell=row.createCell(8);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getYe()));
			
			cell=row.createCell(9);
			cell.setCellStyle(style1);
			if(ad.getMdate().length()>10){
				String ads = ad.getMdate().substring(0,10);
				cell.setCellValue(StringUtil.valueOf(ads));
			}else{
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
	
	
	// 业主余额的导出数据
	public static void exportQueryBalance(List<QueryBalance> list,
			HttpServletResponse response) throws IOException {
		OutputStream os = setStream("业主余额信息", response);
		// 第一步，创建一个webbook，对应一个Excel文件
		HSSFWorkbook wb = new HSSFWorkbook();
		// 第二步，在webbook中添加一个sheet,对应Excel文件中的sheet
		HSSFSheet sheet = wb.createSheet("业主余额信息");
		// 第三步，在sheet中添加表头第0行,注意老版本poi对Excel的行数列数有限制short
		// 设置行宽
		sheet.setColumnWidth(0, 15 * 256);
		sheet.setColumnWidth(1, 15 * 256);
		sheet.setColumnWidth(2, 15 * 256);
		sheet.setColumnWidth(3, 15 * 256);
		sheet.setColumnWidth(4, 15 * 256);
		sheet.setColumnWidth(5, 15 * 256);
		sheet.setColumnWidth(6, 15 * 256);
		sheet.setColumnWidth(7, 15 * 256);
		sheet.setColumnWidth(8, 15 * 256);
		sheet.setColumnWidth(9, 15 * 256);
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
		style1.setBorderBottom(HSSFCellStyle.BORDER_THIN); //下边框
		style1.setBorderLeft(HSSFCellStyle.BORDER_THIN);//左边框
		style1.setBorderTop(HSSFCellStyle.BORDER_THIN);//上边框
		style1.setBorderRight(HSSFCellStyle.BORDER_THIN);//右边框
		
		
		HSSFCell cell = row.createCell(0);
		cell.setCellStyle(style1);
		cell.setCellValue("业主余额信息");
		sheet.addMergedRegion(CellRangeAddress.valueOf("$A$1:$K$1"));
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
		
		// 第二行
		row = sheet.createRow((int) 1);

		cell = row.createCell(0);
		cell.setCellValue("房屋编号");
		cell.setCellStyle(style);

		cell = row.createCell(1);
		cell.setCellValue("楼宇名称");
		cell.setCellStyle(style);

		cell = row.createCell(2);
		cell.setCellValue("业主姓名");
		cell.setCellStyle(style);

		cell = row.createCell(3);
		cell.setCellValue("单元");
		cell.setCellStyle(style);

		cell = row.createCell(4);
		cell.setCellValue("层");
		cell.setCellStyle(style);

		cell = row.createCell(5);
		cell.setCellValue("房号");
		cell.setCellStyle(style);

		cell = row.createCell(6);
		cell.setCellValue("年初本金");
		cell.setCellStyle(style);

		cell = row.createCell(7);
		cell.setCellValue("增加本金");
		cell.setCellStyle(style);

		cell = row.createCell(8);
		cell.setCellValue("减少本金");
		cell.setCellStyle(style);

		cell = row.createCell(9);
		cell.setCellValue("利息余额");
		cell.setCellStyle(style);
		
		cell = row.createCell(10);
		cell.setCellValue("合计");
		cell.setCellStyle(style);

		// 第五步，写入实体数据 实际应用中这些数据从数据库得到
		for (int i = 0; i < list.size(); i++) {
			row = sheet.createRow((int) i + 2);
			QueryBalance ad = (QueryBalance) list.get(i);
			
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
			cell.setCellValue(StringUtil.valueOf(ad.getH002()));
			
			cell=row.createCell(4);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getH003()));
			
			cell=row.createCell(5);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getH005()));
			
			cell=row.createCell(6);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getNc()));
			
			cell=row.createCell(7);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getZj()));
			
			cell=row.createCell(8);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getJs()));
			
			cell=row.createCell(9);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getLx()));
			
			cell=row.createCell(10);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getHj()));

		}
		// 第六步，将文件存到指定位置
		try {

			wb.write(os);
			os.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	
	// 项目利息单的导出数据
	public static void exportProjectInterestF(List<ProjectInterestF> list,
			HttpServletResponse response) throws IOException {
		OutputStream os = setStream("项目利息单", response);
		// 第一步，创建一个webbook，对应一个Excel文件
		HSSFWorkbook wb = new HSSFWorkbook();
		// 第二步，在webbook中添加一个sheet,对应Excel文件中的sheet
		HSSFSheet sheet = wb.createSheet("项目利息单");
		// 第三步，在sheet中添加表头第0行,注意老版本poi对Excel的行数列数有限制short
		// 设置行宽
		sheet.setColumnWidth(0, 15 * 256);
		sheet.setColumnWidth(1, 15 * 256);
		sheet.setColumnWidth(2, 15 * 256);
		sheet.setColumnWidth(3, 15 * 256);
		sheet.setColumnWidth(4, 15 * 256);
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
		style1.setBorderBottom(HSSFCellStyle.BORDER_THIN); //下边框
		style1.setBorderLeft(HSSFCellStyle.BORDER_THIN);//左边框
		style1.setBorderTop(HSSFCellStyle.BORDER_THIN);//上边框
		style1.setBorderRight(HSSFCellStyle.BORDER_THIN);//右边框
		
		
		HSSFCell cell = row.createCell(0);
		cell.setCellStyle(style1);
		cell.setCellValue("项目利息单");
		sheet.addMergedRegion(CellRangeAddress.valueOf("$A$1:$E$1"));
		cell = row.createCell(1);
		cell.setCellStyle(style1);
		cell = row.createCell(2);
		cell.setCellStyle(style1);
		cell = row.createCell(3);
		cell.setCellStyle(style1);
		cell = row.createCell(4);
		cell.setCellStyle(style1);
		
		// 第二行
		row = sheet.createRow((int) 1);

		cell = row.createCell(0);
		cell.setCellValue("财务编号");
		cell.setCellStyle(style);

		cell = row.createCell(1);
		cell.setCellValue("项目编号");
		cell.setCellStyle(style);

		cell = row.createCell(2);
		cell.setCellValue("项目名称");
		cell.setCellStyle(style);

		cell = row.createCell(3);
		cell.setCellValue("增加利息");
		cell.setCellStyle(style);

		cell = row.createCell(4);
		cell.setCellValue("摘要");
		cell.setCellStyle(style);

		// 第五步，写入实体数据 实际应用中这些数据从数据库得到
		for (int i = 0; i < list.size(); i++) {
			row = sheet.createRow((int) i + 2);
			ProjectInterestF ad = (ProjectInterestF) list.get(i);
			
			// 第四步，创建单元格，并设置值
			cell=row.createCell(0);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getCwbm()));
			
			cell=row.createCell(1);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getBm()));
			
			cell=row.createCell(2);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getMc()));
			
			cell=row.createCell(3);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getW006()));
			
			cell=row.createCell(4);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getW002()));
			
		}
		// 第六步，将文件存到指定位置
		try {

			wb.write(os);
			os.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	
	// 小区利息单的导出数据
	public static void exportCommunityInterestF(List<BuildingInterestF> list,
			HttpServletResponse response) throws IOException {
		OutputStream os = setStream("小区利息单", response);
		// 第一步，创建一个webbook，对应一个Excel文件
		HSSFWorkbook wb = new HSSFWorkbook();
		// 第二步，在webbook中添加一个sheet,对应Excel文件中的sheet
		HSSFSheet sheet = wb.createSheet("小区利息单");
		// 第三步，在sheet中添加表头第0行,注意老版本poi对Excel的行数列数有限制short
		// 设置行宽
		sheet.setColumnWidth(0, 15 * 256);
		sheet.setColumnWidth(1, 15 * 256);
		sheet.setColumnWidth(2, 15 * 256);
		sheet.setColumnWidth(3, 15 * 256);
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
		style1.setBorderBottom(HSSFCellStyle.BORDER_THIN); //下边框
		style1.setBorderLeft(HSSFCellStyle.BORDER_THIN);//左边框
		style1.setBorderTop(HSSFCellStyle.BORDER_THIN);//上边框
		style1.setBorderRight(HSSFCellStyle.BORDER_THIN);//右边框
		
		
		HSSFCell cell = row.createCell(0);
		cell.setCellStyle(style1);
		cell.setCellValue("小区利息单");
		sheet.addMergedRegion(CellRangeAddress.valueOf("$A$1:$D$1"));
		cell = row.createCell(1);
		cell.setCellStyle(style1);
		cell = row.createCell(2);
		cell.setCellStyle(style1);
		cell = row.createCell(3);
		cell.setCellStyle(style1);
		
		// 第二行
		row = sheet.createRow((int) 1);

		cell = row.createCell(0);
		cell.setCellValue("小区编号");
		cell.setCellStyle(style);

		cell = row.createCell(1);
		cell.setCellValue("小区名称");
		cell.setCellStyle(style);

		cell = row.createCell(2);
		cell.setCellValue("增加利息");
		cell.setCellStyle(style);

		cell = row.createCell(3);
		cell.setCellValue("摘要");
		cell.setCellStyle(style);

		// 第五步，写入实体数据 实际应用中这些数据从数据库得到
		for (int i = 0; i < list.size(); i++) {
			row = sheet.createRow((int) i + 2);
			BuildingInterestF ad = (BuildingInterestF) list.get(i);
			
			// 第四步，创建单元格，并设置值
			cell=row.createCell(0);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getBm()));
			
			cell=row.createCell(1);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getMc()));
			
			cell=row.createCell(2);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getW006()));
			
			cell=row.createCell(3);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getW002()));
			
		}
		// 第六步，将文件存到指定位置
		try {

			wb.write(os);
			os.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	
	// 楼宇利息单的导出数据
	public static void exportBuildingInterestF(List<BuildingInterestF> list,
			HttpServletResponse response) throws IOException {
		OutputStream os = setStream("楼宇利息单", response);
		// 第一步，创建一个webbook，对应一个Excel文件
		HSSFWorkbook wb = new HSSFWorkbook();
		// 第二步，在webbook中添加一个sheet,对应Excel文件中的sheet
		HSSFSheet sheet = wb.createSheet("楼宇利息单");
		// 第三步，在sheet中添加表头第0行,注意老版本poi对Excel的行数列数有限制short
		// 设置行宽
		sheet.setColumnWidth(0, 15 * 256);
		sheet.setColumnWidth(1, 15 * 256);
		sheet.setColumnWidth(2, 15 * 256);
		sheet.setColumnWidth(3, 15 * 256);
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
		style1.setBorderBottom(HSSFCellStyle.BORDER_THIN); //下边框
		style1.setBorderLeft(HSSFCellStyle.BORDER_THIN);//左边框
		style1.setBorderTop(HSSFCellStyle.BORDER_THIN);//上边框
		style1.setBorderRight(HSSFCellStyle.BORDER_THIN);//右边框
		
		
		HSSFCell cell = row.createCell(0);
		cell.setCellStyle(style1);
		cell.setCellValue("楼宇利息单");
		sheet.addMergedRegion(CellRangeAddress.valueOf("$A$1:$D$1"));
		cell = row.createCell(1);
		cell.setCellStyle(style1);
		cell = row.createCell(2);
		cell.setCellStyle(style1);
		cell = row.createCell(3);
		cell.setCellStyle(style1);
		
		// 第二行
		row = sheet.createRow((int) 1);

		cell = row.createCell(0);
		cell.setCellValue("项目编号");
		cell.setCellStyle(style);

		cell = row.createCell(1);
		cell.setCellValue("项目名称");
		cell.setCellStyle(style);

		cell = row.createCell(2);
		cell.setCellValue("增加利息");
		cell.setCellStyle(style);

		cell = row.createCell(3);
		cell.setCellValue("摘要");
		cell.setCellStyle(style);

		// 第五步，写入实体数据 实际应用中这些数据从数据库得到
		for (int i = 0; i < list.size(); i++) {
			row = sheet.createRow((int) i + 2);
			BuildingInterestF ad = (BuildingInterestF) list.get(i);
			
			// 第四步，创建单元格，并设置值
			cell=row.createCell(0);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getBm()));
			
			cell=row.createCell(1);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getMc()));
			
			cell=row.createCell(2);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getW006()));
			
			cell=row.createCell(3);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getW002()));
			
		}
		// 第六步，将文件存到指定位置
		try {

			wb.write(os);
			os.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	
	// 楼宇利息明细的导出数据
	public static void exportDetailBuildingI(List<DetailBuildingI> list,
			HttpServletResponse response) throws IOException {
		OutputStream os = setStream("楼宇利息明细", response);
		// 第一步，创建一个webbook，对应一个Excel文件
		HSSFWorkbook wb = new HSSFWorkbook();
		// 第二步，在webbook中添加一个sheet,对应Excel文件中的sheet
		HSSFSheet sheet = wb.createSheet("楼宇利息明细");
		// 第三步，在sheet中添加表头第0行,注意老版本poi对Excel的行数列数有限制short
		// 设置行宽
		sheet.setColumnWidth(0, 15 * 256);
		sheet.setColumnWidth(1, 15 * 256);
		sheet.setColumnWidth(2, 15 * 256);
		sheet.setColumnWidth(3, 15 * 256);
		sheet.setColumnWidth(4, 15 * 256);
		sheet.setColumnWidth(5, 15 * 256);
		sheet.setColumnWidth(6, 15 * 256);
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
		style1.setBorderBottom(HSSFCellStyle.BORDER_THIN); //下边框
		style1.setBorderLeft(HSSFCellStyle.BORDER_THIN);//左边框
		style1.setBorderTop(HSSFCellStyle.BORDER_THIN);//上边框
		style1.setBorderRight(HSSFCellStyle.BORDER_THIN);//右边框
		
		
		HSSFCell cell = row.createCell(0);
		cell.setCellStyle(style1);
		cell.setCellValue("楼宇利息明细");
		sheet.addMergedRegion(CellRangeAddress.valueOf("$A$1:$G$1"));
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
		
		// 第二行
		row = sheet.createRow((int) 1);

		cell = row.createCell(0);
		cell.setCellValue("楼宇名称");
		cell.setCellStyle(style);

		cell = row.createCell(1);
		cell.setCellValue("期初余额");
		cell.setCellStyle(style);

		cell = row.createCell(2);
		cell.setCellValue("利息期初");
		cell.setCellStyle(style);

		cell = row.createCell(3);
		cell.setCellValue("利息本期增加");
		cell.setCellStyle(style);
		
		cell = row.createCell(4);
		cell.setCellValue("利息本期减少");
		cell.setCellStyle(style);

		cell = row.createCell(5);
		cell.setCellValue("利息期末余额");
		cell.setCellStyle(style);

		cell = row.createCell(6);
		cell.setCellValue("本金期末余额");
		cell.setCellStyle(style);

		// 第五步，写入实体数据 实际应用中这些数据从数据库得到
		for (int i = 0; i < list.size(); i++) {
			row = sheet.createRow((int) i + 2);
			DetailBuildingI ad = (DetailBuildingI) list.get(i);
			
			// 第四步，创建单元格，并设置值
			cell=row.createCell(0);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getLymc()));
			
			cell=row.createCell(1);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getQcje()));
			
			cell=row.createCell(2);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getQclx()));
			
			cell=row.createCell(3);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getZjje()));
			
			cell=row.createCell(4);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getJsje()));
			
			cell=row.createCell(5);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getBqje()));
			
			cell=row.createCell(6);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getQmbj()));
			
		}
		// 第六步，将文件存到指定位置
		try {

			wb.write(os);
			os.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	
	// 汇缴清册的导出数据
	public static void exportQueryPaymentS(List<QueryPaymentS> list,
			HttpServletResponse response) throws IOException {
		OutputStream os = setStream("汇缴清册信息", response);
		// 第一步，创建一个webbook，对应一个Excel文件
		HSSFWorkbook wb = new HSSFWorkbook();
		// 第二步，在webbook中添加一个sheet,对应Excel文件中的sheet
		HSSFSheet sheet = wb.createSheet("汇缴清册信息");
		// 第三步，在sheet中添加表头第0行,注意老版本poi对Excel的行数列数有限制short
		// 设置行宽
		sheet.setColumnWidth(0, 15 * 256);
		sheet.setColumnWidth(1, 15 * 256);
		sheet.setColumnWidth(2, 15 * 256);
		sheet.setColumnWidth(3, 15 * 256);
		sheet.setColumnWidth(4, 15 * 256);
		sheet.setColumnWidth(5, 15 * 256);
		sheet.setColumnWidth(6, 15 * 256);
		sheet.setColumnWidth(7, 15 * 256);
		sheet.setColumnWidth(8, 15 * 256);
		sheet.setColumnWidth(9, 15 * 256);
		sheet.setColumnWidth(10, 15 * 256);
		sheet.setColumnWidth(11, 15 * 256);
		sheet.setColumnWidth(12, 15 * 256);
		sheet.setColumnWidth(13, 15 * 256);
		sheet.setColumnWidth(14, 15 * 256);
		sheet.setColumnWidth(15, 15 * 256);
		sheet.setColumnWidth(16, 15 * 256);
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
		style1.setBorderBottom(HSSFCellStyle.BORDER_THIN); //下边框
		style1.setBorderLeft(HSSFCellStyle.BORDER_THIN);//左边框
		style1.setBorderTop(HSSFCellStyle.BORDER_THIN);//上边框
		style1.setBorderRight(HSSFCellStyle.BORDER_THIN);//右边框
		
		
		HSSFCell cell = row.createCell(0);
		cell.setCellStyle(style1);
		cell.setCellValue("汇缴清册信息");
		sheet.addMergedRegion(CellRangeAddress.valueOf("$A$1:$Q$1"));
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
		cell = row.createCell(13);
		cell.setCellStyle(style1);
		cell = row.createCell(14);
		cell.setCellStyle(style1);
		cell = row.createCell(15);
		cell.setCellStyle(style1);
		cell = row.createCell(16);
		cell.setCellStyle(style1);
		
		// 第二行
		row = sheet.createRow((int) 1);

		cell = row.createCell(0);
		cell.setCellValue("楼宇名称");
		cell.setCellStyle(style);

		cell = row.createCell(1);
		cell.setCellValue("总层数");
		cell.setCellStyle(style);

		cell = row.createCell(2);
		cell.setCellValue("本栋建面");
		cell.setCellStyle(style);

		cell = row.createCell(3);
		cell.setCellValue("单元");
		cell.setCellStyle(style);
		
		cell = row.createCell(4);
		cell.setCellValue("层");
		cell.setCellStyle(style);

		cell = row.createCell(5);
		cell.setCellValue("房号");
		cell.setCellStyle(style);

		cell = row.createCell(6);
		cell.setCellValue("户型");
		cell.setCellStyle(style);
		
		cell = row.createCell(7);
		cell.setCellValue("业主姓名");
		cell.setCellStyle(style);

		cell = row.createCell(8);
		cell.setCellValue("产权证号");
		cell.setCellStyle(style);

		cell = row.createCell(9);
		cell.setCellValue("建面");
		cell.setCellStyle(style);

		cell = row.createCell(10);
		cell.setCellValue("套面");
		cell.setCellStyle(style);
		
		cell = row.createCell(11);
		cell.setCellValue("购房总额");
		cell.setCellStyle(style);

		cell = row.createCell(12);
		cell.setCellValue("比例");
		cell.setCellStyle(style);

		cell = row.createCell(13);
		cell.setCellValue("汇缴金额");
		cell.setCellStyle(style);
		
		cell = row.createCell(14);
		cell.setCellValue("房屋类型");
		cell.setCellStyle(style);

		cell = row.createCell(15);
		cell.setCellValue("房屋类别");
		cell.setCellStyle(style);
		
		cell = row.createCell(16);
		cell.setCellValue("房屋性质");
		cell.setCellStyle(style);

		// 第五步，写入实体数据 实际应用中这些数据从数据库得到
		for (int i = 0; i < list.size(); i++) {
			row = sheet.createRow((int) i + 2);
			QueryPaymentS ad = (QueryPaymentS) list.get(i);
			
			// 第四步，创建单元格，并设置值
			cell=row.createCell(0);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getLymc()));
			
			cell=row.createCell(1);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getCs()));
			
			cell=row.createCell(2);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getZjzmj()));
			
			cell=row.createCell(3);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getH002()));
			
			cell=row.createCell(4);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getH003()));
			
			cell=row.createCell(5);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getH005()));
			
			cell=row.createCell(6);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getH033()));
			
			cell=row.createCell(7);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getH013()));
			
			cell=row.createCell(8);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getH016()));
			
			cell=row.createCell(9);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getH006()));
			
			cell=row.createCell(10);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getH007()));
			
			cell=row.createCell(11);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getH010()));
			
			cell=row.createCell(12);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getBl()));
			
			cell=row.createCell(13);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getH030()));
			
			cell=row.createCell(14);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getH018()));
			
			cell=row.createCell(15);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getH045()));
			
			cell=row.createCell(16);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getH012()));
			
		}
		// 第六步，将文件存到指定位置
		try {

			wb.write(os);
			os.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	
	// 户数统计的导出数据
	public static void exportCountHouse(List<CountHouse> list,
			HttpServletResponse response) throws IOException {
		OutputStream os = setStream("户数统计信息", response);
		// 第一步，创建一个webbook，对应一个Excel文件
		HSSFWorkbook wb = new HSSFWorkbook();
		// 第二步，在webbook中添加一个sheet,对应Excel文件中的sheet
		HSSFSheet sheet = wb.createSheet("户数统计信息");
		// 第三步，在sheet中添加表头第0行,注意老版本poi对Excel的行数列数有限制short
		// 设置行宽
		sheet.setColumnWidth(0, 15 * 256);
		sheet.setColumnWidth(1, 15 * 256);
		sheet.setColumnWidth(2, 15 * 256);
		sheet.setColumnWidth(3, 15 * 256);
		sheet.setColumnWidth(4, 15 * 256);
		sheet.setColumnWidth(5, 15 * 256);
		sheet.setColumnWidth(6, 15 * 256);
		sheet.setColumnWidth(7, 15 * 256);
		sheet.setColumnWidth(8, 15 * 256);
		sheet.setColumnWidth(9, 15 * 256);
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
		style1.setBorderBottom(HSSFCellStyle.BORDER_THIN); //下边框
		style1.setBorderLeft(HSSFCellStyle.BORDER_THIN);//左边框
		style1.setBorderTop(HSSFCellStyle.BORDER_THIN);//上边框
		style1.setBorderRight(HSSFCellStyle.BORDER_THIN);//右边框
		
		
		HSSFCell cell = row.createCell(0);
		cell.setCellStyle(style1);
		cell.setCellValue("户数统计信息");
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
		
		// 第二行
		row = sheet.createRow((int) 1);

		cell = row.createCell(0);
		cell.setCellValue("项目名称");
		cell.setCellStyle(style);

		cell = row.createCell(1);
		cell.setCellValue("期初户数");
		cell.setCellStyle(style);

		cell = row.createCell(2);
		cell.setCellValue("期初金额");
		cell.setCellStyle(style);

		cell = row.createCell(3);
		cell.setCellValue("本期户数");
		cell.setCellStyle(style);
		
		cell = row.createCell(4);
		cell.setCellValue("增加本金");
		cell.setCellStyle(style);

		cell = row.createCell(5);
		cell.setCellValue("增加利息");
		cell.setCellStyle(style);

		cell = row.createCell(6);
		cell.setCellValue("户数");
		cell.setCellStyle(style);
		
		cell = row.createCell(7);
		cell.setCellValue("减少本金");
		cell.setCellStyle(style);

		cell = row.createCell(8);
		cell.setCellValue("减少利息");
		cell.setCellStyle(style);

		cell = row.createCell(9);
		cell.setCellValue("累计户数");
		cell.setCellStyle(style);

		cell = row.createCell(10);
		cell.setCellValue("累计本金");
		cell.setCellStyle(style);
		
		cell = row.createCell(11);
		cell.setCellValue("累计利息");
		cell.setCellStyle(style);

		cell = row.createCell(12);
		cell.setCellValue("累计金额");
		cell.setCellStyle(style);

		// 第五步，写入实体数据 实际应用中这些数据从数据库得到
		for (int i = 0; i < list.size(); i++) {
			row = sheet.createRow((int) i + 2);
			CountHouse ad = (CountHouse) list.get(i);
			
			// 第四步，创建单元格，并设置值
			cell=row.createCell(0);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getXqmc()));
			
			cell=row.createCell(1);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getQchs()));
			
			cell=row.createCell(2);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getQcje()));
			
			cell=row.createCell(3);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getByhs()));
			
			cell=row.createCell(4);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getZjje()));
			
			cell=row.createCell(5);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getZjlx()));
			
			cell=row.createCell(6);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getJshs()));
			
			cell=row.createCell(7);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getJsje()));
			
			cell=row.createCell(8);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getJslx()));
			
			cell=row.createCell(9);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getBqhs()));
			
			cell=row.createCell(10);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getBjye()));
			
			cell=row.createCell(11);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getLxye()));
			
			cell=row.createCell(12);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getBqje()));
			
			
		}
		// 第六步，将文件存到指定位置
		try {

			wb.write(os);
			os.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	// 导出系统日志信息
	public static void exportSysLog(List<Log> list,
			HttpServletResponse response) throws IOException {
		OutputStream os = setStream("系统日志信息", response);
		// 第一步，创建一个webbook，对应一个Excel文件
		HSSFWorkbook wb = new HSSFWorkbook();
		// 第二步，在webbook中添加一个sheet,对应Excel文件中的sheet
		HSSFSheet sheet = wb.createSheet("系统日志信息");
		// 第三步，在sheet中添加表头第0行,注意老版本poi对Excel的行数列数有限制short
		// 设置行宽
		sheet.setColumnWidth(0, 40 * 256);
		sheet.setColumnWidth(1, 20 * 256);
		sheet.setColumnWidth(2, 15 * 256);
		sheet.setColumnWidth(3, 40 * 256);
		sheet.setColumnWidth(4, 40 * 256);
		sheet.setColumnWidth(5, 15 * 256);
		sheet.setColumnWidth(6, 15 * 256);
		sheet.setColumnWidth(7, 30 * 256);
		
		
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
		style1.setBorderBottom(HSSFCellStyle.BORDER_THIN); //下边框
		style1.setBorderLeft(HSSFCellStyle.BORDER_THIN);//左边框
		style1.setBorderTop(HSSFCellStyle.BORDER_THIN);//上边框
		style1.setBorderRight(HSSFCellStyle.BORDER_THIN);//右边框
		style1.setWrapText(true);//自动换行
		
		
		HSSFCell cell = row.createCell(0);
		cell.setCellStyle(style1);
		cell.setCellValue("系统日志信息");
		sheet.addMergedRegion(CellRangeAddress.valueOf("$A$1:$H$1"));
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
		
		
		// 第二行
		row = sheet.createRow((int) 1);
		
		cell = row.createCell(0);
		cell.setCellValue("ID");
		cell.setCellStyle(style);

		cell = row.createCell(1);
		cell.setCellValue("菜单");
		cell.setCellStyle(style);

		cell = row.createCell(2);
		cell.setCellValue("操作");
		cell.setCellStyle(style);

		cell = row.createCell(3);
		cell.setCellValue("动作");
		cell.setCellStyle(style);

		cell = row.createCell(4);
		cell.setCellValue("执行参数");
		cell.setCellStyle(style);

		cell = row.createCell(5);
		cell.setCellValue("用户ID");
		cell.setCellStyle(style);

		cell = row.createCell(6);
		cell.setCellValue("用户名");
		cell.setCellStyle(style);

		cell = row.createCell(7);
		cell.setCellValue("操作日期");
		cell.setCellStyle(style);
	

		// 第五步，写入实体数据 实际应用中这些数据从数据库得到
		for (int i = 0; i < list.size(); i++) {
			row = sheet.createRow((int) i + 2);
			Log ad = (Log) list.get(i);
			
			// 第四步，创建单元格，并设置值
			cell=row.createCell(0);
			cell.setCellStyle(style1);
			
			
			cell.setCellValue(StringUtil.valueOf(ad.getId()));
			
			
			cell=row.createCell(1);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getMenu()));
			
			cell=row.createCell(2);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getOperate()));
			
			cell=row.createCell(3);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getAction()));
			
			cell=row.createCell(4);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getParams()));
			
			cell=row.createCell(5);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getUserid()));
			
			cell=row.createCell(6);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getUsername()));
			
			cell=row.createCell(7);
			cell.setCellStyle(style1);
			String s = StringUtil.valueOf(ad.getOperatdate());
	        SimpleDateFormat sf1 = new SimpleDateFormat("EEE MMM dd hh:mm:ss z yyyy", Locale.ENGLISH); 
	        Date date = null;
			try {
				date = sf1.parse(s);
				SimpleDateFormat sf2 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				
				cell.setCellValue(StringUtil.valueOf(sf2.format(date)));
			} catch (ParseException e) {
				e.printStackTrace();
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

	// 导出银行日志信息
	public static void exportBankLog(List<BankLog> list,
			HttpServletResponse response) throws IOException {
		OutputStream os = setStream("银行日志信息", response);
		// 第一步，创建一个webbook，对应一个Excel文件
		HSSFWorkbook wb = new HSSFWorkbook();
		// 第二步，在webbook中添加一个sheet,对应Excel文件中的sheet
		HSSFSheet sheet = wb.createSheet("银行日志信息");
		// 第三步，在sheet中添加表头第0行,注意老版本poi对Excel的行数列数有限制short
		// 设置行宽
		sheet.setColumnWidth(0, 30 * 256);
		sheet.setColumnWidth(1, 20 * 256);
		sheet.setColumnWidth(2, 20 * 256);
		sheet.setColumnWidth(3, 50 * 256);
		sheet.setColumnWidth(4, 30 * 256);
		sheet.setColumnWidth(5, 30 * 256);
		
		
		
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
		style1.setBorderBottom(HSSFCellStyle.BORDER_THIN); //下边框
		style1.setBorderLeft(HSSFCellStyle.BORDER_THIN);//左边框
		style1.setBorderTop(HSSFCellStyle.BORDER_THIN);//上边框
		style1.setBorderRight(HSSFCellStyle.BORDER_THIN);//右边框
		style1.setWrapText(true);//自动换行
		
		
		HSSFCell cell = row.createCell(0);
		cell.setCellStyle(style1);
		cell.setCellValue("银行日志信息");
		sheet.addMergedRegion(CellRangeAddress.valueOf("$A$1:$F$1"));
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
		
		
		// 第二行
		row = sheet.createRow((int) 1);
		
		cell = row.createCell(0);
		cell.setCellValue("银行");
		cell.setCellStyle(style);

		cell = row.createCell(1);
		cell.setCellValue("方法");
		cell.setCellStyle(style);

		cell = row.createCell(2);
		cell.setCellValue("业务类型");
		cell.setCellStyle(style);

		cell = row.createCell(3);
		cell.setCellValue("输出数据");
		cell.setCellStyle(style);

		cell = row.createCell(4);
		cell.setCellValue("请求时间");
		cell.setCellStyle(style);

		cell = row.createCell(5);
		cell.setCellValue("响应时间");
		cell.setCellStyle(style);
		

		// 第五步，写入实体数据 实际应用中这些数据从数据库得到
		for (int i = 0; i < list.size(); i++) {
			row = sheet.createRow((int) i + 2);
			BankLog ad = (BankLog) list.get(i);
			
			// 第四步，创建单元格，并设置值
			cell=row.createCell(0);
			cell.setCellStyle(style1);
			
			
			cell.setCellValue(StringUtil.valueOf(ad.getMc()));
			
			
			cell=row.createCell(1);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getMethod()));
			
			cell=row.createCell(2);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getType()));
			
			cell=row.createCell(3);
			cell.setCellStyle(style1);
			String out = StringUtil.valueOf(ad.getOut_xml());
			cell.setCellValue(out.substring(out.indexOf("<error>")+7,out.indexOf("</error>"))+
					out.substring(out.indexOf("<des>")+5,out.indexOf("</des>")));
			
			cell=row.createCell(4);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getIn_time()));
			
			cell=row.createCell(5);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getOut_time()));
			
			
//			cell=row.createCell(7);
//			cell.setCellStyle(style1);
//			String s = StringUtil.valueOf(ad.getOperatdate());
//	        SimpleDateFormat sf1 = new SimpleDateFormat("EEE MMM dd hh:mm:ss z yyyy", Locale.ENGLISH); 
//	        Date date = null;
//			try {
//				date = sf1.parse(s);
//				SimpleDateFormat sf2 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
//				
//				cell.setCellValue(StringUtil.valueOf(sf2.format(date)));
//			} catch (ParseException e) {
//				e.printStackTrace();
//			}
	        

		}
		// 第六步，将文件存到指定位置
		try {

			wb.write(os);
			os.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 是否打印行数据
	 * @return false：不打印，true：打印
	 */
	private static boolean isPrintRow(List<String> itemList, ByBuildingForC1 data) {
		if (itemList.contains("w004") && !data.getW004().equals("0.00")) {
			return true;
		}
		if (itemList.contains("w005") && !data.getW005().equals("0.00")) {
			return true;
		}
		if (itemList.contains("z004") && !data.getZ004().equals("0.00")) {
			return true;
		}
		if (itemList.contains("z005") && !data.getZ005().equals("0.00")) {
			return true;
		}
		if (itemList.contains("bjye") && !data.getBjye().equals("0.00")) {
			return true;
		}
		if (itemList.contains("lxye") && !data.getLxye().equals("0.00")) {
			return true;
		}
		if (itemList.contains("xj") && !data.getXj().equals("0.00")) {
			return true;
		}
		return false;
	}
	
	
		// 小区缴款查询的导出数据
		public static void exportCommunityP(List<QueryCommunityP> list,String xqmc,
				HttpServletResponse response) throws IOException {
			OutputStream os = setStream(xqmc, response);
			// 第一步，创建一个webbook，对应一个Excel文件
			HSSFWorkbook wb = new HSSFWorkbook();
			// 第二步，在webbook中添加一个sheet,对应Excel文件中的sheet
			HSSFSheet sheet = wb.createSheet(xqmc);
			// 第三步，在sheet中添加表头第0行,注意老版本poi对Excel的行数列数有限制short
			// 设置行宽
			sheet.setColumnWidth(0, 20 * 256);
			sheet.setColumnWidth(1, 20 * 256);
			sheet.setColumnWidth(2, 20 * 256);
			sheet.setColumnWidth(3, 20 * 256);
			sheet.setColumnWidth(4, 20 * 256);
			sheet.setColumnWidth(5, 20 * 256);
			sheet.setColumnWidth(6, 20 * 256);
			sheet.setColumnWidth(7, 20 * 256);
			sheet.setColumnWidth(8, 20 * 256);
			sheet.setColumnWidth(9, 20 * 256);
			sheet.setColumnWidth(10, 20 * 256);
			
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
			HSSFFont font1 = wb.createFont();
			font1.setFontName("方正楷体_GBK");
			font1.setFontHeightInPoints((short) 14);//设置字体大小
			font1.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);//粗体显示
			style.setFont(font1);
			
			// 创建样式2：字体居中，单元格无背景色
			HSSFCellStyle style1 = (HSSFCellStyle) wb.createCellStyle();
			style1.setAlignment(HSSFCellStyle.ALIGN_CENTER); // 创建一个居中格式
			style1.setBorderBottom(HSSFCellStyle.BORDER_THIN); //下边框
			style1.setBorderLeft(HSSFCellStyle.BORDER_THIN);//左边框
			style1.setBorderTop(HSSFCellStyle.BORDER_THIN);//上边框
			style1.setBorderRight(HSSFCellStyle.BORDER_THIN);//右边框
			
			HSSFCellStyle style2 = (HSSFCellStyle) wb.createCellStyle();
			style2.setAlignment(HSSFCellStyle.ALIGN_CENTER); // 创建一个居中格式
			style2.setBorderBottom(HSSFCellStyle.BORDER_THIN); //下边框
			style2.setBorderLeft(HSSFCellStyle.BORDER_THIN);//左边框
			style2.setBorderTop(HSSFCellStyle.BORDER_THIN);//上边框
			style2.setBorderRight(HSSFCellStyle.BORDER_THIN);//右边框
			HSSFFont font2 = wb.createFont();
			font2.setFontName("方正楷体_GBK");
			font2.setFontHeightInPoints((short) 18);//设置字体大小
			font2.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);//粗体显示
			style2.setFont(font2);
			
			HSSFCell cell = row.createCell(0);
			cell.setCellStyle(style2);
			cell.setCellValue(xqmc);
			sheet.addMergedRegion(CellRangeAddress.valueOf("$A$1:$K$1"));
			cell = row.createCell(1);
			cell.setCellStyle(style1);
			row.setZeroHeight(false);
			row.setHeight((short) 800);
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
			// 第二行
			row = sheet.createRow((int) 1);

			cell = row.createCell(0);
			cell.setCellValue("小区名称");
			cell.setCellStyle(style);

			cell = row.createCell(1);
			cell.setCellValue("开发建设单位");
			cell.setCellStyle(style);

			cell = row.createCell(2);
			cell.setCellValue("小区户数");
			cell.setCellStyle(style);

			cell = row.createCell(3);
			cell.setCellValue("小区面积");
			cell.setCellStyle(style);

			cell = row.createCell(4);
			cell.setCellValue("应缴金额");
			cell.setCellStyle(style);

			cell = row.createCell(5);
			cell.setCellValue("实缴户数");
			cell.setCellStyle(style);

			cell = row.createCell(6);
			cell.setCellValue("实缴面积");
			cell.setCellStyle(style);

			cell = row.createCell(7);
			cell.setCellValue("实缴金额");
			cell.setCellStyle(style);
			
			cell = row.createCell(8);
			cell.setCellValue("未交户数");
			cell.setCellStyle(style);
			
			cell = row.createCell(9);
			cell.setCellValue("未交面积");
			cell.setCellStyle(style);
			
			cell = row.createCell(10);
			cell.setCellValue("未交金额");
			cell.setCellStyle(style);

			// 第五步，写入实体数据 实际应用中这些数据从数据库得到
			for (int i = 0; i < list.size(); i++) {
				row = sheet.createRow((int) i + 2);
				QueryCommunityP ad = (QueryCommunityP) list.get(i);
				
				// 第四步，创建单元格，并设置值
				cell=row.createCell(0);
				cell.setCellStyle(style1);
				cell.setCellValue(StringUtil.valueOf(ad.getXqmc()));
				
				cell=row.createCell(1);
				cell.setCellStyle(style1);
				cell.setCellValue(StringUtil.valueOf(ad.getDwmc()));
				
				cell=row.createCell(2);
				cell.setCellStyle(style1);
				cell.setCellValue(StringUtil.valueOf(ad.getShs()));
				
				cell=row.createCell(3);
				cell.setCellStyle(style1);
				cell.setCellValue(StringUtil.valueOf(ad.getSh006()));
				
				cell=row.createCell(4);
				cell.setCellStyle(style1);
				cell.setCellValue(StringUtil.valueOf(ad.getSh021()));
				
				cell=row.createCell(5);
				cell.setCellStyle(style1);
				cell.setCellValue(StringUtil.valueOf(ad.getPhs()));
				
				cell=row.createCell(6);
				cell.setCellStyle(style1);
				cell.setCellValue(StringUtil.valueOf(ad.getPh006()));
				
				cell=row.createCell(7);
				cell.setCellStyle(style1);
				cell.setCellValue(StringUtil.valueOf(ad.getPh021()));
				
				cell=row.createCell(8);
				cell.setCellStyle(style1);
				cell.setCellValue(StringUtil.valueOf(ad.getUhs()));
				
				cell=row.createCell(9);
				cell.setCellStyle(style1);
				cell.setCellValue(StringUtil.valueOf(ad.getUh006()));
				
				cell=row.createCell(10);
				cell.setCellStyle(style1);
				cell.setCellValue(StringUtil.valueOf(ad.getUh021()));
				
				/*
				cell=row.createCell(7);
				cell.setCellStyle(style1);
				if(ad.getMdate().length()>10){
					String ads = ad.getMdate().substring(0,10);
					cell.setCellValue(StringUtil.valueOf(ads));
				}else{
				    cell.setCellValue(StringUtil.valueOf(ad.getMdate()));
				}
				*/
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

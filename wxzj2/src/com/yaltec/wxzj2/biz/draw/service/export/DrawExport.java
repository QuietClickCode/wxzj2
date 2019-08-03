package com.yaltec.wxzj2.biz.draw.service.export;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
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
import com.yaltec.comon.utils.Urlencryption;
import com.yaltec.wxzj2.biz.draw.entity.ShareAD;

/**
 * 支取分摊导出
 * @author 亚亮科技有限公司.YL
 *
 * @version: 2016-9-2 上午11:08:32
 */
public class DrawExport {
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

	public static void exportShareAD(List<ShareAD> list,String xqmc,
			HttpServletResponse response) throws IOException {
		xqmc=Urlencryption.unescape(xqmc);
		OutputStream os = setStream(xqmc+"物业专项维修资金支取分摊明细", response);
		// 第一步，创建一个webbook，对应一个Excel文件
		HSSFWorkbook wb = new HSSFWorkbook();
		// 第二步，在webbook中添加一个sheet,对应Excel文件中的sheet
		HSSFSheet sheet = wb.createSheet(xqmc+"物业专项维修资金支取分摊明细");
		// 第三步，在sheet中添加表头第0行,注意老版本poi对Excel的行数列数有限制short
		// 设置行宽
		sheet.setColumnWidth(0, 20 * 256);
		sheet.setColumnWidth(4, 20 * 256);
		sheet.setColumnWidth(15, 20 * 256);
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
		style.setWrapText(true);//自动换行
		style.setBorderBottom(HSSFCellStyle.BORDER_THIN); //下边框
		style.setBorderLeft(HSSFCellStyle.BORDER_THIN);//左边框
		style.setBorderTop(HSSFCellStyle.BORDER_THIN);//上边框
		style.setBorderRight(HSSFCellStyle.BORDER_THIN);//右边框
		style.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());// 设置背景色
		style.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
		
		// 创建样式2：字体居中，单元格无背景色
		HSSFCellStyle style1 = (HSSFCellStyle) wb.createCellStyle();
		style1.setAlignment(HSSFCellStyle.ALIGN_CENTER); // 创建一个居中格式
		style1.setWrapText(true);//自动换行
		style1.setBorderBottom(HSSFCellStyle.BORDER_THIN); //下边框
		style1.setBorderLeft(HSSFCellStyle.BORDER_THIN);//左边框
		style1.setBorderTop(HSSFCellStyle.BORDER_THIN);//上边框
		style1.setBorderRight(HSSFCellStyle.BORDER_THIN);//右边框

		HSSFCell cell = row.createCell(0);
		cell.setCellValue(xqmc+"物业专项维修资金支取分摊明细");
		cell.setCellStyle(style);

		sheet.addMergedRegion(CellRangeAddress.valueOf("$A$1:$B$1"));

		cell = row.createCell(2);
		cell.setCellValue("共有");
		cell.setCellStyle(style);

		cell = row.createCell(3);
		cell.setCellValue(list.size()-1);
		cell.setCellStyle(style);

		cell = row.createCell(4);
		cell.setCellValue("条记录");
		cell.setCellStyle(style);

		

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

//		int zhs = 0;
//		double zmj = 0.0;
		for (int i = 0; i < list.size(); i++) {
			row = sheet.createRow((int) i + 2);
			ShareAD ad = (ShareAD) list.get(i);
			
			// 第四步，创建单元格，并设置值
			row.createCell(0).setCellValue(StringUtil.valueOf(ad.getH001()));
			row.createCell(1).setCellValue(StringUtil.valueOf(ad.getH002()));
			row.createCell(2).setCellValue(StringUtil.valueOf(ad.getH003()));
			row.createCell(3).setCellValue(StringUtil.valueOf(ad.getH005()));
			row.createCell(4).setCellValue(StringUtil.valueOf(ad.getH013()));
			row.createCell(5).setCellValue(StringUtil.valueOf(ad.getH006()));
			row.createCell(6).setCellValue(StringUtil.valueOf(ad.getH015()));
			row.createCell(7).setCellValue(StringUtil.valueOf(ad.getFtje()));
			row.createCell(8).setCellValue(StringUtil.valueOf(ad.getZqbj()));
			row.createCell(9).setCellValue(StringUtil.valueOf(ad.getZqlx()));
			row.createCell(10).setCellValue(StringUtil.valueOf(ad.getZcje()));
			row.createCell(11).setCellValue(StringUtil.valueOf(ad.getH030()));
			row.createCell(12).setCellValue(StringUtil.valueOf(ad.getH031()));
			row.createCell(13).setCellValue(StringUtil.valueOf(ad.getBjye()));
			row.createCell(14).setCellValue(StringUtil.valueOf(ad.getLxye()));
			row.createCell(15).setCellValue(StringUtil.valueOf(ad.getLymc()));
		}
		// 第六步，将文件存到指定位置
		try {

//			FileOutputStream fout = new FileOutputStream("E:/ad.xls");
//			wb.write(os);
			wb.write(os);
			os.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public static void exportShareAD_GDYH(List<ShareAD> list,String bm,String workDir,
			HttpServletResponse response) throws IOException {
		// 第一步，创建一个webbook，对应一个Excel文件
		HSSFWorkbook wb = new HSSFWorkbook();
		// 第二步，在webbook中添加一个sheet,对应Excel文件中的sheet
		HSSFSheet sheet = wb.createSheet("Sheet1");
		// 第三步，在sheet中添加表头第0行,注意老版本poi对Excel的行数列数有限制short
		
		// 第四步，创建单元格，并设置值表头 设置表头居中
		HSSFFont titleFont = wb.createFont();// 字体
		titleFont.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
		titleFont.setFontHeightInPoints((short) 10);

		// 创建样式1：字体加粗、居中，单元格背景色为灰色
		HSSFCellStyle style = wb.createCellStyle();
		style.setAlignment(HSSFCellStyle.ALIGN_CENTER); // 创建一个居中格式
		style.setFont(titleFont);
		style.setWrapText(true);//自动换行
		style.setBorderBottom(HSSFCellStyle.BORDER_THIN); //下边框
		style.setBorderLeft(HSSFCellStyle.BORDER_THIN);//左边框
		style.setBorderTop(HSSFCellStyle.BORDER_THIN);//上边框
		style.setBorderRight(HSSFCellStyle.BORDER_THIN);//右边框
		style.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());// 设置背景色
		style.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
		
		// 第一行
		HSSFRow row = sheet.createRow((int) 0);

		HSSFCell cell = row.createCell(0);
		cell.setCellValue("地房籍号(或唯一标识）");
		cell.setCellStyle(style);

		cell = row.createCell(1);
		cell.setCellValue("所有者*(100)");
		cell.setCellStyle(style);

		cell = row.createCell(2);
		cell.setCellValue("本金*(12.2)");
		cell.setCellStyle(style);

		cell = row.createCell(3);
		cell.setCellValue("利息*(12.2)");
		cell.setCellStyle(style);

		cell = row.createCell(4);
		cell.setCellValue("备注(100)");
		cell.setCellStyle(style);

		// 第五步，写入实体数据 实际应用中这些数据从数据库得到
		for (int i = 0; i < list.size(); i++) {
			row = sheet.createRow((int) i + 1);
			ShareAD ad = (ShareAD) list.get(i);
			
			row.createCell(0).setCellValue(StringUtil.valueOf(ad.getH001()));
			row.createCell(1).setCellValue(StringUtil.valueOf(ad.getH013()));
			row.createCell(2).setCellValue(StringUtil.valueOf(ad.getFtje()));
			row.createCell(3).setCellValue("0");
			if (StringUtil.hasText(ad.getZ003())&& ad.getZ003().length() >=10) {
				row.createCell(4).setCellValue(ad.getZ003().substring(0, 10));
			} else {
				row.createCell(4).setCellValue("");
			}
		}
		// 第六步，将文件存到指定位置
		String path = workDir+"/"+bm+".xls";
		try {
			File file = new File(path);
			// 目录不存在则重新创建
			if (!file.getParentFile().exists()) {
				file.getParentFile().mkdirs();
			}
			// 删除相同名称的文件
			if (file.exists()) {
				file.delete();
			}
			FileOutputStream fout = new FileOutputStream(path);
			
			
			wb.write(fout);
			fout.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public static void exportShareAD_GDYH_TXT(List<ShareAD> list,String bm, String workDir,
			HttpServletResponse response) throws IOException {
		// 第六步，将文件存到指定位置
		String path = workDir+"/ZC"+bm+".txt";
		try {
			File file = new File(path);
			// 目录不存在则重新创建
			if (!file.getParentFile().exists()) {
				file.getParentFile().mkdirs();
			}
			// 删除相同名称的文件
			if (file.exists()) {
				file.delete();
			}
			FileOutputStream fout = new FileOutputStream(file);
			
			OutputStreamWriter write = new OutputStreamWriter(fout,"UTF-8");
	        BufferedWriter writer=new BufferedWriter(write);
	        StringBuffer sb = new StringBuffer();
	        for (ShareAD shareAD :list) {
	        	sb.append(shareAD.getH001()).append("|");
	        	sb.append(shareAD.getH013()).append("|");
	        	sb.append(shareAD.getLymc()).append("|");
	        	sb.append(shareAD.getH002()).append("|");
	        	sb.append(shareAD.getH003()).append("|");
	        	sb.append(shareAD.getH005()).append("|");
	        	sb.append(shareAD.getFtje()).append("|");
	        	sb.append(shareAD.getWxxm()).append("\r\n");
	        	
	        	writer.write(sb.toString());
	        	sb.setLength(0);
			}
	        writer.flush();
	        writer.close();
	        fout.close();
	        write.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
}

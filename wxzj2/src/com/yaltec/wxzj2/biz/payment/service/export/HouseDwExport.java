package com.yaltec.wxzj2.biz.payment.service.export;

import java.io.IOException;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.text.DecimalFormat;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.util.CellRangeAddress;

import com.yaltec.comon.utils.DateUtil;
import com.yaltec.comon.utils.StringUtil;
import com.yaltec.wxzj2.biz.payment.entity.HouseDw;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 单位房屋上报导出
 * @ClassName: HouseDwExport 
 * @author 重庆亚亮科技有限公司 txj 
 * @date 2016-9-5 上午09:54:35
 */
public class HouseDwExport {
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

	public static void exportHouseDw(List<HouseDw> list,
			HttpServletResponse response) throws IOException {
		OutputStream os = setStream(list.get(0).getLymc()+"_单位房屋上报", response);
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
		HouseDw housedw=list.get(list.size()-1);
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
		cell.setCellValue(DataHolder.buildingMap.get(list.get(0).getLybh()).getKfgsmc());
		sheet.addMergedRegion(CellRangeAddress.valueOf("$D$1:$E$1"));
	
		cell = row.createCell(5);
		cell.setCellValue("楼宇名称");
		cell.setCellStyle(style);

		cell = row.createCell(6);
		cell.setCellValue(DataHolder.buildingMap.get(list.get(0).getLybh()).getLymc());
		sheet.addMergedRegion(CellRangeAddress.valueOf("$G$1:$I$1"));

		cell = row.createCell(9);
		cell.setCellValue("楼宇地址");
		cell.setCellStyle(style);

		cell = row.createCell(10);
		cell.setCellValue(DataHolder.buildingMap.get(list.get(0).getLybh()).getAddress());
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
		cell.setCellValue(housedw.getH001());	
		cell = row.createCell(4);
		cell.setCellValue("总面积");
		cell.setCellStyle(style);
		cell = row.createCell(5);
		
		DecimalFormat df = new DecimalFormat("#.00");
		cell.setCellValue(df.format(Double.valueOf(housedw.getH006())));		
		cell = row.createCell(6);
		cell.setCellValue("总交款");
		cell.setCellStyle(style);
		cell = row.createCell(7);
		cell.setCellValue(df.format(Double.valueOf(housedw.getH030())));	
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
			HouseDw h = (HouseDw) list.get(i);
			
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
			row.createCell(13).setCellValue(StringUtil.valueOf(h.getH030()));
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
	/**
	 * 
	 * @param mapList <lymc,List<HouseDw>>
	 * @param response
	 * @throws IOException
	 */
	public static void exportHouseDwByXq(LinkedHashMap<String, List<HouseDw>> mapList,
			HttpServletResponse response) throws IOException {
		OutputStream os = setStream("单位房屋上报", response);
		// 第一步，创建一个webbook，对应一个Excel文件
		HSSFWorkbook wb = new HSSFWorkbook();
		HSSFSheet sheet=null;
		List<HouseDw> list=null;
		for (String lymc : mapList.keySet()) { 
			// 第二步，在webbook中添加一个sheet,对应Excel文件中的sheet
			sheet = wb.createSheet(lymc);
			list=mapList.get(lymc);
			// 第三步，在sheet中添加表头第0行,注意老版本poi对Excel的行数列数有限制short
			// 设置行宽
			sheet.setColumnWidth(0, 5*256);
			sheet.setColumnWidth(1, 5*256);
			sheet.setColumnWidth(2, 5*256);
			sheet.setColumnWidth(11, 12 * 256);
			//获取房屋的统计信息
			HouseDw housedw=list.get(list.size()-1);
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
			cell.setCellValue(housedw.getKfgsmc());
			sheet.addMergedRegion(CellRangeAddress.valueOf("$D$1:$E$1"));
		
			cell = row.createCell(5);
			cell.setCellValue("楼宇名称");
			cell.setCellStyle(style);

			cell = row.createCell(6);
			cell.setCellValue(housedw.getLymc());
			sheet.addMergedRegion(CellRangeAddress.valueOf("$G$1:$I$1"));

			cell = row.createCell(9);
			cell.setCellValue("楼宇地址");
			cell.setCellStyle(style);

			cell = row.createCell(10);
			cell.setCellValue(DataHolder.buildingMap.get(housedw.getLybh()).getAddress());
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
			cell.setCellValue(housedw.getH001());	
			cell = row.createCell(4);
			cell.setCellValue("总面积");
			cell.setCellStyle(style);
			cell = row.createCell(5);
			
			DecimalFormat df = new DecimalFormat("#.00");
			cell.setCellValue(df.format(Double.valueOf(housedw.getH006())));		
			cell = row.createCell(6);
			cell.setCellValue("总交款");
			cell.setCellStyle(style);
			cell = row.createCell(7);
			cell.setCellValue(df.format(Double.valueOf(housedw.getH030())));	
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
				HouseDw h = (HouseDw) list.get(i);
				
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
				row.createCell(13).setCellValue(StringUtil.valueOf(h.getH030()));
				row.createCell(14).setCellValue(StringUtil.valueOf(h.getH019()));
				row.createCell(15).setCellValue(StringUtil.valueOf(h.getH031()));
				row.createCell(16).setCellValue(StringUtil.valueOf(h.getH052()));
				row.createCell(17).setCellValue(StringUtil.valueOf(h.getH053()));
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
	
	/**
	 * 
	 * @param response
	 * @param list
	 * @param title
	 * @param ZHT 中文表头
	 * @param ENT 英文表头
	 * @throws IOException
	 */
	public static void export(HttpServletResponse response,List<Map<String,String>> list,
			String title,String[] ZHT,String[] ENT) throws IOException {
		OutputStream os = setStream(title, response);
		// 第一步，创建一个webbook，对应一个Excel文件
		HSSFWorkbook wb = new HSSFWorkbook();
		// 第二步，在webbook中添加一个sheet,对应Excel文件中的sheet
		HSSFSheet sheet = wb.createSheet(title);
		// 第三步，在sheet中添加表头第0行,注意老版本poi对Excel的行数列数有限制short
		// 设置行宽
//		sheet.setColumnWidth(3, 10 * 256);
//		sheet.setColumnWidth(5, 10 * 256);
//		sheet.setColumnWidth(8, 10 * 256);
//		sheet.setColumnWidth(9, 10 * 256);
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
		cell.setCellValue(title);
		cell.setCellStyle(style);

		sheet.addMergedRegion(CellRangeAddress.valueOf("$A$1:$B$1"));

		cell = row.createCell(2);
		cell.setCellValue("共有");
		cell.setCellStyle(style);

		cell = row.createCell(3);
		cell.setCellValue(list.size());
		cell.setCellStyle(style);

		cell = row.createCell(4);
		cell.setCellValue("条记录");
		cell.setCellStyle(style);

		

		// 第二行
		row = sheet.createRow((int) 1);

		for (int i = 0; i < ZHT.length; i++) {
			cell = row.createCell(i);
			cell.setCellValue(ZHT[i]);
			cell.setCellStyle(style);
		}
		
		// 第五步，写入实体数据 实际应用中这些数据从数据库得到
		for (int i = 0; i < list.size(); i++) {
			row = sheet.createRow((int) i + 2);
			Map<String,String> map = list.get(i);
			
			// 第四步，创建单元格，并设置值
			for (int j = 0; j < ENT.length; j++) {
				row.createCell(j).setCellValue(StringUtil.valueOf(map.get(ENT[j])));
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

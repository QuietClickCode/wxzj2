package com.yaltec.wxzj2.biz.propertymanager.service.export;

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
import org.apache.poi.ss.util.CellRangeAddress;

import com.yaltec.comon.utils.StringUtil;
import com.yaltec.wxzj2.biz.property.entity.House;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 
 * @ClassName: ExportForHouseUnit
 * @Description: 导出房屋换购补交信息
 * 
 * @author hqx
 * @date 2016-10-20 下午03:26:48
 */
public class ExportHousingFill {
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
	
	// 导出房屋补交信息
	public static void exportHouseUnit(List<House> list,
			HttpServletResponse response,String ybje,String yjje) throws IOException {
		OutputStream os = setStream("房屋换购补交信息", response);
		// 第一步，创建一个webbook，对应一个Excel文件
		HSSFWorkbook wb = new HSSFWorkbook();
		// 第二步，在webbook中添加一个sheet,对应Excel文件中的sheet
		HSSFSheet sheet = wb.createSheet("房屋换购补交信息");
		// 第三步，在sheet中添加表头第0行,注意老版本poi对Excel的行数列数有限制short
		// 设置行宽
		sheet.setColumnWidth(0, 5*256);
		sheet.setColumnWidth(1, 5*256);
		sheet.setColumnWidth(2, 5*256);
		sheet.setColumnWidth(11, 12 * 256);
		//获取房屋的统计信息
		House house=list.get(list.size()-1);
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
		cell.setCellValue("1");	
		cell = row.createCell(4);
		cell.setCellValue("总面积");
		cell.setCellStyle(style);
		cell = row.createCell(5);
		cell.setCellValue(house.getH006());		
		cell = row.createCell(6);
		cell.setCellValue("总交款");
		cell.setCellStyle(style);
		
		cell = row.createCell(7);
		cell.setCellValue("0.0");	
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
		for (int i = 0; i < list.size(); i++) {
			row = sheet.createRow((int) i + 4);
			House h = (House) list.get(i);
			
			// 第六步，创建单元格，并设置值
			cell=row.createCell(0);
			cell.setCellStyle(style);
			cell.setCellValue(StringUtil.valueOf(h.getH002()));
			
			cell=row.createCell(1);
			cell.setCellStyle(style);
			cell.setCellValue(StringUtil.valueOf(h.getH003()));
			
			cell=row.createCell(2);
			cell.setCellStyle(style);
			cell.setCellValue(StringUtil.valueOf(h.getH005()));
			
			cell=row.createCell(3);
			cell.setCellStyle(style);
			cell.setCellValue(StringUtil.valueOf(h.getH013()));
			
			cell=row.createCell(4);
			cell.setCellStyle(style);
			cell.setCellValue(StringUtil.valueOf(h.getH015()));
			
			cell=row.createCell(5);
			cell.setCellStyle(style);
			cell.setCellValue(StringUtil.valueOf(h.getH011()));
			
			cell=row.createCell(6);
			cell.setCellStyle(style);
			cell.setCellValue(StringUtil.valueOf(h.getH044()));
			
			cell=row.createCell(7);
			cell.setCellStyle(style);
			cell.setCellValue(StringUtil.valueOf(h.getH006()));
			
			cell=row.createCell(8);
			cell.setCellStyle(style);
			cell.setCellValue(StringUtil.valueOf(h.getH010()));
			
			cell=row.createCell(9);
			cell.setCellStyle(style);
			cell.setCellValue(StringUtil.valueOf(h.getH017()));
			
			cell=row.createCell(10);
			cell.setCellStyle(style);
			cell.setCellValue(StringUtil.valueOf(h.getH022()));
			
			cell=row.createCell(12);
			cell.setCellStyle(style);
			cell.setCellValue(StringUtil.valueOf(yjje));
			
			cell=row.createCell(13);
			cell.setCellStyle(style);
			cell.setCellValue(StringUtil.valueOf(ybje));
			
			cell=row.createCell(14);
			cell.setCellStyle(style);
			cell.setCellValue(StringUtil.valueOf(h.getH019()));
			
			cell=row.createCell(15);
			cell.setCellStyle(style);
			cell.setCellValue(StringUtil.valueOf("0"));
			
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
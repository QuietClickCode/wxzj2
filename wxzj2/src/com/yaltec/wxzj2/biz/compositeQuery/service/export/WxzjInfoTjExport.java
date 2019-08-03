package com.yaltec.wxzj2.biz.compositeQuery.service.export;

import java.io.FileInputStream;
import java.io.IOException;
import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRichTextString;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;

import com.yaltec.comon.utils.GetDirPath;


public class WxzjInfoTjExport {
	
	
	/**
	 * 导出维修资金信息统计信息
	 * 读取EXCEL模板,写入数据并下载
	 * */
	@SuppressWarnings("unchecked")
	public void exportWxzjInfoTj_POI(HttpServletResponse response,Map<String,String> map,String filename)
			throws ClassNotFoundException, Exception {
		try {
			ServletOutputStream os = response.getOutputStream(); //获得输出流
			response.reset();	//清空输出流
			String fName = new String(filename.getBytes("gb2312"), "ISO8859-1") +".xls";
			response.setHeader("Content-disposition", "attachment; filename="+ fName); //设定输出文件头
			response.setContentType("application/msexcel"); //定义输出类型
			
			String filePath = GetDirPath.getProjectRootPath() + "//template//wxzjtj.xls";

			HSSFWorkbook workbook = new HSSFWorkbook(new FileInputStream(filePath));	//读取excel模板
			try {
				HSSFSheet sheet = workbook.getSheetAt(0);	//读取第一个工作簿
				HSSFCell cell = null;
				HSSFCellStyle style = this.getStyle_POI(workbook);
				sheet.getRow(5).getCell(2).setCellValue(new HSSFRichTextString(map.get("01")));
				sheet.getRow(6).getCell(2).setCellValue(new HSSFRichTextString(map.get("02")));
				sheet.getRow(7).getCell(2).setCellValue(new HSSFRichTextString(map.get("03")));
				sheet.getRow(8).getCell(2).setCellValue(new HSSFRichTextString(map.get("04")));
				sheet.getRow(9).getCell(2).setCellValue(new HSSFRichTextString(map.get("05")));
				sheet.getRow(10).getCell(2).setCellValue(new HSSFRichTextString(map.get("06")));
				sheet.getRow(17).getCell(2).setCellValue(new HSSFRichTextString(map.get("07")));
				sheet.getRow(65).getCell(2).setCellValue(new HSSFRichTextString(map.get("08")));
				sheet.getRow(66).getCell(2).setCellValue(new HSSFRichTextString(map.get("09")));
				sheet.getRow(67).getCell(2).setCellValue(new HSSFRichTextString(map.get("10")));
				sheet.getRow(68).getCell(2).setCellValue(new HSSFRichTextString(map.get("11")));
				sheet.getRow(69).getCell(2).setCellValue(new HSSFRichTextString(map.get("12")));
				sheet.getRow(70).getCell(2).setCellValue(new HSSFRichTextString(map.get("13")));
				sheet.getRow(71).getCell(2).setCellValue(new HSSFRichTextString(map.get("14")));
				sheet.getRow(73).getCell(2).setCellValue(new HSSFRichTextString(map.get("15")));
				sheet.getRow(74).getCell(2).setCellValue(new HSSFRichTextString(map.get("16")));
				sheet.getRow(75).getCell(2).setCellValue(new HSSFRichTextString(map.get("17")));
				sheet.getRow(76).getCell(2).setCellValue(new HSSFRichTextString(map.get("18")));
				sheet.getRow(80).getCell(2).setCellValue(new HSSFRichTextString(map.get("19")));
				sheet.getRow(99).getCell(2).setCellValue(new HSSFRichTextString(map.get("20")));
				sheet.getRow(101).getCell(2).setCellValue(new HSSFRichTextString(map.get("21")));
				sheet.getRow(102).getCell(2).setCellValue(new HSSFRichTextString(map.get("22")));
				sheet.getRow(103).getCell(2).setCellValue(new HSSFRichTextString(map.get("23")));
								
				workbook.write(os);
				os.flush();
				os.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	public HSSFCellStyle getStyle_POI(HSSFWorkbook workbook) {
		//设置字体;
		HSSFFont font = workbook.createFont();
		//设置字体大小;
		font.setFontHeightInPoints((short) 10);
		//设置字体名字;
		font.setFontName("Courier New");
		//font.setItalic(true);
		//font.setStrikeout(true);
		//设置样式;
		HSSFCellStyle style = workbook.createCellStyle();
		//设置背景颜色;
		style.setFillForegroundColor(HSSFColor.GREEN.index);                 
		style.setFillBackgroundColor(HSSFColor.GREEN.index); 
		//设置底边框;
		style.setBorderBottom(HSSFCellStyle.BORDER_THIN);
		//设置底边框颜色;
		style.setBottomBorderColor(HSSFColor.BLACK.index);
		//设置左边框;
		style.setBorderLeft(HSSFCellStyle.BORDER_THIN);
		//设置左边框颜色;
		style.setLeftBorderColor(HSSFColor.BLACK.index);
		//设置右边框;
		style.setBorderRight(HSSFCellStyle.BORDER_THIN);
		//设置右边框颜色;
		style.setRightBorderColor(HSSFColor.BLACK.index);
		//设置顶边框;
		style.setBorderTop(HSSFCellStyle.BORDER_THIN);
		//设置顶边框颜色;
		style.setTopBorderColor(HSSFColor.BLACK.index);
		//在样式用应用设置的字体;
		style.setFont(font);
		//设置自动换行;
		style.setWrapText(false);
		//设置水平对齐的样式为居中对齐;
		style.setAlignment(HSSFCellStyle.ALIGN_LEFT);
		//设置垂直对齐的样式为居中对齐;
		style.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
		return style;
	}
}

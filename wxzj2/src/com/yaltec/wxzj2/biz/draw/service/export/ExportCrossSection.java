package com.yaltec.wxzj2.biz.draw.service.export;

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

import com.yaltec.comon.utils.ChangeRMB;
import com.yaltec.comon.utils.GetDirPath;

public class ExportCrossSection {
	
	/**
	 * 导出维修资金划款通知书信息
	 * 读取EXCEL模板,写入数据并下载
	 * */
	@SuppressWarnings("unchecked")
	public void exportWxzjInfoTj_POI(HttpServletResponse response,Map<String,String> map)
			throws ClassNotFoundException, Exception {
		try {
			ServletOutputStream os = response.getOutputStream(); //获得输出流
			response.reset();	//清空输出流
			String filename ="重庆市荣昌区房屋专项维修资金划款通知书";
			String fName = new String(filename.getBytes("gb2312"), "ISO8859-1") +".xls";
			response.setHeader("Content-disposition", "attachment; filename="+ fName); //设定输出文件头
			response.setContentType("application/msexcel"); //定义输出类型
			
			String filePath = GetDirPath.getProjectRootPath() + "//template//hktzs.xls";//指定模板

			HSSFWorkbook workbook = new HSSFWorkbook(new FileInputStream(filePath));	//读取excel模板
			try {
				HSSFSheet sheet = workbook.getSheetAt(0);	//读取第一个工作簿
				HSSFCell cell = null;
				HSSFCellStyle style = this.getStyle_POI(workbook);
				if(map.get("unitcode").equals("1")){
					sheet.getRow(1).getCell(3).setCellValue("2018()");
				}else{
					sheet.getRow(1).getCell(3).setCellValue(new HSSFRichTextString(map.get("unitcode"))+"2018()");
				}
				sheet.getRow(2).getCell(1).setCellValue(new HSSFRichTextString(map.get("xqmc")));
				sheet.getRow(3).getCell(1).setCellValue(new HSSFRichTextString(map.get("xqbh")));
				sheet.getRow(2).getCell(3).setCellValue(new HSSFRichTextString(map.get("lymc")));
				if(map.get("lybh").equals("1")){
					sheet.getRow(3).getCell(3).setCellValue(new HSSFRichTextString(""));
				}else{
					sheet.getRow(3).getCell(3).setCellValue(new HSSFRichTextString(map.get("lybh")));
				}
				
				sheet.getRow(4).getCell(1).setCellValue(new HSSFRichTextString(map.get("je")));
				sheet.getRow(4).getCell(2).setCellValue(new HSSFRichTextString(ChangeRMB.doChangeRMB(map.get("je"))));
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

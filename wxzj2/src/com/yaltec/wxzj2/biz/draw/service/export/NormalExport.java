package com.yaltec.wxzj2.biz.draw.service.export;

import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.net.URLEncoder;
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

import com.yaltec.comon.log.LogUtil;
import com.yaltec.comon.log.entity.Log;
import com.yaltec.comon.utils.DateUtil;
import com.yaltec.comon.utils.StringUtil;
import com.yaltec.wxzj2.biz.draw.entity.ShareAD;

/**
 * 通用导出
 * @author 亚亮科技有限公司.YL
 *
 * @version: 2016-9-2 上午11:08:32
 */
public class NormalExport {
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
	
	// 异常提示
	public static void exeException(String message, HttpServletResponse response) {
		PrintWriter out = null;
		try {
			response.setContentType("text/html;charset=utf-8");
			out = response.getWriter();
			out.print("<script language='javaScript'>alert('" + message + "');" + "self.close();</script>");
		} catch (Exception e) {
			LogUtil.write(new Log("", "导出", "", e.getMessage()));
		} finally {
			out.flush();
			out.close();
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
		sheet.setColumnWidth(0, 20 * 256);
		sheet.setColumnWidth(1, 12 * 256);
		sheet.setColumnWidth(2, 12 * 256);
		sheet.setColumnWidth(3, 12 * 256);
		sheet.setColumnWidth(4, 20 * 256);
		sheet.setColumnWidth(5, 12 * 256);
		sheet.setColumnWidth(6, 12 * 256);
		sheet.setColumnWidth(7,12 * 256);
		// 第一行
		HSSFRow row = sheet.createRow((int) 0);
		// 合并单元格
		sheet.addMergedRegion(CellRangeAddress.valueOf("$A$1:$H$1"));
		sheet.addMergedRegion(CellRangeAddress.valueOf("$A$2:$H$2"));
		// 第四步，创建单元格，并设置值表头 设置表头居中
		HSSFFont titleFont = wb.createFont();// 字体
		titleFont.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
		titleFont.setFontHeightInPoints((short) 20);
		
		HSSFFont contentFont = wb.createFont();// 字体
		contentFont.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
		contentFont.setFontHeightInPoints((short) 10);

		HSSFCellStyle style = wb.createCellStyle();
		style.setAlignment(HSSFCellStyle.ALIGN_CENTER); // 创建一个居中格式
		style.setFont(titleFont);
		
		HSSFCellStyle style_R = wb.createCellStyle();
		style_R.setAlignment(HSSFCellStyle.ALIGN_RIGHT); // 创建一个居中格式
		style_R.setFont(contentFont);
		
		HSSFCellStyle style_C = wb.createCellStyle();
		style_C.setAlignment(HSSFCellStyle.ALIGN_CENTER); // 创建一个居中格式
		style_C.setFont(contentFont);

		HSSFCell cell = row.createCell(0);
		cell.setCellValue(title);
		cell.setCellStyle(style);

		// 第二行
		row = sheet.createRow((int) 1);
		StringBuffer sb = new StringBuffer();
		sb.append("日期：").append(DateUtil.getDate()).append("  共有").append(list.size()-1).append("条记录");
		cell = row.createCell(0);
		cell.setCellValue(sb.toString());
		cell.setCellStyle(style_R);

		// 第三行
		row = sheet.createRow((int) 2);

		for (int i = 0; i < ZHT.length; i++) {
			cell = row.createCell(i);
			cell.setCellValue(ZHT[i]);
			cell.setCellStyle(style_C);
		}
		
		HSSFCellStyle _style_C = wb.createCellStyle();
		_style_C.setAlignment(HSSFCellStyle.ALIGN_LEFT); // 创建一个居中格式
		HSSFFont _contentFont = wb.createFont();// 字体
		contentFont.setFontHeightInPoints((short) 10);
		_style_C.setFont(_contentFont);
		// 第五步，写入实体数据 实际应用中这些数据从数据库得到
		for (int i = 0; i < list.size(); i++) {
			row = sheet.createRow((int) i + 3);
			Map<String,String> map = list.get(i);
			if (i == list.size()-1) {
				map.put("hbrq", "合计");
			}
			
			// 第四步，创建单元格，并设置值
			for (int j = 0; j < ENT.length; j++) {
				HSSFCell _cell = row.createCell(j);
				if (j == 3) {
					String date = StringUtil.valueOf(map.get(ENT[j]));
					if (StringUtil.hasLength(date) && date.length() > 10) {
						if (date.indexOf("-") >= 0) {
							_cell.setCellValue(date.substring(0,10));
						} else {
							_cell.setCellValue(date);
						}
					} else {
						_cell.setCellValue(StringUtil.valueOf(map.get(ENT[j])));
					}
				} else {
					_cell.setCellValue(StringUtil.valueOf(map.get(ENT[j])));
				}
				_cell.setCellStyle(_style_C);
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

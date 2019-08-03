package com.yaltec.wxzj2.biz.voucher.service.export;

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
import com.yaltec.wxzj2.biz.voucher.entity.SummaryCertificate;

/**
 * @ClassName: SummaryCertificateExport
 * @Description: 凭证汇总的导出数据
 * @author moqian
 * @date 2016-9-28 下午17:16:11
 */
public class SummaryCertificateExport {
	private static OutputStream setStream(String filename, HttpServletResponse response) throws IOException {
		OutputStream os = null;
		try {
			os = response.getOutputStream(); // 取得输出流
			response.reset(); // 清空输出流
			response.setHeader("Content-disposition", "filename=" + URLEncoder.encode(filename, "UTF-8") + ".xls"); // 设定输出文件头
			response.setContentType("application/excel"); // 可以在浏览器中打，定义输出类型
		} catch (IOException e) {
			e.printStackTrace();
		}
		return os;
	}

	// 凭证汇总的导出数据
	public static void exportSummaryCertificate(List<SummaryCertificate> list, HttpServletResponse response) throws IOException {
		OutputStream os = setStream("凭证汇总", response);
		// 第一步，创建一个webbook，对应一个Excel文件
		HSSFWorkbook wb = new HSSFWorkbook();
		// 第二步，在webbook中添加一个sheet,对应Excel文件中的sheet
		HSSFSheet sheet = wb.createSheet("凭证汇总");
		// 第三步，在sheet中添加表头第0行,注意老版本poi对Excel的行数列数有限制short
		// 设置行宽
		sheet.setColumnWidth(0, 20 * 256);
		sheet.setColumnWidth(1, 20 * 256);
		sheet.setColumnWidth(2, 20 * 256);
		sheet.setColumnWidth(3, 20 * 256);
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
		style.setBorderBottom(HSSFCellStyle.BORDER_THIN); // 下边框
		style.setBorderLeft(HSSFCellStyle.BORDER_THIN);// 左边框
		style.setBorderTop(HSSFCellStyle.BORDER_THIN);// 上边框
		style.setBorderRight(HSSFCellStyle.BORDER_THIN);// 右边框

		// 创建样式2：字体居中，单元格无背景色
		HSSFCellStyle style1 = (HSSFCellStyle) wb.createCellStyle();
		style1.setAlignment(HSSFCellStyle.ALIGN_CENTER); // 创建一个居中格式
		style1.setBorderBottom(HSSFCellStyle.BORDER_THIN); // 下边框
		style1.setBorderLeft(HSSFCellStyle.BORDER_THIN);// 左边框
		style1.setBorderTop(HSSFCellStyle.BORDER_THIN);// 上边框
		style1.setBorderRight(HSSFCellStyle.BORDER_THIN);// 右边框

		HSSFCell cell = row.createCell(0);
		cell.setCellStyle(style1);
		cell.setCellValue("凭证汇总");
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
		cell.setCellValue("科目编码");
		cell.setCellStyle(style);

		cell = row.createCell(1);
		cell.setCellValue("科目名称");
		cell.setCellStyle(style);

		cell = row.createCell(2);
		cell.setCellValue("借方");
		cell.setCellStyle(style);

		cell = row.createCell(3);
		cell.setCellValue("贷方");
		cell.setCellStyle(style);

		// 第五步，写入实体数据 实际应用中这些数据从数据库得到
		for (int i = 0; i < list.size(); i++) {
			row = sheet.createRow((int) i + 2);
			SummaryCertificate ad = (SummaryCertificate) list.get(i);

			// 第四步，创建单元格，并设置值
			cell = row.createCell(0);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getP018()));

			cell = row.createCell(1);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getP019()));

			cell = row.createCell(2);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getP008()));

			cell = row.createCell(3);
			cell.setCellStyle(style1);
			cell.setCellValue(StringUtil.valueOf(ad.getP009()));
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

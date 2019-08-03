package com.yaltec.wxzj2.biz.draw.service.print;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.lowagie.text.Document;
import com.lowagie.text.DocumentException;
import com.lowagie.text.Font;
import com.lowagie.text.PageSize;
import com.lowagie.text.Rectangle;
import com.lowagie.text.pdf.BaseFont;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;
import com.yaltec.comon.log.LogUtil;
import com.yaltec.comon.log.entity.Log;
import com.yaltec.comon.utils.PdfUtil;
import com.yaltec.comon.utils.StringUtil;
import com.yaltec.wxzj2.biz.draw.entity.ShareAD;

/**
 * <p>ClassName:PreSplitPDF </p>
 * <p>Description:支取预分摊 打印</p>
 * <p>Company:YALTEC</p>
 * @author YiLong
 * @date 2017-10-12 下午03:00:29 
 * @version V1.0
 */
public class PreSplitPDF {
	private static BaseFont bfChinese;
	private static Font headFont1;
	private static Font headFont2;
	private static Font headFont3;
	private static Font headFont4;
	private static DecimalFormat df = new DecimalFormat("0.00"); // 保留2位小数

	static Logger logger = LoggerFactory.getLogger(NormalPrintPDF.class);

	public static void init() throws DocumentException, IOException {
		bfChinese = BaseFont.createFont("STSong-Light", "UniGB-UCS2-H",
				BaseFont.NOT_EMBEDDED);// 设置中文字体
		headFont1 = new Font(bfChinese, 20, Font.NORMAL);// 设置字体大小
		headFont2 = new Font(bfChinese, 12, Font.NORMAL);// 设置字体大小
		headFont3 = new Font(bfChinese, 10, Font.NORMAL);// 设置字体大小
		headFont4 = new Font(bfChinese, 16, Font.BOLD);// 设置字体大小
	}
	// 输出PDF
	public static void output(ByteArrayOutputStream ops, HttpServletResponse response) {
		response.setContentType("application/pdf");

		// response.setHeader("Content-disposition","attachment; filename="+"report.pdf"
		// );
		response.setHeader("Cache-Control", "must-revalidate, post-check=0, pre-check=0");
		response.setHeader("Pragma", "public");
		response.setDateHeader("Expires", (System.currentTimeMillis() + 1000));

		response.setContentLength(ops.size());
		ServletOutputStream out = null;
		try {
			out = response.getOutputStream();
			ops.writeTo(out);
		} catch (IOException e) {
			LogUtil.write(new Log("", "打印", "", e.getMessage()));
		} finally {
			try {
				out.flush();
				out.close();
			} catch (IOException e) {
				LogUtil.write(new Log("", "打印", "", e.getMessage()));
			}
		}
	}
	
	// 异常提示
	public static void exeException(String message, HttpServletResponse response) {
		PrintWriter out = null;
		try {
			response.setContentType("text/html;charset=utf-8");
			out = response.getWriter();
			out.print("<script language='javaScript'>alert('" + message + "');" + "self.close();</script>");
		} catch (Exception e) {
			LogUtil.write(new Log("", "打印", "", e.getMessage()));
		} finally {
			out.flush();
			out.close();
		}
	}
	
	public ByteArrayOutputStream creatPDF_tl(List<ShareAD> list0,String xqmc)
			throws Exception {
		init();
		
		String fileName = "物业专项维修资金使用业主意见表";
		String[] title = { "序号", "业主姓名", "单元", "层", "房号", "建筑面积", "预计分摊金额", 
				"业主签名", "签名时间", "联系电话", "楼宇名称"};
		String[] propertys = { "xh", "h013", "h002", "h003", "h005", "h006", "ftje", 
				"", "", "", "lymc"};// 输出例
		float[] widths = { 30f, 90f, 40f, 40f, 40f, 40f, 40f, 40f, 40f, 40f, 100f };// 设置表格的列以及列宽
		
		Document document = new Document();// 建立一个Document对象
		document.setPageSize(PageSize.A4);// 设置页面大小,为A4纸
		Rectangle pageSize = new Rectangle(PageSize.A4);// 设置页面大小,为A4纸
		document.setPageSize(pageSize.rotate());// 横打
		
		ByteArrayOutputStream ops = new ByteArrayOutputStream();// 输出到客户段的流
		//OutputStream out = new FileOutputStream(new File("e:/a.pdf"));
		
		PdfWriter.getInstance(document, ops);// 建立一个PdfWriter对象
		document.open();
		int len = propertys.length;
	
		PdfPTable table = new PdfPTable(widths);// 建立一个pdf表格
		
		table.setSpacingBefore(20f);// 设置表格上面空白宽度
		table.setTotalWidth(754);// 设置表格的宽度
		table.setLockedWidth(true);// 设置表格的宽度固定
		table.getDefaultCell().setBorder(1);// 设置表格默认为无边框
		
		PdfPCell cell = PdfUtil.createCell(fileName, headFont1, 0,
				55, widths.length, PdfUtil.CENTER_H, PdfUtil.BOTTOM_V);
		table.addCell(cell);// 增加单元格
		
		// 第一行 标题 	物业专项维修资金使用业主意见表
		cell = PdfUtil.createCell("物业专项维修资金使用业主意见表", headFont1, 0, 20, widths.length, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		int w1 = widths.length/2;
		int w2 = widths.length - w1;
		// 第二行
		cell = PdfUtil.createCell("小区名称："+xqmc, headFont3, 1, 20, w1, PdfUtil.LEFT_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("房屋坐落："+list0.get(0).getLyaddress(), headFont3, 1, 20, w2, PdfUtil.LEFT_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		// 第三行
		cell = PdfUtil.createCell("业委会名称："+list0.get(0).getYwhmc(), headFont3, 1, 20, w1, PdfUtil.LEFT_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("物业公司名称："+list0.get(0).getWygsmc(), headFont3, 1, 20, w2, PdfUtil.LEFT_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		// 第四行
		cell = PdfUtil.createCell("公示材料：1、物业专项维修资金使用方案；2、施工单位的选定确认书；3、施工合同；4、分摊方式说明；5、会议记录；6、审核报告。", headFont3, 1, 20, w1, PdfUtil.LEFT_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("公示时间：", headFont3, 1, 20, w2, PdfUtil.LEFT_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		// 第五行
		cell = PdfUtil.createCell("维修范围：", headFont3, 1, 20, w1, PdfUtil.LEFT_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("使用金额（元）："+list0.get(list0.size()-1).getFtje(), headFont3, 1, 20, w2, PdfUtil.LEFT_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		
		//title
		for (int i = 0; i < len; i++) {
			cell = PdfUtil.createCell(title[i], headFont3, 1, 20, 1, PdfUtil.CENTER_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);
		}
		
		//内容
		for (int rowId = 0; rowId < list0.size(); rowId++) {
			// 得到对应行的数据列表
			ShareAD temp = list0.get(rowId);

			//String[] propertys = { "xh", "h013", "h002", "h003", "h005", "h006", "ftje", "", "", "", "lymc"};// 输出例
			cell = PdfUtil.createCell(StringUtil.valueOf(rowId+1), headFont3, 1, 20, 1, PdfUtil.CENTER_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);

			if(temp.getH001().equals("合计")){
				cell = PdfUtil.createCell("合计", headFont3, 1, 20, 1, PdfUtil.CENTER_H,
						PdfUtil.MIDDLE_V);
				table.addCell(cell);
			}else{
				cell = PdfUtil.createCell(StringUtil.valueOf(temp.getH013()), headFont3, 1, 20, 1, PdfUtil.CENTER_H,
						PdfUtil.MIDDLE_V);
				table.addCell(cell);
			}

			cell = PdfUtil.createCell(StringUtil.valueOf(temp.getH002()), headFont3, 1, 20, 1, PdfUtil.CENTER_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);

			cell = PdfUtil.createCell(StringUtil.valueOf(temp.getH003()), headFont3, 1, 20, 1, PdfUtil.CENTER_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);

			cell = PdfUtil.createCell(StringUtil.valueOf(temp.getH005()), headFont3, 1, 20, 1, PdfUtil.CENTER_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);

			cell = PdfUtil.createCell(StringUtil.valueOf(temp.getH006()), headFont3, 1, 20, 1, PdfUtil.CENTER_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);

			cell = PdfUtil.createCell(StringUtil.valueOf(temp.getFtje()), headFont3, 1, 20, 1, PdfUtil.CENTER_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);

			cell = PdfUtil.createCell("", headFont3, 1, 20, 1, PdfUtil.CENTER_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);

			cell = PdfUtil.createCell("", headFont3, 1, 20, 1, PdfUtil.CENTER_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);

			cell = PdfUtil.createCell("", headFont3, 1, 20, 1, PdfUtil.CENTER_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);


			cell = PdfUtil.createCell(StringUtil.valueOf(temp.getLymc()), headFont3, 1, 20, 1, PdfUtil.CENTER_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);
			
		}
		
		document.add(table);
		
		document.close();
		return ops;
	}
	
	public ByteArrayOutputStream creatPDF_Other(List<ArrayList> list,String xqmc)
			throws Exception {
		init();
		Document document = new Document();// 建立一个Document对象
		document.setPageSize(PageSize.A4);// 设置页面大小,为A4纸
		Rectangle pageSize = new Rectangle(PageSize.A4);// 设置页面大小,为A4纸
		document.setPageSize(pageSize.rotate());// 横打
		
		ByteArrayOutputStream ops = new ByteArrayOutputStream();// 输出到客户段的流
		//OutputStream out = new FileOutputStream(new File("e:/a.pdf"));
		
		PdfWriter.getInstance(document, ops);// 建立一个PdfWriter对象
		document.open();
		
		String[] title = { "序号", "业主姓名", "单元", "层", "房号", "建筑面积", "预计分摊金额", 
				"业主签名", "签名时间", "联系电话"};
		String[] propertys = { "xh", "h013", "h002", "h003", "h005", "h006", "ftje", 
				"", "", ""};// 输出例
		float[] widths = { 30f, 90f, 40f, 40f, 40f, 40f, 40f, 40f, 40f, 40f};// 设置表格的列以及列宽
		
		
		PdfPTable table = new PdfPTable(widths);// 建立一个pdf表格
		
		table.setSpacingBefore(20f);// 设置表格上面空白宽度
		table.setTotalWidth(754);// 设置表格的宽度
		table.setLockedWidth(true);// 设置表格的宽度固定
		table.getDefaultCell().setBorder(1);// 设置表格默认为无边框
		
		for (int x = 0; x < list.size(); x++) {
			List<ShareAD> list0 = list.get(x);
			
			String fileName = "物业专项维修资金使用业主意见表";
			
			int len = propertys.length;
			
			PdfPCell cell = PdfUtil.createCell(fileName, headFont1, 0,
					55, widths.length, PdfUtil.CENTER_H, PdfUtil.BOTTOM_V);
			table.addCell(cell);// 增加单元格
			
			// 第一行 标题 	物业专项维修资金使用业主意见表
			cell = PdfUtil.createCell("", headFont1, 0, 20, widths.length, PdfUtil.CENTER_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);
			int w1 = widths.length/2;
			int w2 = widths.length - w1;
			// 第二行
			cell = PdfUtil.createCell("楼宇名称："+list0.get(0).getLymc(), headFont3, 1, 20, w1, PdfUtil.LEFT_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell("房屋坐落："+list0.get(0).getLyaddress(), headFont3, 1, 20, w2, PdfUtil.LEFT_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);
			// 第三行
			cell = PdfUtil.createCell("业委会名称："+list0.get(0).getYwhmc(), headFont3, 1, 20, w1, PdfUtil.LEFT_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell("物业公司名称："+list0.get(0).getWygsmc(), headFont3, 1, 20, w2, PdfUtil.LEFT_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);
			// 第四行
			cell = PdfUtil.createCell("公示材料：1、物业专项维修资金使用方案；2、施工单位的选定确认书；3、施工合同；4、分摊方式说明；5、会议记录；6、审核报告。", headFont3, 1, 20, w1, PdfUtil.LEFT_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell("公示时间：", headFont3, 1, 20, w2, PdfUtil.LEFT_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);
			// 第五行
			cell = PdfUtil.createCell("维修范围：", headFont3, 1, 20, w1, PdfUtil.LEFT_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell("使用金额（元）："+list0.get(list0.size()-1).getFtje(), headFont3, 1, 20, w2, PdfUtil.LEFT_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);
			
			//title
			for (int i = 0; i < len; i++) {
				cell = PdfUtil.createCell(title[i], headFont3, 1, 20, 1, PdfUtil.CENTER_H,
						PdfUtil.MIDDLE_V);
				table.addCell(cell);
			}
			
			//内容
			for (int rowId = 0; rowId < list0.size(); rowId++) {
				// 得到对应行的数据列表
				ShareAD temp = list0.get(rowId);
			
				//String[] propertys = { "xh", "h013", "h002", "h003", "h005", "h006", "ftje", "", "", "", "lymc"};// 输出例
				cell = PdfUtil.createCell(StringUtil.valueOf(rowId+1), headFont3, 1, 20, 1, PdfUtil.CENTER_H,
						PdfUtil.MIDDLE_V);
				table.addCell(cell);
			
				if(temp.getH001().equals("合计")){
					cell = PdfUtil.createCell("合计", headFont3, 1, 20, 1, PdfUtil.CENTER_H,
							PdfUtil.MIDDLE_V);
					table.addCell(cell);
				}else{
					cell = PdfUtil.createCell(StringUtil.valueOf(temp.getH013()), headFont3, 1, 20, 1, PdfUtil.CENTER_H,
							PdfUtil.MIDDLE_V);
					table.addCell(cell);
				}
			
				cell = PdfUtil.createCell(StringUtil.valueOf(temp.getH002()), headFont3, 1, 20, 1, PdfUtil.CENTER_H,
						PdfUtil.MIDDLE_V);
				table.addCell(cell);
			
				cell = PdfUtil.createCell(StringUtil.valueOf(temp.getH003()), headFont3, 1, 20, 1, PdfUtil.CENTER_H,
						PdfUtil.MIDDLE_V);
				table.addCell(cell);
			
				cell = PdfUtil.createCell(StringUtil.valueOf(temp.getH005()), headFont3, 1, 20, 1, PdfUtil.CENTER_H,
						PdfUtil.MIDDLE_V);
				table.addCell(cell);
			
				cell = PdfUtil.createCell(StringUtil.valueOf(temp.getH006()), headFont3, 1, 20, 1, PdfUtil.CENTER_H,
						PdfUtil.MIDDLE_V);
				table.addCell(cell);
			
				cell = PdfUtil.createCell(StringUtil.valueOf(temp.getFtje()), headFont3, 1, 20, 1, PdfUtil.CENTER_H,
						PdfUtil.MIDDLE_V);
				table.addCell(cell);
			
				cell = PdfUtil.createCell("", headFont3, 1, 20, 1, PdfUtil.CENTER_H,
						PdfUtil.MIDDLE_V);
				table.addCell(cell);
			
				cell = PdfUtil.createCell("", headFont3, 1, 20, 1, PdfUtil.CENTER_H,
						PdfUtil.MIDDLE_V);
				table.addCell(cell);
			
				cell = PdfUtil.createCell("", headFont3, 1, 20, 1, PdfUtil.CENTER_H,
						PdfUtil.MIDDLE_V);
				table.addCell(cell);
				
			}
			document.add(table);
			document.newPage();
		}
		
		document.close();
		return ops;
	}
}
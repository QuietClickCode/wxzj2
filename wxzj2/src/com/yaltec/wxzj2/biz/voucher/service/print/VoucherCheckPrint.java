package com.yaltec.wxzj2.biz.voucher.service.print;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.text.DecimalFormat;
import java.util.List;

import com.lowagie.text.Document;
import com.lowagie.text.DocumentException;
import com.lowagie.text.Font;
import com.lowagie.text.PageSize;
import com.lowagie.text.pdf.BaseFont;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;
import com.yaltec.comon.utils.PdfUtil;
import com.yaltec.wxzj2.biz.voucher.entity.VoucherCheck;

/**
 * 
 * @ClassName: VoucherCheckPrint
 * @Description: 凭证审核中已审核凭证打印(可实现批量打印)
 * 
 * @author yangshanping
 * @date 2016-10-11 下午03:01:29
 */
public class VoucherCheckPrint {

	private static BaseFont bfChinese;
	private static Font headFont1;
	private static Font headFont2;
	private static Font headFont3;
	private static Font headFont4;
	private static DecimalFormat df=new DecimalFormat("0.00"); //保留2位小数
	
	public static void init() throws DocumentException, IOException {
		bfChinese = BaseFont.createFont("STSong-Light",
				"UniGB-UCS2-H", BaseFont.NOT_EMBEDDED);// 设置中文字体
		headFont1 = new Font(bfChinese, 16, Font.BOLD);// 设置字体大小
		headFont2 = new Font(bfChinese, 12, Font.BOLD);// 设置字体大小
		headFont3 = new Font(bfChinese, 11, Font.NORMAL);// 设置字体大小
		headFont4 = new Font(bfChinese, 10, Font.NORMAL);// 设置字体大小
	}
	//批量打印
	public ByteArrayOutputStream creatManyPDF(List<List> list,int rp) throws Exception {
		init();
		Document document = new Document();// 建立一个Document对象
		document.setPageSize(PageSize.A4);// 设置页面大小,为A4纸
		
		ByteArrayOutputStream ops = new ByteArrayOutputStream();// 输出到客户段的流
		
		PdfWriter.getInstance(document, ops);// 建立一个PdfWriter对象
		document.open();
		for (List<VoucherCheck> tempList : list) {
				
			float[] widths = { 40f, 20f, 20f, 60f, 60f, 50f, 60f, 40f, 50f, 40f, 50f};// 设置表格的列以及列宽
			PdfPTable table = new PdfPTable(widths);// 建立一个pdf表格
	
			table.setSpacingBefore(60f);// 设置表格上面空白宽度
			table.setTotalWidth(560);// 设置表格的宽度
			table.setLockedWidth(true);// 设置表格的宽度固定
			table.getDefaultCell().setBorder(1);// 设置表格默认为无边框
	
			PdfPCell cell = PdfUtil.createCell("记账凭证", headFont1, 0, 20, 11,
					PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);// 增加单元格
	
			// 空行
			cell = PdfUtil.createCell("", headFont2, 0, 15, 11, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			//-------------
			cell = PdfUtil.createCell("日期："+tempList.get(0).getP006().substring(0, 10), headFont3, 0, 20, 4, PdfUtil.CENTER_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell("", headFont2, 0, 20, 3, PdfUtil.CENTER_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);
			
			if (list.size() > 6) {
				int total = (int) Math.ceil((list.size() -1) / 5.0);
				StringBuffer content = new StringBuffer("");
				content.append("凭证编号：").append(tempList.get(0).getP005()).append("        ");
				content.append("---").append(rp).append("/").append(total);
				cell = PdfUtil.createCell(content.toString(), headFont3, 0, 20, 4, PdfUtil.LEFT_H,
						PdfUtil.MIDDLE_V);
				content.setLength(0);
			} else {
				cell = PdfUtil.createCell("凭证编号："+tempList.get(0).getP005(), headFont3, 0, 20, 4, PdfUtil.LEFT_H,
						PdfUtil.MIDDLE_V);
			}
			
			table.addCell(cell);
	
			// ----------------------
			cell = PdfUtil.createCell("摘          要", headFont2, 20, 3);
			table.addCell(cell);
			cell = PdfUtil.createCell(tempList.get(0).getP007(), headFont4, 1, 20, 4, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell("金          额", headFont2, 20, 4);
			table.addCell(cell);
			// ----------------------
			cell = PdfUtil.createCell("科目编码", headFont2, 20, 3);
			table.addCell(cell);
			cell = PdfUtil.createCell("科目名称", headFont2, 20, 4);
			table.addCell(cell);
			cell = PdfUtil.createCell("借方金额", headFont2, 20, 2);
			table.addCell(cell);
			cell = PdfUtil.createCell("贷方金额", headFont2, 20, 2);
			table.addCell(cell);
			// ----------------------
			int start = (rp - 1) * 5;
			int end = (rp * 5) > (tempList.size() - 1)? (tempList.size() - 1):rp * 5;
			for (int i = start; i < end; i++) {
				cell = PdfUtil.createCell(tempList.get(i).getP018(), headFont3, 20, 3);
				table.addCell(cell);
				cell = PdfUtil.createCell(tempList.get(i).getP019(), headFont4, 20, 4, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
				table.addCell(cell);
				cell = PdfUtil.createCell(df.format(tempList.get(i).getP008()).equals("0.00")? 
						"": df.format(tempList.get(i).getP008()), headFont3, 20, 2, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
				table.addCell(cell);
				
				cell = PdfUtil.createCell(df.format(tempList.get(i).getP009()).equals("0.00")? 
						"": df.format(tempList.get(i).getP009()), headFont3, 20, 2, PdfUtil.RIGHT_H, PdfUtil.MIDDLE_V);
				table.addCell(cell);
			}
			// ----------------------
			//填充空白处  
			for (int i = 0; i < (5 + start - end); i++) {
				cell = PdfUtil.createCell("", headFont3, 20, 3);
				table.addCell(cell);
				cell = PdfUtil.createCell("", headFont4, 20, 4, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
				table.addCell(cell);
				cell = PdfUtil.createCell("", headFont3, 20, 2, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
				table.addCell(cell);
				cell = PdfUtil.createCell("", headFont3, 20, 2, PdfUtil.RIGHT_H, PdfUtil.MIDDLE_V);
				table.addCell(cell);
			}
			// ----------------------
			cell = PdfUtil.createCell("合          计                                        ", headFont2, 20, 3);
			table.addCell(cell);
			cell = PdfUtil.createCell(tempList.get(tempList.size()-1).getDxhj(), headFont2, 20, 4);
			table.addCell(cell);
			cell = PdfUtil.createCell(df.format(tempList.get(tempList.size()-1).getP008()), 
					headFont3, 20, 2,PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(df.format(tempList.get(tempList.size()-1).getP009()), 
					headFont3, 20, 2,PdfUtil.RIGHT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			// ----------------------
			cell = PdfUtil.createCell("附件", headFont2, 20);
			table.addCell(cell);
			cell = PdfUtil.createCell(tempList.get(0).getP022(), headFont3, 20);
			table.addCell(cell);
			cell = PdfUtil.createCell("张", headFont2, 20);
			table.addCell(cell);
			cell = PdfUtil.createCell("会计主管", headFont2, 20);
			table.addCell(cell);
			cell = PdfUtil.createCell("", headFont2, 20);
			table.addCell(cell);
			cell = PdfUtil.createCell("出    纳", headFont2, 20);
			table.addCell(cell);
			cell = PdfUtil.createCell("", headFont2, 20);
			table.addCell(cell);
			cell = PdfUtil.createCell("复    核", headFont2, 20);
			table.addCell(cell);
			cell = PdfUtil.createCell(tempList.get(0).getP011(), headFont3, 20);
			table.addCell(cell);
			cell = PdfUtil.createCell("制    证", headFont2, 20);
			table.addCell(cell);
			cell = PdfUtil.createCell(tempList.get(0).getP021(), headFont3, 20);
			table.addCell(cell);
			
			document.add(table);
			document.newPage();
		}
		document.close();
		
		return ops;
	}
	
}

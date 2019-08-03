package com.yaltec.wxzj2.biz.payment.service.print;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.text.DecimalFormat;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.lowagie.text.Document;
import com.lowagie.text.DocumentException;
import com.lowagie.text.Font;
import com.lowagie.text.PageSize;
import com.lowagie.text.pdf.BaseFont;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;
import com.yaltec.comon.utils.PdfUtil;
import com.yaltec.wxzj2.biz.payment.entity.PaymentRegTZS;
import com.yaltec.wxzj2.biz.property.entity.Building;
import com.yaltec.wxzj2.biz.system.entity.User;

/**
 * 打印交款通知书
 * @ClassName: PaymentRegTZSPDF 
 * @author 重庆亚亮科技有限公司 txj 
 * @date 2016-9-6 下午04:22:52
 */
public class PaymentRegTZSPDF {
	private static BaseFont bfChinese;
	private static Font headFont1;
	private static Font headFont2;
	private static Font headFont3;
	private static Font headFont4;
	private static DecimalFormat df=new DecimalFormat("0.00"); //保留2位小数
	
	static Logger logger = LoggerFactory.getLogger(PaymentRegTZSPDF.class);
	
	public static void init() throws DocumentException, IOException {
		bfChinese = BaseFont.createFont("STSong-Light",
				"UniGB-UCS2-H", BaseFont.NOT_EMBEDDED);// 设置中文字体
		headFont1 = new Font(bfChinese, 20, Font.NORMAL);// 设置字体大小
		headFont2 = new Font(bfChinese, 12, Font.NORMAL);// 设置字体大小
		headFont3 = new Font(bfChinese, 10, Font.NORMAL);// 设置字体大小
		headFont4 = new Font(bfChinese, 9, Font.NORMAL);// 设置字体大小BOLD
	}
	
	public ByteArrayOutputStream creatPDF(Building building,PaymentRegTZS paymentRegTZS, String w008,User user,String assignmentName,String title) throws Exception {
		init();
		Document document = new Document();// 建立一个Document对象
		document.setPageSize(PageSize.A4);// 设置页面大小,为A4纸
		
		ByteArrayOutputStream ops = new ByteArrayOutputStream();// 输出到客户段的流
		PdfWriter.getInstance(document, ops);// 建立一个PdfWriter对象
		document.open();
		float[] widths = {70f, 190f, 70f, 190f};// 设置表格的列以及列宽
		PdfPTable table = new PdfPTable(widths);// 建立一个pdf表格

		table.setSpacingBefore(10f);// 设置表格上面空白宽度
		table.setTotalWidth(520);// 设置表格的宽度
		table.setLockedWidth(true);// 设置表格的宽度固定
		table.getDefaultCell().setBorder(1);// 设置表格默认为无边框

		PdfPCell cell = PdfUtil.createCell(title, headFont1, 0, 25, 4,
				PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);// 增加单元格

		// 空行
		cell = PdfUtil.createCell("", headFont3, 0, 5, 4, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		//-------------
		cell = PdfUtil.createCell("", headFont3, 0, 15, 3, PdfUtil.CENTER_H, PdfUtil.CENTER_H);
		table.addCell(cell);
		cell = PdfUtil.createCell("业务编号："+w008, headFont3, 0, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		//-------------
		cell = PdfUtil.createCell("小区名称", headFont2, 1, 25, 1, PdfUtil.CENTER_H,PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(building.getXqmc(), headFont3, 1, 25, 1, PdfUtil.LEFT_H,PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("单位名称", headFont2, 1, 25, 1, PdfUtil.CENTER_H,PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(building.getKfgsmc(), headFont3, 1, 25, 1, PdfUtil.LEFT_H,PdfUtil.MIDDLE_V);
		table.addCell(cell);
		//-------------
		cell = PdfUtil.createCell("楼宇名称", headFont2, 1, 25, 1, PdfUtil.CENTER_H,PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(paymentRegTZS.getLymc(), headFont3, 1, 25, 1, PdfUtil.LEFT_H,PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("实交金额", headFont2, 1, 25, 1, PdfUtil.CENTER_H,PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("￥"+df.format(Double.valueOf(paymentRegTZS.getW006()))+" 元", headFont3, 1, 25, 1, PdfUtil.LEFT_H,PdfUtil.MIDDLE_V);
		table.addCell(cell);
		//-------------
		cell = PdfUtil.createCell("交存银行", headFont2, 1, 25, 1, PdfUtil.CENTER_H,PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(paymentRegTZS.getYhmc(), headFont3, 1, 25, 1, PdfUtil.LEFT_H,PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("交存日期", headFont2, 1, 25, 1, PdfUtil.CENTER_H,PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(paymentRegTZS.getW013(), headFont3, 1, 25, 1, PdfUtil.LEFT_H,PdfUtil.MIDDLE_V);
		table.addCell(cell);
		//-------------
		cell = PdfUtil.createCell("银行账号", headFont2, 1, 25, 1, PdfUtil.CENTER_H,PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(paymentRegTZS.getBankno(), headFont3, 1, 25, 3, PdfUtil.LEFT_H,PdfUtil.MIDDLE_V);
		table.addCell(cell);
		//-------------
		cell = PdfUtil.createCell("总户数："+paymentRegTZS.getCt(), headFont4, 0, 30, 1, PdfUtil.RIGHT_H,PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("收款单位："+assignmentName + "        操作员："+user.getUsername()+"        打印日期："+paymentRegTZS.getToday(), headFont4, 0, 30, 3, PdfUtil.CENTER_H,PdfUtil.MIDDLE_V);
		table.addCell(cell);
		//-------------
		document.add(table);
		
		document.close();
		return ops;
	}
}

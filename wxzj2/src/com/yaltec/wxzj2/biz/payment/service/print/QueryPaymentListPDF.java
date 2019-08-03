package com.yaltec.wxzj2.biz.payment.service.print;

import java.io.ByteArrayOutputStream;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.lowagie.text.Document;
import com.lowagie.text.PageSize;
import com.lowagie.text.Rectangle;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;
import com.yaltec.comon.utils.DateUtil;
import com.yaltec.comon.utils.PdfUtil;
import com.yaltec.wxzj2.biz.comon.service.AbstractPDFService;
import com.yaltec.wxzj2.biz.payment.entity.QueryPayment;

/**
 * 交款查询—打印清册
 * @ClassName: QueryPaymentListPDF 
 * @author 重庆亚亮科技有限公司 jiangyong
 * @date 2016-9-6 下午04:24:22
 */
public class QueryPaymentListPDF extends AbstractPDFService {
	@SuppressWarnings("unchecked")
	@Override
	protected void buildPdfDocument(Map<String, Object> model, Document document, PdfWriter writer,
			HttpServletRequest request, HttpServletResponse response) throws Exception {
		// 调用父类初始化方法
		super.init(model);
		// 获取传入参数
		List<QueryPayment> list = getValue("list", List.class); // 交款信息

		Rectangle pageSize = new Rectangle(PageSize.A4);
		document.setPageSize(pageSize.rotate());// 设置页面大小,为A4纸

		ByteArrayOutputStream ops = new ByteArrayOutputStream();// 输出到客户段的流

		PdfWriter.getInstance(document, ops);// 建立一个PdfWriter对象
		document.open();
		float[] widths = { 100f, 150f, 50f, 50f, 200f };// 设置表格的列以及列宽
		PdfPTable table = new PdfPTable(widths);// 建立一个pdf表格

		table.setSpacingBefore(20f);// 设置表格上面空白宽度
		table.setTotalWidth(800);// 设置表格的宽度
		table.setLockedWidth(true);// 设置表格的宽度固定
		table.getDefaultCell().setBorder(1);// 设置表格默认为无边框

		PdfPCell cell = PdfUtil.createCell("交款清册", headFont4, 0, 35, 5, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("打印日期：" + DateUtil.getDate() + "        共" + (list.size() - 1) + "条交款记录", headFont3,
				0, 35, 5, PdfUtil.RIGHT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		// -------------
		cell = PdfUtil.createCell("房屋编号", headFont2, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("业主姓名", headFont2, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("交款日期", headFont2, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("交款金额", headFont2, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("地址", headFont2, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);

		// -------------
		for (int i = 0; i < list.size(); i++) {
			cell = PdfUtil.createCell(list.get(i).getH001(), headFont3, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(list.get(i).getW012(), headFont3, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(DateUtil.format(DateUtil.ZH_CN_DATE, list.get(i).getW014()), headFont3, 1, 25, 1,
					PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(String.valueOf(list.get(i).getW006()), headFont3, 1, 25, 1, PdfUtil.CENTER_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(list.get(i).getDz(), headFont3, 1, 25, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
		}
		cell = PdfUtil.createCell("", headFont3, 0, 50, 14, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		document.add(table);
		document.close();
	}

}

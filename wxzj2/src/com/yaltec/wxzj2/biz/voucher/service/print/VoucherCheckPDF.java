package com.yaltec.wxzj2.biz.voucher.service.print;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.lowagie.text.Document;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;
import com.yaltec.comon.utils.PdfUtil;
import com.yaltec.wxzj2.biz.comon.service.AbstractPDFService;
import com.yaltec.wxzj2.biz.voucher.entity.VoucherCheck;

/**
 * <p>
 * ClassName: VoucherCheckPDF
 * </p>
 * <p>
 * Description: 凭证审核—打印预览
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author jiangyong
 * @date 2016-8-22 下午05:33:07
 */
public class VoucherCheckPDF extends AbstractPDFService {

	@SuppressWarnings("unchecked")
	@Override
	protected void buildPdfDocument(Map<String, Object> model, Document document, PdfWriter writer,
			HttpServletRequest request, HttpServletResponse response) throws Exception {
		// 调用父类初始化方法
		super.init(model);
		// 获取传入参数
		String p004 = getValue("p004", String.class); 
		String current = getValue("current", String.class);
		Integer rp = Integer.valueOf(current);
		String p022 = getValue("p022", String.class); 
		List<VoucherCheck> list = getValue("list", List.class); // 房屋信息

		document.open();
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
		cell = PdfUtil.createCell("日期："+list.get(0).getP006().substring(0, 10), headFont3, 0, 20, 4, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("", headFont2, 0, 20, 3, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		
		if (list.size() > 6) {
			int total = (int) Math.ceil((list.size() -1) / 5.0);
			StringBuffer content = new StringBuffer("");
			content.append("凭证编号：").append(p004).append("        ");
			content.append("---").append(rp).append("/").append(total);
			cell = PdfUtil.createCell(content.toString(), headFont3, 0, 20, 4, PdfUtil.LEFT_H,
					PdfUtil.MIDDLE_V);
			content.setLength(0);
		} else {
			cell = PdfUtil.createCell("凭证编号："+p004, headFont3, 0, 20, 4, PdfUtil.LEFT_H,
					PdfUtil.MIDDLE_V);
		}
		
		table.addCell(cell);

		// ----------------------
		cell = PdfUtil.createCell("摘          要", headFont2, 20, 3);
		table.addCell(cell);
		cell = PdfUtil.createCell(list.get(0).getP007(), headFont3, 1, 20, 4, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
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
		int end = (rp * 5) > (list.size() - 1)? (list.size() - 1):rp * 5;
		for (int i = start; i < end; i++) {
			cell = PdfUtil.createCell(list.get(i).getP018(), headFont3, 20, 3);
			table.addCell(cell);
			cell = PdfUtil.createCell(list.get(i).getP019(), headFont3, 20, 4, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(df.format(list.get(i).getP008()).equals("0.00")? 
					"": df.format(list.get(i).getP008()), headFont3, 20, 2, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			
			cell = PdfUtil.createCell(df.format(list.get(i).getP009()).equals("0.00")? 
					"": df.format(list.get(i).getP009()), headFont3, 20, 2, PdfUtil.RIGHT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
		}
		// ----------------------
		//填充空白处  
		for (int i = 0; i < (5 + start - end); i++) {
			cell = PdfUtil.createCell("", headFont3, 20, 3);
			table.addCell(cell);
			cell = PdfUtil.createCell("", headFont3, 20, 4, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell("", headFont3, 20, 2, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell("", headFont3, 20, 2, PdfUtil.RIGHT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
		}
		// ----------------------
		cell = PdfUtil.createCell("合          计                                        ", headFont2, 20, 3);
		table.addCell(cell);
		cell = PdfUtil.createCell(list.get(list.size()-1).getDxhj(), headFont2, 20, 4);
		table.addCell(cell);
		cell = PdfUtil.createCell(df.format(list.get(list.size()-1).getP008()), 
				headFont3, 20, 2,PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(df.format(list.get(list.size()-1).getP009()), 
				headFont3, 20, 2,PdfUtil.RIGHT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		// ----------------------
		cell = PdfUtil.createCell("附件", headFont2, 20);
		table.addCell(cell);
		cell = PdfUtil.createCell(p022, headFont3, 20);
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
		cell = PdfUtil.createCell(list.get(0).getP011(), headFont3, 20);
		table.addCell(cell);
		cell = PdfUtil.createCell("制    证", headFont2, 20);
		table.addCell(cell);
		cell = PdfUtil.createCell(list.get(0).getP021(), headFont3, 20);
		table.addCell(cell);
		
		document.add(table);
		document.close();

	}

}

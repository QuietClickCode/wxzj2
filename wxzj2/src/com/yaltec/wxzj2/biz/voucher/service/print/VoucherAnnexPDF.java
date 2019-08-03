package com.yaltec.wxzj2.biz.voucher.service.print;

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
import com.yaltec.wxzj2.biz.voucher.entity.VoucherAnnex;

/**
 * <p>
 * ClassName: VoucherAnnexPDF
 * </p>
 * <p>
 * Description: 凭证审核—凭证附件打印清册
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author jiangyong
 * @date 2016-8-22 下午05:33:07
 */
public class VoucherAnnexPDF extends AbstractPDFService {

	private final static String name = "物业专项维修资金凭证附件明细";
	
	@SuppressWarnings("unchecked")
	@Override
	protected void buildPdfDocument(Map<String, Object> model, Document document, PdfWriter writer,
			HttpServletRequest request, HttpServletResponse response) throws Exception {
		// 调用父类初始化方法
		super.init(model);
		// 获取传入参数
		// 摘要
		String summary = getValue("summary", String.class);
		// 凭证附件列表
		List<VoucherAnnex> list = getValue("list", List.class);

		Rectangle pageSize = new Rectangle(PageSize.A4);// 设置页面大小,为A4纸
		document.setPageSize(pageSize.rotate());// 横打

		document.open();

		// 得到当前页数
		int page = 1;
		// 得到每页显示行数
		int rp = 20;
		// 总页数
		int zpage = list.size() % rp > 0 ? (list.size() / rp) + 1 : list.size() / rp;

		for (page = 1; page <= zpage; page++) {
			int j = getStarRow(page, rp);
			int k = getEndRow(page, rp, list.size());
			float[] widths = { 130f, 60f, 80f, 40f, 50f, 25f };
			PdfPTable table = new PdfPTable(widths);// 建立一个pdf表格

			table.setSpacingBefore(20f);// 设置表格上面空白宽度
			table.setTotalWidth(754);// 设置表格的宽度
			table.setLockedWidth(true);// 设置表格的宽度固定
			table.getDefaultCell().setBorder(1);// 设置表格默认为无边框

			PdfPCell cell = PdfUtil.createCell(name, headFont1, 0, 55, widths.length, PdfUtil.CENTER_H,
					PdfUtil.BOTTOM_V);
			table.addCell(cell);// 增加单元格

			int w1 = widths.length / 2;
			int w2 = widths.length - w1;
			// info
			cell = PdfUtil.createCell(summary, headFont3, 0, 20, w1, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);

			String rightInfo = "日期：" + DateUtil.getDate() + "  共" + list.size() + "条记录";
			cell = PdfUtil.createCell(rightInfo, headFont3, 0, 20, w2, PdfUtil.RIGHT_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);

			cell = PdfUtil.createCell("楼宇名称", headFont3, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell("房屋编号", headFont3, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell("业主姓名", headFont3, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell("发生额", headFont3, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell("业务日期", headFont3, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell("操作员", headFont3, 1, 20, 1, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
			table.addCell(cell);

			for (int rowId = j; rowId < k; rowId++) {
				// 得到对应行的数据列表
				VoucherAnnex voucherAnnex = list.get(rowId);
				cell = PdfUtil.createCell(voucherAnnex.getLymc(), headFont3, 1, 20, 1, PdfUtil.CENTER_H,
						PdfUtil.MIDDLE_V);
				table.addCell(cell);
				cell = PdfUtil.createCell(voucherAnnex.getH001(), headFont3, 1, 20, 1, PdfUtil.CENTER_H,
						PdfUtil.MIDDLE_V);
				table.addCell(cell);
				cell = PdfUtil.createCell(voucherAnnex.getW012(), headFont3, 1, 20, 1, PdfUtil.CENTER_H,
						PdfUtil.MIDDLE_V);
				table.addCell(cell);
				cell = PdfUtil.createCell(voucherAnnex.getW006(), headFont3, 1, 20, 1, PdfUtil.CENTER_H,
						PdfUtil.MIDDLE_V);
				table.addCell(cell);
				cell = PdfUtil.createCell(voucherAnnex.getW013(), headFont3, 1, 20, 1, PdfUtil.CENTER_H,
						PdfUtil.MIDDLE_V);
				table.addCell(cell);
				cell = PdfUtil.createCell(voucherAnnex.getUsername(), headFont3, 1, 20, 1, PdfUtil.CENTER_H,
						PdfUtil.MIDDLE_V);
				table.addCell(cell);
			}
			// 当前页数
			cell = PdfUtil.createCell("第 " + page + " 页", headFont3, 0, 20, widths.length, PdfUtil.CENTER_H,
					PdfUtil.MIDDLE_V);
			table.addCell(cell);

			document.add(table);
			document.newPage();
		}
		document.close();
	}

}

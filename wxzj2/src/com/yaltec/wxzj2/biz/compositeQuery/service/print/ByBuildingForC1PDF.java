package com.yaltec.wxzj2.biz.compositeQuery.service.print;

import java.io.ByteArrayOutputStream;
import java.util.List;
import java.util.Map;

import javax.activation.DataHandler;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.lowagie.text.Document;
import com.lowagie.text.PageSize;
import com.lowagie.text.Rectangle;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;
import com.yaltec.comon.utils.PdfUtil;
import com.yaltec.comon.utils.StringUtil;
import com.yaltec.wxzj2.biz.comon.service.AbstractPDFService;
import com.yaltec.wxzj2.biz.compositeQuery.entity.ByBuildingForC1;
import com.yaltec.wxzj2.biz.property.entity.House;
import com.yaltec.wxzj2.comon.data.DataHolder;


public class ByBuildingForC1PDF extends AbstractPDFService {
	
	@SuppressWarnings("unchecked")
	@Override
	protected void buildPdfDocument(Map<String, Object> model, Document document, PdfWriter writer,
			HttpServletRequest request, HttpServletResponse response) throws Exception {
		// 调用父类初始化方法
		super.init(model);
		// 获取传入参数
		List<ByBuildingForC1> list = getValue("list", List.class); // 
		String items = getValue("items", String.class);
		House house = getValue("house", House.class); // 
		
		Rectangle pageSize = new Rectangle(PageSize.A4);
		document.setPageSize(pageSize.rotate());// 设置页面大小,为A4纸

		ByteArrayOutputStream ops = new ByteArrayOutputStream();// 输出到客户段的流

		PdfWriter.getInstance(document, ops);// 建立一个PdfWriter对象
		document.open();
		float[] widths = { 50f, 50f, 60f, 50f, 50f, 50f, 40f, 20f, 40f, 20f, 40f, 20f,
				30f, 40f};// 设置表格的列以及列宽
		PdfPTable table = new PdfPTable(widths);// 建立一个pdf表格

		List<String> itemList = StringUtil.tokenize(items, ",");
		
		table.setSpacingBefore(20f);// 设置表格上面空白宽度
		table.setTotalWidth(800);// 设置表格的宽度
		table.setLockedWidth(true);// 设置表格的宽度固定
		table.getDefaultCell().setBorder(1);// 设置表格默认为无边框

		PdfPCell cell = PdfUtil.createCell("分户台账", headFont1, 0, 35, 14,
				PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);// 增加单元格

		// 空行
		cell = PdfUtil.createCell("", headFont3, 0, 10, 14, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		//-------------
		cell = PdfUtil.createCell("", headFont3, 0, 15, 1, PdfUtil.CENTER_H, PdfUtil.CENTER_H);
		table.addCell(cell);
		cell = PdfUtil.createCell("  房屋地址", headFont2, 0, 20, 13, PdfUtil.LEFT_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		//-------------
		cell = PdfUtil.createCell("房                    屋                    状                    况", 
				headFont4, 1, 25, 14, PdfUtil.CENTER_H,
				PdfUtil.MIDDLE_V);
		table.addCell(cell);
		//-------------
		cell = PdfUtil.createCell("楼宇名称", headFont2, 1, 25, 1, PdfUtil.CENTER_H,PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(house.getLymc(), headFont3, 1, 25, 6, PdfUtil.LEFT_H,PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("联系方式", headFont2, 1, 25, 2, PdfUtil.CENTER_H,PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(house.getH019(), headFont3, 1, 25, 2, PdfUtil.CENTER_H,PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("单元", headFont2, 1, 25, 2, PdfUtil.CENTER_H,PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(house.getH002(), headFont3, 1, 25, 1, PdfUtil.CENTER_H,PdfUtil.MIDDLE_V);
		table.addCell(cell);
		//-------------
		cell = PdfUtil.createCell("房屋结构", headFont2, 1, 25, 1, PdfUtil.CENTER_H,PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(house.getH045(), headFont3, 1, 25, 6, PdfUtil.CENTER_H,PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("房屋类型", headFont2, 1, 25, 2, PdfUtil.CENTER_H,PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(house.getH018(), headFont3, 1, 25, 2, PdfUtil.CENTER_H,PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("层", headFont2, 1, 25, 2, PdfUtil.CENTER_H,PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(house.getH003(), headFont3, 1, 25, 1, PdfUtil.CENTER_H,PdfUtil.MIDDLE_V);
		table.addCell(cell);
		//-------------
		cell = PdfUtil.createCell("房屋户型", headFont2, 1, 25, 1, PdfUtil.CENTER_H,PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(house.getH033(), headFont3, 1, 25, 6, PdfUtil.CENTER_H,PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("楼宇总层数", headFont2, 1, 25, 2, PdfUtil.CENTER_H,PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(house.getH040(), headFont3, 1, 25, 2, PdfUtil.CENTER_H,PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("房号", headFont2, 1, 25, 2, PdfUtil.CENTER_H,PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(house.getH005(), headFont3, 1, 25, 1, PdfUtil.CENTER_H,PdfUtil.MIDDLE_V);
		table.addCell(cell);
		//-------------
		cell = PdfUtil.createCell("建筑面积", headFont2, 1, 25, 1, PdfUtil.CENTER_H,PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(String.valueOf(house.getH006()), headFont3, 1, 25, 6, PdfUtil.CENTER_H,PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("使用面积", headFont2, 1, 25, 2, PdfUtil.CENTER_H,PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(String.valueOf(house.getH007()), headFont3, 1, 25, 2, PdfUtil.CENTER_H,PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("总房款", headFont2, 1, 25, 2, PdfUtil.CENTER_H,PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(String.valueOf(house.getH010()), headFont3, 1, 25, 1, PdfUtil.CENTER_H,PdfUtil.MIDDLE_V);
		table.addCell(cell);
		//-------------
		cell = PdfUtil.createCell("房屋性质", headFont2, 1, 25, 1, PdfUtil.CENTER_H,PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell(house.getH012(), headFont3, 1, 25, 6, PdfUtil.CENTER_H,PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("交存比例(%)", headFont2, 1, 25, 4, PdfUtil.CENTER_H,PdfUtil.MIDDLE_V);
		table.addCell(cell);
		if (house.getH032().equals("00")) {
			cell = PdfUtil.createCell(PdfUtil.removeTailZero(house.getH022())+"%"+
					" * "+house.getH023(), headFont3, 1, 25, 3, PdfUtil.CENTER_H,PdfUtil.MIDDLE_V);
			table.addCell(cell);
		} else {
			cell = PdfUtil.createCell(PdfUtil.removeTailZero(house.getH022())+
					" * "+house.getH023(), headFont3, 1, 25, 3, PdfUtil.CENTER_H,PdfUtil.MIDDLE_V);
			table.addCell(cell);
		}
		//--------------
		cell = PdfUtil.createCell("增减变动情况", headFont4, 1, 35, 14, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		//-------------
		cell = PdfUtil.createCell("日期", headFont2, 1, 25, 1, PdfUtil.CENTER_H,PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("业主姓名", headFont2, 1, 25, 1, PdfUtil.CENTER_H,PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("摘要", headFont2, 1, 25, 1, PdfUtil.CENTER_H,PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("增加本金", headFont2, 1, 25, 1, PdfUtil.CENTER_H,PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("增加利息", headFont2, 1, 25, 1, PdfUtil.CENTER_H,PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("减少本金", headFont2, 1, 25, 1, PdfUtil.CENTER_H,PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("减少利息", headFont2, 1, 25, 2, PdfUtil.CENTER_H,PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("本金余额", headFont2, 1, 25, 2, PdfUtil.CENTER_H,PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("利息余额", headFont2, 1, 25, 2, PdfUtil.CENTER_H,PdfUtil.MIDDLE_V);
		table.addCell(cell);
		cell = PdfUtil.createCell("合计(元)", headFont2, 1, 25, 2, PdfUtil.CENTER_H,PdfUtil.MIDDLE_V);
		table.addCell(cell);
		//-------------
		for (int i = 0; i < list.size(); i++) {
			// 验证打印的金额是否都为0，为0当前行则不打印
			if (!isPrintRow(itemList, list.get(i))) {
				continue;
			}
			cell = PdfUtil.createCell(list.get(i).getW003().substring(0, 10), headFont3, 1, 25, 1, PdfUtil.CENTER_H,PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(list.get(i).getW012(), headFont3, 1, 25, 1, PdfUtil.CENTER_H,PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(list.get(i).getW002(), headFont3, 1, 25, 1, PdfUtil.CENTER_H,PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(itemList.contains("w004")? list.get(i).getW004(): "", headFont3, 1, 25, 1, PdfUtil.CENTER_H,PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(itemList.contains("w005")? list.get(i).getW005(): "", headFont3, 1, 25, 1, PdfUtil.CENTER_H,PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(itemList.contains("z004")? list.get(i).getZ004(): "", headFont3, 1, 25, 1, PdfUtil.CENTER_H,PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(itemList.contains("z005")? list.get(i).getZ005(): "", headFont3, 1, 25, 2, PdfUtil.CENTER_H,PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(itemList.contains("bjye")? list.get(i).getBjye(): "", headFont3, 1, 25, 2, PdfUtil.CENTER_H,PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(itemList.contains("lxye")? list.get(i).getLxye(): "", headFont3, 1, 25, 2, PdfUtil.CENTER_H,PdfUtil.MIDDLE_V);
			table.addCell(cell);
			cell = PdfUtil.createCell(itemList.contains("xj")? list.get(i).getXj(): "", headFont3, 1, 25, 2, PdfUtil.CENTER_H,PdfUtil.MIDDLE_V);
			table.addCell(cell);
		}
		//-------------
		cell = PdfUtil.createCell("", headFont3, 0, 50, 14, PdfUtil.CENTER_H, PdfUtil.MIDDLE_V);
		table.addCell(cell);
		//-------------
		document.add(table);
		

		float[] widths2 = { 560f};// 设置表格的列以及列宽
		PdfPTable table2 = new PdfPTable(widths2);// 建立一个pdf表格

		table2.setSpacingBefore(20f);// 设置表格上面空白宽度
		table2.setTotalWidth(800);// 设置表格的宽度
		table2.setLockedWidth(true);// 设置表格的宽度固定
		table2.getDefaultCell().setBorder(1);// 设置表格默认为无边框
		if (DataHolder.customerInfo.isJLP()) {
			cell = PdfUtil.createCell("主管部门：重庆市九龙坡区物业专项维修资金管理中心 "+
					"                                     记账：", 
					headFont2, 1, 35, 1,
					PdfUtil.CENTER_H, PdfUtil.TOP_V);
		} else {
			cell = PdfUtil.createCell("主管部门：                                                        "+
					"                                              记账：", 
					headFont2, 1, 35, 1,
					PdfUtil.CENTER_H, PdfUtil.TOP_V);
		}
		cell.setBorderWidthBottom(0);
		cell.setBorderWidthLeft(0);
		cell.setBorderWidthRight(0);
		table2.addCell(cell);// 增加单元格
		document.add(table2);
		
		document.close();
	}
	
	/**
	 * 是否打印行数据
	 * @return false：不打印，true：打印
	 */
	private boolean isPrintRow(List<String> itemList, ByBuildingForC1 data) {
		if (itemList.contains("w004") && !data.getW004().equals("0.00")) {
			return true;
		}
		if (itemList.contains("w005") && !data.getW005().equals("0.00")) {
			return true;
		}
		if (itemList.contains("z004") && !data.getZ004().equals("0.00")) {
			return true;
		}
		if (itemList.contains("z005") && !data.getZ005().equals("0.00")) {
			return true;
		}
		if (itemList.contains("bjye") && !data.getBjye().equals("0.00")) {
			return true;
		}
		if (itemList.contains("lxye") && !data.getLxye().equals("0.00")) {
			return true;
		}
		if (itemList.contains("xj") && !data.getXj().equals("0.00")) {
			return true;
		}
		return false;
	}
	
}

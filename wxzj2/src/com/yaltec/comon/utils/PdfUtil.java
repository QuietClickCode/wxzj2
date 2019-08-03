package com.yaltec.comon.utils;

import com.lowagie.text.Element;
import com.lowagie.text.Font;
import com.lowagie.text.Paragraph;
import com.lowagie.text.pdf.PdfPCell;

public class PdfUtil {
	/**
	 *<p>文件名称: PdfUtil.java</p>
	 * <p>文件描述: </p>
	 * <p>版权所有: 版权所有(C)2010</p>
	 * <p>公   司: yaltec</p>
	 * <p>内容摘要: </p>
	 * <p>其他说明: </p>
	 * <p>完成日期：Mar 11, 2011</p>
	 * <p>修改记录0：无</p>
	 * @version 1.0
	 * @author jiangyong
	 */
	public static final int CENTER_H = Element.ALIGN_CENTER;// 设置内容水平居中显示
	public static final int LEFT_H = Element.ALIGN_LEFT;// 设置内容水平居左显示
	public static final int RIGHT_H = Element.ALIGN_RIGHT;// 设置内容水平居右显示
	public static final int MIDDLE_V = Element.ALIGN_MIDDLE;// 设置垂直居中
	public static final int TOP_V = Element.ALIGN_TOP;// 设置垂直顶部
	public static final int BOTTOM_V = Element.ALIGN_BOTTOM;// 设置垂直底部
	
	//默认为水平居中垂直居中， 占1个单元格
	public static PdfPCell createCell(String text, Font font, int height) {
		PdfPCell cell = new PdfPCell(new Paragraph(text, font));
		cell.setColspan(1);
		cell.setFixedHeight(height);// 单元格高度
		cell.setHorizontalAlignment(CENTER_H);
		cell.setVerticalAlignment(MIDDLE_V);
		return cell;
	}
	
	//默认为水平居中垂直居中， 
	public static PdfPCell createCell(String text, Font font, int height, int colspan) {
		PdfPCell cell = new PdfPCell(new Paragraph(text, font));
		if (colspan >= 2) {
			cell.setColspan(colspan);
		}
		cell.setFixedHeight(height);// 单元格高度
		cell.setHorizontalAlignment(CENTER_H);
		cell.setVerticalAlignment(MIDDLE_V);
		return cell;
	}
	
	public static PdfPCell createCell(String text, Font font, int height, int colspan, int hAlign, int vAlign) {
		PdfPCell cell = new PdfPCell(new Paragraph(text, font));
		if (colspan >= 2) {
			cell.setColspan(colspan);
		}
		cell.setFixedHeight(height);// 单元格高度
		cell.setHorizontalAlignment(hAlign);
		cell.setVerticalAlignment(vAlign);
		return cell;
	}
	
	public static PdfPCell createCell(String text, Font font, int borderWidth,
			int height, int colspan, int hAlign, int vAlign) {
		PdfPCell cell = new PdfPCell(new Paragraph(text, font));
		if (borderWidth == 0) {
			cell.setBorder(borderWidth);
		}
		if (colspan >= 2) {
			cell.setColspan(colspan);
		}
		cell.setFixedHeight(height);// 单元格高度
		cell.setHorizontalAlignment(hAlign);
		cell.setVerticalAlignment(vAlign);
		return cell;
	}
	
	public static PdfPCell createCell(String text, Font font, int borderWidth,
			int height, int rowspan, int colspan, int hAlign, int vAlign) {
		PdfPCell cell = new PdfPCell(new Paragraph(text, font));
		if (borderWidth == 0) {
			cell.setBorder(borderWidth);
		}
		if (rowspan >= 2) {
			cell.setRowspan(rowspan);
		}
		if (colspan >= 2) {
			cell.setColspan(colspan);
		}
		cell.setFixedHeight(height);// 单元格高度
		cell.setHorizontalAlignment(hAlign);
		cell.setVerticalAlignment(vAlign);
		return cell;
	}
	
	//转换数字返回字符串数组(把金额转换为从分到千万的数，不够充0)
	public static String[] convert(String str) {
		str = str.replace(".", "");
		String[] result = new String[10];
		for (int i = 0; i < 10 - str.length(); i++) {
			result[i] = "";
		}
		
		int j = 0;
		for (int i = 10 - str.length(); i < 10; i++) {
			result[i] = String.valueOf(str.charAt(j));
			j++;
		}
		result[10 - str.length() - 1] = "￥";
		return result;
	}
	
	/**
	 * 去掉末尾多余的0和小数点
	 * */
	public static String removeTailZero(String in_str) {
		String result = in_str;
		if (in_str.indexOf(".") != -1) {
			char[] cha = in_str.toCharArray();
			for (int i = cha.length - 1; i >=0; i--) {
				if (cha[i] != '0' && cha[i] != '.') {
					break;
				} else if(cha[i] == '.'){
					cha[i] = 'x';
					break;
				} else {
					cha[i] = 'x';
				}
			}
			result = new String(cha);
			result = result.replaceAll("x", "");
		}
		return result;
	}
}

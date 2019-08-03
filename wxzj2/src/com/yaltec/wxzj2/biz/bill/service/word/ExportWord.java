package com.yaltec.wxzj2.biz.bill.service.word;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.io.IOUtils;
import org.apache.poi.xwpf.usermodel.ParagraphAlignment;
import org.apache.poi.xwpf.usermodel.UnderlinePatterns;
import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.apache.poi.xwpf.usermodel.XWPFParagraph;
import org.apache.poi.xwpf.usermodel.XWPFRun;
import com.yaltec.comon.utils.DateUtil;
import com.yaltec.comon.utils.ServletUtils;
import com.yaltec.wxzj2.biz.bill.entity.BillM;

/**
 * @ClassName: ExportWord
 * @Description: Word文档导出
 * 
 * @author moqian
 * @date 2016-9-29 下午04:09:54
 */
public class ExportWord {
	/**
	 * 基本的写操作
	 * 
	 * @throws Exception
	 */
	public void lingTiaoWrite(HttpServletRequest request, HttpServletResponse response, BillM billm) throws Exception {
		String[] ary = new String[8];
		ary[0] = billm.getYhmc();// 银行
		ary[1] = billm.getPjzs();// 份
		ary[2] = billm.getPjls();// 联
		ary[3] = billm.getQsh();// 起始号
		ary[4] = billm.getZzh();// 结束号
		ary[5] = billm.getCzry();// 领取人
		ary[6] = billm.getYhmc();// 领取银行
		ary[7] = DateUtil.format("yyyy-MM-hh", billm.getGmrq());// 日期
																// " 2015 年 4 月 10 日"

		// 新建一个文档
		XWPFDocument doc = new XWPFDocument();
		// 创建一个段落
		XWPFParagraph para = doc.createParagraph();
		para.setAlignment(ParagraphAlignment.CENTER);
		// 一个XWPFRun代表具有相同属性的一个区域。
		XWPFRun run = para.createRun();
		run.setBold(true); // 加粗
		run.setFontSize(20);
		// 设置上下两行之间的间距
		run.setTextPosition(40);
		run.setText("领   条");

		// 创建一个段落
		para = doc.createParagraph();
		// para.setAlignment(ParagraphAlignment.CENTER);
		// 一个XWPFRun代表具有相同属性的一个区域。
		run = para.createRun();
		run.setText("");
		run = para.createRun();
		run.setFontSize(14);
		run.setText("       ");
		//
		run = para.createRun();
		run.setFontSize(14);// 字体
		run.setUnderline(UnderlinePatterns.SINGLE);// 下划线
		run.setText(ary[0]);
		//
		run = para.createRun();
		run.setFontSize(14);
		run.setUnderline(UnderlinePatterns.NONE);
		run.setText(" 从本单位领取《物业专项维修资金专用收据》  ");
		//
		run = para.createRun();
		run.setFontSize(14);
		run.setUnderline(UnderlinePatterns.SINGLE);
		run.setText(ary[1]);
		//
		run = para.createRun();
		run.setFontSize(14);
		run.setUnderline(UnderlinePatterns.NONE);
		run.setText(" 份，一份   ");
		//
		run = para.createRun();
		run.setFontSize(14);
		run.setUnderline(UnderlinePatterns.SINGLE);
		run.setText(ary[2]);
		//
		run = para.createRun();
		run.setFontSize(14);
		run.setUnderline(UnderlinePatterns.NONE);
		run.setText("  联，票据起始号： ");
		//
		run = para.createRun();
		run.setFontSize(14);
		run.setUnderline(UnderlinePatterns.SINGLE);
		run.setText(ary[3]);
		//
		run = para.createRun();
		run.setFontSize(14);
		run.setUnderline(UnderlinePatterns.NONE);
		run.setText("   终止号：  ");
		//
		run = para.createRun();
		run.setFontSize(14);
		run.setUnderline(UnderlinePatterns.SINGLE);
		run.setText(ary[4]);
		//
		run = para.createRun();
		run.setFontSize(14);
		run.setUnderline(UnderlinePatterns.NONE);
		run.setText(" 。");

		// 创建一个段落
		para = doc.createParagraph();
		para.setAlignment(ParagraphAlignment.RIGHT);
		// 一个XWPFRun代表具有相同属性的一个区域。
		//
		run = para.createRun();
		// 设置上下两行之间的间距
		run.setFontSize(18);
		run.setTextPosition(20);
		run.setText("");
		//
		para = doc.createParagraph();
		para.setAlignment(ParagraphAlignment.LEFT);
		run = para.createRun();
		run.setText("                                                                                    ");
		run = para.createRun();
		run.setFontSize(13);
		run.setText("领  取  人：" + ary[5]);
		//
		para = doc.createParagraph();
		para.setAlignment(ParagraphAlignment.LEFT);
		run = para.createRun();
		run.setText("                                                                                    ");
		run = para.createRun();
		run.setFontSize(13);
		run.setText("领取银行：" + ary[6]);
		//
		para = doc.createParagraph();
		para.setAlignment(ParagraphAlignment.LEFT);
		run = para.createRun();
		run.setText("                                                                                    ");
		run = para.createRun();
		run.setFontSize(13);
		run.setText("日         期： " + ary[7]);

		OutputStream os = new FileOutputStream("D:\\LingTiao.docx");
		// 把doc输出到输出流
		doc.write(os);
		close(os);
		String path = "D:\\LingTiao.docx";
		InputStream input = null;
		try {
			input = new FileInputStream(path);
		} catch (FileNotFoundException e) {
			return;
		}
		// 下载
		ServletUtils.setFileDownloadHeader(request, response, "领条.docx");
		IOUtils.copy(input, response.getOutputStream());
	}

	/**
	 * 关闭输出流
	 * 
	 * @param os
	 */
	private void close(OutputStream os) {
		if (os != null) {
			try {
				os.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}

}

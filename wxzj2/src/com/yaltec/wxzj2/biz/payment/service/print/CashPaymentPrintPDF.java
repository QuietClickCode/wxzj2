package com.yaltec.wxzj2.biz.payment.service.print;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.text.DecimalFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.lowagie.text.Document;
import com.lowagie.text.DocumentException;
import com.lowagie.text.Font;
import com.lowagie.text.Rectangle;
import com.lowagie.text.pdf.BaseFont;
import com.lowagie.text.pdf.PdfContentByte;
import com.lowagie.text.pdf.PdfWriter;
import com.yaltec.comon.utils.ChangeRMB;
import com.yaltec.comon.utils.DateUtil;
import com.yaltec.comon.utils.Dom4j;
import com.yaltec.comon.utils.PdfUtil;
import com.yaltec.wxzj2.biz.payment.entity.CashPayment;
import com.yaltec.wxzj2.biz.system.entity.PrintSet;

/**
 * 现金交款凭证打印
 * @ClassName: CashPaymentPrintPDF 
 * @author 重庆亚亮科技有限公司 txj 
 * @date 2016-9-6 下午04:21:43
 */
public class CashPaymentPrintPDF {
	private BaseFont bfChinese;
	private Font headFont1;
	private Font headFont2;
	private Font headFont3;
	private DecimalFormat df = new DecimalFormat("0.00"); // 保留2位小数

	static Logger logger = LoggerFactory.getLogger(CashPaymentPrintPDF.class);

	public void init() throws DocumentException, IOException {
		bfChinese = BaseFont.createFont("STSong-Light", "UniGB-UCS2-H",
				BaseFont.NOT_EMBEDDED);// 设置中文字体
		headFont1 = new Font(bfChinese, 14, Font.BOLD);// 设置字体大小
		headFont2 = new Font(bfChinese, 12, Font.NORMAL);// 设置字体大小
		headFont3 = new Font(bfChinese, 10, Font.NORMAL);// 设置字体大小
	}

	// 套打【从配置文件中获取打印配置参数】
	public ByteArrayOutputStream creatPDFDynamic(CashPayment cp,String username,String title,String xmlname)
			throws Exception {
		init();
		Document document = new Document();// 建立一个Document对象
		Rectangle pageSize = new Rectangle(268, 550);
		document.setPageSize(pageSize);
		document.setPageSize(pageSize.rotate());

		ByteArrayOutputStream ops = new ByteArrayOutputStream();// 输出到客户段的流
		PdfWriter writer = PdfWriter.getInstance(document, ops);// 建立一个PdfWriter对象

		document.open();

		// 定点输出文字
		PdfContentByte cb = writer.getDirectContent();
		//设置字体
		cb.beginText();
		cb.setFontAndSize(bfChinese, 11);

		// 读取XML配置文件定义标签坐标
		//Map map = Dom4j.getNodeForPrintSet("cashprintset.xml", "CashPaymentReg");
		Map map = new HashMap();
		if(xmlname !=null && !xmlname.trim().equals("")){
			try {
				map = Dom4j.getNodeForPrintSet(xmlname, "CashPaymentReg");
			} catch (Exception e) {
				throw new Exception("打印设置，XML名称有误！");
			}
		}else{
			map = Dom4j.getNodeForPrintSet("cashprintset.xml", "CashPaymentReg");
		}
		
		String nowDate = DateUtil.getDate(new Date());
		String[] date = nowDate.split("-");
		
		// 年月日
		cb.showTextAligned(PdfContentByte.ALIGN_RIGHT, date[0].substring(0, 4),
				((PrintSet) map.get("year")).getX(), ((PrintSet) map
						.get("year")).getY(), 0);
		cb.showTextAligned(PdfContentByte.ALIGN_RIGHT, date[1],
				((PrintSet) map.get("month")).getX(), ((PrintSet) map
						.get("month")).getY(), 0);
		cb.showTextAligned(PdfContentByte.ALIGN_RIGHT, date[2],
				((PrintSet) map.get("day")).getX(), ((PrintSet) map
						.get("day")).getY(), 0);
		
		 //房屋编号
	    cb.showTextAligned(PdfContentByte.ALIGN_LEFT,"房屋编号："+cp.getH001(), 
	    		((PrintSet)map.get("h001")).getX(), ((PrintSet)map.get("h001")).getY(), 0);
	    

		//收款人全称
	    cb.showTextAligned(PdfContentByte.ALIGN_LEFT,cp.getSkr(), 
	    		((PrintSet)map.get("skr")).getX(), ((PrintSet)map.get("skr")).getY(), 0);

		//银行名称
	    cb.showTextAligned(PdfContentByte.ALIGN_LEFT,cp.getYhmc(), 
	    		((PrintSet)map.get("yhmc")).getX(), ((PrintSet)map.get("yhmc")).getY(), 0);
		
	    //银行账号
	    cb.showTextAligned(PdfContentByte.ALIGN_LEFT,cp.getBankno(), 
	    		((PrintSet)map.get("bankno")).getX(), ((PrintSet)map.get("bankno")).getY(), 0);
		
	    //款项来源
	    cb.showTextAligned(PdfContentByte.ALIGN_LEFT,cp.getZjxm(), 
	    		((PrintSet)map.get("zjxm")).getX(), ((PrintSet)map.get("zjxm")).getY(), 0);
		
	    //币种 
	    cb.showTextAligned(PdfContentByte.ALIGN_LEFT,cp.getBz(), 
	    		((PrintSet)map.get("bz")).getX(), ((PrintSet)map.get("bz")).getY(), 0);
	    
		// 交存金额
		cb.showTextAligned(PdfContentByte.ALIGN_LEFT, ChangeRMB
				.doChangeRMB(cp.getH021()), ((PrintSet) map.get("u_jkje")).getX(),
				((PrintSet) map.get("u_jkje")).getY(), 0);
		Integer h021 = (int)(Double.valueOf(cp.getH021())*100);
		String[] jkje = PdfUtil.convert(cp.getH021());
		String[] str = {"千万","百万","十万","万","千","百","十","元","角","分"};
		for (int i=0;i<jkje.length;i++) {
			cb.showTextAligned(PdfContentByte.ALIGN_LEFT, jkje[i], ((PrintSet) map
					.get(str[i])).getX(), ((PrintSet) map.get(str[i]))
					.getY(), 0);
		}
		/*cb.showTextAligned(PdfContentByte.ALIGN_LEFT, "￥"+cp.getH021(), ((PrintSet) map
				.get("l_jkje")).getX(), ((PrintSet) map.get("l_jkje"))
				.getY(), 0);
		*/
		cb.endText();
		
		document.close();
		return ops;
	}

	// 套打【从数据库获取打印配置参数】
	public ByteArrayOutputStream creatPDFDynamicDB(CashPayment cp,String username,String title,Map map)
			throws Exception {
		init();
		Document document = new Document();// 建立一个Document对象
		Rectangle pageSize = new Rectangle(268, 550);
		document.setPageSize(pageSize);
		document.setPageSize(pageSize.rotate());

		ByteArrayOutputStream ops = new ByteArrayOutputStream();// 输出到客户段的流
		PdfWriter writer = PdfWriter.getInstance(document, ops);// 建立一个PdfWriter对象

		document.open();

		// 定点输出文字
		PdfContentByte cb = writer.getDirectContent();
		//设置字体
		cb.beginText();
		cb.setFontAndSize(bfChinese, 11);

		// 读取XML配置文件定义标签坐标
		//Map map = Dom4j.getNodeForPrintSet("cashprintset.xml", "CashPaymentReg");
		/*
		Map map = new HashMap();
		if(xmlname !=null && !xmlname.trim().equals("")){
			try {
				map = Dom4j.getNodeForPrintSet(xmlname, "CashPaymentReg");
			} catch (Exception e) {
				throw new Exception("打印设置，XML名称有误！");
			}
		}else{
			map = Dom4j.getNodeForPrintSet("cashprintset.xml", "CashPaymentReg");
		}
		*/
		String nowDate = DateUtil.getDate(new Date());
		String[] date = nowDate.split("-");
		
		// 年月日
		cb.showTextAligned(PdfContentByte.ALIGN_RIGHT, date[0].substring(0, 4),
				((PrintSet) map.get("year")).getX(), ((PrintSet) map
						.get("year")).getY(), 0);
		cb.showTextAligned(PdfContentByte.ALIGN_RIGHT, date[1],
				((PrintSet) map.get("month")).getX(), ((PrintSet) map
						.get("month")).getY(), 0);
		cb.showTextAligned(PdfContentByte.ALIGN_RIGHT, date[2],
				((PrintSet) map.get("day")).getX(), ((PrintSet) map
						.get("day")).getY(), 0);
		
		 //房屋编号
	    cb.showTextAligned(PdfContentByte.ALIGN_LEFT,"房屋编号："+cp.getH001(), 
	    		((PrintSet)map.get("h001")).getX(), ((PrintSet)map.get("h001")).getY(), 0);
	    

		//收款人全称
	    cb.showTextAligned(PdfContentByte.ALIGN_LEFT,cp.getSkr(), 
	    		((PrintSet)map.get("skr")).getX(), ((PrintSet)map.get("skr")).getY(), 0);

		//银行名称
	    cb.showTextAligned(PdfContentByte.ALIGN_LEFT,cp.getYhmc(), 
	    		((PrintSet)map.get("yhmc")).getX(), ((PrintSet)map.get("yhmc")).getY(), 0);
		
	    //银行账号
	    cb.showTextAligned(PdfContentByte.ALIGN_LEFT,cp.getBankno(), 
	    		((PrintSet)map.get("bankno")).getX(), ((PrintSet)map.get("bankno")).getY(), 0);
		
	    //款项来源
	    cb.showTextAligned(PdfContentByte.ALIGN_LEFT,cp.getZjxm(), 
	    		((PrintSet)map.get("zjxm")).getX(), ((PrintSet)map.get("zjxm")).getY(), 0);
		
	    //币种 
	    cb.showTextAligned(PdfContentByte.ALIGN_LEFT,cp.getBz(), 
	    		((PrintSet)map.get("bz")).getX(), ((PrintSet)map.get("bz")).getY(), 0);
	    
		// 交存金额
		cb.showTextAligned(PdfContentByte.ALIGN_LEFT, ChangeRMB
				.doChangeRMB(cp.getH021()), ((PrintSet) map.get("u_jkje")).getX(),
				((PrintSet) map.get("u_jkje")).getY(), 0);
		Integer h021 = (int)(Double.valueOf(cp.getH021())*100);
		String[] jkje = PdfUtil.convert(cp.getH021());
		String[] str = {"千万","百万","十万","万","千","百","十","元","角","分"};
		for (int i=0;i<jkje.length;i++) {
			cb.showTextAligned(PdfContentByte.ALIGN_LEFT, jkje[i], ((PrintSet) map
					.get(str[i])).getX(), ((PrintSet) map.get(str[i]))
					.getY(), 0);
		}
		/*cb.showTextAligned(PdfContentByte.ALIGN_LEFT, "￥"+cp.getH021(), ((PrintSet) map
				.get("l_jkje")).getX(), ((PrintSet) map.get("l_jkje"))
				.getY(), 0);
		*/
		cb.endText();
		
		document.close();
		return ops;
	}

}

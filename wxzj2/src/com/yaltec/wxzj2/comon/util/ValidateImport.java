package com.yaltec.wxzj2.comon.util;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * <p>文件名称: ValidateHouseUnit.java</p>
 * <p>文件描述: 验证单位房屋上报字段，并对一些内容做相应的处理</p>
 * <p>版权所有: 版权所有(C)2010</p>
 * <p>公   司: yaltec</p>
 * <p>内容摘要: </p>
 * <p>其他说明: </p>
 * <p>完成日期：Oct 18, 2012</p>
 * <p>修改记录0：无</p>
 * @version 1.0
 * @author jiangyong
 */
public class ValidateImport {

	private String beginStr;
	private final static String ENDSTR = " \r\n";
	
	public void setRows(int rows) {
		beginStr = "上传文件第："+rows+"行";
	}
	
	//给msg中添加错误信息
	public void writeMsg(StringBuffer msg, String content) {
		msg.append(beginStr).append(content).append(ENDSTR);
	}
	
	//单元 为空"00",保留2位
	public String ValidateH002(String h002, StringBuffer msg) {
		h002 = h002.equals("")? "00": h002;
		h002 = h002.length() == 1? "0" + h002: h002;
		return h002;
	}
	
	//层 不能为空，保留2位
	public String ValidateH003(String h003, StringBuffer msg) {
		if (h003.equals("")) {
			writeMsg(msg, "层不能为空，请检查上传文件！<br>");
		}
		h003 = h003.length() == 1? "0" + h003: h003;
		return h003;
	}
	
	//房号、房屋性质编码、房屋用途编码
	public String ValidateCode(String str, StringBuffer msg) {
		str = str.length() == 1? "0" + str: str;
		return str;
	}
	
	//金额
	public String ValidateAmount(String str, StringBuffer msg) {
		try {
			if(str.equals("")) {
				str = "0";
			} else {
				Float.valueOf(str);
			}
		} catch (Exception e) {
			writeMsg(msg, "金额存在非法数字，请检查上传文件！<br>");
		}
		return str;
	}

	//X,Y坐标
	public String Validate_X_Y(String str, StringBuffer msg) {
		try {
			if(str.equals("")) {
				writeMsg(msg, "X,Y坐标不能为空，请检查上传文件！<br>");
			} else {
				Float.valueOf(str);
			}
		} catch (Exception e) {
			writeMsg(msg, "X,Y坐标存在非法数字，请检查上传文件！<br>");
		}
		return str;
	}
	
	//产权人h013、身份证号h015、联系电话h019
	
	//房屋类型编码不能为空，保留2位
	public String ValidateH017(String h017, StringBuffer msg) {
		if (h017.equals("")) {
			writeMsg(msg, "房屋类型不能为空，请检查上传文件！<br>");
		}
		h017 = h017.length() == 1? "0" + h017: h017;
		return h017;
	}
	
	//交存标准编码不能为空，保留2位
	public String ValidateH022(String h022, StringBuffer msg) {
		if (h022.equals("")) {
			writeMsg(msg, "交存标准不能为空，请检查上传文件！<br>");
		}
		h022 = h022.length() == 1? "0" + h022: h022;
		return h022;
	}
	
	//验证日期
	public String ValidateH020(String h020, StringBuffer msg) throws Exception {
		DateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		sdf.setLenient(false);
		if (h020 == null || "".equals(h020)) {
			h020 = sdf.format(new Date());
			//writeMsg(msg, "上传日期不能为空，请检查上报文件！<br>");
		} else {
			try {
				h020 = h020.replaceAll("/", "-");
				h020 = sdf.format(sdf.parse(h020));
				Date date = sdf.parse("1990-01-01");
				boolean flag = sdf.parse(h020).before(date);
				if(flag){
					throw new Exception("日期超出限制！");
				}
			} catch (Exception e) {
				writeMsg(msg, "上报日期格式为非法日期格式，请检查上传文件！<br>");
			}
		}
		return h020;
	}
}

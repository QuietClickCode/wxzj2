package com.yaltec.comon.utils;

import java.text.DecimalFormat;

/**
 * <p>
 * 文件名称: ConvertDecimal.java
 * </p>
 * <p>
 * 文件描述: 处理含小数的数字
 * </p>
 * <p>
 * 版权所有: 版权所有(C)2010
 * </p>
 * <p>
 * 公 司: yaltec
 * </p>
 * <p>
 * 内容摘要:
 * </p>
 * <p>
 * 其他说明:
 * </p>
 * <p>
 * 完成日期：Nov 21, 2011
 * </p>
 * <p>
 * 修改记录0：无
 * </p>
 * 
 * @version 1.0
 * @author jiangyong
 */
public class ConvertDecimal {
	/**
	 * 去掉末尾多余的0和小数点
	 * flag 如果结果为0，是否保留 true为保留
	 */
	public static String removeTailZero(String int_str, boolean flag) {
		if (int_str == null) return "";
		String result = int_str;
		if (int_str.indexOf(".") != -1) {
			char[] cha = int_str.toCharArray();
			for (int i = cha.length - 1; i >= 0; i--) {
				if (cha[i] != '0' && cha[i] != '.') {
					break;
				} else if (cha[i] == '.') {
					cha[i] = 'x';
					break;
				} else {
					cha[i] = 'x';
				}
			}
			result = new String(cha);
			result = result.replaceAll("x", "");
		}
		if (!flag) {
			result = result.equals("0") ? "" : result;
		}
		return result;
	}
	
	/**
	 * 保留两位小数
	 * @param int_str
	 * @return
	 */
	public static String format(double int_str){
    	DecimalFormat df = new DecimalFormat("0.00");
    	return df.format(int_str);
	}
}

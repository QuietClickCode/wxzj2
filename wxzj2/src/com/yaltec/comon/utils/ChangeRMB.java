package com.yaltec.comon.utils;

import java.math.BigDecimal;



public final class ChangeRMB {

	// 每个数字对应的大写
	private static final String[] num = { "零", "壹", "贰", "叁", "肆", "伍", "陆",
			"柒", "捌", "玖", };

	// 从低到高排列的单位
	private static final String[] bit = { "圆", "拾", "佰", "仟", "万", "拾", "佰",
			"仟", "亿", "拾", "佰", "仟", "万", "拾", "佰", "仟", "亿" };

	// 金额里面的角和分
	private static final String[] jf = { "角", "分" };

	/**
	 * 处理金额的整数部分,返回"...圆整"
	 * 
	 * @param integer
	 * @return String
	 * @throws Exception
	 */
	public static String praseUpcaseRMB(String integer) throws Exception {
		StringBuilder sbdr = new StringBuilder("");

		int j = integer.length();
		if (j > bit.length) {
			throw new Exception("\n只能处理亿万亿以内的数据(含亿万亿)!");
		}

		char[] rmb = integer.toCharArray();
		for (int i = 0; i < rmb.length; i++) {
			int numLocate = Integer.parseInt("" + rmb[i]); // 大写数字位置
			int bitLocate = j - 1 - i; // 数字单位的位置

			/*
			 * 连续大写零只添加一个
			 */
			if (numLocate == 0) {
				if (!sbdr.toString().endsWith(num[0])) {
					sbdr.append(num[numLocate]);
				}
				continue;
			}

			/*
			 * 下面的if语句保证 10065004583.05-->壹佰亿陆仟伍佰万肆仟伍佰捌拾叁圆零伍分
			 */
			if (bit[bitLocate].equals("仟")) {
				String s = sbdr.toString();
				if (!s.endsWith(bit[bitLocate + 1]) && s.length() > 0) {
					if (s.endsWith(num[0])) {
						sbdr.deleteCharAt(sbdr.length() - 1);
					}
					sbdr.append(bit[bitLocate + 1]);
				}
			}

			sbdr.append(num[numLocate]);
			sbdr.append(bit[bitLocate]);

		}// end for

		/*
		 * 去掉结尾"零"后,补全
		 */
		if (sbdr.toString().endsWith(num[0])) {
			sbdr.deleteCharAt(sbdr.length() - 1);
			sbdr.append("圆整");
		} else {
			sbdr.append("整");
		}

		return sbdr.toString();
	}

	/**
	 * 处理带小数的金额,整数部分交由上一个方法处理,小数部分自己处理
	 * 
	 * @param integer
	 * @param decimal
	 * @return String
	 * @throws Exception
	 */
	public static String praseUpcaseRMB(String integer, String decimal)
			throws Exception {

		String ret = ChangeRMB.praseUpcaseRMB(integer);
		ret = ret.split("整")[0]; // 处理整数部分
		StringBuilder sbdr = new StringBuilder("");
		sbdr.append(ret);

		char[] rmbjf = decimal.toCharArray();
		for (int i = 0; i < rmbjf.length; i++) {
			int locate = Integer.parseInt("" + rmbjf[i]);
			if (locate == 0) {
				if (!sbdr.toString().endsWith(num[0])) {
					sbdr.append(num[locate]);
				}
				continue;
			}
			sbdr.append(num[locate]);
			sbdr.append(jf[i]);
		}

		return sbdr.toString();
	}

	/**
	 * 将double形式的字符串(有两位小数或无小数)转换成人民币的大写格式
	 * 
	 * @param doubleStr
	 * @return String
	 * @throws Exception
	 */
	public static String doChangeRMB(String doubleStr) throws Exception {
		String result = null;

		if (doubleStr.contains(".") && doubleStr.indexOf(".00") == -1) { // 金额带小数
			int dotloc = doubleStr.indexOf(".");
			int strlen = doubleStr.length();

			String integer = doubleStr.substring(0, dotloc);
			String decimal = doubleStr.substring(dotloc + 1, strlen);
			// 去掉小数的最后一个0
			if (decimal.endsWith("0")) {
				decimal = decimal.substring(0, decimal.length() -1);
			}
			result = ChangeRMB.praseUpcaseRMB(integer, decimal);
		} else { // 金额是整数
			// 只保留2位小数
			if (doubleStr.indexOf(".00") != -1) {
				doubleStr = doubleStr.substring(0, doubleStr.indexOf(".00"));
			}
			String integer = (Integer.valueOf(doubleStr)).toString();
			result = ChangeRMB.praseUpcaseRMB(integer);
		}
		return result;
	}

	/**
	 * 将double数值(有两位小数或无小数)转换成人民币的大写格式
	 * 
	 * @param rmbDouble
	 * @return String
	 * @throws Exception
	 */
	public static String doChangeRMB(double rmbDouble) throws Exception {
		// 转换一次，针对上千万的金额中带E
		BigDecimal bigDecimal = new BigDecimal(rmbDouble);

		String doubleStr = bigDecimal.setScale(2, BigDecimal.ROUND_HALF_UP)
				.toString();

		return doChangeRMB(doubleStr);
	}

	public static void main(String[] args) throws Exception {
		double b = 465811780.200;
		System.out.println(ChangeRMB.doChangeRMB(b));
	}

}

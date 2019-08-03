package com.yaltec.comon.utils;

import java.math.BigDecimal;
import java.math.BigInteger;
import java.text.DecimalFormat;

/**
 * <pre>
 * <b>高进度计算辅助.</b>
 * <b>Description:</b> 提供高精度数据计算的封装, 默认保留2位小数精度.
 * 
 */
public abstract class MathUtil {

    /**
     * 默认除法运算精度长度,即保留小数点多少位.
     */
    public static final int SCALE_LENGTH = 2;

    /**
     * 数值默认表示格式，2位小数 (#,##0.00).
     */
    public static final String FORMAT = "#,##0.00";

    // 默认构造方法.
    protected MathUtil() {
        super();
    }

    /**
     * 精确加法运算, 默认精度：2位小数.
     * 
     * @param v1 被加数
     * @param v2 加数
     * @return double 两个参数的和
     */
    public static BigDecimal add(BigDecimal v1, String v2) {
        return add(v1, v2, SCALE_LENGTH);
    }

    /**
     * 精确加法运算.
     * 
     * @param v1 被加数
     * @param v2 加数
     * @param scale 精度
     * @return double 两个参数的和
     */
    public static BigDecimal add(BigDecimal v1, String v2, int scale) {
        BigDecimal b2 = new BigDecimal(v2);
        return (v1.add(b2)).setScale(scale, BigDecimal.ROUND_HALF_UP);
    }

    /**
     * 精确加法运算, 默认精度：2位小数.
     * 
     * @param v1 被加数
     * @param v2 加数
     * @return double 两个参数的和
     */
    public static BigDecimal add(String v1, String v2) {
        return add(v1, v2, SCALE_LENGTH);
    }

    /**
     * 精确加法运算.
     * 
     * @param v1 被加数
     * @param v2 加数
     * @param scale 精度
     * @return double 两个参数的和
     */
    public static BigDecimal add(String v1, String v2, int scale) {
        BigDecimal b1 = new BigDecimal(v1);
        BigDecimal b2 = new BigDecimal(v2);
        return (b1.add(b2)).setScale(scale, BigDecimal.ROUND_HALF_UP);
    }

    /**
     * 精确减法运, 默认精度：2位小数.
     * 
     * @param v1 被减数
     * @param v2 减数
     * @return double 两个参数的差
     */
    public static BigDecimal sub(String v1, String v2) {
        return sub(v1, v2, SCALE_LENGTH);
    }

    /**
     * 精确减法运.
     * 
     * @param v1 被减数
     * @param v2 减数
     * @param scale 精度
     * @return double 两个参数的差
     */
    public static BigDecimal sub(String v1, String v2, int scale) {
        BigDecimal b1 = new BigDecimal(v1);
        BigDecimal b2 = new BigDecimal(v2);
        return (b1.subtract(b2)).setScale(scale, BigDecimal.ROUND_HALF_UP);
    }

    /**
     * 精确乘法运算, 默认精度：2位小数.
     * 
     * @param v1 被乘数
     * @param v2 乘数
     * @return 两个参数的积
     */
    public static BigDecimal mul(String v1, String v2) {
        return mul(v1, v2, SCALE_LENGTH);
    }

    /**
     * 精确乘法运算
     * 
     * @param v1 被乘数
     * @param v2 乘数
     * @param scale 精度
     * @return 两个参数的积
     */
    public static BigDecimal mul(String v1, String v2, int scale) {
        BigDecimal b1 = new BigDecimal(v1);
        BigDecimal b2 = new BigDecimal(v2);
        return (b1.multiply(b2)).setScale(scale, BigDecimal.ROUND_HALF_UP);
    }

    /**
     * <pre>
     * （相对）精确除法运算，当发生除不尽的情况时，精确到 小数点以后多少位，以后的数字四舍五入
     * 默认精度：2位小数
     * </pre>
     * 
     * @param v1 被除数
     * @param v2 除数
     * @return 两个参数的商
     */
    public static BigDecimal div(String v1, String v2) {
        return div(v1, v2, SCALE_LENGTH);
    }

    /**
     * （相对）精确的除法运算，当发生除不尽的情况时，由scale参数指 定精度，以后的数字四舍五入.
     * 
     * @param v1 被除数
     * @param v2 除数
     * @param scale 精度
     * @return double 两个参数的商
     */
    public static BigDecimal div(String v1, String v2, int scale) {
        if (scale < 0) {
            return div(v1, v2, SCALE_LENGTH);
        }
        BigDecimal b1 = new BigDecimal(v1);
        BigDecimal b2 = new BigDecimal(v2);
        return (b1.divide(b2, scale, BigDecimal.ROUND_HALF_UP));
    }

    /**
     * 计算Factorial阶乘.
     * 
     * @param n 任意大于等于0的int
     * @return n BigInteger !的值
     */
    public static BigInteger factorial(int n) {
        if (n < 0) {
            return new BigInteger("-1");
        } else if (n == 0) {
            return new BigInteger("0");
        }

        // 将数组换成字符串后构造BigInteger
        BigInteger result = new BigInteger("1");
        for (; n > 0; n--) {
            // 将数字n转换成字符串后，再构造一个BigInteger对象，与现有结果做乘法
            result = result.multiply(new BigInteger(new Integer(n).toString()));
        }
        return result;
    }

    /**
     * 降低小数的精度, 默认精度：2位小数.
     * 
     * @param v1 目标小数.
     * @return double
     */
    public static double scale(double v1) {
        return scale(v1, 2);
    }

    /**
     * 降低小数的精度.
     * 
     * @param v1 目标小数.
     * @param scale 小数精度.
     * @return double
     */
    public static double scale(double v1, int scale) {
        return new BigDecimal(Double.toString(v1)).setScale(scale, BigDecimal.ROUND_HALF_UP).doubleValue();
    }

    /**
     * 数字渲染格式化 默认格式：#0.00.
     * 
     * @param value
     * @return String
     */
    public static String format(double value) {
        return format(value, FORMAT);
    }

    /**
     * 数字渲染格式化.
     * 
     * @param value
     * @param ft 例如：#0.00
     * @return String
     */
    public static String format(double value, String ft) {
        return new DecimalFormat(ft).format(value);
    }
    
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
    public static void main(String[] args) {
        DecimalFormat df1 = new DecimalFormat("0,000.0");
        DecimalFormat df2 = new DecimalFormat("0,000.00");
        DecimalFormat df3 = new DecimalFormat("0,000.000");

        DecimalFormat df4 = new DecimalFormat("#,##0.0");
        // df4.setMinimumIntegerDigits(1);
        DecimalFormat df5 = new DecimalFormat("#,##0.0");
        // df5.setMinimumIntegerDigits(1);
        DecimalFormat df6 = new DecimalFormat("#,##0.00");
        // df6.setMinimumIntegerDigits(1);

        System.out.println(df1.format(12.1234));
        System.out.println(df2.format(12.1234));
        System.out.println(df3.format(12.1234));

        System.out.println(df1.format(-0.1234));
        System.out.println(df2.format(-0.1234));
        System.out.println(df3.format(-0.1234));

        System.out.println(df1.format(12024));
        System.out.println(df2.format(12024));
        System.out.println(df3.format(12024));

        System.out.println(df4.format(12024));
        System.out.println(df5.format(12024));
        System.out.println(df6.format(12024));

        System.out.println(df4.format(12.1234));
        System.out.println(df5.format(12.1234));
        System.out.println(df6.format(12.1234));

        System.out.println(df4.format(-0.1234));
        System.out.println(df5.format(0.1234));
        System.out.println(df6.format(0.1234));
        System.out.println(df6.format(0.1));

        System.out.println(MathUtil.format(0.1));
        System.out.println(MathUtil.format(-0.1234));
        System.out.println(MathUtil.format(10232.1234));
        System.out.println(MathUtil.format(10232));

        System.out.println(df4.format(11420.1234));
        System.out.println(df5.format(11420.1234));
        System.out.println(df6.format(11420.1234));
    }
}
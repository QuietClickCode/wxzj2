package com.yaltec.comon.utils;

import java.nio.charset.Charset;
import java.util.regex.Pattern;


/**
 * <pre>
 * <b>通用辅助工具.</b>
 * <b>Description:</b> 主要提供如下: 
 *   1、通过字符串获取指定编码的二进制, 已经将二进制转为指定编码的字符串;
 *   2、对非常规字符串进行简单可逆向加解密.
 * 
 * <b>Date:</b> 2014-1-1 上午10:00:01
 *   Ver   Date                  Author              Detail
 *   ----------------------------------------------------------------------
 *         new file.
 * </pre>
 */
public abstract class _Util {

    /**
     * 固定字符串"defalut".
     */
    public static final String DEFAULT = "default";

    /**
     * 字符串默认分割符: 英文逗号 ",".
     */
    public static final String STR_SEPARATOR = ",";

    /**
     * 常量, 空的字符串, ""
     */
    public static final String EMPTY_STR = "";

    /**
     * 常量, null的字符串, "&ltnull&gt"
     */
    public static final String NULL_STR = "<null>";

    /**
     * 常量, 空的二进制数组, new byte[] {}
     */
    public static final byte[] EMPTY_BYTE = new byte[] {};

    /**
     * 常量, 空的对象数组, new Object[] {}
     */
    public static final Object[] EMPTY_OBJECTS = new Object[] {};

    /**
     * UTF-8 编码.
     */
    public static final String ENCODING = "UTF-8";

    /**
     * 字符集编码, 默认: UTF-8.
     */
    public static final Charset CHARSET = Charset.forName(ENCODING);

    /**
     * HEX 16进制对照字典.
     */
    public static final char HEX_DIGITS[] = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F' };

    /**
     * 定义通用参数变量格式模板, <br/>
     * 格式为: ${参数值}, 即 ${THun2VqRzUwe/GsUmt/MO}.<br/>
     * Pattern.compile("\\$\\{[^\\$\\{\\}]+\\}"); <br/>
     */
    public static final Pattern VAR_PATTERN = Pattern.compile("\\$\\{[^\\$\\{\\}]+\\}");

    /**
     * 默认构造方法.
     */
    protected _Util() {
        super();
    }

    /**
     * 将字符串转换二进制数组, 默认字符集编码: ENCODING = "UTF-8".<br/>
     * 如果被加密字符串为null 或 长度为0时, 则直接返回 null.
     * 
     * @param str 待转换的字符串.
     * @return byte[] 转换后的二进制数组.
     */
    public static byte[] getBytes(String str) {
        return getBytes(str, CHARSET);
    }

    /**
     * 将字符串转为二进制数组, 需要指定具体字符集编码.<br/>
     * 如果被加密字符串为null时, 则直接返回 null;<br/>
     * 如果转换指定的字符集编码为null 或 长度为0时, 则直接返回 null.
     * 
     * @param str 待转换的字符串.
     * @param encoding 指定的字符编码.
     * @return byte[] 转换后的二进制数组.
     */
    public static byte[] getBytes(String str, String encoding) {
        if (null == str || null == encoding || encoding.length() == 0) {
            return null;
        }

        Charset charset = Charset.forName(encoding);
        return getBytes(str, charset);
    }

    /**
     * 将字符串转为二进制数组, 需要指定具体字符集编码.<br/>
     * 如果被加密字符串为null时, 则直接返回 null;<br/>
     * 如果转换指定的字符集编码为null 或 长度为0时, 则直接返回 null.
     * 
     * @param str 待转换的字符串.
     * @param charset 指定的字符编码.
     * @return byte[] 转换后的二进制数组.
     */
    public static byte[] getBytes(String str, Charset charset) {
        if (null == str || null == charset) {
            return null;
        }
        if (str.length() == 0) {
            return EMPTY_BYTE;
        }

        byte[] bytes = null;
        try {
            bytes = str.getBytes(charset);
        } catch (Throwable e) {
            e.printStackTrace();
        }
        return bytes;
    }

    /**
     * 将二进制数组转为字符串, 默认字符集编码: ENCODING = "UTF-8".
     * 
     * @param bytes 待转换的二进制数组.
     * @return String 转换后的字符串.
     */
    public static String getString(byte[] bytes) {
        return getString(bytes, CHARSET);
    }

    /**
     * 将二进制数组转为字符串, 需要指定具体字符集编码.<br/>
     * 如果给定的二进制数组为null, 则直接返回 null;<br/>
     * 如果转换指定的字符集编码为null 或 长度为0时, 则直接返回 null.
     * 
     * @param bytes 待转换的二进制数组.
     * @param encoding 指定的字符编码.
     * @return String 转换后的字符串.
     */
    public static String getString(byte[] bytes, String encoding) {
        if (null == bytes || null == encoding || encoding.length() == 0) {
            return null;
        }

        Charset charset = Charset.forName(encoding);
        return getString(bytes, charset);
    }

    /**
     * 将二进制数组转为字符串, 需要指定具体字符集编码.<br/>
     * 如果给定的二进制数组为null, 则直接返回 null;<br/>
     * 如果转换指定的字符集编码为null 或 长度为0时, 则直接返回 null.
     * 
     * @param bytes 待转换的二进制数组.
     * @param charset 指定的字符编码.
     * @return String 转换后的字符串.
     */
    public static String getString(byte[] bytes, Charset charset) {
        if (null == bytes || null == charset) {
            return null;
        }
        if (bytes.length == 0) {
            return EMPTY_STR;
        }

        String str = null;
        try {
            str = new String(bytes, charset);
        } catch (Throwable e) {
        	e.printStackTrace();
        }
        return str;
    }

    /**
     * 对字符串进行可逆加密计算.<br/>
     * 如果待加密的字符串为null, 则直接返回null.
     * 
     * @param str 待可逆加密的字符串.
     * @return String 可逆加密后的字符串.
     */
    public static String encode(String str) {
        if (null == str) {
            return null;
        }
        if (str.length() == 0) {
            return EMPTY_STR;
        }

        char[] a = str.toCharArray();
        for (int i = 0; i < a.length; i++) {
            a[i] = (char) (a[i] ^ 't');
        }
        str = new String(a);
        return str;
    }

    /**
     * 对可逆加密后的字符串解密.<br/>
     * 如果待解密的字符串为null, 则直接返回null.
     * 
     * @param str 待解密的字符串.
     * @return String 解密后的字符串.
     */
    public static String decode(String str) {
        char[] a = str.toCharArray();
        for (int i = 0; i < a.length; i++) {
            a[i] = (char) (a[i] ^ 't');
        }
        str = new String(a);
        return str;
    }
    
    public static void main(String[] args) {
        String str = "mmtrip";
        System.out.println(str);
        str = encode(str);
        System.out.println(str);
        str = decode(str);
        System.out.println(str);
    }
}

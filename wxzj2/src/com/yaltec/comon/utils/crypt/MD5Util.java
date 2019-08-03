package com.yaltec.comon.utils.crypt;

import java.nio.charset.Charset;
import java.security.MessageDigest;

import com.yaltec.comon.utils.StringUtil;

/**
 * <pre>
 * <b>MD5加、解密辅助工具.</b>
 * <b>Description:</b> 主要提供对字符串进行加密; 对加密后字符串进行解密.
 *    MD5的算法在RFC1321中定义, 给出了Test suite用来检验你的实现是否正确:
 *    MD5 ("") = d41d8cd98f00b204e9800998ecf8427e 
 *    MD5 ("a") = 0cc175b9c0f1b6a831c399e269772661
 *    MD5 ("123456") = e10adc3949ba59abbe56e057f20f883e 
 *    MD5 ("message digest") = f96b697d7cb7938d525a2f31aaf161d0
 * MD5 ("abcdefghijklmnopqrstuvwxyz") = c3fcd3d76192e4007dfb496cca67e13b
 * 
 */
public abstract class MD5Util {

	/**
	 * 常量, KEY:'MD5'
	 */
	public static final String KEY = "MD5";

	/**
	 * 常量, UTF-8 编码.
	 */
	public static final String ENCODING = "UTF-8";

	/**
	 * 常量, 字符集编码, 默认:UTF-8.
	 */
	public static final Charset CHARSET = Charset.forName(ENCODING);

	/**
	 * 常量, HEX 16进制对照字典.
	 */
	public static final char HEX_DIGITS[] = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd',
			'e', 'f' };

	/**
	 * 构造方法.
	 */
	protected MD5Util() {
		super();
	}

	/**
	 * 对字符串进行MD5加密;<br/>
	 * 如果待加密的字符串为null, 则直接返回null.
	 * 
	 * @param str
	 *            待加密的字符串.
	 * @return String 加密后字符串.
	 */
	public static String encrypt(String str) {
		return encrypt(str, CHARSET);
	}

	/**
	 * 对字符串进行MD5加密;<br/>
	 * 如果待加密的字符串为null, 则直接返回null.
	 * 
	 * @param str
	 *            待加密的字符串.
	 * @param charset
	 *            文件转码字符集编码.
	 * @return String 加密后字符串.
	 */
	public static String encrypt(String str, Charset charset) {
		byte[] bytes = StringUtil.getBytes(str, charset);
		return encrypt(bytes);
	}

	/**
	 * 对二进制进行MD5加密;<br/>
	 * 如果待加密的二进制为null, 则直接返回null.
	 * 
	 * @param bytes
	 *            待加密的二进制.
	 * @return String 加密后二进制.
	 */
	public static String encrypt(byte[] bytes) {
		if (null == bytes) {
			return null;
		}

		String str = null;
		// 每个字节用 16 进制表示的话, 使用两个字符, 所以表示成 16 进制需要 32 个字符
		char[] chars = new char[16 * 2];
		// 表示转换结果中对应的字符位置
		int k = 0;
		try {
			// 用来将字节转换成 16 进制表示的字符
			MessageDigest md = MessageDigest.getInstance(KEY);
			md.update(bytes);
			// MD5 的计算结果是一个 128 位的长整数, 用字节表示就是 16 个字节
			byte _bytes[] = md.digest();
			// 从第一个字节开始, 对 MD5 的每一个字节转换成 16 进制字符的转换
			for (int i = 0; i < 16; i++) {
				// 取第 i 个字节
				byte bt = _bytes[i];
				// 取字节中高 4 位的数字转换, >>> 为逻辑右移, 将符号位一起右移
				chars[k++] = HEX_DIGITS[bt >>> 4 & 0xf];
				// 取字节中低 4 位的数字转换
				chars[k++] = HEX_DIGITS[bt & 0xf];
			}
			// 换后的结果转换为字符串
			str = new String(chars);
		} catch (Throwable e) {
			e.printStackTrace();
		}
		return str;
	}

	// 截取加密的密码
	public static String getPassWord(String pass) {
		String result = MD5Util.encrypt(pass.toLowerCase());
		result = String.valueOf(result.toCharArray(), 5, 16);
		return result;
	}

	public static void main(String[] args) {
		String str = "1498.00 张天才、李贵强";
		System.err.println("   原文: " + str);
		System.err.println(" 加密后: " + (str = MD5Util.encrypt(str)));
		System.err.println("签名Key: " + (str = MD5Util.encrypt("test" + str + "2099-12-31 00:00:00")));
	}
}

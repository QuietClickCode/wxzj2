package com.yaltec.comon.utils;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * <pre>
 * <b>正则表达式 辅助工具.</b>
 * <b>Description:</b> 
 *    
 */
public abstract class RegexUtil {

    /**
     * 受保护的构造方法, 防止外部构建对象实例.
     */
    protected RegexUtil() {
        super();
    }

    /**
     * 验证给定的字符串是否符合正则表达式的格式要求.
     * 
     * @param str 给定的字符串.
     * @param pattern 指定正则表达式.
     * @return boolean, true:符合; false:不符合.
     */
    public static boolean isMatch(final String str, final Pattern pattern) {
        Matcher matcher = pattern.matcher(str);
        return matcher.matches();
    }
}
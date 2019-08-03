package com.yaltec.comon.utils;

/**
 * <pre>
 * <b>系统操作 辅助工具.</b>
 * <b>Description:</b> 
 *    
 */
public abstract class SystemUtil {

    /**
     * 受保护的构造方法, 防止外部构建对象实例.
     */
    protected SystemUtil() {
        super();
    }

    /**
     * 获取操作系统的名称, 如:Windows、Linux、Unix.
     * 
     * @return String
     */
    public static String getOsName() {
        return System.getProperty("os.name");
    }

    /**
     * 获取JavaHome的绝对路径.
     * 
     * @return String
     */
    public static String getJavaHome() {
        return System.getProperty("java.home");
    }

    /**
     * 获取ClassPath路径.
     * 
     * @return String
     */
    public static String getClassPath() {
        return System.getProperty("java.class.path");
    }
}

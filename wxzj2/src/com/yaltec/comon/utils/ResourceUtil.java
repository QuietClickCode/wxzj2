package com.yaltec.comon.utils;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStream;

/**
 * <pre>
 * <b>.</b>
 * <b>Description:资源工具类</b> 
 *    
 */
public abstract class ResourceUtil {

    private static ClassLoader classLoader = ResourceUtil.class.getClassLoader();

    /**
     * 受保护的构造方法, 防止外部构建对象实例.
     */
    protected ResourceUtil() {
        super();
    }

    /**
     * 用calsspath 作根目录提供 package 路径或文件相对路径获取资源的输入流;
     * 
     * @param resourcePath
     * @return 输入流,资源不存在时返回null
     */
    public static InputStream getResource(String resourcePath) {
        InputStream in = null;
        in = getResourceForFilepath(resourcePath);
        if (in == null) {
            in = getResourceForCasspath(resourcePath);
        }
        return in;
    }

    /**
     * 用calsspath 根据package 获取资源的输入流
     * 
     * @param casspath package下的路径
     * @return 输入流,资源不存在时返回null
     */
    public static InputStream getResourceForCasspath(String casspath) {
        return classLoader.getResourceAsStream(casspath);
    }

    /**
     * 用calsspath 根据文件的相对路径获取资源的输入流
     * 
     * @param filepath 相对calsspath 的相对路径
     * @return 输入流,资源不存在时返回null
     */
    public static InputStream getResourceForFilepath(String filepath) {
        InputStream in = null;
        try {
            in = new FileInputStream(classLoader.getResource("").getPath() + filepath);
        } catch (FileNotFoundException e) {
        }
        return in;
    }
}

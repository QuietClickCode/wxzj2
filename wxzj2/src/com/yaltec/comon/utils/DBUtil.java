package com.yaltec.comon.utils;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

/**
 * <pre>
 * <b>数据库操作辅助工具.</b>
 * <b>Description:</b> 
 *    
 */
public abstract class DBUtil {

    /**
     * 查询统计综合时用该key 获取对应的字段值.
     */
    public static final String TOTALCOUNT_KEY = "totalCount";

    /**
     * 受保护的构造方法, 防止外部构建对象实例.
     */
    protected DBUtil() {
        super();
    }

    /**
     * 关闭会话中所有对象.
     * 
     * @param res
     * @param stm
     * @param conn
     */
    public static void close(final ResultSet res, final Statement stm, final Connection conn) {
        close(res);
        close(stm);
        close(conn);
    }

    /**
     * 关闭回话中所有对象.
     * 
     * @param res
     * @param stm
     */
    public static void close(final ResultSet res, final Statement stm) {
        close(res);
        close(stm);
    }

    /**
     * 关闭数据库相关操作对象.
     * 
     * @param conn
     */
    public static void close(final Connection conn) {
        if (null != conn) {
            try {
                conn.close();
            } catch (Throwable e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * 关闭数据库相关操作对象.
     * 
     * @param stm
     */
    public static void close(final Statement stm) {
        if (null != stm) {
            try {
                stm.close();
            } catch (Throwable e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * 关闭数据库相关操作对象.
     * 
     * @param res
     */
    public static void close(final ResultSet res) {
        if (null != res) {
            try {
                res.close();
            } catch (Throwable e) {
                e.printStackTrace();
            }
        }
    }

}

package com.yaltec.comon.mysql;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.UUID;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class DBUtil {

	/**
	 * 日志记录器
	 */
	public static final Log logger = LogFactory.getLog("mysql.dbutil");

	/**
	 * 查询统计综合时用该key 获取对应的字段值
	 */
	public static final String COUNT_KEY = " totalCount ";

	/**
	 * 构建UUID
	 * 
	 * @return String
	 */
	public static String buildUuid() {

		String uuid = UUID.randomUUID().toString().toUpperCase();
		return uuid.replaceAll("-", "");
	}

	/**
	 * <pre>
	 * 转换普通SQL 的 select count(1) 语句 （Oracle 版本）
	 * 
	 * eg:&quot;select * from per_user&quot;;
	 *     &quot;select uuid from per_user where uuid in (select userId from per_userrole)&quot;
	 * </pre>
	 * 
	 * @param page
	 */
	public static String buildCountSql(String sql) {

		// int index = sql.indexOf("from");
		// sql = "select count(1) as " + OTALCOUNT_KEY + sql.substring(index,
		// sql.length());
		// return sql;
		return "select count(1) from (" + sql + ")";
	}

	/**
	 * <pre>
	 * 构建分页SQL语句（Oracle 版本）
	 * </pre>
	 * 
	 * @param sql
	 * @param pageSize
	 * @param pageNo
	 * @return
	 */
	public static String buildPageSql(String sql, int pageSize, int pageNo) {

		StringBuffer sb = new StringBuffer();
		String beginrow = String.valueOf((pageNo - 1) * pageSize);
		String endrow = String.valueOf(pageNo * pageSize);

		sb.append("select * from ( select row_.*, rownum rownum_ from ( ");
		sb.append(sql).append(" ) row_ where rownum<= ").append(endrow);
		sb.append(") where rownum_ > ").append(beginrow);

		return sb.toString();
	}

	/**
	 * 关闭会话中所有对象
	 * 
	 * @param conn
	 * @param stm
	 * @param res
	 */
	public static void close(Connection conn, Statement stm, ResultSet res) {

		close(conn);

		close(stm);

		close(res);
	}

	/**
	 * 关闭回话中所有对象
	 * 
	 * @param conn
	 * @param stm
	 * @param res
	 */
	public static void close(Statement stm, ResultSet res) {

		close(stm);

		close(res);
	}

	/**
	 * 关闭数据库相关操作对象
	 * 
	 * @param conn
	 */
	public static void close(Connection conn) {

		if (null != conn) {
			try {
				conn.close();

			} catch (Exception e) {
			} finally {
				conn = null;
			}
		}
	}

	/**
	 * 关闭数据库相关操作对象
	 * 
	 * @param stm
	 */
	public static void close(Statement stm) {

		if (null != stm) {
			try {
				stm.close();

			} catch (Exception e) {
			} finally {
				stm = null;
			}
		}
	}

	/**
	 * 关闭数据库相关操作对象
	 * 
	 * @param res
	 */
	public static void close(ResultSet res) {

		if (null != res) {
			try {
				res.close();

			} catch (Exception e) {
			} finally {
				res = null;
			}
		}
	}

	/**
	 * 释放 DBHandle中当前的Connection
	 * 
	 * @param dbHandle
	 */
	public static void release(DBHandle dbHandle) {

		if (null != dbHandle) {
			try {
				dbHandle.release();

			} catch (Exception e) {
			}
		}
	}

}

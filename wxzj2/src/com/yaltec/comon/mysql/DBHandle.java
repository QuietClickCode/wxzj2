package com.yaltec.comon.mysql;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.ParameterMetaData;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.sql.rowset.CachedRowSet;

import org.apache.commons.dbutils.QueryRunner;
import org.apache.commons.dbutils.handlers.BeanHandler;
import org.apache.commons.dbutils.handlers.BeanListHandler;
import org.apache.commons.dbutils.handlers.MapListHandler;
import org.apache.commons.dbutils.handlers.ScalarHandler;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.sun.rowset.CachedRowSetImpl;
import com.yaltec.comon.utils.ObjectUtil;
import com.yaltec.comon.utils.StringUtil;


public class DBHandle {

	/**
	 * 通用日志记录器
	 */
	public static final Log logger = LogFactory.getLog("mysql.dbhandle");

	private Connection conn;

	public DBHandle() {
		conn = getConnection();
		// conn = getConnectionForJavaApp();
	}

	public Connection getConnection() {
		try {
			return ConnectDb.getConnection();
		} catch (Exception e) {
			logger.error("获取数据库连接失败", e);
			return null;
		}

	}

	@SuppressWarnings("unchecked")
	public PageDataSet query(String sql, Object[] params, Class bean, int currentPage, int pageSize, int totalCount) {
		PageDataSet pds = new PageDataSet();
		try {
			QueryRunner queryRunner = new QueryRunner();
			if (totalCount == -1) {
				Object o = (Object) queryRunner.query(conn, DBUtil.buildCountSql(sql), new ScalarHandler(), params);
				totalCount = ((BigDecimal) o).intValue();
			}
			pds.init(currentPage, pageSize, totalCount);
			List list = (List) queryRunner.query(conn, DBUtil
					.buildPageSql(sql, pds.getPageSize(), pds.getCurrentPage()), new BeanListHandler(bean), params);
			pds.setDataset(list);
			return pds;
		} catch (Exception e) {
			logger.error(e.getMessage());
			return null;
		}
	}

	@SuppressWarnings("unchecked")
	public PageDataSet query(String sql, Object[] params, Class bean, int currentPage, int pageSize) {
		return query(sql, params, bean, currentPage, pageSize, -1);
	}

	public PageDataSet query(String sql, Object[] params, int currentPage, int pageSize, int totalCount) {
		PageDataSet pds = new PageDataSet();
		try {
			QueryRunner queryRunner = new QueryRunner();
			if (totalCount == -1) {
				Object o = (Object) queryRunner.query(conn, DBUtil.buildCountSql(sql), new ScalarHandler(), params);
				totalCount = ((BigDecimal) o).intValue();
			}
			pds.init(currentPage, pageSize, totalCount);
			List<Map<String, Object>> list = (List<Map<String, Object>>) queryRunner.query(conn, DBUtil.buildPageSql(
					sql, pds.getPageSize(), pds.getCurrentPage()), new MapListHandler(), params);
			pds.setDataset(list);
			return pds;
		} catch (Exception e) {
			logger.error(e.getMessage());
			return null;
		}

	}

	public PageDataSet query(String sql, Object[] params, int currentPage, int pageSize) {
		return query(sql, params, currentPage, pageSize, -1);
	}

	@SuppressWarnings("unchecked")
	public List query(String sql, Object[] params, Class bean) {
		try {
			QueryRunner queryRunner = new QueryRunner();
			List list = (List) queryRunner.query(conn, sql, new BeanListHandler(bean), params);
			return list;
		} catch (Exception e) {
			logger.error(e.getMessage());
			return null;
		}

	}

	public void release() {
		DBUtil.close(conn);
	}

	public int update(String sql, Object[] params) throws SQLException {
		QueryRunner queryRunner = new QueryRunner();
		return queryRunner.update(conn, sql, params);

	}

	public void beginTransation() throws SQLException {

		if (conn == null) {
			throw new SQLException("connection is null");
		}
		conn.setAutoCommit(false);

	}

	public void commit() throws SQLException {
		if (conn == null) {
			throw new SQLException("connection is null");
		}
		conn.commit();
		conn.setAutoCommit(true);

	}

	public void rollback() throws SQLException {
		if (conn == null) {
			throw new SQLException("connection is null");
		}
		conn.rollback();
		conn.setAutoCommit(true);

	}

	/**
	 * 批量处理SQL语句
	 * 
	 * @author liushiboy
	 * @edittime 2010.5.20
	 * @param sql
	 * @param paramList
	 * @return
	 * @throws SQLException
	 */
	public int updateBatch(String sql, Object[][] paramList) throws SQLException {
		QueryRunner queryRunner = new QueryRunner();
		int[] it = queryRunner.batch(conn, sql, paramList);
		int result = 0;
		for (int i = 0; i < it.length - 1; i++) {
			result += it[i];
		}
		return result;
	}

	/**
	 * 批量处理SQL语句
	 * 
	 * @author liushiboy
	 * @edittime 2010.5.20
	 * @param sql
	 * @param paramList
	 * @return
	 * @throws SQLException
	 */
	public int updateBatch(String sql, List<Object[]> paramList) throws SQLException {
		QueryRunner queryRunner = new QueryRunner();
		int[] it = queryRunner.batch(conn, sql, paramList);
		int result = 0;
		for (int i = 0; i < it.length; i++) {
			result += it[i];
		}
		return result;
	}

	/**
	 * 批量处理SQL语句
	 * 
	 * @author liushiboy
	 * @edittime 2010.5.20
	 * @param sqlList
	 * @param paramList
	 * @return
	 * @throws Exception
	 */
	public int updateBatch(List<String> sqlList, List<Object[]> paramList) throws SQLException {
		QueryRunner queryRunner = new QueryRunner();
		int result = 0;
		for (int i = 0; i < sqlList.size(); i++) {
			String sql = sqlList.get(i);
			if (paramList == null) {
				result += queryRunner.update(conn, sql);
			} else {
				result += queryRunner.update(conn, sql, paramList.get(i));
			}
		}
		return result;
	}

	/***************************************************************************
	 * 执行查询，将每行的结果保存到DtoBean中，然后将所有DtoBean保存到List中
	 * 
	 */
	@SuppressWarnings("unchecked")
	public <T> List<T> query(Class<T> entityClass, String sql, Object[] params) {
		List<T> result = null;
		try {
			QueryRunner queryRunner = new QueryRunner();
			if (params == null) {
				result = (List<T>) queryRunner.query(conn, sql, new BeanListHandler(entityClass));
			} else {
				result = (List<T>) queryRunner.query(conn, sql, new BeanListHandler(entityClass), params);
			}
			return result;
		} catch (Exception e) {
			logger.error(e.getMessage());
			return null;
		}
	}

	/***************************************************************************
	 * 执行查询，将每行的结果保存到DtoBean中，然后将所有DtoBean保存到List中
	 * 
	 */
	public <T> List<T> query(Class<T> entityClass, String sql) {
		return query(entityClass, sql, null);
	}

	/**
	 * 查询出结果集中的第一条记录，并封装成对象
	 * 
	 * @author liushiboy
	 * @history 2010.5.20
	 * @param entityClass
	 *            类名
	 * @param sql
	 *            sql语句
	 * @param params
	 *            参数数组
	 * @return 对象
	 */
	/**
	 * @author liuchun
	 * @history 2011-5-24 下午11:40:46
	 * @description 变Object[]为Object...params
	 */
	/**
	 * @author liuchun
	 * @edittime 2011-5-31 下午09:13:20
	 * @description 取消了，使用模式有冲突
	 */
	@SuppressWarnings("unchecked")
	public <T> T queryFirst(Class<T> entityClass, String sql, Object[] params) {
		QueryRunner queryRunner = new QueryRunner();
		Object object = null;
		try {
			if (params == null) {
				object = queryRunner.query(conn, sql, new BeanHandler(entityClass));
			} else {
				object = queryRunner.query(conn, sql, new BeanHandler(entityClass), params);
			}
		} catch (SQLException e) {
			logger.error(e.getMessage());
		}
		return (T) object;
	}

	/**
	 * @author liuchun
	 * @edittime 2011-5-31 下午09:48:32
	 * @description
	 */
	public <T> T queryFirst(Class<T> entityClass, String sql) {
		return queryFirst(entityClass, sql, null);
	}

	/**
	 * 执行查询，将每行的结果保存到一个Map对象中，然后将所有Map对象保存到List中
	 * 
	 * @author liushiboy
	 * @edittime 2010.5.20
	 * @param sql
	 *            sql语句
	 * @param params
	 *            参数数组
	 * @return 查询结果
	 */
	/**
	 * @author liuchun
	 * @edittime 2011-5-24 下午11:25:01
	 * @description 修改可变参数Object... params. cu.username
	 *              依然使用username去访问，如果相同使用cu.username as shit
	 */
	// @SuppressWarnings("unchecked")
	public List<Map<String, Object>> query(String sql, Object... params) {
		QueryRunner queryRunner = new QueryRunner();
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		try {
			if (params == null) {
				list = (List<Map<String, Object>>) queryRunner.query(conn, sql, new MapListHandler());
			} else {
				list = (List<Map<String, Object>>) queryRunner.query(conn, sql, new MapListHandler(), params);
			}
		} catch (SQLException e) {
			logger.error(e.getMessage());
		}
		return list;
	}

	/***************************************************************************
	 * 功能：输入sql语句，传回CachedRowSet接口对象
	 * 
	 * 示例：利用sql语句，查询结果，并遍历整个结果集 import javax.sql.rowset.CachedRowSet;
	 * 
	 * DBHandle db=new DBHandle(); try{ String sqlstr="select * from table where
	 * f=123"; CachedRowSet rs= db.executeQuery(sqlstr);
	 * 
	 * while(rs.next()){ System.out.println(rs.getString("field1")); } }
	 * catch(SQLException e){ logger.error("CachedRowSet查询失败", e); } finally{ }
	 * 
	 * @param sqlstr
	 * @return
	 * @throws java.sql.SQLException
	 */
	public CachedRowSet executeQuery(String sqlstr) throws java.sql.SQLException {
		CachedRowSet cst = new CachedRowSetImpl();
		Statement ps = null;
		ResultSet rs = null;
		try {
			String sql = escapeNull(sqlstr);
			ps = conn.createStatement();
			rs = ps.executeQuery(sql);
			cst.populate(rs);
		} catch (SQLException e) {
			throw new SQLException("数据查询出错" + e.getMessage() + "出错sql为：" + sqlstr);
		} finally {
			if (rs != null) {
				rs.close();
				rs = null;
			}
			if (ps != null) {
				ps.close();
				ps = null;
			}
		}
		return cst;
	}

	/**
	 * 执行<b>批量</b>增、删、改操作, 返回更新影响记录行数.
	 * 
	 * @param key
	 *            数据库类别Key.
	 * @param sql
	 *            更新SQL.
	 * @param params
	 *            更新参数列表.
	 * @return int 更新影响记录行数.
	 * @throws DbException
	 */
	public int batch(final String sql, final Object[][] params) throws java.sql.SQLException {
		QueryRunner qr = new QueryRunner();
		int[] count;
		count = qr.batch(conn, sql, params);
		int result = 0;
		if (!ObjectUtil.isEmpty(count)) {
			for (int i = 0; i < count.length; i++) {
				result += count[i];
			}
		}
		return result;
	}

	/***************************************************************************
	 * 功能：输入sql语句，传回CachedRowSet接口对象
	 * 
	 * @param sqlstr
	 * @param params
	 *            preparestatement的值
	 * @return
	 * @throws java.sql.SQLException
	 */
	/**
	 * @author liuchun
	 * @edittime 2011-5-24 下午11:25:55
	 * @description add ps.clos()
	 */
	public CachedRowSet executeQuery(String sqlstr, Object... params) throws java.sql.SQLException {
		CachedRowSet cst = new CachedRowSetImpl();
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			String sql = escapeNull(sqlstr);
			ps = conn.prepareStatement(sql);
			this.fillPreparedStatement(ps, params);
			rs = ps.executeQuery();
			cst.populate(rs);
		} catch (SQLException e) {
			throw new SQLException("数据查询出错" + e.getMessage() + "出错sql为：" + sqlstr);
		} finally {
			if (rs != null) {
				rs.close();
				rs = null;
			}
			if (ps != null) {
				ps.close();
				ps = null;
			}
		}
		return cst;
	}

	/**
	 * 从QueryRunner参考 Fill the <code>PreparedStatement</code> replacement
	 * parameters with the given objects.
	 * 
	 * @param stmt
	 *            PreparedStatement to fill
	 * @param params
	 *            Query replacement parameters; <code>null</code> is a valid
	 *            value to pass in.
	 * @throws SQLException
	 *             if a database access error occurs
	 */
	private volatile boolean pmdKnownBroken = false;

	public void fillPreparedStatement(PreparedStatement stmt, Object... params) throws SQLException {

		if (params == null) {
			return;
		}

		ParameterMetaData pmd = null;
		if (!pmdKnownBroken) {
			pmd = stmt.getParameterMetaData();
			if (pmd.getParameterCount() < params.length) {
				throw new SQLException("Too many parameters: expected " + pmd.getParameterCount() + ", was given "
						+ params.length);
			}
		}
		for (int i = 0; i < params.length; i++) {
			if (params[i] != null) {
				stmt.setObject(i + 1, params[i]);
			} else {
				// VARCHAR works with many drivers regardless
				// of the actual column type. Oddly, NULL and
				// OTHER don't work with Oracle's drivers.
				int sqlType = Types.VARCHAR;
				if (!pmdKnownBroken) {
					try {
						sqlType = pmd.getParameterType(i + 1);
					} catch (SQLException e) {
						pmdKnownBroken = true;
					}
				}
				stmt.setNull(i + 1, sqlType);
			}
		}
	}

	/**
	 * 获取单行单列数据
	 * 
	 * @param sql
	 * @param params
	 * @return
	 */
	/**
	 * @author liuchun
	 * @edittime 2011-5-31 下午09:52:56
	 * @description add params=null
	 */
	public Object queryScalar(String sql, Object... params) {
		try {
			QueryRunner queryRunner = new QueryRunner();
			Object obj;
			if (params == null) {
				obj = (Object) queryRunner.query(conn, sql, new ScalarHandler());
			} else {
				obj = (Object) queryRunner.query(conn, sql, new ScalarHandler(), params);
			}
			return obj;
		} catch (Exception e) {
			logger.error(e.getMessage());
			return null;
		}
	}

	public PreparedStatement getpreparedStatement(String sql) {
		try {
			return conn.prepareStatement(sql);
		} catch (SQLException e) {
			logger.error(e.getMessage());
			return null;
		}
	}

	private String escapeNull(String str) {
		str = StringUtil.replace(str, "'null'", "''");
		str = StringUtil.replace(str, "'%null%'", "'%'");
		return str;
	}

}

package com.yaltec.comon.mysql;

import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Connection;

public class ConnectDb {

	/**
	 * MYsql数据库连接配置
	 */
	private static String driveClassName = "com.mysql.jdbc.Driver";
	private static String url = "jdbc:mysql://127.0.0.1:3306/bosssoft?useUnicode=true&characterEncoding=utf8";
	private static String user = "bosssoft";
	private static String password = "bosssoft";

	public static Connection getConnection() {
		Connection conn = null;

		// load driver
		try {
			Class.forName(driveClassName);
		} catch (ClassNotFoundException e) {
			System.out.println("load driver failed!");
			e.printStackTrace();
		}
		// connect db
		try {
			conn = DriverManager.getConnection(url, user, password);
		} catch (SQLException e) {
			System.out.println("connect failed!");
			e.printStackTrace();
		}

		return conn;
	}
}

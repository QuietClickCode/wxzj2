package com.yaltec.comon.utils;

import java.net.URLDecoder;

public class GetDirPath {
	/**
	 *<p>文件名称: getDirPath.java</p>
	 * <p>文件描述: 获取路径（临时文件夹路径，项目路径）</p>
	 * <p>版权所有: 版权所有(C)2010</p>
	 * <p>公   司: yaltec</p>
	 * <p>内容摘要: </p>
	 * <p>其他说明: </p>
	 * <p>完成日期：Nov 11, 2010</p>
	 * <p>修改记录0：无</p>
	 * @version 1.0
	 * @author jiangyong
	 */
	
	/**
	 * 获取项目的绝对路径
	 */
	@SuppressWarnings("deprecation")
	public static String getProjectRootPath() {
		String projectpath = GetDirPath.class.getResource("/").toString();
		projectpath = projectpath.substring(0, projectpath.indexOf("/WEB-INF"));
		projectpath = projectpath.substring(6, projectpath.length());
		projectpath = URLDecoder.decode(projectpath);
		return projectpath;
	}
	
	/**
	 * 获取tomcat项目的绝对路径
	 */
	@SuppressWarnings("deprecation")
	public static String getProjectSPath() {
		String projectpath = GetDirPath.class.getResource("/").toString();
		projectpath = projectpath.substring(0, projectpath.indexOf("webapps") + 7);
		projectpath = projectpath.substring(6, projectpath.length());
		projectpath = URLDecoder.decode(projectpath);
		return projectpath;
	}
	
	/**
	 * 获取保存临时文件的绝对路径
	 */
	@SuppressWarnings("deprecation")
	public static String getTempFilePath() {
		String tempfilepath = getProjectRootPath() + "/temp";
		return tempfilepath;
	}
}

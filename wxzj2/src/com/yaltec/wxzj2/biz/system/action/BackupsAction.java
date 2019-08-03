package com.yaltec.wxzj2.biz.system.action;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.yaltec.comon.log.LogUtil;
import com.yaltec.comon.log.entity.Log;
import com.yaltec.wxzj2.biz.system.service.BackupsService;

/**
 * 
 * @ClassName: BackupsAction
 * @Description: TODO 中心数据管理-数据备份信息实现类
 * 
 * @author jiangyong
 * @date 2016-9-27 下午03:50:41
 */
@Controller
public class BackupsAction {

	@Autowired
	private BackupsService backupsService;
	
	/**
	 * FTP开关，默认false
	 */
	@Value("${ftp.open}")
	private String ftpOpen;
	
	/**
	 * FTP的IP
	 */
	@Value("${ftp.host}")
	private String ftpHost;

	/**
	 * FTP的端口
	 */
	@Value("${ftp.port}")
	private String ftpPort;

	/**
	 * FTP的登录用户
	 */
	@Value("${ftp.user}")
	private String ftpUser;

	/**
	 * FTP的登录密码
	 */
	@Value("${ftp.password}")
	private String ftpPassword;
	
	/**
	 * ftp目录
	 */
	@Value("${ftp.path}")
	private String ftpPath;
	
	
	/**
	 * 跳转到数据备份首页
	 */
	@RequestMapping("/backups/index")
	public String index(Model model){
		LogUtil.write(new Log("中心数据管理信息", "查询", "BackupsAction.list", ""));
		if (ftpOpen.contains("true")) {
			model.addAttribute("ftpHost", ftpHost);
			model.addAttribute("ftpPort", ftpPort);
			model.addAttribute("ftpUser", ftpUser);
			model.addAttribute("ftpPassword", ftpPassword);
			model.addAttribute("ftpPath", ftpPath);
		}
		return "/system/backups/index";
	}
	
	/**
	 * 备份数据库
	 * @throws IOException 
	 */
	@RequestMapping("/backups/backupDB")
	public void backupDB(String url, String fileName, String compression,HttpServletResponse response) throws IOException {
		File filez = new File(url);
		if(!filez.exists()){
			filez.mkdirs();
		}
		String path = url + fileName;
		LogUtil.write(new Log("中心数据管理信息", "备份", "BackupsAction.backupDB", path));
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		
		try {
			backupsService.backupDB(path, compression);
			// 执行完成后未跑出异常则默认为执行成功
			pw.print(1);
			return ;
		} catch (Exception e) {
			e.printStackTrace();
		}
		// 默认执行失败
		pw.print(0);
	}
}

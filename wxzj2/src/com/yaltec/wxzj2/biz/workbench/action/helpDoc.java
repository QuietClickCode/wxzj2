package com.yaltec.wxzj2.biz.workbench.action;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLEncoder;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * 
 * @ClassName: helpDoc
 * @Description: 帮助文档实现类
 * 
 * @author yangshanping
 * @date 2017-6-15 上午10:11:56
 */
@Controller
public class helpDoc {
	/**
	 * 显示帮助文档
	 */
	@RequestMapping("help")
	public void toHelp(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// 定义输入、输出流
		FileInputStream fis = null;
		BufferedInputStream buff = null;
		OutputStream myout = null;
		try {
			// 获取根目录
			String strDirPath = request.getSession().getServletContext()
					.getRealPath("/");
			// 设置格式
			response.setContentType("application/pdf");
			response.setHeader("Content-Disposition", "filename="
					+ URLEncoder.encode("help.pdf", "utf-8"));
			//	读取帮助文档
			File file = new File(strDirPath + "template\\help.pdf");
			// 获取文档长度
			response.setContentLength((int) file.length());
			fis = new FileInputStream(file);
			buff = new BufferedInputStream(fis);
			byte[] b = new byte[1024];
			long k = 0;
			myout = response.getOutputStream();
			// 输出到页面
			while (k < file.length()) {
				int j = buff.read(b, 0, 1024);
				k += j;
				myout.write(b, 0, j);
			}
		} catch (IOException e) {
			System.out.println(e.getMessage());
		} finally {
			if (buff != null)
				buff.close();
			if (myout != null)
				myout.close();
			if (fis != null)
				fis.close();
		}

	}
}

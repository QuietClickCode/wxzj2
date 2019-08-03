package com.yaltec.wxzj2.biz.system.action;


import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.net.Socket;
import java.net.UnknownHostException;

import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.github.pagehelper.StringUtil;
import com.yaltec.comon.log.LogUtil;
import com.yaltec.comon.log.entity.Log;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 
 * @ClassName: BankInterfaceTest
 * @Description: TODO 银行接口测试实现类
 * 
 * @author chenxiaokuang
 * @date 2016-9-5 上午09:28:41
 */
@Controller
public class BankInterfaceTestAction {

	
	/**
	 * 进入银行接口测试首页
	 * 
	 * @return 跳转的JSP页面
	 */
	@RequestMapping("/BankInterfaceTest/index")
	public String index(Model model) {
		// 跳转的JSP页面
		model.addAttribute("bank", DataHolder.dataMap.get("bank"));
		return "/system/bankinterfacetest/index";
	}
	
	
	/**
	 * 根据收款银行 和 房屋编号/业务编号 获取银行接口测试状态
	 * 
	 * @throws IOException 
	 */
	@RequestMapping("/BankInterfaceTest/query")
	public void query(String bankCode, String h001,HttpServletResponse response) throws IOException {
		LogUtil.write(new Log("银行接口测试", "查询", "BankInterfaceTestAction.query", ""));
		PrintWriter pw = response.getWriter();
		String type = "";
		if (StringUtil.isEmpty(h001))
			return;
		if (h001.length() == 14) {
			type = "00";
		} else if (h001.length() == 8) {
			type = "01";
		}
		String in_xml1 = "<?xml version=\"1.0\" encoding=\"GBK\"?><XML_Info><source>"
				+ bankCode
				+ "</source>"
				+ "<method>QUERY</method><parameters><accNo>"
				+ h001
				+ "</accNo><type>" + type + "</type></parameters></XML_Info>";
		String  result = _exec(in_xml1);
		if(!StringUtil.isEmpty(result)) {
			if(result.indexOf("<error>08</error>")>0) {
				result = "0";
			} else {
				result ="1";
			}
		} else{
			result = "0";
		}
		pw.write(result);
	}
	
	
	
	public static String _exec(String in_xml) {
		Socket socket = null;
		OutputStream netOut = null;
		DataOutputStream doc = null;
		DataInputStream in = null;
		try {
			socket = new Socket("127.0.0.1", 8083);
			netOut = socket.getOutputStream();
			doc = new DataOutputStream(netOut);

			in = new DataInputStream(socket.getInputStream());
			// 向服务器端发送字符串
			doc.write(in_xml.getBytes());
			doc.flush();

			byte[] bt = new byte[1024];
			int j = 1, b;
			String r = "";
			while ((b = in.read(bt)) > 0) {
				String res = new String(bt, 0, b);
				r = r+res;
				j++;
			}
			return r;
		} catch (UnknownHostException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			try {
				if (netOut != null)
					netOut.close();
				if (doc != null)
					doc.close();
				if (in != null)
					in.close();
				if (socket != null)
					socket.close();
			} catch (IOException e) {
			}
		}
		return null;
	}
}


package com.yaltec.wxzj2.biz;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Map;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.yaltec.comon.utils.http.HttpUtil;
import com.yaltec.comon.utils.http.entity.HttpResult;

public class T {

	public static Map<String, String> headers = new HashMap<String, String>();
	public static Map<String, Object> params = new HashMap<String, Object>();
	public static String url = "http://119.23.114.82:6666/cmppweb/sendsms";
	
	// 根据id删除通知信息
	public static void test() throws JsonProcessingException, UnsupportedEncodingException {
		// 必须设置参数类型
		//headers.put("Content-type", "application/json");
		params.put("uid", "104346");
		params.put("pwd", "8fabaa9bbf9c6b38d5f23896aa6b3941");
		params.put("mobile", "15923065923");
		params.put("srcphone", "106910134346");
		String msg = URLEncoder.encode("【重庆互联网+物业】您的验证码为123456。请勿向他人透露", "UTF-8");
		System.out.println(msg);
		params.put("msg", msg);
		
		HttpResult result = HttpUtil.doPost(url, headers, params);
		System.out.println(result.getText());
	}

	public static void main(String[] args) {
		try {
			test();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
}

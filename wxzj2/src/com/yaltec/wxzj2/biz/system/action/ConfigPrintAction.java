package com.yaltec.wxzj2.biz.system.action;

import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.yaltec.comon.auth.TokenHolder;
import com.yaltec.comon.utils.JsonUtil;
import com.yaltec.wxzj2.biz.draw.entity.CodeName;
import com.yaltec.wxzj2.biz.system.entity.ConfigPrint;
import com.yaltec.wxzj2.biz.system.service.ConfigPrintService;
import com.yaltec.wxzj2.biz.system.service.UserService;

/**
 * 
 * @ClassName: ConfigPrintAction
 * @Description: TODO 打印参数设置实现类
 * 
 * @author hqx
 * @date 2016-10-13 上午10:08:41
 */
@Controller
public class ConfigPrintAction {
	
	@Autowired
	private UserService userService;
	
	@Autowired
	private ConfigPrintService configprintservice;
	
	/**
	 * 查询交存标准设置列表
	 * 
	 * @return 跳转的JSP页面
	 */
	@RequestMapping("/configPrint/index")
	public String index(Model model) {
		// 跳转的JSP页面
		return "/system/configprint/index";
	}
	
	/**
	 * 获取打印配置信息放入select
	 * @param request
	 * @param model
	 * @param response
	 * @param userid
	 */
	@RequestMapping("/configPrint/printSet")
	public void getPrint(HttpServletRequest request,Model model,HttpServletResponse response) {
		try{
			response.setCharacterEncoding("utf-8");
			PrintWriter pw = response.getWriter();
			Map<String,Object> resultMap=new HashMap<String,Object>();
			List<CodeName> list=userService.printset();
			resultMap.put("list", list);
			pw.print(JsonUtil.toJson(resultMap));
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * 按打印标识检查打印配置信息
	 * @param request
	 * @param model
	 * @param response
	 * @param userid
	 */
	@RequestMapping("/qureyConfigPrint/ConfigPrint")
	public void queryConfigPrint(HttpServletRequest request,Model model,HttpServletResponse response,String moduleKey) {
		try{
			response.setCharacterEncoding("utf-8");
			PrintWriter pw = response.getWriter();
			Map<String,Object> resultMap=new HashMap<String,Object>();
			List<ConfigPrint> list=configprintservice.queryConfigPrintByModuleKey(moduleKey);
			resultMap.put("list", list);
			pw.print(JsonUtil.toJson(resultMap));
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * 判断打印名称、打印标识在数据库是否存在
	 * @param request
	 * @param model
	 * @param response
	 * @param method
	 * @param para
	 */
	@RequestMapping("/qureyConfigPrint/ifExists")
	public void ifExists(HttpServletRequest request,Model model,HttpServletResponse response,String method,String para) {
		try{
			response.setCharacterEncoding("utf-8");
			PrintWriter pw = response.getWriter();
			Map<String,String> paraMap=new HashMap<String,String>();
			paraMap.put("para", para);
			paraMap.put("resultName", "");
			paraMap.put("resultIndex", "");
			if("ifNameExists".equals(method.toString())){
				String resultName=configprintservice.ifNameExists(paraMap);
				if( Integer.parseInt(resultName)>0){
					paraMap.put("result", "1");
				}else{
					paraMap.put("result", "0");
				}
				
			}else if("ifModuleKeyExists".equals(method.toString())){
				String resultIndex=configprintservice.ifModuleKeyExists(paraMap);
				if( Integer.parseInt(resultIndex)>0){
					paraMap.put("result", "2");
				}else{
					paraMap.put("result", "0");
				}
			}
			pw.print(JsonUtil.toJson(paraMap));
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * 判断属性标识在数据库是否存在
	 */
	@RequestMapping("/configPrint/ifPropertyExists")
	public void ifPropertyExists(HttpServletRequest request,Model model,HttpServletResponse response,String property,String moduleKey) {
		try{
			response.setCharacterEncoding("utf-8");
			PrintWriter pw = response.getWriter();
			Map<String,String> paraMap=new HashMap<String,String>();
			paraMap.put("moduleKey", moduleKey);
			paraMap.put("property", property);
			String result=configprintservice.ifPropertyExists(paraMap);
			paraMap.put("result", result);
			pw.print(JsonUtil.toJson(paraMap));
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * 保存打印参数设置
	 */
	@RequestMapping("/configPrint/saveConfigPrint")
	public void saveConfigPrint(HttpServletRequest request,Model model,HttpServletResponse response,String moduleKey,String name,
			String property,String propertyName,String num,String fontsize,String color,String x,String y,String note) {
		try{
			response.setCharacterEncoding("utf-8");
			PrintWriter pw = response.getWriter();
			Integer r = -1;
			String[] propertyArray = property.toString().split(",");
			String[] propertyNameArray = propertyName.toString().split(",");
			String[] numArray = num.toString().split(",");
			String[] fontsizeArray = fontsize.toString().split(",");
			String[] colorArray = color.toString().split(",");
			String[] xArray = x.toString().split(",");
			String[] yArray = y.toString().split(",");
			String[] noteArray = note.toString().split(",");
			
			Map<String,Object> paramMap=new HashMap<String,Object>();
			paramMap.put("moduleKey", moduleKey);
			configprintservice.delConfigPrint(paramMap);
			
			for (int i = 0; i < numArray.length; i++) {
				if (numArray.equals("")){
					 r=-1;
				}else{
					paramMap.put("moduleKey", moduleKey);
					paramMap.put("name", name);
					paramMap.put("property", propertyArray[i]);
					paramMap.put("num", numArray[i]);
					paramMap.put("fontsize", fontsizeArray[i]);
					paramMap.put("color", colorArray[i]);
					paramMap.put("x", xArray[i]);
					paramMap.put("y", yArray[i]);
					try {
						paramMap.put("note", noteArray[i]);
					} catch (RuntimeException e) {
						paramMap.put("note", "");
					}
					try {
						paramMap.put("propertyName", propertyNameArray[i]);
					} catch (RuntimeException e) {
						paramMap.put("propertyName", "");
					}
					paramMap.put("operid", TokenHolder.getUser().getUserid());
					paramMap.put("opername", TokenHolder.getUser().getUsername());
					configprintservice.saveConfigPrint(paramMap);
					r = 1;
				}
			}
			
			paramMap.put("result", r);
			pw.print(JsonUtil.toJson(paramMap));
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
	
	
	
	
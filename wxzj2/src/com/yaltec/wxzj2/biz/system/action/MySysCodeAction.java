package com.yaltec.wxzj2.biz.system.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.yaltec.comon.core.entity.ReqPamars;
import com.yaltec.comon.utils.JsonUtil;
import com.yaltec.wxzj2.biz.system.entity.CodeName;
import com.yaltec.wxzj2.biz.system.entity.Enctype;
import com.yaltec.wxzj2.biz.system.entity.MySysCode;
import com.yaltec.wxzj2.biz.system.service.MySysCodeService;

/**
 * 
 * @ClassName: EnctypeAction
 * @Description: TODO 系统编码信息实现类
 * 
 * @author hequanxin
 * @date 2016-7-13 上午10:08:41
 */
@Controller
public class MySysCodeAction {
	
	@Autowired
	private MySysCodeService MSCService;

	/**
	 * 系统编码设置页面
	 */
	@RequestMapping("/sysCode/list")
	public String list(Integer pageNo, Integer pageSize, Enctype enctype, Model model){
		List<CodeName> list=MSCService.findList();
		String zNodes = JsonUtil.toJson(list);
		zNodes = zNodes.replaceAll("bm", "id");
		zNodes = zNodes.replaceAll("mc", "name");
		model.addAttribute("zNodes2", zNodes);		
		return "/system/MySysCode/index";
	}
	
	/**
	 * 根据编码类型名称查询对应的编码信息
	 * @param pageNo
	 * @param pageSize
	 * @param MScode
	 * @param model
	 * @param redirectAttributes
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping("/sysCode/findById")
	public void findById(@RequestBody ReqPamars req, HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		List<Map<String,String>> list = MSCService.findById(req.getParams());
		// 返回结果
		pw.print(JsonUtil.toJson(list));
	}
	
	/**
	 * 跳转到添加页面
	 * @param request
	 * @param MScode
	 * @param model
	 * @return
	 */
	@RequestMapping("/sysCode/toAdd")
	public String toAdd(HttpServletRequest request,MySysCode MScode,Model model){
		String mycode_bm=request.getParameter("mycode_bm");
		String bm=MSCService.findByMycodeBm(mycode_bm);
		String xh="";
		if(bm==null||bm==""){
			bm=mycode_bm+"0001";
			xh="0001";
		}else{
			int bmNum=Integer.parseInt(bm)+1;
			bm=String.valueOf(bmNum);
			//截取最后四位
			xh=bm.substring(bm.length()-4,bm.length());
		}
		// 编码的值显示为8位，位数不够左边加0
		bm=String.format("%08d", Integer.parseInt(bm));
		model.addAttribute("bm", bm);
		model.addAttribute("xh",xh);
		model.addAttribute("mycode_bm", mycode_bm);
		return "/system/MySysCode/add";
	}
	
	/**
	 * 添加系统编码
	 * @param mycode_bm
	 * @param request
	 * @param MScode
	 * @param model
	 * @param redirectAttributes
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping("/sysCode/add")
	public void add(HttpServletRequest request,HttpServletResponse response, MySysCode MScode,
			Model model,MySysCode mySysCode,RedirectAttributes redirectAttributes){
		
		Map<String, String> map = JsonUtil.toObject(request.getParameter("data"), HashMap.class);
		try {
			int result = MSCService.add(map);
			PrintWriter pw = response.getWriter();
			// 返回结果
			pw.print(JsonUtil.toJson(result));
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * 跳转到系统编码编辑界面
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/sysCode/toUpdate")
	public String toUpdate(String bm, Model model) {
		MySysCode MySysCode = MSCService.findByBm(bm);
		model.addAttribute("MySysCode", MySysCode);
		return "/system/MySysCode/update";
	}
	
	/**
	 * 修改系统编码信息
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/sysCode/update")
	public void update(HttpServletRequest request, HttpServletResponse response,Model model,
			RedirectAttributes redirectAttributes) {
		Map<String, String> map = new HashMap<String, String>();
		map = JsonUtil.toObject(request.getParameter("data"), HashMap.class);
		try {
			int result = MSCService.update(map);
			PrintWriter pw = response.getWriter();
			// 返回结果
			pw.print(JsonUtil.toJson(result));
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
}




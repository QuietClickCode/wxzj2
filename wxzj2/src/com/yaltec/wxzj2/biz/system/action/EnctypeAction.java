package com.yaltec.wxzj2.biz.system.action;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.comon.core.entity.ReqPamars;
import com.yaltec.comon.log.LogUtil;
import com.yaltec.comon.log.entity.Log;
import com.yaltec.wxzj2.biz.comon.service.IdUtilService;
import com.yaltec.wxzj2.biz.system.entity.Enctype;
import com.yaltec.wxzj2.biz.system.service.EnctypeService;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * @ClassName: EnctypeAction
 * @Description: TODO 编码类型信息实现类
 * 
 * @author hequanxin
 * @date 2016-7-13 上午10:08:41
 */
@Controller
public class EnctypeAction {

	@Autowired
	private EnctypeService enctypeService;
	
	@Autowired
	private IdUtilService idUtilService;

	/**
	 * 跳转到首页
	 * @author hequanxin
	 */
	@RequestMapping("/enctype/index")
	public String index(Model model) {
		return "/system/enctype/index";
	}
	
	/**
	 * 编码类型添列表
	 * @param req
	 * @param request
	 * @param response
	 * @throws IOException
	 */
	@RequestMapping("/enctype/list")
	public void list(@RequestBody ReqPamars<Enctype> req, HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 添加操作日志
		LogUtil.write(new Log("编码类型", "查询", "EnctypeAction.list", req.toString()));
		Page<Enctype> page = new Page<Enctype>(req.getEntity(), req.getPageNo(), req.getPageSize());
		enctypeService.findAll(page);
		// 返回结果
		pw.print(page.toJson());
	}
	
	/**
	 * 编码类型添加页面
	 */
	@RequestMapping("/enctype/toAdd")
	public String toAdd(HttpServletRequest request,Model model){
		String bm = "";
		try {
			bm = idUtilService.getNextBm("MYcode");
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("bm", bm);
		model.addAttribute("enctype", DataHolder.dataMap.get("enctype"));
		return "/system/enctype/add";
	}
	
	/**
	 * 编码类型信息
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/enctype/add")
	public String add(Enctype enctype, HttpServletRequest request, Model model,
			RedirectAttributes redirectAttributes) {
		// 添加操作日志
		LogUtil.write(new Log("编码类型", "增加", "EnctypeAction.add", enctype.toString()));
		Enctype _enctype=enctypeService.findByMc(enctype.getMc());
		if (_enctype != null) {
			request.setAttribute("msg", "名称已存在");
			String bm = "";
			try {
				bm = idUtilService.getNextBm("MYcode");
			} catch (Exception e) {
				e.printStackTrace();
			}
			model.addAttribute("bm", bm);
			model.addAttribute("enctype", DataHolder.dataMap.get("enctype"));
			return "/system/enctype/add";
		}else{
			int result = enctypeService.add(enctype);
			if (result > 0) {
				redirectAttributes.addFlashAttribute("msg", "添加成功");
				return "redirect:/enctype/index";
			} else {
				request.setAttribute("msg", "添加失败");
				return "/system/enctype/add";
			}
		}	
	}
	
	/**
	 * 跳转到编码类型信息编辑界面
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/enctype/toUpdate")
	public String toUpdate(String bm, Model model) {
		Enctype enctype = enctypeService.findByBm(bm);
		model.addAttribute("enctype", enctype);
		return "/system/enctype/update";
	}
	
	/**
	 * 修改编码类型信息
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/enctype/update")
	public String update(Enctype enctype, HttpServletRequest request, Model model,
			RedirectAttributes redirectAttributes) {
		String _result=enctypeService.findByBmMc(enctype);
		if (_result ==null||_result=="") {
			// 添加操作日志
			LogUtil.write(new Log("编码类型", "修改", "EnctypeAction.update", enctype.toString()));
			int result = enctypeService.update(enctype);
			if (result > 0) {
				redirectAttributes.addFlashAttribute("msg", "修改成功");
				return "redirect:/enctype/index";
			} else {
				request.setAttribute("msg", "修改失败");
				return "/system/enctype/update";
			}
		} else {
			request.setAttribute("msg", "编码类型名称已存在！");
			return "/system/enctype/update";
			
		}	
	}
}	

package com.yaltec.wxzj2.biz.bill.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;


import com.yaltec.comon.auth.TokenHolder;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.comon.core.entity.ReqPamars;
import com.yaltec.comon.log.LogUtil;
import com.yaltec.comon.log.entity.Log;
import com.yaltec.comon.utils.DateUtil;
import com.yaltec.comon.utils.StringUtil;
import com.yaltec.wxzj2.biz.bill.entity.BillM;
import com.yaltec.wxzj2.biz.bill.service.BillMService;
import com.yaltec.wxzj2.biz.bill.service.word.ExportWord;
import com.yaltec.wxzj2.comon.data.DataHolder;


/**
 * 
 * @ClassName: BillMAction
 * @Description: TODO票据信息实现类
 * 
 * @author moqian
 * @date 2016-7-18 下午15:12:03
 */

@Controller
public class BillMAction {
	
	@Autowired
	private BillMService billMService;	
	
	/**
	 * 查询票据信息列表
	 */
	@RequestMapping("/billM/index")
	public String index(Model model){
		model.addAttribute("banks", DataHolder.dataMap.get("bank"));
		model.addAttribute("user", TokenHolder.getUser());
		return "/bill/billM/index";
	}
		
	/**
	 * 查询票据信息列表
	 */
	@RequestMapping("/billM/list")
	public void list(@RequestBody ReqPamars<BillM> req, HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		// 新增操作日志
		LogUtil.write(new Log("票据信息", "查询", "BillMAction.list", req.toString()));
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		Page<BillM> page = new Page<BillM>(req.getEntity(), req.getPageNo(), req.getPageSize());
		billMService.findAll(page);
		pw.print(page.toJson());
	}
	
	/**
	 *跳转到新增票据信息页面
	 */
	@RequestMapping("/billM/toAdd")
	public String toAdd(HttpServletRequest request, Model model) {
		model.addAttribute("pjlbmcs", DataHolder.billTypeMap);
		model.addAttribute("banks", DataHolder.dataMap.get("bank"));
		model.addAttribute("user", TokenHolder.getUser());
		return "/bill/billM/add";
	}
	
	/**
	 * 保存新增票据信息
	 * @param request 
	 * @param qsh 
	 * @param gmrq 
	 * @return
	 */
	@RequestMapping("/billM/add")
	public String add(BillM billM, HttpServletRequest request, Model model, RedirectAttributes redirectAttributes, 
			String qsh, String gmrq) {
		billM.setBm("");
		//日期为空时赋当前时间
		if (gmrq == null || "".equals(gmrq)) {
			billM.setGmrq(DateUtil.getDate());
		}
		Map<String, String> paramMap = toMap(billM);
		// 新增操作日志
		LogUtil.write(new Log("票据信息", "新增", "BillMAction.add", paramMap.toString()));
		// 数据库中编码bm
		int result = billMService.save(paramMap);
		if (result == 0) {
			redirectAttributes.addFlashAttribute("msg", "新增成功！");
			return "redirect:/billM/index";
		} else if (result == 3) {
			request.setAttribute("msg", "以"+qsh+"为起始号的票据信息已经存在,请检查！");
			model.addAttribute("banks", DataHolder.dataMap.get("bank"));
			model.addAttribute("pjlbmcs", DataHolder.billTypeMap);
			return "/bill/billM/add";
		} else {
			request.setAttribute("msg", "新增失败！");
			model.addAttribute("banks", DataHolder.dataMap.get("bank"));
			model.addAttribute("pjlbmcs", DataHolder.billTypeMap);
			return "/bill/billM/add";
		}
	}
	
	/**
	 * 跳转到票据信息编辑界面
	 * @param request
	 * @return
	 */
	@RequestMapping("/billM/toUpdate")
	public String toUpdate(String bm, Model model) {
		BillM billM = billMService.findByBm(bm);
		model.addAttribute("pjlbmcs", DataHolder.billTypeMap);
		model.addAttribute("banks", DataHolder.dataMap.get("bank"));
		model.addAttribute("billM", billM);
		model.addAttribute("user", TokenHolder.getUser());
		return "/bill/billM/update";
	}
	
	/**
	 * 修改票据信息
	 * @param request
	 * @param qsh 
	 * @param gmrq 
	 * @return
	 */
	@RequestMapping("/billM/update")
	public String update(BillM billM, HttpServletRequest request, Model model, RedirectAttributes redirectAttributes,
			String qsh, String gmrq ) {
		//日期为空时赋当前时间
		if (gmrq == null || "".equals(gmrq)) {
			billM.setGmrq(DateUtil.getDate());
		}
		Map<String, String> paramMap = toMap(billM);
		LogUtil.write(new Log("票据信息", "修改", "BillMAction.update", paramMap.toString()));
		int result = billMService.update(paramMap);
		// 新增操作日志
		if (result == 0) {
			redirectAttributes.addFlashAttribute("msg", "修改成功！");
			return "redirect:/billM/index";
		} else if (result == 2) {
			request.setAttribute("msg", "以"+qsh+"起始号的票据已用,请检查！");
			model.addAttribute("banks", DataHolder.dataMap.get("bank"));
			model.addAttribute("pjlbmcs", DataHolder.billTypeMap);
			return "/bill/billM/update";
		}  else if (result == 3) {
			request.setAttribute("msg", "以"+qsh+"起始号的票据信息票据是否已用,请检查！");
			model.addAttribute("banks", DataHolder.dataMap.get("bank"));
			model.addAttribute("pjlbmcs", DataHolder.billTypeMap);
			return "/bill/billM/update";
		} else {
			request.setAttribute("msg", "修改失败！");
			model.addAttribute("banks", DataHolder.dataMap.get("bank"));
			model.addAttribute("pjlbmcs", DataHolder.billTypeMap);
			return "/bill/billM/update";
		}
	}
	
	/**
	 * 删除票据信息
	 * @param bm
	 * @param request
	 * @param model
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping("/billM/delete")
	public String delete(String bm, HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
		//获取参数
		Map<String, String> paramMap=new HashMap<String, String>();
		paramMap.put("bm", bm);
		paramMap.put("flag", "14");
		paramMap.put("userid", TokenHolder.getUser().getUserid());
		paramMap.put("username", TokenHolder.getUser().getUsername());
		paramMap.put("result", "-1");
		// 新增操作日志
		LogUtil.write(new Log("票据信息", "删除", "BillMAction.delete", paramMap.toString()));
		int result=billMService.delete(paramMap);
		if (result == 0) {
			redirectAttributes.addFlashAttribute("msg", "删除成功！");
		} else if(result == 1){
			redirectAttributes.addFlashAttribute("msg", "存在已使用的票据不允许删除，请检查后重试！");
		} else {
			request.setAttribute("msg", "删除失败！");
		} 
		return "redirect:/billM/index";
	}	
	
	/**
	 * billM转MAP
	 * 
	 * @param billM
	 * @return
	 */
	private Map<String, String> toMap(BillM billM) {
		Map<String, String> paramMap = new HashMap<String, String>();
		paramMap.put("username", TokenHolder.getUser().getUsername());
		paramMap.put("bm", billM.getBm());
		paramMap.put("qsh", billM.getQsh());
		paramMap.put("zzh", billM.getZzh());
		paramMap.put("pjdm", billM.getPjdm());
		paramMap.put("pjmc", billM.getPjmc());
		paramMap.put("pjlbbm", billM.getPjlbbm());
		paramMap.put("pjlbmc", DataHolder.billTypeMap.get(billM.getPjlbbm()));
		paramMap.put("pjls", billM.getPjls());
		paramMap.put("pjzs", billM.getPjzs());
		paramMap.put("czry", billM.getCzry());
		paramMap.put("gmrq", billM.getGmrq());
		paramMap.put("yhbh", billM.getYhbh());
		paramMap.put("yhmc", DataHolder.dataMap.get("bank").get(billM.getYhbh()));
		paramMap.put("sfqy", StringUtil.isEmpty(billM.getSfqy())? "0": billM.getSfqy());
		paramMap.put("regNo", billM.getRegNo());
		paramMap.put("result", "-1");
		return paramMap;				
	}
	
	/**
	 * 导出票据领条
	 * @param request 
	 */
	@RequestMapping("/billM/exportWordBillM")
	public void exportWordBillM(HttpServletRequest request, HttpServletResponse response) {
		String bm = request.getParameter("bm");
		try {
			BillM billm = billMService.findByBm(bm);
			// 新增操作日志
			LogUtil.write(new Log("票据信息", "导出领条", "BillMAction.exportWordBillM", request.toString()));
			ExportWord word = new ExportWord();
			word.lingTiaoWrite(request, response, billm);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
}

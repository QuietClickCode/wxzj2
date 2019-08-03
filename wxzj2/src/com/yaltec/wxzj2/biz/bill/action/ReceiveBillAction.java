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
import com.yaltec.wxzj2.biz.bill.entity.ReceiveBill;
import com.yaltec.wxzj2.biz.bill.service.ReceiveBillService;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 
 * @ClassName: ReceiveBillAction
 * @Description: TODO票据接收实现类
 * 
 * @author moqian
 * @date 2016-7-18 下午15:12:03
 */

@Controller
public class ReceiveBillAction {
	
	@Autowired
	private ReceiveBillService receiveBillService;	
	
	/**
	 * 查询票据接收列表
	 */
	@RequestMapping("/receiveBill/index")
	public String index(Model model){
		model.addAttribute("banks", DataHolder.dataMap.get("bank"));
		return "/bill/receiveBill/index";
	}
		
	/**
	 * 查询票据接收列表
	 */
	@RequestMapping("/receiveBill/list")
	public void list(@RequestBody ReqPamars<ReceiveBill> req, HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		// 添加操作日志
		LogUtil.write(new Log("票据接收", "查询", "ReceiveBillAction.list", req.toString()));
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		Page<ReceiveBill> page = new Page<ReceiveBill>(req.getEntity(), req.getPageNo(), req.getPageSize());
		receiveBillService.findAll(page);
		pw.print(page.toJson());
	}

	/**
	 *跳转到添加票据接收页面
	 */
	@RequestMapping("/receiveBill/toAdd")
	public String toAdd(HttpServletRequest request, Model model) {
		model.addAttribute("banks", DataHolder.dataMap.get("bank"));
		return "/bill/receiveBill/add";
	}
	
	/**
	 * 保存添加票据接收信息
	 */
	@RequestMapping("/receiveBill/add")
	public String add(ReceiveBill receiveBill,HttpServletRequest request, Model model, 
			RedirectAttributes redirectAttributes) {
		// 添加操作日志
		LogUtil.write(new Log("票据接收", "添加", "ReceiveBillAction.add", receiveBill.toString()));
		receiveBill.setYhmc(DataHolder.dataMap.get("bank").get(receiveBill.getYhbh()));
		int result = receiveBillService.save(receiveBill);	
		if (result > 0) {
			redirectAttributes.addFlashAttribute("msg", "添加成功！");
			return "redirect:/receiveBill/index";
		} else {
			request.setAttribute("msg", "添加失败！");
			model.addAttribute("banks", DataHolder.dataMap.get("bank"));
			return "/bill/receiveBill/add";
		}
	}

	
	/**
	 * 跳转到票据接收编辑界面
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/receiveBill/toUpdate")
	public String toUpdate(String bm, Model model) {
		ReceiveBill receiveBill = receiveBillService.findByBm(bm);
		model.addAttribute("banks", DataHolder.dataMap.get("bank"));
		model.addAttribute("receiveBill", receiveBill);
		return "/bill/receiveBill/update";
	}
	
	/**
	 * 修改票据接收信息
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/receiveBill/update")
	public String update(ReceiveBill receiveBill, HttpServletRequest request, Model model,
			RedirectAttributes redirectAttributes) {
		// 添加操作日志
		LogUtil.write(new Log("票据接收", "修改", "ReceiveBillAction.update", receiveBill.toString()));
		receiveBill.setYhmc(DataHolder.dataMap.get("bank").get(receiveBill.getYhbh()));
		int result = receiveBillService.update(receiveBill);
		if (result > 0) {
			redirectAttributes.addFlashAttribute("msg", "修改成功！");
			return "redirect:/receiveBill/index";
		} else {
			request.setAttribute("msg", "修改失败！");
			model.addAttribute("banks", DataHolder.dataMap.get("bank"));
			return "/bill/receiveBill/update";
		}
	}
	
	/**
	 * 删除接收票据信息
	 * @param bms
	 * @param request
	 * @param model
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping("/receiveBill/batchDelete")
	public String batchDelete(String bms, HttpServletRequest request, Model model,
			RedirectAttributes redirectAttributes) {
		String[] paras = bms.split(",");
		Map<String,String> paramMap = new HashMap<String, String>();
		paramMap.put("userid", TokenHolder.getUser().getUserid());
		paramMap.put("username", TokenHolder.getUser().getUsername());
		paramMap.put("flag", "16");
		// 添加操作日志
		LogUtil.write(new Log("票据接收", "删除", "ReceiveBillAction.batchDelete", bms.toString()));
		for (String bm : paras) {
			paramMap.put("result", "");
			paramMap.put("bm", bm);
			int result = receiveBillService.batchDelete(paramMap);
			if (result == 0) {
				redirectAttributes.addFlashAttribute("msg", "删除成功！");
			}else{
            	redirectAttributes.addFlashAttribute("msg","删除失败！");
            }
		}
		return "redirect:/receiveBill/index";
	}

}

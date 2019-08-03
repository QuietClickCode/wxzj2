package com.yaltec.wxzj2.biz.fixedDeposit.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
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

import com.yaltec.comon.core.entity.Page;
import com.yaltec.comon.core.entity.ReqPamars;
import com.yaltec.comon.log.LogUtil;
import com.yaltec.comon.log.entity.Log;
import com.yaltec.wxzj2.biz.fixedDeposit.entity.Deposits;
import com.yaltec.wxzj2.biz.fixedDeposit.service.DepositsService;
import com.yaltec.wxzj2.comon.data.DataHolder;


/**
 * 存款信息
 * @ClassName: DepositsAction 
 * @author 重庆亚亮科技有限公司 hqx 
 * @date 2017-9-6 下午02:18:15
 */
@Controller
public class DepositsAction {
	@Autowired
	private DepositsService depositsService;
	

	/**
	 * 跳转到首页
	 */
	@RequestMapping("/deposits/index")
	public String index(Model model) {
		
		return "/fixedDeposit/deposits/index";
	}
	
	
	/**
	 * 存款信息
	 * @param req
	 * @param request
	 * @param response
	 * @throws IOException
	 */
	@RequestMapping("/deposits/list")
	public void list(@RequestBody ReqPamars<Deposits> req, HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 添加操作日志
		LogUtil.write(new Log("存款信息", "查询", "DepositsAction.list", req.toString()));
		Page<Deposits> page = new Page<Deposits>(req.getEntity(), req.getPageNo(), req.getPageSize());
		depositsService.findAll(page);
		// 返回结果
		pw.print(page.toJson());
	}
	
	/**
	 * 增加存款信息
	 */
	@RequestMapping("/deposits/toAdd")
	public String toAdd(HttpServletRequest request, Model model) {
		model.addAttribute("yhmc", DataHolder.dataMap.get("assignment"));
		return "/fixedDeposit/deposits/add";
	}
	
	
	/**
	 * 保存存款信息
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/deposits/add")
	public String add(Deposits deposits, HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
		// 根据楼宇、房屋类型、房屋性质、房屋用途、房屋户型、交存标准和归集中心编号获取相应的value
		deposits.setYhmc(DataHolder.dataMap.get("assignment").get(deposits.getYhbh()));
		// 添加操作日志
		LogUtil.write(new Log("存款信息", "增加", "DepositsAction.add", deposits.toString()));
			Map<String, String> map = toMap(deposits);
			int result = depositsService.save(map);
			if (result > 0) {
				// 更新缓存
				redirectAttributes.addFlashAttribute("msg", "添加成功");
				return "redirect:/deposits/index";
			} else {
				request.setAttribute("msg", "添加失败");
				return "/fixedDeposit/deposits/add";
			}
	}


	
	/**
	 * 跳转到存款信息编辑界面
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/deposits/toUpdate")
	public String toUpdate(String id, Model model) {
		Deposits deposits = depositsService.findById(id);
		model.addAttribute("yhmc", DataHolder.dataMap.get("assignment"));
		model.addAttribute("deposits", deposits);
		return "/fixedDeposit/deposits/update";
	}
	
	/**
	 * 修改存款信息
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/deposits/update")
	public String update(Deposits deposits, HttpServletRequest request, Model model,
			RedirectAttributes redirectAttributes) {
		//String _result=depositsService.findById(deposits);
		// 添加操作日志
		LogUtil.write(new Log("存款信息", "修改", "DepositsAction.update", deposits.toString()));
		deposits.setYhmc(DataHolder.dataMap.get("assignment").get(deposits.getYhbh()));
			String enddate="";
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			Date date1 = null;
			Calendar can1 = Calendar.getInstance();
			try {
				date1 = sdf.parse(deposits.getBegindate());
			} catch (ParseException e) {
				e.printStackTrace();
			}
			can1.setTime(date1);
			int year1=can1.get(Calendar.YEAR);
			int month1=can1.get(Calendar.MONTH) + 1;
			int day1=can1.get(Calendar.DAY_OF_MONTH);//当月的天数
			enddate= String.valueOf(year1+deposits.getYearLimit())+"-"+month1+"-"+day1;
			deposits.setEnddate(enddate);
			
		int result = depositsService.update(deposits);
		if (result > 0) {
			redirectAttributes.addFlashAttribute("msg", "修改成功");
			return "redirect:/deposits/index";
		} else {
			request.setAttribute("msg", "修改失败");
			return "/fixedDeposit/deposits/update";
		}
	}
	
	@RequestMapping("/deposits/delete")
	public String delete(String id, HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
		// 添加操作日志
		LogUtil.write(new Log("存款信息", "删除", "DepositsAction.delete", id));
		int result=depositsService.delete(id);
		
		if (result == 1) {
			redirectAttributes.addFlashAttribute("msg", "删除成功！");
		}  else {
			redirectAttributes.addFlashAttribute("error", "删除失败！");
		}
		return "redirect:/deposits/index";
	}
	
	private Map<String, String> toMap(Deposits deposits) {
		Map<String, String> map = new HashMap<String, String>();
		try {	
			String enddate="";
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			Date date1 = null;
			Calendar can1 = Calendar.getInstance();
			date1 = sdf.parse(deposits.getBegindate());
			can1.setTime(date1);
			int year1=can1.get(Calendar.YEAR);
			int month1=can1.get(Calendar.MONTH) + 1;
			int day1=can1.get(Calendar.DAY_OF_MONTH);//当月的天数
			enddate= String.valueOf(year1+deposits.getYearLimit())+"-"+month1+"-"+day1;
			deposits.setEnddate(enddate);
		
		map.put("ckdw", deposits.getCkdw());
		map.put("yhbh", deposits.getYhbh());
		map.put("yhmc", deposits.getYhmc());
		map.put("yearLimit", String.valueOf(deposits.getYearLimit()));
		map.put("money", deposits.getMoney());
		map.put("begindate", deposits.getBegindate());
		map.put("enddate", enddate);
		map.put("rate", deposits.getRate());
		map.put("passDate", deposits.getPassDate());
		map.put("earnings", deposits.getEarnings() == null ? "0" : deposits.getEarnings());
		map.put("result", "-1");
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return map;
	}
}






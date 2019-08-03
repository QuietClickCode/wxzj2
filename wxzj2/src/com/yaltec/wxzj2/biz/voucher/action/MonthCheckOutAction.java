package com.yaltec.wxzj2.biz.voucher.action;

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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.yaltec.comon.auth.TokenHolder;
import com.yaltec.comon.utils.DateUtil;
import com.yaltec.comon.utils.JsonUtil;
import com.yaltec.wxzj2.biz.voucher.entity.CheckoutEndOfMonth;
import com.yaltec.wxzj2.biz.voucher.service.MonthCheckOutService;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * @ClassName: MonthCheckOutAction
 * @Description: 月末结账ACTION
 * 
 * @author hqx
 * @date 2016-7-7 上午10:04:38
 */
@Controller
public class MonthCheckOutAction {
	
	@Autowired
	private MonthCheckOutService monthcheckoutservice;

	/**
	 * 跳转到首页
	 */
	@RequestMapping("/monthcheckout/index")
	public String index(Model model) {
		model.addAttribute("assignment", DataHolder.dataMap.get("assignment"));
		model.addAttribute("user", TokenHolder.getUser());
		return "/voucher/monthcheckout/index";
	}
	
	/**
	 * 月末结账界面初始化
	 */
	@RequestMapping("/monthcheckout/init")
	public void init(String paras, HttpServletResponse response,
			RedirectAttributes redirectAttributes) throws IOException{
		Map<String, String> paramMap = new HashMap<String, String>();
		try {
			paramMap.put("SumPZ", "0");
			paramMap.put("SumPZ_Y", "0");
			paramMap.put("SumPZ_W", "0");
			paramMap.put("SumJK", "0");
			paramMap.put("SumZQ", "0");
			paramMap.put("result", "0");
			monthcheckoutservice.monthinit(paramMap);
			response.setCharacterEncoding("utf-8");
			PrintWriter pw = response.getWriter();
			// 返回结果
			pw.print(JsonUtil.toJson(paramMap));
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}
	
	/**
	 * 月末结账
	 * @param response
	 * @param request
	 * @param redirectAttributes
	 * @return
	 * @throws IOException
	 */
	@RequestMapping("/monthcheckout/save")
	public String save(HttpServletResponse response,HttpServletRequest request,
			RedirectAttributes redirectAttributes) throws IOException{
		// 创建一个map集合，作为调用提交销户申请方法的参数
		Map<String,String> paramMap=new HashMap<String,String>();
		paramMap.put("userid", TokenHolder.getUser().getUserid());
		paramMap.put("username", TokenHolder.getUser().getUsername());
		if(DataHolder.parameterKeyValMap.get("03")=="" || DataHolder.parameterKeyValMap.get("15")==null){
			if(monthcheckoutservice.checkOutEndOfMonthCA() !=null){
				paramMap.put("flag", "1");
				paramMap.put("msg", "有未入账的结息凭证，请先审核");
			}
		}
		// 财务月度
		String AudDate = monthcheckoutservice.getReviewDate().toString();
		if (AudDate.substring(5, 7).equals("12")) {
			paramMap.put("flag", "2");
			paramMap.put("msg", "请进行年末结账！不能进行月末结账！");
		}
		// 财务月度+1
		AudDate = DateUtil.add(AudDate, 0, 1, 0, true);
		// 判断该月借贷
		List<CheckoutEndOfMonth> list = monthcheckoutservice.checkOutEndOfMonthCB();
		StringBuffer ywbhs = new StringBuffer();
		StringBuffer pzbhs = new StringBuffer();
		StringBuffer msg = new StringBuffer();
		for (CheckoutEndOfMonth checkoutEndOfMonth : list) {
			if (checkoutEndOfMonth.getflag() && !checkoutEndOfMonth.getP005().equals("00000000")) {
				if (checkoutEndOfMonth.getP005().equals("")) {
					ywbhs.append(checkoutEndOfMonth.getP004()).append(";");
				} else {
					pzbhs.append(checkoutEndOfMonth.getP005()).append(";");
				}
			}
			if (!ywbhs.toString().equals("") || !pzbhs.toString().equals("")) {
				if (!ywbhs.toString().equals("") && !pzbhs.toString().equals("")) {
					msg.append("该月中有借贷不相等的记录！已审核凭证中：凭证编号：").append(pzbhs);
					msg.append("未审核凭证中：业务编号：").append(ywbhs);
				} else if (ywbhs.toString().equals("") && !pzbhs.toString().equals("")) {
					msg.append("该月中有借贷不相等的记录！已审核凭证中：凭证编号：").append(pzbhs);
				} else {
					msg.append("该月中有借贷不相等的记录！未审核凭证中：业务编号：").append(ywbhs);
				}
				paramMap.put("flag", "3");
				paramMap.put("msg", msg.toString());
			}
		}
		paramMap.put("auddate", AudDate);
		int result=monthcheckoutservice.CheckoutEndOfMonth(paramMap);
		if (result > 0) {
			redirectAttributes.addFlashAttribute("msg", "月末结账成功！");
			return "redirect:/monthcheckout/index";
		} else {
			redirectAttributes.addFlashAttribute("msg", "月末结账失败，请稍候重试！");
			return "redirect:/monthcheckout/index";
		}
	}
}




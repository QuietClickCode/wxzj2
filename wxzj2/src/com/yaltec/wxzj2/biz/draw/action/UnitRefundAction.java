package com.yaltec.wxzj2.biz.draw.action;

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

import com.yaltec.comon.auth.TokenHolder;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.comon.core.entity.ReqPamars;
import com.yaltec.comon.utils.DateUtil;
import com.yaltec.comon.utils.StringUtil;
import com.yaltec.wxzj2.biz.draw.entity.UnitRefund;
import com.yaltec.wxzj2.biz.draw.service.UnitRefundService;
import com.yaltec.wxzj2.biz.payment.entity.UnitToPrepay;
import com.yaltec.wxzj2.biz.system.entity.User;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 单位退款实现类
 * @ClassName: UnitRefundAction 
 * @author 重庆亚亮科技有限公司 txj 
 * @date 2016-8-20 下午02:18:40
 */
@Controller
public class UnitRefundAction {
	@Autowired
	private UnitRefundService unitRefundService;
	/**
	 * 跳转到首页
	 */
	@RequestMapping("/unitrefund/index")
	public String index(Model model) {
		model.addAttribute("kfgss", DataHolder.dataMap.get("developer"));
		return "/draw/unitrefund/index";
	}
	
	/**
	 * 查询单位退款列表
	 */
	@RequestMapping("/unitrefund/list")
	public void list(@RequestBody ReqPamars<UnitRefund> req, HttpServletRequest request,
			HttpServletResponse response) throws IOException {	
		//获取查询条件
		Map<String, Object> paramMap = req.getParams();
		// 根据用户获取归集中心
		paramMap.put("unitcode",TokenHolder.getUser().getUnitcode());
		paramMap.put("result", "-1");		
		//判断结束日期为空取当前日期
		if(String.valueOf(paramMap.get("enddate")).equals("")){
			paramMap.put("enddate",DateUtil.getCurrTime("yyyy-MM-dd"));
		}
		//查询分页
		Page<UnitRefund> page = new Page<UnitRefund>(req.getEntity(), req.getPageNo(), req.getPageSize());
		unitRefundService.queryUnitRefund(page,paramMap);
		//返回数据
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 返回结果
		pw.print(page.toJson());
	}
	
	/**
	 * 跳转到添加页面
	 * @param model
	 * @return
	 */
	@RequestMapping("/unitrefund/toAdd")
	public String toAdd(Model model) {		
		model.addAttribute("kfgss", DataHolder.dataMap.get("developer"));
		model.addAttribute("banks", DataHolder.dataMap.get("bank"));
		return "/draw/unitrefund/add";
	}
	
	/**
	 * 根据单位获取累计金额
	 * @param request
	 * @param model
	 * @param response
	 * @throws IOException
	 */
	@RequestMapping("/unitrefund/getUnitLjAndLzje")
	public void getUnitLjAndLzje(HttpServletRequest request,
			Model model,HttpServletResponse response)throws IOException {
		//获取参数
		String dwbm=request.getParameter("dwbm");
		UnitRefund unitRefund=unitRefundService.getUnitLjAndLzje(dwbm);		
		//返回数据
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		
		String json = "{\"ljje\":" + unitRefund.getLjje() + ",\"lzje\":" + unitRefund.getLzje()  + "}";  
		pw.print(json);
	}
	
	
	/**
	 * 添加数据
	 * @param model
	 * @return
	 */
	@RequestMapping("/unitrefund/add")
	public String add(HttpServletRequest request, UnitRefund unitRefund,
			Model model, RedirectAttributes redirectAttributes) {		
		unitRefund.setDwmc(DataHolder.dataMap.get("developer").get(unitRefund.getDwbm()));
		unitRefund.setYhmc(DataHolder.dataMap.get("bank").get(unitRefund.getYhbh()));
		//获取
		Map<String, String> paramMap =unitRefund.toMap();
		User user=TokenHolder.getUser();
		paramMap.put("userid",user.getUserid());
		paramMap.put("username", user.getUsername());
		paramMap.put("result", "-1");
		paramMap.put("w008", "");
		//查询单位未到账的数据
		List<UnitRefund>  list=unitRefundService.isExistRecordedByDW(paramMap);
		if(list==null || list.size()==0){		
			int result=unitRefundService.saveUnitRefund(paramMap);
			if (result == 0) {
				redirectAttributes.addFlashAttribute("msg", "添加成功！");
				return "redirect:/unitrefund/index";
			}else if(result == 3){
				redirectAttributes.addFlashAttribute("msg", paramMap.get("dwmc")+"上有存在未入账的业务，请检查！");
				redirectAttributes.addFlashAttribute("unitRefund", unitRefund);
				return "redirect:/unitrefund/toAdd";			
			}else{
				redirectAttributes.addFlashAttribute("msg", "保存失败，请稍候重试！");
				redirectAttributes.addFlashAttribute("unitRefund", unitRefund);
				return "redirect:/unitrefund/toAdd";
			}
		}else{
			redirectAttributes.addFlashAttribute("msg", paramMap.get("dwmc")+"上有存在未入账的业务，请检查！");
			redirectAttributes.addFlashAttribute("unitRefund", unitRefund);
			return "redirect:/unitrefund/toAdd";
		}
	}
	
	@RequestMapping("/unitrefund/toDel")
	public String toDel(String ywbhs,HttpServletRequest request,Model model, RedirectAttributes redirectAttributes) {	
		//获取选中的业务编号
		List<String> ywbhList = StringUtil.tokenize(ywbhs, ",");
		//删除单位预交
		int result=unitRefundService.delUnitRefund(ywbhList);
		if(result==0){
			redirectAttributes.addFlashAttribute("msg", "删除失败！");			
		}else{
			redirectAttributes.addFlashAttribute("msg", "删除成功！");			
		}
		return "redirect:/unitrefund/index";
	}
}

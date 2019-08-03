package com.yaltec.wxzj2.biz.payment.action;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
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
import com.yaltec.comon.log.LogUtil;
import com.yaltec.comon.log.entity.Log;
import com.yaltec.comon.utils.DateUtil;
import com.yaltec.comon.utils.StringUtil;
import com.yaltec.wxzj2.biz.payment.entity.UnitToPrepay;
import com.yaltec.wxzj2.biz.payment.service.UnitPaymentService;
import com.yaltec.wxzj2.biz.system.entity.User;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 单位预交实现类
 * @ClassName: UnitPayment 
 * @author 重庆亚亮科技有限公司 txj 
 * @date 2016-8-19 下午03:17:25
 */
@Controller
public class UnitPaymentAction {
	@Autowired
	private UnitPaymentService unitPaymentService;
	
	/**
	 * 跳转到首页
	 */
	@RequestMapping("/unitpayment/index")
	public String index(Model model) {
		model.addAttribute("kfgss", DataHolder.dataMap.get("developer"));
		return "/payment/unitpayment/index";
	}
	
	/**
	 * 查询单位预交列表
	 */
	@RequestMapping("/unitpayment/list")
	public void list(@RequestBody ReqPamars<UnitToPrepay> req, HttpServletRequest request,
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
		Page<UnitToPrepay> page = new Page<UnitToPrepay>(req.getEntity(), req.getPageNo(), req.getPageSize());
		unitPaymentService.queryUnitToPrepay(page,paramMap);
		LogUtil.write(new Log("单位预交", "查询", "UnitPaymentAction.list",paramMap.toString()));
		//返回数据
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 返回结果
		pw.print(page.toJson());
	}
	
	/**
	 * 跳转到新增页面
	 * @param model
	 * @return
	 */
	@RequestMapping("/unitpayment/toAdd")
	public String toAdd(Model model) {		
		model.addAttribute("kfgss", DataHolder.dataMap.get("developer"));
		model.addAttribute("banks", DataHolder.dataMap.get("bank"));
		return "/payment/unitpayment/add";
	}
	
	/**
	 * 新增数据
	 * @param model
	 * @return
	 */
	@RequestMapping("/unitpayment/add")
	public String add(HttpServletRequest request, UnitToPrepay unitToPrepay,
			Model model, RedirectAttributes redirectAttributes) {		
		unitToPrepay.setDwmc(DataHolder.dataMap.get("developer").get(unitToPrepay.getDwbm()));
		unitToPrepay.setYhmc(DataHolder.dataMap.get("bank").get(unitToPrepay.getYhbh()));
		//获取
		Map<String, String> paramMap =unitToPrepay.toMap();
		User user=TokenHolder.getUser();
		paramMap.put("userid",user.getUserid());
		paramMap.put("username", user.getUsername());
		paramMap.put("result", "-1");
		int result=unitPaymentService.saveUnitToPrepay(paramMap);
		LogUtil.write(new Log("单位预交", "新增", "UnitPaymentAction.add",paramMap.toString()));
		if (result == 0) {
			redirectAttributes.addFlashAttribute("msg", "新增成功！");
			return "redirect:/unitpayment/index";
		}else if(result == 3){
			redirectAttributes.addFlashAttribute("msg", paramMap.get("dwmc")+"上有存在未入账的业务，请检查！");
			redirectAttributes.addFlashAttribute("unitToPrepay", unitToPrepay);
			return "redirect:/unitpayment/toAdd";			
		}else{
			redirectAttributes.addFlashAttribute("msg", "保存失败，请稍候重试！");
			redirectAttributes.addFlashAttribute("unitToPrepay", unitToPrepay);
			return "redirect:/unitpayment/toAdd";
		}
	}
	
	/**
	 * 批量删除
	 * @param ywbhs
	 * @param request
	 * @param model
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping("/unitpayment/toDel")
	public String toDel(String ywbhs,HttpServletRequest request,Model model, RedirectAttributes redirectAttributes) {	
		//获取选中的业务编号
		List<String> ywbhList = StringUtil.tokenize(ywbhs, ",");		
		//删除前判断是否已审核凭证
		List<UnitToPrepay> list=unitPaymentService.isAudit(ywbhList);
		if(list==null || list.size()==0 ){
			//删除单位预交
			int result=unitPaymentService.delUnitToPrepay(ywbhList);
			LogUtil.write(new Log("单位预交", "删除", "UnitPaymentAction.toDel",ywbhList.toString()));
			if(result==0){
				redirectAttributes.addFlashAttribute("msg", "删除失败！");			
			}else{
				redirectAttributes.addFlashAttribute("msg", "删除成功！");			
			}
		}else{
			redirectAttributes.addFlashAttribute("msg", "选中交款中含有已审核的交款信息！");		
		}
		return "redirect:/unitpayment/index";
	}
	
	/**
	 * 
	 * @param request
	 * @param response
	 * @throws IOException
	 */
	@RequestMapping("/unitpayment/toPrint")
	public void toPrintHouseUnit(HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		// 获取参数
		String dwbms = request.getParameter("dwbms");
		List<String> dwbmsList = new ArrayList<String>();
		for (String dwbm : dwbms.split(",")) {
			if (!dwbm.equals("")) {
				dwbmsList.add(dwbm);
			}
		}
		ByteArrayOutputStream ops = unitPaymentService.toPrint(dwbmsList);
		LogUtil.write(new Log("单位预交", "查询",
				"HouseUnitAction.toPrintHouseUnit", dwbmsList.toString()));
		if (ops != null) {
			unitPaymentService.output(ops, response);
		}
	}
}

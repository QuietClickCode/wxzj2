package com.yaltec.wxzj2.biz.propertymanager.action;

import java.io.ByteArrayOutputStream;
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
import com.yaltec.wxzj2.biz.propertymanager.entity.Redemption;
import com.yaltec.wxzj2.biz.propertymanager.service.RedemptionService;

/**
 * 换购查询实现类
 * @author hqx
 *
 */
@Controller
public class QueryRedemptionAction {

	@Autowired
	private RedemptionService redemptionservice;

	/**
	 * 跳转到首页
	 */
	@RequestMapping("/queryredemption/index")
	public String index(Model model) {
		return "/propertymanager/queryredemption/index";
	}

	/**
	 * 查询房屋换购列表
	 */
	@RequestMapping("/queryredemption/list")
	public void list(@RequestBody ReqPamars<Redemption> req, HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		// 获取查询条件
		Map<String, Object> paramMap = req.getParams();
		paramMap.put("username", TokenHolder.getUser().getUsername());
		Page<Redemption> page = new Page<Redemption>(req.getEntity(), req.getPageNo(), req.getPageSize());
		// 添加操作日志
		LogUtil.write(new Log("产权管理_换购查询", "查询", "QueryRedemptionAction.list",req.toString()));
		redemptionservice.findAll(page, paramMap);
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 返回结果
		pw.print(page.toJson());
	}
	
	/**
	 * 删除房屋换购信息
	 * @param p004
	 * @param response
	 * @throws IOException
	 */
	@RequestMapping("/queryredemption/delete")
	public String delete(String p004,HttpServletResponse response,RedirectAttributes redirectAttributes){
		int result = -1;
		try {
			/* 判断是否是自己做的业务
			if (!isOwnOfDataS("isOwnOfDataFDelRP", p004, username)) {
				return -5;
			}*/
			// 检查业主退款业主是否已审核
			// if (logicService.getobject("checkForDelRefund", p004) == null) {
			Map<String, String> paramMap = new HashMap<String, String>();
			paramMap.put("userid", TokenHolder.getUser().getUserid());
			paramMap.put("username", TokenHolder.getUser().getUsername());
			paramMap.put("flag", "22");
			paramMap.put("bm", p004);
			paramMap.put("result", "-1");
			// 添加操作日志
			LogUtil.write(new Log("产权管理_换购查询", "删除", "QueryRedemptionAction.delete",paramMap.toString()));
			result= redemptionservice.delRedemption(paramMap);
			if(result==0){
				redirectAttributes.addFlashAttribute("msg", "删除成功！");
			} else if(result == -5){
				redirectAttributes.addFlashAttribute("msg","操作员只能删除自己的业务，请检查！");
            } else if(result == 1) {
            	redirectAttributes.addFlashAttribute("msg","已经审核的业务不能删除！");
            } else {
            	redirectAttributes.addFlashAttribute("msg","删除失败，请稍候重试！");
            }
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "redirect:/queryredemption/index";
	}
	/**
	 * 打印清册
	 * @param request
	 * @param response
	 * @throws IOException
	 */
	@RequestMapping("/queryredemption/inventory")
	public void inventory(HttpServletRequest request,HttpServletResponse response)throws IOException{
		//获取参数
		Map<String,Object> paramMap = new HashMap<String, Object>();
		paramMap.put("username",TokenHolder.getUser().getUsername());
		paramMap.put("sfsh",request.getParameter("sfsh"));
		paramMap.put("result","");
		paramMap.put("begindate",request.getParameter("begindate"));
		paramMap.put("enddate",request.getParameter("enddate"));
		// 添加操作日志
		LogUtil.write(new Log("产权管理_换购查询", "打印清册", "QueryRedemptionAction.inventory",paramMap.toString()));
		ByteArrayOutputStream ops=redemptionservice.inventory(paramMap);
		if(ops != null){
			redemptionservice.output(ops, response);
		}
	}
	 
	/**
	 * 房屋换购打印
	 * @param request
	 * @param response
	 * @throws IOException
	 */
	@RequestMapping("/queryredemption/toPrint")
	public void toPrint(HttpServletRequest request,HttpServletResponse response)throws IOException{
		//获取参数
		Map<String,String> paramMap = new HashMap<String, String>();
		paramMap.put("w008",request.getParameter("w008"));
		// 添加操作日志
		LogUtil.write(new Log("产权管理_换购查询", "房屋换购打印", "QueryRedemptionAction.toPrint",paramMap.toString()));
		ByteArrayOutputStream ops=redemptionservice.pdfRedemption(paramMap);
		if(ops != null){
			redemptionservice.output(ops, response);
		}
	
	}
}
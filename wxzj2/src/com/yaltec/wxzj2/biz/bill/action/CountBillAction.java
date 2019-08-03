package com.yaltec.wxzj2.biz.bill.action;


import java.io.IOException;
import java.io.PrintWriter;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

import com.yaltec.comon.auth.TokenHolder;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.comon.core.entity.ReqPamars;
import com.yaltec.comon.log.LogUtil;
import com.yaltec.comon.log.entity.Log;
import com.yaltec.wxzj2.biz.bill.entity.CountBill;
import com.yaltec.wxzj2.biz.bill.service.CountBillService;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 
 * @ClassName: CountBillAction
 * @Description: TODO票据统计实现类
 * 
 * @author moqian
 * @date 2016-7-18 下午15:12:03
 */

@Controller
public class CountBillAction {
	
	@Autowired
	private CountBillService countBillService;	
		
	/**
	 * 查询票据统计列表
	 */
	@RequestMapping("/countBill/index")
	public String index(Model model){
		model.addAttribute("banks", DataHolder.dataMap.get("bank"));
		model.addAttribute("user", TokenHolder.getUser());
		return "/bill/countBill/index";
	}
	
	/**
	 * 查询票据统计列表
	 */
	@RequestMapping("/countBill/list")
	public void list(@RequestBody ReqPamars<CountBill> req, HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		//获取查询条件
		Map<String, Object> paramMap = req.getParams();
		paramMap.put("min_je", "0");
		paramMap.put("max_je", "0");
		paramMap.put("result", "-1");	
		// 添加操作日志
		LogUtil.write(new Log("票据统计", "查询", "CountBillAction.list", req.toString()));
		Page<CountBill> page = new Page<CountBill>(req.getEntity(), req.getPageNo(), req.getPageSize());
		countBillService.findAll(page, paramMap);
		//返回数据
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 返回结果
		pw.print(page.toJson());				
	}	
	
}

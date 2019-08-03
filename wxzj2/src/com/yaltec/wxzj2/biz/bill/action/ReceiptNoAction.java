package com.yaltec.wxzj2.biz.bill.action;


import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.comon.core.entity.ReqPamars;
import com.yaltec.comon.log.LogUtil;
import com.yaltec.comon.log.entity.Log;
import com.yaltec.wxzj2.biz.bill.entity.ReceiptNo;
import com.yaltec.wxzj2.biz.bill.service.ReceiptNoService;
import com.yaltec.wxzj2.comon.data.DataHolder;


/**
 * 
 * @ClassName: ReceiptNoAction
 * @Description: TODO票据回传情况实现类
 * 
 * @author moqian
 * @date 2016-7-18 下午15:12:03
 */

@Controller
public class ReceiptNoAction {
	
	@Autowired
	private ReceiptNoService receiptNoService;	
	
	/**
	 * 查询票据回传情况列表
	 */
	@RequestMapping("/receiptNo/index")
	public String index(Model model){
		model.addAttribute("banks", DataHolder.dataMap.get("bank"));
		return "/bill/receiptNo/index";
	}
	
	/**
	 * 查询票据回传情况列表
	 */
	@RequestMapping("/receiptNo/list")
	public void list(@RequestBody ReqPamars<ReceiptNo> req, HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		// 添加操作日志
		LogUtil.write(new Log("票据回传情况", "查询", "ReceiptNoAction.list", req.toString()));
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		Page<ReceiptNo> page = new Page<ReceiptNo>(req.getEntity(), req.getPageNo(), req.getPageSize());
		receiptNoService.findAll(page);
		pw.print(page.toJson());
	}

}

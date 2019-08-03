package com.yaltec.wxzj2.biz.compositeQuery.action;

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
import org.springframework.web.servlet.ModelAndView;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.comon.core.entity.ReqPamars;
import com.yaltec.comon.log.LogUtil;
import com.yaltec.comon.log.entity.Log;
import com.yaltec.comon.utils.JsonUtil;
import com.yaltec.wxzj2.biz.compositeQuery.entity.MonthReportOfBank;
import com.yaltec.wxzj2.biz.compositeQuery.service.MonthReportOfBankService;
import com.yaltec.wxzj2.biz.compositeQuery.service.export.MonthReportOfBankExport;
import com.yaltec.wxzj2.biz.compositeQuery.service.print.MonthReportOfBankPrint;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 
 * @ClassName: MonthReportOfBankAction
 * @Description: TODO按银行统计月报查询实现类
 * 
 * @author moqian
 * @date 2016-8-25 上午11:12:03
 */

@Controller
public class MonthReportOfBankAction {

	@Autowired
	private MonthReportOfBankService monthReportOfBankService;

	/**
	 * 查询按银行统计月报信息列表
	 */
	@RequestMapping("/monthReportOfBank/index")
	public String index(Model model) {
		model.addAttribute("communitys", DataHolder.communityMap);
		model.addAttribute("banks", DataHolder.dataMap.get("bank"));
		return "/compositeQuery/monthReportOfBank/index";
	}

	/**
	 * 查询按银行统计月报信息列表
	 * 
	 * @param request
	 */
	@RequestMapping("/monthReportOfBank/list")
	public void list(@RequestBody ReqPamars<MonthReportOfBank> req, HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		// 添加操作日志
		LogUtil.write(new Log("按银行统计月报", "查询", "MonthReportOfBankAction.list", req.toString()));
		// 获取查询条件
		Map<String, Object> paramMap = req.getParams();
		paramMap.put("result", "-1");
		Page<MonthReportOfBank> page = new Page<MonthReportOfBank>(req.getEntity(), req.getPageNo(), req.getPageSize());
		monthReportOfBankService.queryMonthReportOfBank(page, paramMap);
		// 返回数据
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 返回结果
		pw.print(page.toJson());
	}
	
	/**
	 * 导出银行统计月报信息
	 */
	@RequestMapping("/monthReportOfBank/toExport")
	public void export(HttpServletRequest request, HttpServletResponse response) {
		// 获取页面传入的参数，并以逗号(,)分割，存入数组中
		String paras = request.getParameter("str");
		String[] strs = paras.split(",");
		try {
			Map<String, String> map = new HashMap<String, String>();
			map.put("bank", strs[0]);
			map.put("begindate", strs[1]);
			map.put("enddate", strs[2]);
			map.put("flag", strs[3]);
			map.put("cxfs", strs[4]);
			// 添加操作日志
			LogUtil.write(new Log("按银行统计月报", "导出", "MonthReportOfBankAction.export", map.toString()));
			List<MonthReportOfBank> resultList = monthReportOfBankService.findReportOfBank(map);
			
			MonthReportOfBankExport.exportReportOfBank(resultList, response);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * 打印银行统计月报信息
	 */
	@RequestMapping("/monthReportOfBank/toPrint")
	public ModelAndView listPrint(HttpServletRequest request, HttpServletResponse response) {
		// 获取页面传入的参数，并以逗号(,)分割，存入数组中
		String paras = request.getParameter("str");
		String[] strs = paras.split(",");
		Map<String, String> map = new HashMap<String, String>();
		map.put("bank", strs[0]);
		map.put("begindate", strs[1]);
		map.put("enddate", strs[2]);
		map.put("flag", strs[3]);
		map.put("cxfs", strs[4]);
		// 添加操作日志
		LogUtil.write(new Log("按银行统计月报", "打印", "MonthReportOfBankAction.listPrint", map.toString()));
		List<MonthReportOfBank> list = monthReportOfBankService.findReportOfBank(map);
		
		// 传参容器
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("list", list);
		MonthReportOfBankPrint view = new MonthReportOfBankPrint();
		paramMap.put("begindate", strs[1]);
		paramMap.put("enddate", strs[2]);;
		// 设置参数
		view.setAttributesMap(paramMap);
		// 返回视图
		return new ModelAndView(view);
	}
}

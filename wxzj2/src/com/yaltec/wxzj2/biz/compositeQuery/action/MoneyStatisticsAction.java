package com.yaltec.wxzj2.biz.compositeQuery.action;

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

import com.yaltec.comon.core.entity.Page;
import com.yaltec.comon.core.entity.ReqPamars;
import com.yaltec.comon.log.LogUtil;
import com.yaltec.comon.log.entity.Log;
import com.yaltec.comon.utils.JsonUtil;
import com.yaltec.wxzj2.biz.compositeQuery.entity.MoneyStatistics;
import com.yaltec.wxzj2.biz.compositeQuery.service.MoneyStatisticsService;
import com.yaltec.wxzj2.biz.draw.service.print.NormalPrintPDF;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 
 * @ClassName: ProjectInterestFAction
 * @Description: TODO项目利息实现类
 * 
 * @author moqian
 * @date 2016-8-23 上午09:12:03
 */

@Controller
public class MoneyStatisticsAction {
	
	@Autowired
	private MoneyStatisticsService moneyStatisticsService;	
	
	/**
	 * 查询项目利息信息列表
	 */
	@RequestMapping("/moneyStatistics/index")
	public String index(Model model){
		
		model.addAttribute("communitys", DataHolder.communityMap);
//		model.addAttribute("banks", DataHolder.dataMap.get("bank"));
//		model.addAttribute("projects", DataHolder.dataMap.get("project"));
//		//获取所有年度
//		List<String> list = projectInterestFService.getReviewNd();
//		model.addAttribute("nds", list);
//		System.out.println(list);
		return "/compositeQuery/moneyStatistics/index";
	}
	
	/**
	 * 查询资金统计报表列表
	 * @param request 
	 */
	@RequestMapping("/moneyStatistics/list")
	public void list(@RequestBody ReqPamars<MoneyStatistics> req, HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		// 添加操作日志
		LogUtil.write(new Log("资金统计报表", "查询", "MoneyStatisticsAction.list", req.toString()));
		//获取查询条件
		Map<String, Object> paramMap = req.getParams();
		paramMap.put("result", "-1");	
		Page<MoneyStatistics> page = new Page<MoneyStatistics>(req.getEntity(), req.getPageNo(), req.getPageSize());
		moneyStatisticsService.queryList(page, paramMap);
		//返回数据
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 返回结果
		pw.print(page.toJson());				
	}
	
	/**
	 * 资金统计报表导出
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping("/moneyStatistics/toExport")
	public void toExport(HttpServletRequest request,HttpServletResponse response) {
		Map<String, Object> map = JsonUtil.toObject(request.getParameter("data"), HashMap.class);
		map.put("result", "-1");	
		// 添加操作日志
		LogUtil.write(new Log("综合查询_资金统计报表", "导出", "MoneyStatisticsAction.toExport",map.toString()));
		try {
			moneyStatisticsService.export(map, response);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 资金统计报表打印
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping("/moneyStatistics/toPrint")
	public void toPrint(HttpServletRequest request,HttpServletResponse response) {
		response.setCharacterEncoding("utf-8");
		ByteArrayOutputStream ops = null;
		if (request.getParameter("data") == null || request.getParameter("data").equals("")) {
			NormalPrintPDF.exeException("获取传递的数据发生错误！",response);
			return;
		}
		Map<String, Object> map = JsonUtil.toObject(request.getParameter("data"), HashMap.class);
		map.put("result", "-1");	
		// 添加操作日志
		LogUtil.write(new Log("综合查询_资金统计报表", "打印", "MoneyStatisticsAction.toPrint",map.toString()));
		try {
			moneyStatisticsService.print(map, response);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}	
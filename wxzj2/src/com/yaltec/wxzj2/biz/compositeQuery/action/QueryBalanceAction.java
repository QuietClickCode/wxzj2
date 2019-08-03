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
import com.yaltec.comon.core.entity.Page;
import com.yaltec.comon.core.entity.ReqPamars;
import com.yaltec.comon.log.LogUtil;
import com.yaltec.comon.log.entity.Log;
import com.yaltec.comon.utils.JsonUtil;
import com.yaltec.comon.utils.Urlencryption;
import com.yaltec.wxzj2.biz.compositeQuery.entity.QueryBalance;
import com.yaltec.wxzj2.biz.compositeQuery.service.QueryBalanceService;
import com.yaltec.wxzj2.biz.compositeQuery.service.export.DataExport;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 
 * @ClassName: QueryBalanceAction
 * @Description: TODO业主余额查询实现类
 * 
 * @author moqian
 * @date 2016-8-9 下午17:12:03
 */

@Controller
public class QueryBalanceAction {
	
	@Autowired
	private QueryBalanceService queryBalanceService;	
	
	/**
	 * 查询业主余额信息列表
	 * @param house 
	 */
	@RequestMapping("/queryBalance/index")
	public String index(Model model, Object house){
		model.addAttribute("house", house);
		model.addAttribute("projects", DataHolder.dataMap.get("project"));
		model.addAttribute("communitys", DataHolder.communityMap);
		return "/compositeQuery/queryBalance/index";
	}
	
	/**
	 * 查询业主余额信息列表
	 * @param request 
	 */
	@RequestMapping("/queryBalance/list")
	public void list(@RequestBody ReqPamars<QueryBalance> req, HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		// 添加操作日志
		LogUtil.write(new Log("业主余额", "查询", "QueryBalanceAction.list", req.toString()));
		//获取查询条件
		Map<String, Object> paramMap = req.getParams();
		paramMap.put("result", "-1");	
		Page<QueryBalance> page = new Page<QueryBalance>(req.getEntity(), req.getPageNo(), req.getPageSize());
		queryBalanceService.queryQueryBalance(page, paramMap);
		//返回数据
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 返回结果
		pw.print(page.toJson());				
	}	
	
	/**
	 *业主余额的导出数据
	 */
	@RequestMapping("/queryBalance/exportQueryBalance")
	public void export(HttpServletRequest request, HttpServletResponse response) {
		try {
			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("xmbh",request.getParameter("xmbh"));
			paramMap.put("xqbh",request.getParameter("xqbh"));
			paramMap.put("lybh",request.getParameter("lybh"));
			paramMap.put("enddate",request.getParameter("enddate"));
			paramMap.put("h001",request.getParameter("h001"));
			paramMap.put("cxfs",request.getParameter("cxfs"));
			paramMap.put("w012",Urlencryption.unescape(request.getParameter("w012")));
			paramMap.put("pzsh",request.getParameter("pzsh"));
			// 添加操作日志
			LogUtil.write(new Log("业主余额", "导出", "QueryBalanceAction.export", paramMap.toString()));
			List<QueryBalance> resultList = queryBalanceService.findQueryBalance(paramMap);
			
			DataExport.exportQueryBalance(resultList, response);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}

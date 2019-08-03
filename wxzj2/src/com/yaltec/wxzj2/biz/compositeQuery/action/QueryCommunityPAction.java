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
import com.yaltec.wxzj2.biz.compositeQuery.entity.ByCommunityForB;
import com.yaltec.wxzj2.biz.compositeQuery.entity.QueryCommunityP;
import com.yaltec.wxzj2.biz.compositeQuery.service.QueryCommunityPService;
import com.yaltec.wxzj2.biz.compositeQuery.service.export.DataExport;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * <p>ClassName: QueryCommunityPAction</p>
 * <p>Description: 小区缴款查询</p>
 * <p>Company: YALTEC</p>
 * @author jiangyong
 * @date 2018-8-3 上午09:34:06
 */
@Controller
public class QueryCommunityPAction {

	@Autowired
	private QueryCommunityPService queryCommunityPService;
	
	/**
	 * 首页
	 */
	@RequestMapping("/queryCommunityPayment/index")
	public String index(Model model) {
		model.addAttribute("communitys", DataHolder.communityMap);
		return "/compositeQuery/queryCommunityPayment/index";
	}
	
	/**
	 * 查询小区利息单信息列表
	 * @param request 
	 */
	@RequestMapping("/queryCommunityPayment/list")
	public void list(@RequestBody ReqPamars<QueryCommunityP> req, HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		//返回数据
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 添加操作日志
		LogUtil.write(new Log("小区缴款查询", "查询", "QueryCommunityPAction.list", req.toString()));
		//获取查询条件
		List<QueryCommunityP> list = queryCommunityPService.findList(req.getParams());
		// 返回结果
		pw.print(JsonUtil.toJson(list));				
	}	
	
	
	/**
	  *小区缴款查询
	 */
	@RequestMapping("/queryCommunityP/exportCommunityP")
	public void export(HttpServletRequest request, HttpServletResponse response) {
		try {
			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("xqbh",request.getParameter("xqbh"));
			paramMap.put("begindate",request.getParameter("begindate"));
			paramMap.put("enddate",request.getParameter("enddate"));
			// 添加操作日志
			LogUtil.write(new Log("小区缴款查询", "导出", "ByCommunityForBAction.export", paramMap.toString()));
			List<QueryCommunityP> resultList = queryCommunityPService.findByCommunityP(paramMap);
			String xqmc="";
			String name=DataHolder.customerInfo.getName();
			name=name.substring(0,6);
			xqmc=Urlencryption.unescape(request.getParameter("xqmc"));
			if(request.getParameter("xqbh")==null||request.getParameter("xqbh").equals("")) {
				xqmc=name+"小区缴纳情况汇总表";
			}else {
				xqmc=name+xqmc+"小区缴纳情况汇总表";
			}
			DataExport.exportCommunityP(resultList,xqmc, response);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
}

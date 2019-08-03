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
import com.yaltec.comon.utils.DateUtil;
import com.yaltec.wxzj2.biz.compositeQuery.entity.WxzjInfoTj;
import com.yaltec.wxzj2.biz.compositeQuery.service.QueryWxzjInfoTjService;
import com.yaltec.wxzj2.biz.compositeQuery.service.export.WxzjInfoTjExport;

/**
 * 
 * @ClassName: QueryWxzjInfoTjAction
 * @Description: TODO信息统计查询实现类
 * 
 * @author moqian
 * @date 2016-8-29 上午09:12:03
 */

@Controller
public class QueryWxzjInfoTjAction {
	
	@Autowired
	private QueryWxzjInfoTjService queryWxzjInfoTjService;	
	
	/**
	 * 信息统计查询列表
	 */
	@RequestMapping("/queryWxzjInfoTj/index")
	public String index(Model model){
		return "/compositeQuery/queryWxzjInfoTj/index";
	}
	
	/**
	 * 信息统计查询列表
	 * @param request 
	 */
	@RequestMapping("/queryWxzjInfoTj/list")
	public void list(@RequestBody ReqPamars<WxzjInfoTj> req, HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		// 添加操作日志
		LogUtil.write(new Log("信息统计", "查询", "QueryWxzjInfoTjAction.list", req.toString()));
		//获取查询条件
		Map<String, Object> paramMap = req.getParams();
		paramMap.put("result", "-1");	
		Page<WxzjInfoTj> page = new Page<WxzjInfoTj>(req.getEntity(), req.getPageNo(), req.getPageSize());
		queryWxzjInfoTjService.QueryWxzjInfoTj(page, paramMap);
		//返回数据
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 返回结果
		pw.print(page.toJson());				
	}	
	
	/**
	 * 导出
	 */
	@RequestMapping("/queryWxzjInfoTj/toExport")
	public void Export(HttpServletRequest request, HttpServletResponse response) {
		try {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("thatYear", request.getParameter("thatYear"));
			// 添加操作日志
			LogUtil.write(new Log("信息统计", "导出", "QueryWxzjInfoTjAction.Export", map.toString()));
			List<WxzjInfoTj> resultList = queryWxzjInfoTjService.findWxzjInfoTj(map);
			
			Map<String,String> mapR = new HashMap<String,String>();
			for (WxzjInfoTj tj : resultList) {
				if(tj.getBm().trim().equals("")){
					continue;
				}
				mapR.put(tj.getBm(), tj.getContent());
			}
			String filename=DateUtil.format("yyyy",map.get("thatYear").toString())+"年维修资金信息统计信息";
			WxzjInfoTjExport excel = new WxzjInfoTjExport();
			excel.exportWxzjInfoTj_POI( response, mapR, filename);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
}

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
import com.yaltec.wxzj2.biz.compositeQuery.service.QueryArrearService;
import com.yaltec.wxzj2.biz.compositeQuery.service.export.QueryArrearExport;
import com.yaltec.wxzj2.biz.compositeQuery.service.print.QueryArrearPrint;
import com.yaltec.wxzj2.biz.property.entity.House;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 
 * @ClassName: QueryArrearAction
 * @Description: TODO欠费催交查询实现类
 * 
 * @author moqian
 * @date 2016-8-25 下午15:12:03
 */

@Controller
public class QueryArrearAction {
	
	@Autowired
	private QueryArrearService queryArrearService;	
	
	/**
	 * 查询欠费催交信息列表
	 */
	@RequestMapping("/queryArrear/index")
	public String index(Model model){
		model.addAttribute("communitys", DataHolder.communityMap);
		return "/compositeQuery/queryArrear/index";
	}
	
	/**
	 * 查询欠费催交信息列表
	 * @param request 
	 */
	@RequestMapping("/queryArrear/list")
	public void list(@RequestBody ReqPamars<House> req, HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		// 添加操作日志
		LogUtil.write(new Log("小区余额", "查询", "QueryArrearAction.list", req.toString()));
		//获取查询条件
		Map<String, Object> paramMap = req.getParams();
		paramMap.put("result", "-1");	
		Page<House> page = new Page<House>(req.getEntity(), req.getPageNo(), req.getPageSize());
		queryArrearService.QueryArrear(page, paramMap);
		//返回数据
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 返回结果
		pw.print(page.toJson());				
	}
	
	/**
	 * 导出欠费催交信息
	 */
	@RequestMapping("/queryArrear/toExport")
	public void export(String lybh, String xqbh, HttpServletRequest request, HttpServletResponse response) {
		try {
			Map<String, String> map = new HashMap<String, String>();
			map.put("lybh", lybh);
			map.put("xqbh", xqbh);
			// 添加操作日志
			LogUtil.write(new Log("小区余额", "导出", "QueryArrearAction.export", map.toString()));
			List<House> resultList = queryArrearService.findArrear(map);
			
			QueryArrearExport.exportQueryArrear(resultList, response);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * 打印欠费催交信息
	 */
	@RequestMapping("/queryArrear/toPrint")
	public ModelAndView listPrint(String lybh, String xqbh,HttpServletRequest request, HttpServletResponse response) {
		Map<String, String> map = new HashMap<String, String>();
		map.put("lybh", lybh);
		map.put("xqbh", xqbh);
		// 添加操作日志
		LogUtil.write(new Log("小区余额", "打印", "QueryArrearAction.listPrint", map.toString()));
		List<House> list = queryArrearService.findArrear(map);
		// 传参容器
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("list", list);
		QueryArrearPrint view = new QueryArrearPrint();
		// 设置参数
		view.setAttributesMap(paramMap);
		// 返回视图
		return new ModelAndView(view);
	}
}

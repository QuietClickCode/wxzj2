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
import com.yaltec.comon.utils.Urlencryption;
import com.yaltec.wxzj2.biz.compositeQuery.service.QueryDunningService;
import com.yaltec.wxzj2.biz.compositeQuery.service.export.DataExport;
import com.yaltec.wxzj2.biz.compositeQuery.service.print.QueryDunningPrint;
import com.yaltec.wxzj2.biz.property.entity.House;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 
 * @ClassName: QueryDunningAction
 * @Description: TODO续筹催交查询实现类
 * 
 * @author moqian
 * @date 2016-8-25 下午16:12:03
 */

@Controller
public class QueryDunningAction {
	
	@Autowired
	private QueryDunningService queryDunningService;	
	
	/**
	 * 查询续筹催交信息列表
	 */
	@RequestMapping("/queryDunning/index")
	public String index(Model model){
		model.addAttribute("projects", DataHolder.dataMap.get("project"));
		model.addAttribute("communitys", DataHolder.communityMap);
		return "/compositeQuery/queryDunning/index";
	}
	
	/**
	 * 查询续筹催交信息列表
	 * @param request 
	 */
	@RequestMapping("/queryDunning/list")
	public void list(@RequestBody ReqPamars<House> req, HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		// 添加操作日志
		LogUtil.write(new Log("续筹催交", "查询", "QueryDunningAction.list", req.toString()));
		//获取查询条件
		Map<String, Object> paramMap = req.getParams();
		paramMap.put("result", "-1");	
		Page<House> page = new Page<House>(req.getEntity(), req.getPageNo(), req.getPageSize());
		queryDunningService.queryQueryDunning(page, paramMap);
		//返回数据
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 返回结果
		pw.print(page.toJson());
	}	
	
	/**
	 * 导出续筹催交信息
	 */
	@RequestMapping("/queryDunning/toExport")
	public void export(HttpServletRequest request, HttpServletResponse response) {
		// 获取页面传入的参数，并以逗号(,)分割，存入数组中
		String paras = request.getParameter("str");
		String[] strs = paras.split(",");
		try {
			Map<String, String> map = new HashMap<String, String>();
			map.put("xqbh", strs[0]);
			map.put("lybh", strs[1]);
			map.put("StandardType", strs[2]);
			map.put("ShowType", strs[3]);
			map.put("Item", Urlencryption.unescape(strs[4]));
			map.put("Coefficient", strs[5]);
			map.put("xmbm", strs[6]);
			map.put("type", strs[7]);
			// 添加操作日志
			LogUtil.write(new Log("续筹催交", "导出", "QueryDunningAction.export", map.toString()));	
			List<House> resultList = queryDunningService.findQueryDunning(map);
			// 当type=1，导出续筹催交信息，否则导出补交信息
			if(strs[7].equals("1")){
				DataExport.exportDunningDate(resultList, response);
			}else{
				DataExport.exportDunningBJDate(resultList, response);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * 打印续筹催交信息
	 */
	@RequestMapping("/queryDunning/toPrint")
	public ModelAndView listPrint(HttpServletRequest request, HttpServletResponse response) {
		// 获取页面传入的参数，并以逗号(,)分割，存入数组中
		String paras = request.getParameter("str");
		String[] strs = paras.split(",");
		Map<String, String> map = new HashMap<String, String>();
		map.put("xqbh", strs[0]);
		map.put("lybh", strs[1]);
		map.put("StandardType", strs[2]);
		map.put("ShowType", strs[3]);
		map.put("Item", Urlencryption.unescape(strs[4]));
		map.put("Coefficient", strs[5]);
		map.put("xmbm", strs[6]);
		map.put("type", strs[7]);
		// 添加操作日志
		LogUtil.write(new Log("续筹催交", "打印", "QueryDunningAction.listPrint", map.toString()));	
		// 查询要打印的数据
		List<House> list = queryDunningService.findQueryDunning(map);
		// 传参容器
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("list", list);
		QueryDunningPrint view = new QueryDunningPrint();
		// 设置参数
		view.setAttributesMap(paramMap);
		// 返回视图
		return new ModelAndView(view);
	}
}

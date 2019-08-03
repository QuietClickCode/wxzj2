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
import com.yaltec.wxzj2.biz.compositeQuery.service.QueryUnitToPrepayService;
import com.yaltec.wxzj2.biz.compositeQuery.service.export.DataExport;
import com.yaltec.wxzj2.biz.payment.entity.UnitToPrepay;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 
 * @ClassName: QueryUnitToPrepayAction
 * @Description: TODO单位交支查询实现类
 * 
 * @author moqian
 * @date 2016-8-26 上午09:12:03
 */

@Controller
public class QueryUnitToPrepayAction {
	
	@Autowired
	private QueryUnitToPrepayService queryUnitToPrepayService;	
	
	/**
	 * 查询单位交支信息列表
	 */
	@RequestMapping("/queryUnitToPrepay/index")
	public String index(Model model){
		model.addAttribute("kfgss", DataHolder.dataMap.get("developer"));
		return "/compositeQuery/queryUnitToPrepay/index";
	}
	
	/**
	 * 查询单位交支信息列表
	 * @param request 
	 */
	@RequestMapping("/queryUnitToPrepay/list")
	public void list(@RequestBody ReqPamars<UnitToPrepay> req, HttpServletRequest request, HttpServletResponse response)
			throws IOException {
		// 添加操作日志
		LogUtil.write(new Log("单位交支", "查询", "QueryUnitToPrepayAction.list", req.toString()));
		//获取查询条件
		Map<String, Object> paramMap = req.getParams();
		paramMap.put("result", "-1");	
		Page<UnitToPrepay> page = new Page<UnitToPrepay>(req.getEntity(), req.getPageNo(), req.getPageSize());
		queryUnitToPrepayService.queryQryUnitToPrepay(page, paramMap);
		//返回数据
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 返回结果
		pw.print(page.toJson());
	}
	
	/**
	 * 导出单位交支信息
	 */
	@RequestMapping("/queryUnitToPrepay/toExport")
	public void Export(HttpServletRequest request, HttpServletResponse response) {
		// 获取页面传入的参数，并以逗号(,)分割，存入数组中
		String paras = request.getParameter("str");
		String[] strs = paras.split(",");
		try {
			Map<String, String> map = new HashMap<String, String>();
			map.put("dwbm", strs[0]);
			map.put("bdate", strs[1]);
			map.put("edate", strs[2]);
			map.put("Ifsh", strs[3]);
			// 添加操作日志
			LogUtil.write(new Log("单位交支", "导出", "QueryUnitToPrepayAction.Export", map.toString()));
			List<UnitToPrepay> resultList = queryUnitToPrepayService.findUnitToPrepay(map);
			
			DataExport.exportUnitToPrepay(resultList, response);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
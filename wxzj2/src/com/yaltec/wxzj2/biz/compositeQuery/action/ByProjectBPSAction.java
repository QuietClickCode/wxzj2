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
import com.yaltec.wxzj2.biz.compositeQuery.entity.ByProjectBPS;
import com.yaltec.wxzj2.biz.compositeQuery.service.ByProjectBPSService;
import com.yaltec.wxzj2.biz.compositeQuery.service.export.DataExport;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 
 * @ClassName: ByProjectBPSAction
 * @Description: TODO项目收支统计实现类
 * 
 * @author moqian
 * @date 2016-8-26 下午16:12:03
 */

@Controller
public class ByProjectBPSAction {
	
	@Autowired
	private ByProjectBPSService byProjectBPSService;	
	
	/**
	 * 查询项目收支统计列表
	 */
	@RequestMapping("/byProjectBPS/index")
	public String index(Model model){
		model.addAttribute("projects", DataHolder.dataMap.get("project"));
		return "/compositeQuery/byProjectBPS/index";
	}
	
	/**
	 * 查询项目收支统计列表
	 * @param request 
	 */
	@RequestMapping("/byProjectBPS/list")
	public void list(@RequestBody ReqPamars<ByProjectBPS> req, HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		// 添加操作日志
		LogUtil.write(new Log("项目收支统计", "查询", "ByProjectBPSAction.list", req.toString()));
		//获取查询条件
		Map<String, Object> paramMap = req.getParams();
		paramMap.put("result", "-1");	
		Page<ByProjectBPS> page = new Page<ByProjectBPS>(req.getEntity(), req.getPageNo(), req.getPageSize());
		byProjectBPSService.queryByProjectBPS(page, paramMap);
		//返回数据
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 返回结果
		pw.print(page.toJson());				
	}	
	
	/**
	 * 导出项目收支统计信息
	 */
	@RequestMapping("/byProjectBPS/toExport")
	public void Export(HttpServletRequest request, HttpServletResponse response) {
		// 获取页面传入的参数，并以逗号(,)分割，存入数组中
		String paras = request.getParameter("str");
		String[] strs = paras.split(",");
		try {
			Map<String, String> map = new HashMap<String, String>();
			map.put("xmbm", strs[0]);
			map.put("begindate", strs[1]);
			map.put("enddate", strs[2]);
			map.put("pzsh", strs[3]);
			map.put("cxlb", strs[4]);
			map.put("sfbq", strs[5]);
			map.put("result", "");
			// 添加操作日志
			LogUtil.write(new Log("项目收支统计", "导出", "ByProjectBPSAction.Export", map.toString()));
			List<ByProjectBPS> resultList = byProjectBPSService.findProjectBPS(map);
			
			DataExport.exportProjectBPS(resultList, response);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}

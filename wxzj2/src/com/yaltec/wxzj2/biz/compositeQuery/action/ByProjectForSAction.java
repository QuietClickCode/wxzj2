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
import com.yaltec.wxzj2.biz.compositeQuery.entity.ByBuildingForC1;
import com.yaltec.wxzj2.biz.compositeQuery.service.ByProjectForSService;
import com.yaltec.wxzj2.biz.compositeQuery.service.export.DataExport;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 
 * @ClassName: ByProjectForSAction
 * @Description: TODO项目台账查询实现类
 * 
 * @author moqian
 * @date 2016-8-24 下午16:12:03
 */

@Controller
public class ByProjectForSAction {
	
	@Autowired
	private ByProjectForSService byProjectForSService;	
	
	/**
	 * 查询项目台账信息列表
	 */
	@RequestMapping("/byProjectForS/index")
	public String index(Model model){
		model.addAttribute("projects", DataHolder.dataMap.get("project"));
		return "/compositeQuery/byProjectForS/index";
	}
	
	/**
	 * 查询项目台账信息列表
	 * @param request 
	 */
	@RequestMapping("/byProjectForS/list")
	public void list(@RequestBody ReqPamars<ByBuildingForC1> req, HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		// 添加操作日志
		LogUtil.write(new Log("项目台账信息", "查询", "ByProjectForSAction.list", req.toString()));
		//获取查询条件
		Map<String, Object> paramMap = req.getParams();
		paramMap.put("result", "-1");	
		Page<ByBuildingForC1> page = new Page<ByBuildingForC1>(req.getEntity(), req.getPageNo(), req.getPageSize());
		byProjectForSService.queryByProjectForS(page, paramMap);
		//返回数据
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 返回结果
		pw.print(page.toJson());				
	}
	
	/**
	 *按项目汇总台账的导出数据
	 */
	@RequestMapping("/byProjectForS/exportProjectForS")
	public void export(HttpServletRequest request, HttpServletResponse response) {
		try {
			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("xmbm",request.getParameter("xmbm"));
			paramMap.put("begindate",request.getParameter("begindate"));
			paramMap.put("enddate",request.getParameter("enddate"));
			paramMap.put("pzsh",request.getParameter("pzsh"));
			paramMap.put("cxlb",request.getParameter("cxlb"));
			paramMap.put("xssy",request.getParameter("xssy"));
			// 添加操作日志
			LogUtil.write(new Log("项目台账信息", "导出", "ByProjectForSAction.export", paramMap.toString()));
			List<ByBuildingForC1> resultList = byProjectForSService.findByProjectForS(paramMap);
			
			DataExport.exportProjectForS(resultList, response);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
}
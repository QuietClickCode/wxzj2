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
import com.yaltec.comon.utils.Urlencryption;
import com.yaltec.wxzj2.biz.compositeQuery.entity.ProjectInterestF;
import com.yaltec.wxzj2.biz.compositeQuery.service.ProjectInterestFService;
import com.yaltec.wxzj2.biz.compositeQuery.service.export.DataExport;
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
public class ProjectInterestFAction {
	
	@Autowired
	private ProjectInterestFService projectInterestFService;	
	
	/**
	 * 查询项目利息信息列表
	 */
	@RequestMapping("/projectInterestF/index")
	public String index(Model model){
		model.addAttribute("banks", DataHolder.dataMap.get("bank"));
		model.addAttribute("projects", DataHolder.dataMap.get("project"));
		//获取所有年度
		List<String> list = projectInterestFService.getReviewNd();
		model.addAttribute("nds", list);
		return "/compositeQuery/projectInterestF/index";
	}
	
	/**
	 * 查询项目利息信息列表
	 * @param request 
	 */
	@RequestMapping("/projectInterestF/list")
	public void list(@RequestBody ReqPamars<ProjectInterestF> req, HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		// 添加操作日志
		LogUtil.write(new Log("项目利息", "查询", "ProjectInterestFAction.list", req.toString()));
		//获取查询条件
		Map<String, Object> paramMap = req.getParams();
		paramMap.put("result", "-1");
		Page<ProjectInterestF> page = new Page<ProjectInterestF>(req.getEntity(), req.getPageNo(), req.getPageSize());
		projectInterestFService.queryProjectInterestF(page, paramMap);
		//返回数据
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 返回结果
		pw.print(page.toJson());				
	}	
	
	
	/**
	 *项目利息单的导出数据
	 */
	@RequestMapping("/projectInterestF/exportProjectInterestF")
	public void export(HttpServletRequest request, HttpServletResponse response) {
		try {
			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("bm",request.getParameter("bm"));
			paramMap.put("yhbh",request.getParameter("yhbh"));
			paramMap.put("lsnd",Urlencryption.unescape(request.getParameter("lsnd")));
			// 添加操作日志
			LogUtil.write(new Log("项目利息", "导出", "ProjectInterestFAction.export", paramMap.toString()));
			List<ProjectInterestF> resultList = projectInterestFService.findProjectInterestF(paramMap);
			
			DataExport.exportProjectInterestF(resultList, response);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
}

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
import com.yaltec.wxzj2.biz.compositeQuery.entity.DetailBuildingI;
import com.yaltec.wxzj2.biz.compositeQuery.service.DetailBuildingIService;
import com.yaltec.wxzj2.biz.compositeQuery.service.export.DataExport;
import com.yaltec.wxzj2.biz.compositeQuery.service.print.DetailBuildingIPrint;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 
 * @ClassName: DetailBuildingIAction
 * @Description: TODO楼宇利息明细查询实现类
 * 
 * @author moqian
 * @date 2016-8-23 下午14:12:03
 */

@Controller
public class DetailBuildingIAction {
	
	@Autowired
	private DetailBuildingIService detailBuildingIService;	
	
	/**
	 * 查询楼宇利息明细信息列表
	 */
	@RequestMapping("/detailBuildingI/index")
	public String index(Model model){
		model.addAttribute("communitys", DataHolder.communityMap);
		return "/compositeQuery/detailBuildingI/index";
	}
	
	/**
	 * 查询楼宇利息明细信息列表
	 * @param request 
	 */
	@RequestMapping("/detailBuildingI/list")
	public void list(@RequestBody ReqPamars<DetailBuildingI> req, HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		// 添加操作日志
		LogUtil.write(new Log("楼宇利息明细", "查询", "DetailBuildingIAction.list", req.toString()));
		//获取查询条件
		Map<String, Object> paramMap = req.getParams();
		paramMap.put("result", "-1");	
		Page<DetailBuildingI> page = new Page<DetailBuildingI>(req.getEntity(), req.getPageNo(), req.getPageSize());
		detailBuildingIService.queryDetailBuildingI(page, paramMap);
		//返回数据
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 返回结果
		pw.print(page.toJson());				
	}	
	
	/**
	 * 楼宇利息单明细打印清册
	 */
	@RequestMapping("/detailBuildingI/printPdfDetailBuildingI")
	public ModelAndView print(HttpServletRequest request, HttpServletResponse response) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("begindate",request.getParameter("begindate"));
		map.put("enddate",request.getParameter("enddate"));
		map.put("lybh",request.getParameter("lybh"));
		// 添加操作日志
		LogUtil.write(new Log("楼宇利息明细", "打印", "DetailBuildingIAction.print", map.toString()));
		List<DetailBuildingI> list = detailBuildingIService.findDetailBuildingI(map);
		// 传参容器
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("list", list);
		DetailBuildingIPrint view = new DetailBuildingIPrint();
		// 设置参数
		view.setAttributesMap(paramMap);
		// 返回视图
		return new ModelAndView(view);
	}
	
	/**
	 *楼宇利息明细的导出数据
	 */
	@RequestMapping("/detailBuildingI/exportDetailBuildingI")
	public void export(HttpServletRequest request, HttpServletResponse response) {
		try {
			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("begindate",request.getParameter("begindate"));
			paramMap.put("enddate",request.getParameter("enddate"));
			paramMap.put("lybh",request.getParameter("lybh"));
			// 添加操作日志
			LogUtil.write(new Log("楼宇利息明细", "导出", "DetailBuildingIAction.export", paramMap.toString()));
			List<DetailBuildingI> resultList = detailBuildingIService.findDetailBuildingI(paramMap);
			
			DataExport.exportDetailBuildingI(resultList, response);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}

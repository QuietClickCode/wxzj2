package com.yaltec.wxzj2.biz.propertymanager.action;

import java.io.ByteArrayOutputStream;
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
import com.yaltec.wxzj2.biz.property.entity.House;
import com.yaltec.wxzj2.biz.property.service.HouseService;
import com.yaltec.wxzj2.biz.propertymanager.entity.ChangeProperty;
import com.yaltec.wxzj2.biz.propertymanager.entity.ChangePropertyPDF;
import com.yaltec.wxzj2.biz.propertymanager.service.PropertyService;
import com.yaltec.wxzj2.biz.propertymanager.service.export.ChangePropertyExport;
import com.yaltec.wxzj2.biz.system.service.AssignmentService;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 产权变更查询实现类
 * @ClassName: QueryChangePropertyAction 
 * @author 重庆亚亮科技有限公司 hqx 
 * @date 2016-8-8 下午03:26:20
 */
@Controller
public class QueryChangePropertyAction {
	@Autowired
	private HouseService houseService;
	@Autowired
	private PropertyService propertyService;
	
	@Autowired
	private AssignmentService assignmentService;
	
	/**
	 * 跳转首页
	 * @param model
	 * @return
	 */
	@RequestMapping("/querychangeproperty/index")
	public String changesearch(Model model) {
		model.addAttribute("communitys", DataHolder.communityMap);
		return "/propertymanager/querychangeproperty/index";
	}
	
	/**
	 * 变更查询列表
	 */
	@RequestMapping("/querychangeproperty/list")
	public void changesearchlist(@RequestBody ReqPamars<ChangeProperty> req, HttpServletRequest request,
			HttpServletResponse response) throws IOException {	
		//获取查询条件
		Map<String, Object> paramMap = req.getParams();
		if(paramMap.get("enddate").toString().equals("")){
			paramMap.put("enddate",DateUtil.getCurrTime(DateUtil.ZH_CN_DATE));
		}
		if(!paramMap.get("h001").toString().equals("")){
			House house=  houseService.findByH001(paramMap.get("h001").toString());
			paramMap.put("xqbh",house.getXqbh());
			paramMap.put("lybh",house.getLybh());
		}
		Page<ChangeProperty> page = new Page<ChangeProperty>(req.getEntity(), req.getPageNo(), req.getPageSize());
		// 添加操作日志
		LogUtil.write(new Log("产权管理_变更查询", "查询", "QueryChangePropertyAction.changesearchlist",req.toString()));
		propertyService.change(page, paramMap);
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 返回结果
		pw.print(page.toJson());
	}
	
	/**
	 * 导出变更查询信息
	 * @param bm
	 * @param lb
	 * @param xqmc
	 * @param response
	 */
	@RequestMapping("/ChangeProperty/toExportChange")
	public void exportChange(HttpServletRequest request,ChangeProperty changeProperty,HttpServletResponse response) {
		response.setCharacterEncoding("utf-8");
		String queryJson=request.getParameter("queryJson");
		String[] strs=queryJson.split(",");
		Map<String, String> map= new HashMap<String, String>();
		map.put("xqbm",strs[0] );
		map.put("lybh", strs[1]);
		map.put("h001", strs[2]);
		map.put("enddate", strs[3]);
		map.put("begindate", strs[4]);
		List<ChangeProperty> resultList = null;
		try {
			// 添加操作日志
			LogUtil.write(new Log("产权管理_变更查询", "导出", "QueryChangePropertyAction.exportChange",map.toString()));
			resultList = propertyService.queryChangeProperty2(map);
			ChangePropertyExport.exportChangeProperty(resultList, response);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * 打印证明
	 * @param request
	 * @param response
	 * @throws IOException
	 */
	@RequestMapping("/changeproperty/printManyPdf")
	public void printManyPdf(HttpServletRequest request,HttpServletResponse response)throws IOException{
		//获取参数
		String tbid=request.getParameter("tbid");
		tbid=tbid.substring(0,tbid.length()-1);
		Map<String, String> paramMap = new HashMap<String, String>();
		try {
			ChangePropertyPDF pdf = new ChangePropertyPDF();
			List<ChangeProperty> resultList = null;
			String sqlstr = "select a.*,b.h030+b.h031 h030,b.h002,b.h003,b.h005 from TChangeProperty a,house b where a.tbid in ("
					+ tbid + ") and a.h001=b.h001";
			paramMap.put("sqlstr", sqlstr);
			
			// 添加操作日志
			LogUtil.write(new Log("产权管理_变更查询", "打印证明", "QueryChangePropertyAction.printManyPdf",paramMap.toString()));
			resultList=propertyService.printManyPdf(paramMap);
			// 获取房管局归集中心
			String assignment = DataHolder.dataMap.get("assignment").get("00");
			if (assignment == null || assignment.equals("")) {
				assignment = assignmentService.findByBm("00").getMc();
			}
			String title = "";
			// 判断是否江津
			if (DataHolder.customerInfo.isJJ()) {
				title = "重庆市江津区" + title;
			}
			ByteArrayOutputStream ops = null;
			ops = pdf.creatPDF2(resultList, title, assignment);
			if(ops != null){
				propertyService.output(ops, response);
			}
		}catch (Exception e) {
			e.printStackTrace();
		}
	}
}

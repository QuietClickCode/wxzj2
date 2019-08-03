package com.yaltec.wxzj2.biz.draw.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.lang.reflect.Field;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.yaltec.comon.auth.TokenHolder;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.comon.core.entity.ReqPamars;
import com.yaltec.comon.log.LogUtil;
import com.yaltec.comon.log.entity.Log;
import com.yaltec.comon.utils.JsonUtil;
import com.yaltec.comon.utils.Urlencryption;
import com.yaltec.wxzj2.biz.draw.entity.ApplyDraw;
import com.yaltec.wxzj2.biz.draw.service.DrawService;
import com.yaltec.wxzj2.biz.draw.service.ShareADService;
import com.yaltec.wxzj2.biz.draw.service.export.ExportCrossSection;
import com.yaltec.wxzj2.biz.draw.service.print.ApplyDrawPDF;
import com.yaltec.wxzj2.biz.property.entity.Building;
import com.yaltec.wxzj2.biz.property.entity.Community;
import com.yaltec.wxzj2.biz.property.entity.House;
import com.yaltec.wxzj2.biz.system.entity.MySysCode;
import com.yaltec.wxzj2.biz.system.service.AssignmentService;
import com.yaltec.wxzj2.comon.data.DataHolder;

@Controller
public class DrawAction {
	@Autowired
	private DrawService drawService;
	@Autowired
	private ShareADService shareADService;
	@Autowired
	private AssignmentService assignmentService;
	
	/**
	 * 日志记录器.
	 */
	private static final Logger logger = Logger.getLogger("BatchRefund");
	/**
	 * 将对象中的所有属性和值组合成一个map
	 * 
	 * @param obj
	 *            对象
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public static Map<String,Object> toMap(Object obj) {
		Field[] fields = obj.getClass().getDeclaredFields();
		Map<String,Object> map = new HashMap<String,Object>();
		String key = "";
		String value = "";
		Object vObj = new Object();
		try {
			for (int i = 0; i < fields.length; i++) {
				key = fields[i].getName();
				try {
					vObj = obj.getClass().getMethod("get" + key.substring(0, 1).toUpperCase() + key.substring(1), null)
							.invoke(obj, null);
				} catch (Exception e) {
					continue;
				}
				if (vObj != null) {
					value = vObj.toString();
					map.put(key, value);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return map;
	}

	// 异常提示
	public void exeException(String message, HttpServletResponse response) {
		PrintWriter out = null;
		try {
			response.setContentType("text/html;charset=utf-8");
			out = response.getWriter();
			out.print("<script language='javaScript'>alert('" + message + "');" + "self.close();</script>");
		} catch (Exception e) {
			logger.error(e.getMessage());
		} finally {
			out.flush();
			out.close();
		}
	}
	
	/**
	 * 支取主页
	 * @param request
	 * @param house
	 * @param model
	 * @return
	 */
	@RequestMapping("/applyDraw/index")
	public String index(HttpServletRequest request, House house, Model model){
		model.addAttribute("projects", DataHolder.dataMap.get("project"));
		model.addAttribute("communitys", DataHolder.communityMap);
		model.addAttribute("developers", DataHolder.dataMap.get("developer"));//开发单位
		model.addAttribute("industrys", DataHolder.dataMap.get("industry"));//业委会
		model.addAttribute("propertycompanys", DataHolder.dataMap.get("propertycompany"));//物业公司
		// 获取房管局归集中心
		String assignmentName = DataHolder.dataMap.get("assignment").get("00");
		if (assignmentName == null || assignmentName.equals("")) {
			assignmentName = assignmentService.findByBm("00").getMc();
		}
		// 判断是否荣昌
		int judgeRC = 0;
		if (DataHolder.customerInfo.isRC()) {
			judgeRC = 1;
		}
		model.addAttribute("judgeRC", judgeRC);//业委会
		
		if(DataHolder.getParameter("17")){
			return "/draw/applyDraw/index";//走流程
		}else{
			return "/draw/applyDraw2/index";//不走流程
		}
	}

	/**
	 * 新增申请（共用）
	 * @param request
	 * @param house
	 * @param model
	 * @return
	 */
	@RequestMapping("/applyDraw/toAdd")
	public String toAdd(HttpServletRequest request, House house, Model model){
		try {
			model.addAttribute("house", house);
			model.addAttribute("projects", DataHolder.dataMap.get("project"));
			model.addAttribute("projectCommunitys", JsonUtil.toJson(DataHolder.projectCommunityMap));
			model.addAttribute("communitys", DataHolder.communityMap);
			model.addAttribute("developers", DataHolder.dataMap.get("developer"));//开发单位
			model.addAttribute("industrys", DataHolder.dataMap.get("industry"));//业委会
			model.addAttribute("propertycompanys", DataHolder.dataMap.get("propertycompany"));//业委会
			model.addAttribute("isJLP", DataHolder.customerInfo.isJLP()?"1":"0");//业委会
			//model.addAttribute("msg", "");
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return "/draw/applyDraw/add";
	}
	/**
	 * 保存支取申请（共用）
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/applyDraw/add")
	public String add(ApplyDraw applyDraw, HttpServletRequest request, Model model,
			RedirectAttributes redirectAttributes) {
		
		// 添加操作日志
		LogUtil.write(new Log("支取业务_支取申请", "保存", "DrawAction.add",JsonUtil.toJson(applyDraw)));
		Map<String,Object> map = toMap(applyDraw);
		
//		String bm = drawService.getBmByContent(map);
//		bm = bm == null ? "" : bm;
//		if(!bm.equals("")){
//			redirectAttributes.addFlashAttribute("msg1", "该业务可能已经申请，请确认业务："+bm);
//			return "redirect:/applyDraw/index";
//		}
		map.put("username", TokenHolder.getUser().getUsername());
		map.put("OFileName", "");
		map.put("OFileName", "");
		map.put("result", "-1");
		int result = drawService.add(map);
		if (result == 0) {
			redirectAttributes.addFlashAttribute("msg", "添加成功");
			return "redirect:/applyDraw/index";
		} else {
			redirectAttributes.addFlashAttribute("msg", "添加失败");
			redirectAttributes.addFlashAttribute("applyDraw", applyDraw);
			return "redirect:/applyDraw/toAdd";
		}
	}

	/**
	 * 判断系统是中否存在申请单位、日期和金额都一致的情况
	 * @param request
	 * @param response
	 * @throws IOException
	 */
	@RequestMapping("/applyDraw/checkBusiness")
	public void checkBusiness(HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		// 添加操作日志
		LogUtil.write(new Log("支取业务_支取申请", "查询", "DrawAction.checkBusiness",request.getParameter("data")));
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();

		Map<String,Object> map = JsonUtil.toObject(request.getParameter("data"), HashMap.class);;
		String bm = drawService.getBmByContent(map);
		bm = bm == null ? "" : bm;
		String msg = "0";//不存在 
		if(!bm.equals("")){
			msg = "该业务可能已经申请，请确认业务："+bm;
		}
		// 返回结果
		pw.print(JsonUtil.toJson(msg));
	}
	
	/**
	 * 查询支取申请列表(ajax调用)
	 * 
	 * @param req 从第几条数据库开始算(+每页显示的条数)
	 * @param limit 每页显示的条数，相当于pageSize
	 * @param ApplyDraw 查询条件
	 * @throws IOException
	 */
	@RequestMapping("/applyDraw/list")
	public void list(@RequestBody ReqPamars<ApplyDraw> req, HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		// 添加操作日志
		LogUtil.write(new Log("支取业务_支取申请", "查询", "DrawAction.add",req.toJson()));
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		List<ApplyDraw> list = drawService.query(req.getParams());
		// 返回结果
		pw.print(JsonUtil.toJson(list));
	}
	
	/**
	 * 判断支取是否已经分摊 
	 * @param request
	 * @return
	 */
	@RequestMapping("/applyDraw/isShare")
	public void isShare(String bm, HttpServletRequest request, Model model, HttpServletResponse response) throws IOException  {

		LogUtil.write(new Log("支取业务_支取申请", "判断支取是否已经分摊 ", "DrawAction.isShare",bm));
		int result =  drawService.isShare(bm);

		PrintWriter pw = response.getWriter();
		// 返回结果
		pw.print(result);
	}
	
	/**
	 * 删除支取申请记录
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/applyDraw/batchDelete")
	public void delete(String bms, HttpServletRequest request, Model model, HttpServletResponse response) throws IOException  {

		String[] paras = bms.split(",");
		Map<String,String> paramMap = new HashMap<String, String>();
		paramMap.put("userid", TokenHolder.getUser().getUserid());
		paramMap.put("username", TokenHolder.getUser().getUsername());
		paramMap.put("flag", "17");
		// 添加操作日志
		LogUtil.write(new Log("支取业务_支取申请", "删除", "DrawAction.add",paramMap.toString()));
		String msg = "";
		for (String bm : paras) {
			if(bm.equals("")){
				continue;
			}
			paramMap.put("result", "3");
			paramMap.put("bm", bm);
			int result =  drawService.delete(paramMap);
			if (result == 0) {
				msg = "删除成功";
             } else if(result == -1){
            	 msg = bm+"该申请有凭证已经审核的支取记录，不能删除！";
            	 break;
             } else if(result == -5){
            	 msg = bm+"操作员只能删除自己的业务，请检查！";
            	 break;
             } else {
            	 msg = bm+"删除失败，请稍候重试！";
            	 break;
             } 
		}

		PrintWriter pw = response.getWriter();
		// 返回结果
		pw.print(JsonUtil.toJson(msg));
	}

	/**
	 * 跳转到分摊界面
	 * @param request
	 * @return
	 */
	@RequestMapping("/applyDraw/toShareAD")
	public String toShareAD(String bm, HttpServletRequest request, Model model,
			RedirectAttributes redirectAttributes) {
		ApplyDraw ad = drawService.get(bm);
		model.addAttribute("ad", ad);
		return "/draw/applyDraw/shareAD";
	}

	/**
	 * 跳转到分摊界面
	 * @param request
	 * @return
	 */
	@RequestMapping("/applyDraw2/toShareAD")
	public String toShareAD2(String bm, HttpServletRequest request, Model model,
			RedirectAttributes redirectAttributes) {
		ApplyDraw ad = drawService.get(bm);
		model.addAttribute("banks", DataHolder.dataMap.get("bank"));
		model.addAttribute("ad", ad);
		return "/draw/applyDraw2/shareAD";
	}
	
	/**
	 * 审核支取申请
	 * @param request
	 * @return
	 */
	@RequestMapping("/applyDraw/auditApplyDraw")
	public void audit(String bm,String status, HttpServletRequest request,HttpServletResponse response) throws Exception  {

		// 添加操作日志
		LogUtil.write(new Log("支取业务_支取申请", "提交", "DrawAction.audit","bm="+bm+",status="+status));
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();

		String msg = "";
		try {
			Map<String,Object> map = new HashMap<String,Object>();
			map.put("bm", bm);
			map.put("status", status);
			msg = shareADService.audit(map);
			// 返回结果
			pw.print(JsonUtil.toJson(msg));
		} catch (Exception e) {
			logger.error(e.getMessage());
			pw.print(JsonUtil.toJson("提交失败！"));
			throw e;
		}
	}
	
	/**
	 * 打印支取申请
	 * @throws Exception
	 */
	@RequestMapping("/applyDraw/printApplyDraw")
	public void printApplyDraw(String bm,HttpServletResponse response) {
		// 添加操作日志
		LogUtil.write(new Log("支取业务_支取申请", "打印", "DrawAction.printApplyDraw","bm="+bm));
		response.setCharacterEncoding("utf-8");
		ApplyDraw applyDraw = null;
		try {
			applyDraw = drawService.get(bm);
			ApplyDrawPDF pdf = new ApplyDrawPDF();
			pdf.creatPDF(applyDraw,response);
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e.getMessage());
			exeException("生成PDF文件发生错误！",response);
		}
	}
	/**
	 * 跳转到分摊明细
	 * @param request
	 * @return
	 */
	@RequestMapping("/applyDraw/showDrawForRe")
	public String showDrawForRe(HttpServletRequest request) {
		return "/draw/shareDetail/showDrawForRe";
	}
	
	/**
	 * 跳转到划款通知书
	 * @param request
	 * @param MScode
	 * @param model
	 * @return
	 */
	@RequestMapping("/applyDraw/ExportSave")
	public String ExportSave(HttpServletRequest request,MySysCode MScode,Model model){
		/*
		model.addAttribute("assignment", DataHolder.dataMap.get("assignment"));
		String bm=request.getParameter("bm");
		ApplyDraw applyDraw = null;
		try {
			applyDraw = drawService.getApplydrawWebByBm(bm);
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e.getMessage());
		}
		model.addAttribute("applyDraw", applyDraw);
		*/
		return "/draw/applyDraw2/ExportSave";
	}
	
	/**
	 * 导出划款通知书信息
	 * @param request
	 * @param changeProperty
	 * @param response
	 */
	@RequestMapping("/applyDraw/toExportCrossSection")
	public void toExportCrossSection(HttpServletRequest request,ApplyDraw applyDraw,HttpServletResponse response) {
		try {
			response.setCharacterEncoding("utf-8");
			String je=request.getParameter("je");
			String xqmc=request.getParameter("xqmc");
			String lymc=request.getParameter("lymc");
			String xqbh=request.getParameter("xqbh");
			String lybh=request.getParameter("lybh");
			String unitcode=request.getParameter("unitcode");
			Map<String, String> map= new HashMap<String, String>();
			map.put("je",je );
			map.put("xqmc", Urlencryption.unescape(xqmc));
			map.put("lymc", Urlencryption.unescape(lymc));
			map.put("xqbh", xqbh);
			map.put("lybh",lybh);
			map.put("unitcode", Urlencryption.unescape(unitcode));
			ExportCrossSection excel = new ExportCrossSection();
			excel.exportWxzjInfoTj_POI( response, map);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * 修改申请（共用）
	 * @param request
	 * @param house
	 * @param model
	 * @return
	 */
	@RequestMapping("/applyDraw/toUpdate")
	public String toUpdate(HttpServletRequest request, String bm, Model model){
		try {
			ApplyDraw applyDraw = drawService.get(bm);
			model.addAttribute("applyDraw", applyDraw);
			model.addAttribute("projects", DataHolder.dataMap.get("project"));
			model.addAttribute("projectCommunitys", JsonUtil.toJson(DataHolder.projectCommunityMap));
			model.addAttribute("communitys", DataHolder.communityMap);
			LinkedHashMap<String, Community> communityMap = new LinkedHashMap<String, Community>();
			for(Entry<String, Community> entry: DataHolder.communityMap.entrySet()) {
				Community community = new Community();
				community.setBm(entry.getValue().getBm());
				community.setMc(entry.getValue().getMc());
				community.setXmbm(entry.getValue().getXmbm());
				community.setXmmc(entry.getValue().getXmmc());
				communityMap.put(entry.getKey(), community);
			}
			model.addAttribute("communitysJson", JsonUtil.toJson(communityMap));
			communityMap.clear();
			model.addAttribute("developers", DataHolder.dataMap.get("developer"));//开发单位
			model.addAttribute("industrys", DataHolder.dataMap.get("industry"));//业委会
			model.addAttribute("propertycompanys", DataHolder.dataMap.get("propertycompany"));//业委会
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "/draw/applyDraw/update";
	}
	
	/**
	 * 修改支取申请
	 * @param request
	 * @return
	 */
	@RequestMapping("/applyDraw/update")
	public void update(HttpServletRequest request, Model model, HttpServletResponse response) throws IOException  {
		HashMap<String, String> map = JsonUtil.toObject(request.getParameter("data"), HashMap.class);;
		LogUtil.write(new Log("支取业务_支取申请", "修改 ", "DrawAction.update",map.toString()));
		Integer result = drawService.update(map);
		PrintWriter pw = response.getWriter();
		// 返回结果
		pw.print(result);
	}

	/**
	 * 快速查询维修项目
	 * @param model
	 * @return
	 */
	@RequestMapping("/applyDraw/open/list")
	public String openlist(Model model){
		
		return "/draw/applyDraw/popUp";	
	}
}

package com.yaltec.wxzj2.biz.draw.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
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
import com.yaltec.wxzj2.biz.draw.entity.ApplyLogout;
import com.yaltec.wxzj2.biz.draw.service.ApplyLogoutService;
import com.yaltec.wxzj2.biz.property.entity.House;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 
 * @ClassName: ApplyLogoutAction
 * @Description: TODO销户申请实现类
 * 
 * @author yangshanping
 * @date 2016-8-8 上午10:07:20
 */
@Controller
public class ApplyLogoutAction {

	@Autowired
	private ApplyLogoutService applyLogoutService;
	
	/**
	 * 跳转到首页
	 */
	@RequestMapping("/applylogout/index")
	public String index(Model model,House house) {
		model.addAttribute("house", house);
		model.addAttribute("communitys", DataHolder.communityMap);
		return "/draw/applylogout/index";
	}
	/**
	 * 查询销户申请信息
	 */
	@RequestMapping("/applylogout/list")
	public void list(@RequestBody ReqPamars<ApplyLogout> req, HttpServletRequest request,
			HttpServletResponse response)throws IOException{
		// 添加操作日志
		LogUtil.write(new Log("销户申请", "查询", "ApplyLogoutAction.list", req.toString()));
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 获取页面传入的查询条件，并存入map集合
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("nbhdcode", req.getParams().get("xqbh") == null ? "" : req.getParams().get("xqbh"));
		paramMap.put("bldgcode", req.getParams().get("lybh") == null ? "" : req.getParams().get("lybh"));
		paramMap.put("h001", req.getParams().get("h001") == null ? "" : req.getParams().get("h001"));
		paramMap.put("sqrq", req.getParams().get("sqrq") == null ? "" : req.getParams().get("sqrq"));
		paramMap.put("cxlb", req.getParams().get("zt") == null ? "" : req.getParams().get("zt"));
		
		Page<ApplyLogout> page = new Page<ApplyLogout>(req.getEntity(), req.getPageNo(), req.getPageSize());
		applyLogoutService.find(page, paramMap);
		// 返回结果
		pw.print(page.toJson());
	}
	
	/**
	 * 跳转到添加销户申请信息页面
	 */
	@RequestMapping("/applylogout/toAdd")
	public String toAdd(HttpServletRequest request, Model model, House house) {
		model.addAttribute("house", house);
		model.addAttribute("communitys", DataHolder.communityMap);
		return "/draw/applylogout/add";
	}
	
	/**
	 * 保存销户申请信息
	 */
	@RequestMapping("/applylogout/add")
	public String add(HttpServletRequest request, Model model,RedirectAttributes redirectAttributes) {
		// 创建一个map集合，用来接收页面传入的参数
		Map<String,String> paramMap=new HashMap<String,String>();
		paramMap.put("nbhdcode", request.getParameter("xqbh"));
		paramMap.put("nbhdname", request.getParameter("xqmc"));
		paramMap.put("bldgcode", request.getParameter("lybh"));
		paramMap.put("bldgname", request.getParameter("lymc"));
		paramMap.put("HandlingUser", request.getParameter("HandlingUser"));
		paramMap.put("h001", request.getParameter("h001")==null?"":request.getParameter("h001"));
		paramMap.put("sqrq", request.getParameter("sqrq"));
		paramMap.put("ApplyRemark", request.getParameter("ApplyRemark"));
		paramMap.put("oFileName", "");
		paramMap.put("nFileName", "");
		paramMap.put("username", TokenHolder.getUser().getUsername());
		paramMap.put("result", "");
		// 添加操作日志
		LogUtil.write(new Log("销户申请", "添加", "ApplyLogoutAction.add", paramMap.toString()));
		// 将该map集合作为参数，传递到saveApplyLogout方法中，调用对应的存储过程
		int result = applyLogoutService.saveApplyLogout(paramMap);
		if (result == 0) {
			redirectAttributes.addFlashAttribute("msg","保存成功！");
        } else if(result == 1) {
        	redirectAttributes.addFlashAttribute("msg","销户的房屋存在有未入账业务，不允许销户！");
        	return "redirect:/applylogout/toAdd";
        } else if(result == 2) {
        	redirectAttributes.addFlashAttribute("msg","此房屋编号已经申请了销户！");
        	return "redirect:/applylogout/toAdd";
        } else if(result == 5) {
        	redirectAttributes.addFlashAttribute("msg","无相应的房屋信息，请检查！");
        	return "redirect:/applylogout/toAdd";
        } else {
        	redirectAttributes.addFlashAttribute("msg","保存失败，请稍候重试！");
        	return "redirect:/applylogout/toAdd";
        }
		return "redirect:/applylogout/index";
	}
	
	/**
	 * 提交销户申请信息(可实现批量提交)
	 */
	@RequestMapping("/applylogout/updtApplyLogoutChecked")
	public String updtApplyLogoutChecked(HttpServletRequest request, Model model,RedirectAttributes redirectAttributes) {
		// 通过request接收页面传递的编码(bm)数据
		String paras=request.getParameter("bms");
		// 添加操作日志
		LogUtil.write(new Log("销户申请", "提交销户申请", "ApplyLogoutAction.updtApplyLogoutChecked", paras));
		if(paras.isEmpty()){
			redirectAttributes.addFlashAttribute("msg","获取数据异常，请请检查重试！");
        	return  "redirect:/applylogout/index";
		}
		// 将编码按逗号进行分割
		String[] bms = paras.split(",");
		// 创建一个map集合，作为调用提交销户申请方法的参数
		Map<String,String> paramMap=new HashMap<String,String>();
		paramMap.put("sj","2016-08-09");
		paramMap.put("username", TokenHolder.getUser().getUsername());
		paramMap.put("status", "11");
		paramMap.put("hbzt", "不许划拨");
		paramMap.put("reson", "");
		paramMap.put("result", "");
		paramMap.put("slzt", "正常受理");
		// 根据bm进行循环提交销户申请
		for (String bm : bms) {
			if (!bm.equals("")) {
				paramMap.put("bm", bm);
				String result = applyLogoutService.updtApplyLogout(paramMap);
				if (result.equals("0")) {
					redirectAttributes.addFlashAttribute("msg","已通过申请,请到初审流程办理！");
		        } else {
		        	redirectAttributes.addFlashAttribute("msg","提交销户申请失败！");
		        }
			}
		}
		return  "redirect:/applylogout/index";
	}
	/**
	 * 删除销户申请信息(可进行批量删除)
	 */
	@RequestMapping("/applylogout/delApplyLogout")
	public String delApply(HttpServletRequest request, Model model,RedirectAttributes redirectAttributes) {
		// 通过request接收页面传递过来要删除的编码(bm)数据
		String paras=request.getParameter("bms");
		if(paras.isEmpty()){
			redirectAttributes.addFlashAttribute("msg","获取数据异常，请稍候重试！");
        	return  "redirect:/applylogout/index";
		}
		// 添加操作日志
		LogUtil.write(new Log("销户申请", "删除", "ApplyLogoutAction.delApplyLogout", paras));
		// 将编码按逗号进行分割
		String[] bms = paras.split(",");
		// 创建一个map集合，作为调用删除销户申请方法的参数
		Map<String,String> paramMap=new HashMap<String,String>();
		paramMap.put("userid", TokenHolder.getUser().getUserid());
		paramMap.put("username", TokenHolder.getUser().getUsername());
		paramMap.put("flag", "18");
		paramMap.put("result", "");
		// 根据bm进行循环删除销户申请
		for (String bm : bms) {
			if (!bm.equals("")) {
				paramMap.put("bm", bm);
				int result = applyLogoutService.delApplyLogout(paramMap);
				if (result==0) {
					redirectAttributes.addFlashAttribute("msg","删除销户申请成功！");
		        }else {
                	redirectAttributes.addFlashAttribute("msg","删除失败，请稍候重试！");
                }
			}
		}
		return  "redirect:/applylogout/index";
	}
}

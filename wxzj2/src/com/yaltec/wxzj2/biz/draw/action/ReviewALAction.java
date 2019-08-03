package com.yaltec.wxzj2.biz.draw.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
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
import com.yaltec.comon.utils.Urlencryption;
import com.yaltec.wxzj2.biz.draw.entity.ApplyLogout;
import com.yaltec.wxzj2.biz.draw.service.ReviewALService;
import com.yaltec.wxzj2.biz.property.entity.House;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 
 * @ClassName: ReviewALAction
 * @Description: TODO销户审核实现类
 * 
 * @author yangshanping
 * @date 2016-8-10 上午09:35:02
 */
@Controller
public class ReviewALAction {
	@Autowired
	private ReviewALService reviewALService;

	/**
	 * 跳转到首页
	 */
	@RequestMapping("/reviewal/index")
	public String index(Model model,House house) {
		model.addAttribute("house", house);
		model.addAttribute("communitys", DataHolder.communityMap);
		return "/draw/reviewal/index";
	}
	/**
	 * 查询销户申请信息
	 */
	@RequestMapping("/reviewal/list")
	public void list(@RequestBody ReqPamars<ApplyLogout> req, HttpServletRequest request,
			HttpServletResponse response)throws IOException{
		// 添加操作日志
		LogUtil.write(new Log("销户审核", "查询", "ReviewALAction.list", req.toString()));
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 获取页面传入的查询条件，并存入map集合
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("nbhdcode", req.getParams().get("xqbh") == null ? "" : req.getParams().get("xqbh"));
		paramMap.put("bldgcode", req.getParams().get("lybh") == null ? "" : req.getParams().get("lybh"));
		paramMap.put("h001", req.getParams().get("h001") == null ? "" : req.getParams().get("h001"));
		paramMap.put("sqrq", req.getParams().get("sqrq") == null ? "" : req.getParams().get("sqrq"));
		/* cxlb状态值：10调入清册,11初审,12初审返回,13领导审批,14领导审批退回到初审,15领导审批退回到调入清册,16划拨,17审核 */
		paramMap.put("cxlb", "13");
		Page<ApplyLogout> page = new Page<ApplyLogout>(req.getEntity(), req.getPageNo(), req.getPageSize());
		reviewALService.find(page, paramMap);
		// 返回结果
		pw.print(page.toJson());
	}

	/**
	 * 审核通过(可批量操作)
	 */
	@RequestMapping("/reviewal/agreeChecked")
	public String agreeChecked(HttpServletRequest request, Model model,
			RedirectAttributes redirectAttributes) {
		// 获取页面传入的查询条件，并存入map集合
		String paras = request.getParameter("bms");
		if (paras.isEmpty()) {
			redirectAttributes.addFlashAttribute("msg", "获取数据异常，请检查重试！");
			return "redirect:/reviewal/index";
		}
		// 添加操作日志
		LogUtil.write(new Log("销户审核", "审核通过", "ReviewALAction.agreeChecked", paras));
		// 将编码按逗号进行分割
		String[] bms = paras.split(",");
		// 创建一个map集合，作为调用审核通过方法的参数
		Map<String, String> paramMap = new HashMap<String, String>();
		// 获取当前系统时间
		Date date=new Date();
		String df= new SimpleDateFormat("yyyy-MM-dd").format(date);
		paramMap.put("sj", df);
		paramMap.put("userid", TokenHolder.getUser().getUserid());
		paramMap.put("username", TokenHolder.getUser().getUsername());
		paramMap.put("hbzt", "允许划拨");
		paramMap.put("result", "-1");
		paramMap.put("reson", "");
		paramMap.put("slzt", "正常受理");
		paramMap.put("status", "16");
		// 根据bm进行循环审核通过方法
		for (String bm : bms) {
			if (!bm.equals("")) {
				paramMap.put("bm", bm);
				String result = reviewALService.updtApplyLogout(paramMap);
				if (result.equals("0")) {
					redirectAttributes.addFlashAttribute("msg",
							"已通过审核,请到划拨流程办理！");
				} else {
					redirectAttributes.addFlashAttribute("msg", "审核失败，请稍候重试！");
				}
			}
		}
		return "redirect:/reviewal/index";
	}

	/**
	 * 返回申请
	 */
	@RequestMapping("/reviewal/returnCheck")
	public String returnCheck(HttpServletRequest request, Model model,
			RedirectAttributes redirectAttributes) {
		// 获取页面传入的查询条件，并存入map集合
		String paras = request.getParameter("bms");
		if (paras.isEmpty()) {
			redirectAttributes.addFlashAttribute("msg", "获取数据异常，请检查重试！");
			return "redirect:/reviewal/index";
		}
		// 添加操作日志
		LogUtil.write(new Log("销户审核", "返回申请", "ReviewALAction.returnCheck", paras));
		String[] bms = paras.split(";");
		Map<String, String> paramMap = new HashMap<String, String>();
		// 获取当前系统时间
		Date date=new Date();
		String df= new SimpleDateFormat("yyyy-MM-dd").format(date);
		paramMap.put("sj", df);
		paramMap.put("userid", TokenHolder.getUser().getUserid());
		paramMap.put("username", TokenHolder.getUser().getUsername());
		paramMap.put("hbzt", "不许划拨");
		paramMap.put("result", "-1");
		paramMap.put("slzt", "正常受理");
		paramMap.put("status", bms[1]);
		// 获取页面传入的驳回原因，并转码
		paramMap.put("reson", Urlencryption.unescape(bms[2]));
		paramMap.put("bm", bms[0]);
		reviewALService.returnReviewAL(paramMap);
		String result = paramMap.get("result");
		if (result.equals("0")) {
			if (paramMap.get("status").toString().equals("14")) {
				redirectAttributes.addFlashAttribute("msg",
						"该申请已返回到初审流程中,请到初审流程中重新办理！");
			} else if (paramMap.get("status").toString().equals("15")) {
				redirectAttributes.addFlashAttribute("msg",
						"该申请已返回到申请流程中,请到申请流程中重新办理！");
			} else if (paramMap.get("status").toString().equals("25")) {
				redirectAttributes.addFlashAttribute("msg", "该申请已被拒绝受理！");
			}
		} else {
			redirectAttributes.addFlashAttribute("msg", "返回申请失败！");
		}
		return "redirect:/reviewal/index";
	}
}

package com.yaltec.wxzj2.biz.draw.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

import com.yaltec.comon.auth.TokenHolder;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.comon.core.entity.ReqPamars;
import com.yaltec.comon.log.LogUtil;
import com.yaltec.comon.log.entity.Log;
import com.yaltec.comon.utils.DateUtil;
import com.yaltec.comon.utils.JsonUtil;
import com.yaltec.wxzj2.biz.draw.entity.ApplyDraw;
import com.yaltec.wxzj2.biz.draw.entity.ShareAD;
import com.yaltec.wxzj2.biz.draw.service.CheckAD1Service;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 
 * @ClassName: CheckAD1Action
 * @Description: 支取初审实现类
 * 
 * @author yangshanping
 * @date 2016-8-31 下午04:34:58
 */
@Controller
public class CheckAD1Action {
	@Autowired
	private CheckAD1Service checkAD1Service;
	/**
	 * 日志记录器.
	 */
	private static final Logger logger = Logger.getLogger("CheckAD1");

	/**
	 * 跳转到首页 初审
	 */
	@RequestMapping("/checkAD/index1")
	public String index1(Model model) {
		model.addAttribute("projects", DataHolder.dataMap.get("project"));
		model.addAttribute("communitys", DataHolder.communityMap);
		return "/draw/checkAD/index1";
	}

	/**
	 * 跳转到首页  审核
	 */
	@RequestMapping("/checkAD/index2")
	public String index2(Model model) {
		model.addAttribute("projects", DataHolder.dataMap.get("project"));
		model.addAttribute("communitys", DataHolder.communityMap);
		return "/draw/checkAD/index2";
	}

	/**
	 * 跳转到首页  审核
	 */
	@RequestMapping("/checkAD/index3")
	public String index3(Model model) {
		model.addAttribute("projects", DataHolder.dataMap.get("project"));
		model.addAttribute("communitys", DataHolder.communityMap);
		return "/draw/checkAD/index3";
	}

	/**
	 * 跳转到首页  审批
	 */
	@RequestMapping("/checkAD/index4")
	public String index4(Model model) {
		model.addAttribute("projects", DataHolder.dataMap.get("project"));
		model.addAttribute("communitys", DataHolder.communityMap);
		return "/draw/checkAD/index4";
	}

	/**
	 * 查询支取申请信息（支取初审）
	 */
	@RequestMapping("/checkAD/list")
	public void list(@RequestBody ReqPamars<ApplyDraw> req,
			HttpServletRequest request, HttpServletResponse response)
			throws IOException {
		// 添加操作日志
		LogUtil.write(new Log("支取业务_支取审核流程", "查询", "CheckAD1Action.list",req.toString()));
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 获取页面传入的查询条件，并存入map集合
		Map<String, Object> paramMap = req.getParams();

		Page<ApplyDraw> page = new Page<ApplyDraw>(req.getEntity(), req
				.getPageNo(), req.getPageSize());
		checkAD1Service.find(page, paramMap);
		// 返回结果
		pw.print(page.toJson());
	}

	/**
	 * 查询支取明细信息
	 */
	@RequestMapping("/checkAD/openDrawForRe")
	public void openDrawForRe(@RequestBody ReqPamars<ShareAD> req,
			HttpServletRequest request, HttpServletResponse response)
			throws IOException {
		// 添加操作日志
		LogUtil.write(new Log("支取业务_审核流程", "明细查询", "CheckAD1Action.openDrawForRe",req.toString()));
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 获取页面传入的查询条件，并存入map集合
		Map<String, Object> paramMap = req.getParams();
		paramMap.put("unitcode", TokenHolder.getUser().getUnitcode());

		Page<ShareAD> page = new Page<ShareAD>(req.getEntity(),
				req.getPageNo(), req.getPageSize());
		checkAD1Service.findDrawForRe(page, paramMap);
		// 返回结果
		pw.print(page.toJson());
	}
	
	
	
	/**
	 * 获取系统参数业务设置信息（根据编码）
	 */
	@RequestMapping("/checkAD/getSystemArg")
	public void getSystem(String bm, HttpServletResponse response) {
		try {
			response.setCharacterEncoding("utf-8");
			PrintWriter pw = response.getWriter();
			if (bm.length() == 1) {
				bm = "0" + bm;
			}
			boolean sysParam = DataHolder.getParameter(bm);
			
			pw.print(sysParam);
			
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	
	
	
	/**
	 * 跳转到支取审核通过意见页面
	 * @param bm
	 * @param response
	 */
	@RequestMapping("/checkAD/toAgree")
	public String toAgree(String bm, Model model,HttpServletResponse response) {
		try {
			response.setCharacterEncoding("utf-8");
			ApplyDraw applyDraw = checkAD1Service.getOpinionByBm(bm);
			model.addAttribute("applyDraw", applyDraw);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "/draw/checkAD/agree";
	}

	/**
	 * 审核通过支取申请信息
	 * 
	 * @throws Exception
	 * 
	 * @throws Exception
	 */
	@RequestMapping("/checkAD/agreeCheckAD")
	public void agree(String bm,String zqbh,String reason,String status,HttpServletRequest request,HttpServletResponse response) throws Exception {
		//status(103:初审通过；1：审核通过；3：复核通过；7：审批通过。)
		// 添加操作日志
		LogUtil.write(new Log("支取业务_支取审核流程", "审核", "CheckAD1Action.agree","bm="+bm+",zqbh="+zqbh+",reason="+reason+",status="+status));
		String sqlstr = "";
		String msg = "";
		if("103".equals(status)){
			sqlstr = "update SordineApplDraw set status = '"+status+"', csrq = '"+DateUtil.getDate()+"', " 
			+"csr = '"+TokenHolder.getUser().getUsername()+"',opinion1='"+reason+"' where bm = '"+bm+"'";
			msg = "初审通过！";
		}else if("1".equals(status)){
			sqlstr = "update SordineApplDraw set status = '"+status+"', shrq = '"+DateUtil.getDate()+"', " 
			+"shr = '"+TokenHolder.getUser().getUsername()+"',opinion2='"+reason+"' where bm = '"+bm+"'";
			msg = "审核通过！";
		}else if("3".equals(status)){
			sqlstr = "update SordineApplDraw set status = '"+status+"', fhrq = '"+DateUtil.getDate()+"', " 
			+"fhr = '"+TokenHolder.getUser().getUsername()+"',opinion3='"+reason+"' where bm = '"+bm+"'";
			msg = "复核通过！";
		}else if("7".equals(status)){
			sqlstr = "update SordineApplDraw set pzrq = '"+DateUtil.getDate()+"', status = '"+status+"', pzr = '"+TokenHolder.getUser().getUsername()+"', hbzt = '允许划拨' where bm = '"+bm+"' "
				+"delete from TMaterialsDetail where ApplyNO='"+bm+"' and BusinessNO='"+zqbh+"' "
				+"insert TMaterialsDetail(ApplyNO,BusinessNO,MaterialNO,MaterialName,LeaderOpinion,Process,Whether,MatrNumber,username,Leadership)" 
				+"values('"+bm+"','"+zqbh+"','A','领导批示','"+reason+"','审核',1,1,'"+TokenHolder.getUser().getUsername()+"','"+TokenHolder.getUser().getUsername()+"') ";
			msg = "审批通过！";
		}
		Map<String, String> paramMap = new HashMap<String, String>();
		paramMap.put("sqlstr", sqlstr);
		int result = -1;
		try {
			result = checkAD1Service.execute(paramMap);
			PrintWriter pw = response.getWriter();
			if(result>0){
				pw.print(msg);
			}else{
				pw.print("操作失败！");
			}
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
	}


	/**
	 * 跳转到支取退回原因页面
	 * @param bm
	 * @param response
	 */
	@RequestMapping("/checkAD/toReturnReson")
	public String toReturnReson(String bm, Model model,HttpServletResponse response) {
		try {
			response.setCharacterEncoding("utf-8");
			ApplyDraw applyDraw = checkAD1Service.getOpinionByBm(bm);
			model.addAttribute("applyDraw", applyDraw);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "/draw/checkAD/returnReson";
	}

	/**
	 * 支取初审返回支取申请
	 * 
	 * @throws Exception
	 */
	@RequestMapping("/checkAD/returnCheckAD")
	public void returnCheck(String bm, String status, String reason,HttpServletResponse response)
			throws Exception {
		// 添加操作日志
		LogUtil.write(new Log("支取业务_支取审核流程", "返回", "CheckAD1Action.returnCheck","bm="+bm+",reason="+reason+",status="+status));
		//status(102:初审返回；104：审核返回；2：复核返回；5：审批返回申请；4：审批返回复核；15：拒绝受理。)
		String sqlstr = "";
		String msg = "";
		if("102".equals(status)){
			sqlstr = "update SordineApplDraw set status = '"+status+"',TrialRetApplyReason='"+reason+"' where bm = '"+bm+"'";
			msg = "已退回到申请！";
		}else if("104".equals(status)){
			sqlstr = "update SordineApplDraw set status = '"+status+"',returnReason1='"+reason+"' where bm = '"+bm+"'";
			msg = "已退回到初审！";
		}else if("2".equals(status)){
			sqlstr = "update SordineApplDraw set status = '"+status+"',returnReason2='"+reason+"' where bm = '"+bm+"'";
			msg = "已退回到审核！";
		}else if("5".equals(status)){
			sqlstr = "update SordineApplDraw set status = '"+status+"',AuditRetApplyReason='"+reason+"' where bm = '"+bm+"'";
			msg = "已退回到申请！";
		}else if("4".equals(status)){
			sqlstr = "update SordineApplDraw set status = '"+status+"',AuditRetTrialReason='"+reason+"' where bm = '"+bm+"'";
			msg = "已退回到申复核！";
		}else if("15".equals(status)){
			sqlstr = "update SordineApplDraw set status = '5',RefuseReason='"+reason+"', slzt = '拒绝受理' where bm = '"+bm+"'";
			msg = "已退拒绝受理！";
		}
		Map<String, String> paramMap = new HashMap<String, String>();
		paramMap.put("sqlstr", sqlstr);
		int result = -1;
		try {
			result = checkAD1Service.execute(paramMap);
			PrintWriter pw = response.getWriter();
			if(result>0){
				pw.print(msg);
			}else{
				pw.print("操作失败！");
			}
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
	}

}

package com.yaltec.wxzj2.biz.draw.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.yaltec.comon.auth.TokenHolder;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.comon.core.entity.ReqPamars;
import com.yaltec.comon.log.LogUtil;
import com.yaltec.comon.log.entity.Log;
import com.yaltec.comon.utils.JsonUtil;
import com.yaltec.comon.utils.Urlencryption;
import com.yaltec.wxzj2.biz.draw.entity.ApplyLogout;
import com.yaltec.wxzj2.biz.draw.service.TransferALService;
import com.yaltec.wxzj2.biz.property.entity.House;
import com.yaltec.wxzj2.biz.system.service.BankService;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 
 * @ClassName: TransferALAction
 * @Description: TODO销户划拨实现类
 * 
 * @author yangshanping
 * @date 2016-8-10 下午02:44:18
 */
@Controller
public class TransferALAction {
	
	@Autowired
	private TransferALService transferALService;
	@Autowired
	private BankService bankService;
	/**
	 * 跳转到首页
	 */
	@RequestMapping("/transferal/index")
	public String index(Model model,House house) {
		model.addAttribute("house", house);
		model.addAttribute("communitys", DataHolder.communityMap);
		return "/draw/transferal/index";
	}
	/**
	 * 查询销户申请信息
	 */
	@RequestMapping("/transferal/list")
	public void list(@RequestBody ReqPamars<ApplyLogout> req, HttpServletRequest request,
			HttpServletResponse response)throws IOException {
		// 添加操作日志
		LogUtil.write(new Log("销户划拨", "查询", "TransferALAction.list", req.toString()));
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 获取页面传入的查询条件，并存入map集合
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("flag", req.getParams().get("flag") == null ? "" : req.getParams().get("flag"));
		paramMap.put("xqbm", req.getParams().get("xqbh") == null ? "" : req.getParams().get("xqbh"));
		paramMap.put("lybh", req.getParams().get("lybh") == null ? "" : req.getParams().get("lybh"));
		paramMap.put("h001", req.getParams().get("h001") == null ? "" : req.getParams().get("h001"));
		paramMap.put("sqsj", req.getParams().get("sqrq") == null ? "" : req.getParams().get("sqrq"));
		paramMap.put("xhrq", req.getParams().get("hbsj") == null ? "" : req.getParams().get("hbsj"));
		paramMap.put("BusinessNO", req.getParams().get("businessNO") == null ? "" : req.getParams().get("businessNO"));
		/* cxlb状态值：10调入清册,11初审,12初审返回,13领导审批,14领导审批退回到初审,15领导审批退回到调入清册,16划拨,17审核 */
		paramMap.put("cxlb", "16");
		Page<ApplyLogout> page = new Page<ApplyLogout>(req.getEntity(), req.getPageNo(), req.getPageSize());
		transferALService.find(page, paramMap);
		// 返回结果
		pw.print(page.toJson());
	}
	/**
	 * 返回审核
	 */
	@RequestMapping("/transferal/returnCheck")
	public String returnCheck(HttpServletRequest request, Model model,
			RedirectAttributes redirectAttributes) {
		// 获取页面传入的查询条件，并存入map集合
		String paras = request.getParameter("bms");
		if (paras.isEmpty()) {
			redirectAttributes.addFlashAttribute("msg", "获取数据异常，请检查重试！");
			return "redirect:/transferal/index";
		}
		// 添加操作日志
		LogUtil.write(new Log("销户划拨", "返回申请", "TransferALAction.returnCheck", paras));
		// 将页面传入的数据按分号进行分割
		String[] bmsArr = paras.split(";");
		// 创建一个map集合，作为调用返回申请方法的参数
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
		paramMap.put("status", bmsArr[1]);
		// 获取页面传入的驳回原因，并转码
		paramMap.put("reason", Urlencryption.unescape(bmsArr[2]));
		// 将编码按逗号进行分割
		String[] bms = bmsArr[0].split(",");
		for (String bm : bms) {
			// 判断bm是否为空，若不为空，调用返回申请方法，实现驳回
			if (!bms[0].equals("")) {
				paramMap.put("bm", bm);
				String result = transferALService.returnReviewAL(paramMap);
				if (result.equals("0")) {
					redirectAttributes.addFlashAttribute("msg", "已将该申请退回审核，请到审核流程办理！");
				} else {
					redirectAttributes.addFlashAttribute("msg", "退回失败，请稍候再重试！");
				}
			}
		}
		return "redirect:/transferal/index";
	}
	/**
	 * 划拨入账
	 */
	@RequestMapping("/transferal/transferALSave")
	public String transferALSave(HttpServletRequest request, Model model,
			RedirectAttributes redirectAttributes) {
		// 获取页面传入的编码、业务号、银行编号、票据号和划拨时间数据，并存入map集合
		String paras=request.getParameter("bms");
		String pjh=request.getParameter("pjh");
		if (paras.isEmpty()) {
			redirectAttributes.addFlashAttribute("msg", "获取数据异常，请检查重试！");
			return "redirect:/transferal/index";
		}
		// 添加操作日志
		LogUtil.write(new Log("销户划拨", "划拨入账", "TransferALAction.transferALSave", paras));
		// 将页面传入的数据按分号进行分割
		String[] bms = paras.split(";");
		// 根据银行编码获取银行名称
		String yhmc=bankService.findByBm(bms[3]).getMc();
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("BusinessNO", bms[1]);
		paramMap.put("yhbh", bms[3]);
		paramMap.put("yhmc", yhmc);
		paramMap.put("xhrq", bms[2]);
		paramMap.put("userid", TokenHolder.getUser().getUserid());
		paramMap.put("username", TokenHolder.getUser().getUsername());
		paramMap.put("pjh", pjh);
	
		int result=transferALService.saveTransferAL(paramMap);
		if(result == 0) {
			redirectAttributes.addFlashAttribute("msg", "保存成功！");
        } else if(result == -3) {
        	redirectAttributes.addFlashAttribute("msg", "该银行余额不足，请重新选择银行！");
        } else if(result == -5) {
        	redirectAttributes.addFlashAttribute("msg", "销户划拨日期不能小于该房屋最后一笔交款日期！");
        } else if(result == 5) {
        	redirectAttributes.addFlashAttribute("msg", "此房屋不存在，请确定！");
        } else if(result == 6) {
        	redirectAttributes.addFlashAttribute("msg", "销户总金额为零！");
        } else if(result == 7) {
        	redirectAttributes.addFlashAttribute("msg","此房屋已销户！");
        }
		return "redirect:/transferal/index";
	}
	/**
	 * 结算利息
	 * @throws Exception 
	 */
	@RequestMapping("/transferal/countInterest")
	public void countLXJS(String flag,String businessNO,String xhrq,
			HttpServletResponse response,RedirectAttributes redirectAttributes) throws Exception {
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 添加操作日志
		LogUtil.write(new Log("销户划拨", "结算利息", "TransferALAction.countInterest", businessNO));
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("flag", flag);
		paramMap.put("BusinessNO", businessNO);
		paramMap.put("xhrq", xhrq);
		paramMap.put("result", "0");
		if (transferALService.checkForsaveTransferAL(paramMap) != null) {
			paramMap.put("result", "-1");
		}
		if(paramMap.get("result").equals("0")){
			// 由于在查询方法find中有结算利息的方法，结算利息处理后，也需要在页面上显示。所以在这一步，直接调用find方法
			List<ApplyLogout> resultList = transferALService.queryTransferAL_LXJS(paramMap);
//			model.addAttribute("flag", paramMap.get("flag"));
			pw.print(JsonUtil.toJson(resultList));
		}else{
			redirectAttributes.addFlashAttribute("msg","销户划拨日期应大于等于最后一次到账日期！");
		}
		
	}
}

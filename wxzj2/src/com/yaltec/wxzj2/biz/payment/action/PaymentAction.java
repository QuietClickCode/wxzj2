package com.yaltec.wxzj2.biz.payment.action;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.LinkedHashMap;
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
import com.yaltec.wxzj2.biz.bill.service.ReceiptInfoMService;
import com.yaltec.wxzj2.biz.payment.entity.CashPayment;
import com.yaltec.wxzj2.biz.payment.entity.PayToStore;
import com.yaltec.wxzj2.biz.payment.service.PaymentService;
import com.yaltec.wxzj2.biz.system.entity.User;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 交款实现类
 * @ClassName: PaymentAction 
 * @author 重庆亚亮科技有限公司 txj 
 * @date 2016-8-1 下午03:44:38
 */
@Controller
public class PaymentAction {
	@Autowired
	private PaymentService paymentService;
	@Autowired
	private ReceiptInfoMService receiptInfoMService;

	/**
	 * 交款登记-连续业务缓存
	 */
	protected static Map<String, String> businessContinuityMap = new LinkedHashMap<String, String>();

	/**
	 * 跳转到首页
	 */
	@RequestMapping("/paymentregister/index")
	public String index(Model model) {
		model.addAttribute("communitys", DataHolder.communityMap);
		model.addAttribute("dataSources", DataHolder.getParameter("27"));//是否启用产权接口获取数据？
		return "/payment/paymentregister/index";
	}
	
	/**
	 * 查询交款登记列表
	 */
	@RequestMapping("/paymentregister/list")
	public void list(@RequestBody ReqPamars<PayToStore> req, HttpServletRequest request,
			HttpServletResponse response) throws IOException {	
		//获取查询条件
		Map<String, Object> paramMap = req.getParams();
		// 根据用户获取归集中心
		paramMap.put("unitcode",TokenHolder.getUser().getUnitcode());
		paramMap.put("result", "-1");
		//查询分页
		Page<PayToStore> page = new Page<PayToStore>(req.getEntity(), req.getPageNo(), req.getPageSize());
		paymentService.queryPaymentDJBS(page, paramMap);
		LogUtil.write(new Log("交款登记", "查询", "PaymentAction.list",paramMap.toString()));
		//返回数据
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 返回结果
		pw.print(page.toJson());
	}

	/**
	 * 跳转到新增交款登记页面
	 */
	@RequestMapping("/paymentregister/toAdd")
	public String addPaymentRegister(HttpServletRequest request, Model model,RedirectAttributes redirectAttributes) {
		User user=TokenHolder.getUser();
		String w008=request.getParameter("w008")==null?"":request.getParameter("w008");
		String tzlx="0";//跳转类型0：新增；1：双击
		if(w008.equals("")){			
			//新增进入，获取缓存中保存的业务编号
			if(businessContinuityMap.get(user.getUserid()) !=null){
				w008=businessContinuityMap.get(user.getUserid());
			}
		}else{
			//双击进入，更新缓存中的业务编号
			businessContinuityMap.put(user.getUserid(),w008);
			tzlx="1";
		}		
		model.addAttribute("communitys", DataHolder.communityMap);
		model.addAttribute("w008", w008);
		model.addAttribute("tzlx", tzlx);
		model.addAttribute("banks", DataHolder.dataMap.get("bank"));
		model.addAttribute("user", TokenHolder.getUser());
		model.addAttribute("assignment", DataHolder.dataMap.get("assignment"));
		return "/payment/paymentregister/add";
	}
	
	/**
	 * 清空连续业务编号
	 */
	@RequestMapping("/paymentregister/clear")
	public void clearBusinessContinuity(HttpServletRequest request,
			HttpServletResponse response)throws IOException {
		String result="0";
		User user=TokenHolder.getUser();
		//清空用户缓存的业务编号
		businessContinuityMap.put(user.getUserid(),"");
		if(businessContinuityMap.get(user.getUserid()).equals("")){
			result="1";
		}
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 返回结果
		pw.print(result);
	}
	
	/**
	 * 根据楼宇获取最近次交款的归集中心
	 * @param request
	 * @param response
	 * @throws IOException
	 */
	@RequestMapping("/paymentregister/getUnitcodeByLybh")
	public void getUnitcodeByLybh(HttpServletRequest request,
			HttpServletResponse response)throws IOException {
		Map<String, String> resultMap=paymentService.getUnitcodeByLybh(request.getParameter("lybh"));
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 返回结果
		pw.print(JsonUtil.toJson(resultMap));
	}
	

	/**
	 * 保存交款登记
	 */
	@RequestMapping("/paymentregister/add")
	public String add(HttpServletRequest request, PayToStore payToStore,
			Model model, RedirectAttributes redirectAttributes) {
		Map<String, String> paramMap = new HashMap<String, String>();
		paramMap.put("lybh", payToStore.getLybh());
		paramMap.put("h001", payToStore.getH001());
		paramMap.put("w001", payToStore.getW001());
		paramMap.put("w002", payToStore.getW002());
		paramMap.put("w003", payToStore.getW003());
		paramMap.put("w004", payToStore.getW004());
		paramMap.put("w011", payToStore.getW011());
		paramMap.put("posno", payToStore.getPosno());
		paramMap.put("yhbh", payToStore.getYhbh());
		paramMap.put("yhmc", DataHolder.dataMap.get("bank").get(payToStore.getYhbh()));
		User user=TokenHolder.getUser();
		paramMap.put("userid",user.getUserid());
		paramMap.put("username", user.getUsername());
		paramMap.put("w010", payToStore.getW010());
		paramMap.put("w008", payToStore.getW008());
		paramMap.put("serialno", payToStore.getSerialno());
		paramMap.put("result", "-1");
		int result = paymentService.add(paramMap);
		LogUtil.write(new Log("交款登记", "保存 ", "PaymentAction.add",paramMap.toString()));
		redirectAttributes.addFlashAttribute("xqbh",request.getParameter("xqbh") );
		redirectAttributes.addFlashAttribute("h001mc",request.getParameter("h001mc") );
		if (result == 0) {		
			redirectAttributes.addFlashAttribute("msg", "新增成功！");
			redirectAttributes.addFlashAttribute("h001", payToStore.getH001());
			redirectAttributes.addFlashAttribute("w003", payToStore.getW003());
			redirectAttributes.addFlashAttribute("returnUrl", "list");
			return "redirect:/paymentregister/index";
		}else if(result == 3  || result == 5 || result == 6){
			redirectAttributes.addFlashAttribute("msg", result);
			redirectAttributes.addFlashAttribute("payment",payToStore);
			return "redirect:/paymentregister/toAdd";
		}else {
			redirectAttributes.addFlashAttribute("msg", "新增失败！");
			redirectAttributes.addFlashAttribute("payment",payToStore);
			return "redirect:/paymentregister/toAdd";
		}
	}
	
	/**
	 * 获取系统参数
	 * @param request
	 * @param response
	 * @throws IOException
	 */
	@RequestMapping("/paymentregister/getSystemArg")
	public void getSystemArg(HttpServletRequest request,HttpServletResponse response)throws IOException{		
		//返回数据
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 返回结果
		pw.print(DataHolder.getParameter(request.getParameter("bm")));
	}
	
	/**
	 * 打印
	 * @param request
	 * @param payToStore
	 * @param model
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping("/paymentregister/toPrint")
	public void toPrint(HttpServletRequest request,HttpServletResponse response)throws IOException{
		//获取参数
		Map<String,String> paramMap = new HashMap<String, String>();
		paramMap.put("h001",request.getParameter("h001"));
		paramMap.put("jksj",request.getParameter("jksj"));
		paramMap.put("jkje",request.getParameter("jkje"));
		paramMap.put("w008",request.getParameter("w008"));
		paramMap.put("key",request.getParameter("key"));
		paramMap.put("pjh",request.getParameter("pjh"));
		paramMap.put("message","");//存放错误提示
		ByteArrayOutputStream ops=paymentService.toPrint(paramMap);
		LogUtil.write(new Log("交款登记", "打印", "PaymentAction.toPrint",paramMap.toString()));
		if(paramMap.get("message").equals("")){
			if(ops != null){
				paymentService.output(ops, response);
			}
		}else{
			PrintWriter out = null;
			response.setContentType("text/html;charset=utf-8");
			out = response.getWriter();
			out.print("<script language='javaScript'>alert('" + paramMap.get("message") + "');" + "self.close();</script>");
		}
	}
	
	/**
	 * 获取打印现金交款凭证的信息 
	 * @param request
	 * @param response
	 * @throws IOException
	 */
	@RequestMapping("/paymentregister/isGetCashPayment")
	public void isGetCashPayment(HttpServletRequest request,HttpServletResponse response)throws IOException{
		String h001=request.getParameter("h001");
		CashPayment cashPayment= paymentService.getCashPayment(h001);
		LogUtil.write(new Log("交款登记", "打印现金交款凭证的信息", "PaymentAction.isGetCashPayment",h001));
		h001=cashPayment.getH001();
		if(h001.equals("")){
			h001="0";
		}else{
			h001="1";
		}
		//返回数据
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 返回结果
		pw.print(h001);
	}
	
	/**
	 * 打印现金凭证
	 * @param request
	 * @param response
	 * @throws IOException
	 */
	@RequestMapping("/paymentregister/printpdfCashPayment")
	public void printpdfCashPayment(HttpServletRequest request,HttpServletResponse response)throws IOException{
		//获取参数
		Map<String,String> paramMap = new HashMap<String, String>();
		paramMap.put("h001",request.getParameter("h001"));		
		paramMap.put("message","");//存放错误提示
		ByteArrayOutputStream ops=paymentService.printpdfCashPayment(paramMap);
		LogUtil.write(new Log("交款登记", "打印现金交款凭证", "PaymentAction.printpdfCashPayment",paramMap.toString()));
		if(paramMap.get("message").equals("")){
			if(ops != null){
				paymentService.output(ops, response);
			}
		}else{
			PrintWriter out = null;
			response.setContentType("text/html;charset=utf-8");
			out = response.getWriter();
			out.print("<script language='javaScript'>alert('" + paramMap.get("message") + "');" + "self.close();</script>");
		}
	}
	
	/**
	 * 删除一条交款信息
	 * @param payToStore
	 * @param request
	 * @param model
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping("/paymentregister/delone")
	public void delone(HttpServletRequest request,HttpServletResponse response)throws IOException {
		Map<String, String> paramMap=new HashMap<String, String>();
		paramMap.put("w004", request.getParameter("w004"));
		paramMap.put("w008", request.getParameter("w008"));
		paramMap.put("serialno", request.getParameter("serialno"));
		paramMap.put("sf", request.getParameter("sf"));
		User user=TokenHolder.getUser();
		paramMap.put("userid", user.getUserid());
		paramMap.put("username", user.getUsername());
		paramMap.put("result", "-1");
		int result=paymentService.deleone(paramMap);
		LogUtil.write(new Log("交款登记", "删除", "PaymentAction.delone",paramMap.toString()));		
		//返回数据
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 返回结果
		pw.print(String.valueOf(result));
	}
	
	/**
	 * 打印通知书
	 * @param request
	 * @param model
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping("/paymentregister/toPrintTZS")
	public void printTZS(HttpServletRequest request,
			Model model,HttpServletResponse response) {
		//获取参数
		Map<String,String> paramMap = new HashMap<String, String>();
		paramMap.put("w008",request.getParameter("w008"));
		ByteArrayOutputStream ops=paymentService.paymentRegTZS(paramMap);
		LogUtil.write(new Log("交款登记", "打印通知书", "PaymentAction.printTZS",paramMap.toString()));
		if(ops != null){
			paymentService.output(ops, response);
		}
	}
	
	/**
	 * 打印通知书明细
	 * @param request
	 * @param model
	 * @param response
	 */
	@RequestMapping("/paymentregister/toPrintTZSMX")
	public void printTZSMX(HttpServletRequest request,
			Model model,HttpServletResponse response) {
		//获取参数
		Map<String,String> paramMap = new HashMap<String, String>();
		paramMap.put("w008",request.getParameter("w008"));
		ByteArrayOutputStream ops=paymentService.paymentRegTZSMX(paramMap);
		LogUtil.write(new Log("交款登记", " 打印通知书明细", "PaymentAction.printTZSMX",paramMap.toString()));
		if(ops != null){
			paymentService.output(ops, response);
		}
	}
	
	/**
	 * 获取该笔业务的数量
	 * @param request
	 * @param response
	 * @throws IOException
	 */
	@RequestMapping("/paymentregister/getNumByW008")
	public void getNumByW008(HttpServletRequest request,HttpServletResponse response)throws IOException {		
		int result=paymentService.getNumByW008(request.getParameter("w008"));
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 返回结果
		pw.print(String.valueOf(result));
	}
	
	/**
	 * 判断缴款的房屋是否还有其它缴款信息
	 * @param request
	 * @param response
	 * @throws IOException
	 */
	@RequestMapping("/paymentregister/getOtherPayNumByH001")
	public void getOtherPayNumByH001(HttpServletRequest request,HttpServletResponse response)throws IOException {		
		String result="0"; 
		//获取参数
		Map<String,String> paramMap = new HashMap<String, String>();		
		paramMap.put("w008", request.getParameter("w008"));
		paramMap.put("serialno", request.getParameter("serialno"));
		//获取房屋交款的总条数
		int num_h001=paymentService.getPayNumByH001(paramMap);
		//为空判断业务数量与房屋数量
		if(paramMap.get("serialno").toString().equals("")){
			// 获取该笔业务的数量
			int num_w008=paymentService.getNumByW008(request.getParameter("w008"));
			if(num_h001>num_w008){
				result="1";
			}
		}else{
			if(num_h001>1){
				result="1";
			}
		}
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 返回结果
		pw.print(result);
	}	
	
	
	/**
	 * 根据业务编号删除交款信息
	 * @param request
	 * @param model
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping("/paymentregister/delByW008")
	public void delByW008(HttpServletRequest request,HttpServletResponse response)throws IOException{
		//获取参数
		Map<String, String> paramMap=new HashMap<String, String>();
		paramMap.put("w008", request.getParameter("w008"));
		paramMap.put("sf", request.getParameter("sf"));
		User user=TokenHolder.getUser();
		paramMap.put("userid", user.getUserid());
		paramMap.put("username", user.getUsername());
		paramMap.put("result", "-1");
		//调用service的delByW008方法
		int result=paymentService.delByW008(paramMap);
		LogUtil.write(new Log("交款登记", "根据业务编号删除交款信息", "PaymentAction.delByW008",paramMap.toString()));
		//返回数据
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 返回结果
		pw.print(String.valueOf(result));
	}
	
	/**
	 * 修改交款pos号
	 * @param request
	 * @param payToStore
	 * @param model
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping("/paymentregister/editPosh")
	public void eidtPoshPaymentReg(HttpServletRequest request,PayToStore payToStore,
			Model model,HttpServletResponse response) throws IOException {
		//获取参数
		Map<String, String> paramMap=new HashMap<String, String>();
		paramMap.put("h001", payToStore.getH001());
		paramMap.put("w003", payToStore.getW003());
		paramMap.put("w004", payToStore.getW004());
		paramMap.put("w008", payToStore.getW008());
		paramMap.put("posno", payToStore.getPosno());
		paramMap.put("result", "-1");
		int result = paymentService.eidtPoshPaymentReg(paramMap);
		LogUtil.write(new Log("交款登记", "修改交款pos号", "PaymentAction.eidtPoshPaymentReg",paramMap.toString()));
		//返回数据
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 返回结果
		pw.print(result);
	}
	
	/**
	 * 获取用户在指定银行未使用的最小票据号
	 * @param request
	 * @param payToStore
	 * @param model
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping("/paymentregister/getPJH")
	public void getPJH(HttpServletRequest request,
			Model model,HttpServletResponse response)throws IOException {		
		//获取参数
		Map<String, String> paramMap=new HashMap<String, String>();	
		User user=TokenHolder.getUser();		
		paramMap.put("yhbh", user.getBankId());
		paramMap.put("userid", user.getUserid());
		String billNo = receiptInfoMService.getNextBillNo(paramMap);
		LogUtil.write(new Log("交款登记", "获取用户在指定银行未使用的最小票据号", "PaymentAction.getPJH",paramMap.toString()));
		//返回数据
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		pw.print(JsonUtil.toJson(billNo));
	}
	
	/**
	 * 修改交款票据号
	 * @param request
	 * @param payToStore
	 * @param model
	 * @param redirectAttributes
	 */
	@RequestMapping("/paymentregister/editW011")
	public void eidtPJPaymentReg(HttpServletRequest request,
			Model model,HttpServletResponse response)throws IOException {
		//获取参数
		Map<String, String> paramMap=new HashMap<String, String>();		
		paramMap.put("h001", request.getParameter("h001"));
		paramMap.put("w008", request.getParameter("w008"));
		paramMap.put("w013", request.getParameter("w003"));
		paramMap.put("w011", request.getParameter("w011"));
		paramMap.put("fingerprintData","");
		paramMap.put("regNo","");		
		User user=TokenHolder.getUser();
		paramMap.put("username", user.getUsername());
		paramMap.put("result", "-1");		
		String h001 = paramMap.get("h001").toString();
		String w011 = paramMap.get("w011").toString();
		String fingerprintData = buildFingerprintData(h001, w011);
		paramMap.put("fingerprintData", fingerprintData);
		String regNo=receiptInfoMService.getRegNoByBillNo(paramMap.get("w011"));
		paramMap.put("regNo", regNo);
		int result = paymentService.eidtPJPaymentReg(paramMap);
		LogUtil.write(new Log("交款登记", "修改交款票据号", "PaymentAction.eidtPJPaymentReg",paramMap.toString()));
		//返回数据
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		pw.print(result);
	}
	
	/**
	 * 根据房屋编号、票据号生成18位数字指纹
	 * @param h001
	 * @param w011
	 * @return
	 */
	public static String buildFingerprintData(String h001, String w011) {
		String fingerprintData = h001 + w011;
		//fingerprintData = MD5.getMD5Str(fingerprintData);
		fingerprintData = fingerprintData.substring(14).toUpperCase();
		return fingerprintData;
	}
}

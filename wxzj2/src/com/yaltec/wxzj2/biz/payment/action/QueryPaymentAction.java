package com.yaltec.wxzj2.biz.payment.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
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

import com.yaltec.comon.auth.TokenHolder;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.comon.core.entity.ReqPamars;
import com.yaltec.comon.log.LogUtil;
import com.yaltec.comon.log.entity.Log;
import com.yaltec.comon.utils.StringUtil;
import com.yaltec.comon.utils.Urlencryption;
import com.yaltec.wxzj2.biz.bill.action.ReceiptInfoMAction;
import com.yaltec.wxzj2.biz.draw.service.export.NormalExport;
import com.yaltec.wxzj2.biz.payment.entity.QueryPayment;
import com.yaltec.wxzj2.biz.payment.service.QueryPaymentService;
import com.yaltec.wxzj2.biz.payment.service.print.QueryPaymentBDPDF;
import com.yaltec.wxzj2.biz.payment.service.print.QueryPaymentListPDF;
import com.yaltec.wxzj2.biz.payment.service.print.QueryPaymentSDPDF;
import com.yaltec.wxzj2.biz.payment.service.print.QueryPaymentSDPDF2;
import com.yaltec.wxzj2.biz.property.entity.House;
import com.yaltec.wxzj2.biz.property.service.HouseService;
import com.yaltec.wxzj2.biz.system.entity.PrintSet;
import com.yaltec.wxzj2.biz.system.entity.User;
import com.yaltec.wxzj2.biz.system.service.PrintConfigService;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 
 * @ClassName: QueryPaymentAction
 * @Description: 交款查询action
 * 
 * @author jiangyong
 * @date 2016-8-18 上午10:04:38
 */
@Controller
public class QueryPaymentAction {

	@Autowired
	private QueryPaymentService queryPaymentService;
	@Autowired
	private PrintConfigService printConfigService;
	@Autowired
	private HouseService houseService;

	/**
	 * 跳转到交款查询首页
	 * 
	 * @return 跳转的JSP页面
	 */
	@RequestMapping("/querypayment/index")
	public String index(Model model) {
		model.addAttribute("assignment", DataHolder.dataMap.get("assignment"));
		model.addAttribute("projects", DataHolder.dataMap.get("project"));
		model.addAttribute("communitys", DataHolder.communityMap);
		model.addAttribute("user", TokenHolder.getUser());
		// 跳转的JSP页面
		return "/payment/querypayment/index";
	}

	/**
	 * 查询交款信息
	 * 
	 */
	@RequestMapping("/querypayment/list")
	public void list(@RequestBody ReqPamars<QueryPayment> req,
			HttpServletRequest request, HttpServletResponse response)
			throws IOException {
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();

		Map<String, Object> map = req.getParams();
		map.put("sysUser", "");
		map.put("result", "");
		System.out.println(map);
		LogUtil.write(new Log("交款查询", "查询", "QueryPaymentAction.list", map
				.toString()));
		Page<QueryPayment> page = new Page<QueryPayment>(null, req.getPageNo(),
				req.getPageSize());
		queryPaymentService.findAll(page, map);
		// 返回结果
		pw.print(page.toJson());
	}

	/**
	 * 单笔打印交款收据
	 */
	@RequestMapping("/querypayment/singlePrint")
	public ModelAndView singlePrint(HttpServletRequest request,
			HttpServletResponse response) {
		String h001 = request.getParameter("h001");
		String jksj = request.getParameter("jksj");// 交款日期
		String jkje = request.getParameter("jkje");// 交款金额
		String w008 = request.getParameter("w008");// 业务编号
		String pjh = request.getParameter("pjh");// 票据号
		String bankName = Urlencryption.unescape(request
				.getParameter("bankName"));// 银行名称
		// 根据房屋编号、票据号生成数字指纹，不用再从数据库中取值
		String key = ReceiptInfoMAction.buildFingerprintData(h001, pjh);// 数字指纹
		// 获取当前操作用户
		User user = TokenHolder.getUser();
		// 获取用户对于的打印配置
		String printSetName = "";
		if (user.getPrintSet() != null) {
			printSetName = user.getPrintSet().getXmlname1();
		}
		// 根据房屋编号获取房屋信息
		House house = houseService.findByH001ForPDF(h001);
		// 根据房屋编号获取利息
		QueryPayment queryPayment = queryPaymentService.getW005(h001, w008);
		String w005 = queryPayment.getW005() == 0?"0.00": String.valueOf(queryPayment.getW005());
		// 传参容器
		Map<String, Object> map = new HashMap<String, Object>();
		// 用户的打印配置
		Map<String, PrintSet> printConfig = printConfigService
				.get(printSetName);
		map.put("printConfig", printConfig);
		map.put("house", house);
		house.setXqmc(DataHolder.buildingMap.get(house.getLybh()).getXqmc());
		map.put("jksj", jksj);
		map.put("jkje", jkje);
		map.put("key", key);
		map.put("pjh", pjh);
		map.put("w005", w005);
		map.put("user", user);
		map.put("bankName", bankName);
		QueryPaymentSDPDF view = new QueryPaymentSDPDF();
		// 设置参数
		view.setAttributesMap(map);
		LogUtil.write(new Log("交款查询", "单笔打印交款收据",
				"QueryPaymentAction.singlePrint", map.toString()));
		// 返回视图
		return new ModelAndView(view);
	}

	/**
	 * 判断当前业务是否交款 type：0房屋编号，1业务编号
	 */
	@RequestMapping("/querypayment/isPayIn")
	public void isPayIn(HttpServletRequest request, HttpServletResponse response)
			throws IOException {
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		Map<String, String> map = new HashMap<String, String>();
		// type：0房屋编号，1业务编号；id：编号
		String type = request.getParameter("type");
		String id = request.getParameter("id");
		if (type.equals("0")) {
			map.put("w008", id);
		} else {
			String h001s = "'" + id.replaceAll(",", "','") + "'";
			map.put("h001s", h001s);
		}
		boolean result = queryPaymentService.isPayIn(type, map);
		LogUtil.write(new Log("交款查询", "判断当前业务是否交款",
				"QueryPaymentAction.isPayIn", type + "|" + map.toString()));
		// 返回结果
		pw.print(result);
	}

	/**
	 * 批量打印交款收据
	 */
	@RequestMapping("/querypayment/batchPrint")
	public ModelAndView batchPrint(HttpServletRequest request,
			HttpServletResponse response) {
		String h001s = request.getParameter("h001s");
		String jksjs = request.getParameter("jksjs");// 交款日期
		String jkjes = request.getParameter("jkjes");// 交款金额
		String w008s = request.getParameter("w008s");// 业务编号
		// (0：批量交款打印，票据号为起始票据号，其他票据号需要生成；1：批量补打，传递了票据号拼接字符串)
		String type = request.getParameter("type");
		String pjhs = request.getParameter("pjhs");// 票据号

		LogUtil.write(new Log("交款查询", "批量打印交款收据",
				"QueryPaymentAction.batchPrint", h001s + "|" + jksjs + "|" + jkjes + "|" + type + "|" + pjhs));
		
		String bankName = "";// 银行名称
		try {
			if (StringUtil.hasLength(request.getParameter("bankName"))) {
				bankName = Urlencryption.unescape(request.getParameter("bankName"));
			}
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("银行名称传入错误");
		}
		
		String[] h001 = h001s.split(",");
		String[] w008 = w008s.split(",");
		String[] jksj = jksjs.split(",");
		String[] jkje = jkjes.split(",");
		String[] pjh = new String[h001.length];
		String[] key = new String[h001.length];
		List<String> w005List = new ArrayList<String>();
		List<House> listHouse = new ArrayList<House>();
		if (type.equals("0") && pjhs.indexOf(",") < 0) {
			for (int i = 0; i < h001.length; i++) {
				// 获取利息、票据号
				QueryPayment queryPayment = queryPaymentService.getW005(h001[i], w008[i]);
				
				// 票据号
				pjh[i] = queryPayment.getW011();
				// 根据房屋编号、票据号生成数字指纹，不用再从数据库中取值
				key[i] = ReceiptInfoMAction.buildFingerprintData(h001[i], pjh[i]);
				House house = houseService.findByH001ForPDF(h001[i]);
				
				house.setXqmc(DataHolder.buildingMap.get(house.getLybh()).getXqmc());
				listHouse.add(house);
				// 利息
				w005List.add(queryPayment.getW005() == 0?"0.00": String.valueOf(queryPayment.getW005()));
			}
		} else {
			pjh = pjhs.split(",");
			for (int i = 0; i < h001.length; i++) {
				// 根据房屋编号、票据号生成数字指纹，不用再从数据库中取值
				key[i] = ReceiptInfoMAction.buildFingerprintData(h001[i],
						pjh[i]);
				House house = houseService.findByH001ForPDF(h001[i]);
				house.setXqmc(DataHolder.buildingMap.get(house.getLybh()).getXqmc());
				listHouse.add(house);
				// 根据房屋编号获取利息
				QueryPayment queryPayment = queryPaymentService.getW005(h001[i], w008[i]);
				w005List.add(queryPayment.getW005() == 0?"0.00": String.valueOf(queryPayment.getW005()));
			}
		}
		// 获取当前操作用户
		User user = TokenHolder.getUser();
		// 获取用户对于的打印配置
		String printSetName = "";
		if (user.getPrintSet() != null) {
			printSetName = user.getPrintSet().getXmlname1();
		}
		// 传参容器
		Map<String, Object> map = new HashMap<String, Object>();
		// 用户的打印配置
		Map<String, PrintSet> printConfig = printConfigService
				.get(printSetName);
		map.put("printConfig", printConfig);
		map.put("listHouse", listHouse);
		map.put("jksj", jksj);
		map.put("jkje", jkje);
		map.put("key", key);
		map.put("pjh", pjh);
		map.put("w005", w005List);
		map.put("user", user);
		map.put("bankName", bankName);

		QueryPaymentBDPDF view = new QueryPaymentBDPDF();
		// 设置参数
		view.setAttributesMap(map);
		// 返回视图
		return new ModelAndView(view);
	}

	/**
	 * 交款查询-打印清册
	 */
	@RequestMapping("/querypayment/listPrint")
	public ModelAndView listPrint(HttpServletRequest request,
			HttpServletResponse response) {
		// 查询条件
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("begindate", request.getParameter("begindate"));
		paramMap.put("enddate", request.getParameter("enddate"));
		paramMap.put("xmbh", request.getParameter("xmbh"));
		paramMap.put("xqbh", request.getParameter("xqbh"));
		paramMap.put("lybh", request.getParameter("lybh"));
		paramMap.put("item", request.getParameter("item"));
		paramMap.put("h001", request.getParameter("h001"));
		paramMap.put("w012", request.getParameter("w012"));
		paramMap.put("unitcode", request.getParameter("unitcode"));
		paramMap.put("sfdy", request.getParameter("sfdy"));
		paramMap.put("cxlb", request.getParameter("cxlb"));
		paramMap.put("w008", request.getParameter("w008"));
		paramMap.put("jw008", request.getParameter("jw008"));
		paramMap.put("qserialno", request.getParameter("qserialno"));
		paramMap.put("jserialno", request.getParameter("jserialno"));
		paramMap.put("sfrz", request.getParameter("sfrz"));
		paramMap.put("sysUser", TokenHolder.getUser().getUsername());
		paramMap.put("result", "");
		LogUtil.write(new Log(" 交款查询", "打印清册", "QueryPaymentAction.listPrint",
				paramMap.toString()));
		List<QueryPayment> list = queryPaymentService.findAll(paramMap);

		System.out.println(paramMap);
		// 传参容器
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("list", list);
		QueryPaymentListPDF view = new QueryPaymentListPDF();
		// 设置参数
		view.setAttributesMap(map);
		// 返回视图
		return new ModelAndView(view);
	}

	/**
	 * 打印交款收据（非套打）
	 * 
	 * @throws Exception
	 */
	@RequestMapping("/querypayment/singlePrint2")
	public ModelAndView singlePrint2(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String h001 = request.getParameter("h001");
		String jksj = request.getParameter("jksj");// 交款日期
		String jkje = request.getParameter("jkje");// 交款金额
		// String w008 = request.getParameter("w008");// 业务编号
		// 获取当前操作用户
		String username = TokenHolder.getUser().getUsername();
		// 根据房屋编号获取房屋信息
		House house = houseService.findByH001ForPDF(h001);
		// 传参容器
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("house", house);
		map.put("jksj", jksj);
		map.put("jkje", jkje);
		// map.put("w008", w008);
		map.put("username", username);
		LogUtil.write(new Log("交款查询", "单笔打印交款收据(非套打)",
				"QueryPaymentAction.singlePrint2", map.toString()));
		QueryPaymentSDPDF2 view = new QueryPaymentSDPDF2();
		// 设置参数
		view.setAttributesMap(map);
		// 返回视图
		return new ModelAndView(view);
	}

	/**
	 * 交款查询导出
	 * @throws Exception
	 */
	@RequestMapping("/querypayment/exportExcel")
	public void exportExcel(HttpServletRequest request,HttpServletResponse response) {
		response.setCharacterEncoding("utf-8");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("begindate", request.getParameter("begindate"));
		map.put("enddate", request.getParameter("enddate"));
		map.put("xmbh", request.getParameter("xmbh"));
		map.put("xqbh", request.getParameter("xqbh"));
		map.put("lybh", request.getParameter("lybh"));
		map.put("item", request.getParameter("item"));
		map.put("h001", request.getParameter("h001"));
		map.put("w012", request.getParameter("w012"));
		map.put("unitcode", request.getParameter("unitcode"));
		map.put("sfdy", request.getParameter("sfdy"));
		map.put("cxlb", request.getParameter("cxlb"));
		map.put("w008", request.getParameter("w008"));
		map.put("jw008", request.getParameter("jw008"));
		map.put("qserialno", request.getParameter("qserialno"));
		map.put("jserialno", request.getParameter("jserialno"));
		map.put("sfrz", request.getParameter("sfrz"));
		map.put("sysUser", TokenHolder.getUser().getUsername());
		map.put("result", "");
		// 添加操作日志
		LogUtil.write(new Log(" 交款查询", "导出清册", "QueryPaymentAction.exportExcel",
				map.toString()));
		String title = "缴款信息";
		String[] ZHT = { "房屋编号", "业主姓名", "交款金额", "交款日期","面积","业务编号","流水号","票据号","收款银行","房屋地址"};
		String[] ENT = { "h001", "w012", "w006", "w014","mj","w008","serialno","w011","yhmc","dz"};// 输出例
		List<Map<String,String>> list = null;
		try {
			list = queryPaymentService.findDataToExport(map);
			if (list.size() == 0) {
				NormalExport.exeException("获取数据失败！",response);
				return;
			}
			NormalExport.export(response, list, title, ZHT, ENT);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}

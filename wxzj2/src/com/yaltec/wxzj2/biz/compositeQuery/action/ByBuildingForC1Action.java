package com.yaltec.wxzj2.biz.compositeQuery.action;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletRequest;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.yaltec.comon.auth.TokenHolder;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.comon.core.entity.ReqPamars;
import com.yaltec.comon.log.LogUtil;
import com.yaltec.comon.log.entity.Log;
import com.yaltec.comon.utils.DateUtil;
import com.yaltec.wxzj2.biz.compositeQuery.entity.ByBuildingForC1;
import com.yaltec.wxzj2.biz.compositeQuery.service.ByBuildingForC1Service;
import com.yaltec.wxzj2.biz.compositeQuery.service.export.DataExport;
import com.yaltec.wxzj2.biz.compositeQuery.service.print.ByBuildingForC1PDF;
import com.yaltec.wxzj2.biz.payment.service.PaymentService;
import com.yaltec.wxzj2.biz.payment.service.print.PaymentRegPDF;
import com.yaltec.wxzj2.biz.property.entity.House;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 
 * @ClassName: ByBuildingForC1Action
 * @Description: TODO分户台账查询实现类
 * 
 * @author moqian
 * @date 2016-8-2 下午14:12:03
 */

@Controller
public class ByBuildingForC1Action {

	@Autowired
	private ByBuildingForC1Service byBuildingForC1Service;

	@Autowired
	private PaymentService paymentService;

	/**
	 * 查询分户台账信息列表
	 * 
	 * @param house
	 */
	@RequestMapping("/byBuildingForC1/index")
	public String index(Model model) {
		model.addAttribute("communitys", DataHolder.communityMap);
		model.addAttribute("lymc", DataHolder.buildingMap);
		return "/compositeQuery/byBuildingForC1/index";
	}

	/**
	 * 弹出选择打印金额页面
	 * 
	 * @param house
	 */
	@RequestMapping("/byBuildingForC1/open/choosePrint")
	public String choosePrint(Model model) {
		return "/compositeQuery/byBuildingForC1/choosePrint";
	}

	/**
	 * 查询分户台账信息列表
	 * 
	 * @param request
	 */
	@RequestMapping("/byBuildingForC1/list")
	public void list(@RequestBody ReqPamars<ByBuildingForC1> req,
			HttpServletRequest request, HttpServletResponse response)
			throws IOException {
		// 添加操作日志
		LogUtil.write(new Log("分户台账", "查询", "ByBuildingForC1Action.list", req
				.toString()));
		// 获取查询条件
		Map<String, Object> paramMap = req.getParams();
		if (paramMap.get("enddate").toString().equals("")) {
			paramMap.put("enddate", DateUtil.getCurrTime(DateUtil.ZH_CN_DATE));
		}
		paramMap.put("result", "-1");
		Page<ByBuildingForC1> page = new Page<ByBuildingForC1>(req.getEntity(),
				req.getPageNo(), req.getPageSize());
		byBuildingForC1Service.queryByBuildingForC1(page, paramMap);
		// 返回数据
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 返回结果
		pw.print(page.toJson());
	}

	/**
	 *分户台账打印
	 * 
	 * @param h001
	 * 
	 * */
	@RequestMapping("/byBuildingForC1/pdfByBuildingForC1")
	public ModelAndView print(RedirectAttributes redirectAttributes,
			ServletRequest request, String h001, HttpServletResponse response) {
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("h001", request.getParameter("h001"));
		paramMap.put("begindate", request.getParameter("begindate"));
		paramMap.put("enddate", request.getParameter("enddate"));
		paramMap.put("pzsh", request.getParameter("pzsh"));
		paramMap.put("cxlb", request.getParameter("cxlb"));
		String items = request.getParameter("items");
		// 添加操作日志
		LogUtil.write(new Log("分户台账", "打印", "ByBuildingForC1Action.print",
				paramMap.toString()));
		List<ByBuildingForC1> resultList = byBuildingForC1Service
				.queryByBuildingForC1(paramMap);
		House house = byBuildingForC1Service.findByH001(h001);

		// 传参容器
		paramMap.clear();
		paramMap.put("list", resultList);
		paramMap.put("house", house);
		paramMap.put("items", items);
		ByBuildingForC1PDF view = new ByBuildingForC1PDF();
		// 设置参数
		view.setAttributesMap(paramMap);
		// 返回视图
		return new ModelAndView(view);
	}

	/**
	 * 分户台账打印：物业专项维修资金交存证明
	 * */
	@RequestMapping("/byBuildingForC1/pdfPaymentProve")
	public ByteArrayOutputStream pdfPaymentProve(
			RedirectAttributes redirectAttributes, ServletRequest request,
			HttpServletResponse response) {
		ByteArrayOutputStream ops = null;
		House result = null;
		String username = TokenHolder.getUser().getUsername();
		String h001 = request.getParameter("h001");
		// 添加操作日志
		LogUtil.write(new Log("分户台账", "打印物业专项维修资金交存证明",
				"ByBuildingForC1Action.pdfPaymentProve", h001.toString()));
		try {
			result = byBuildingForC1Service.pdfPaymentProve(h001);
			if (result == null) {
				redirectAttributes.addFlashAttribute("msg", "未查到对应的缴款信息！");
				return null;
			}
			String jksj = result.getH020();// 交款日期
			String jkje = result.getH039();// 交款金额
			String w008 = "";// 业务编号
			PaymentRegPDF pdf = new PaymentRegPDF();
			if (DataHolder.customerInfo.isJJ() && username.equals("系统管理")) {
				// 江津 管理员 非套打
				ops = pdf.creatPDFFixed_JJ(result, jksj, jkje, w008, username,
						"重庆市江津区物业专项维修资金缴存证明");
			} else {
				ops = pdf.creatPDFFixed_JJ(result, jksj, jkje, w008, username,
						"物业专项维修资金交存证明");
			}
		} catch (Exception e) {
			e.printStackTrace();
			redirectAttributes.addFlashAttribute("msg", "生成PDF文件发生错误！");
			return null;
		}
		if (ops != null) {
			paymentService.output(ops, response);
		}
		return ops;
	}

	/**
	 *分户台账的导出数据
	 */
	@RequestMapping("/byBuildingForC1/exportByBuildingForC1")
	public void export(HttpServletRequest request, HttpServletResponse response) {
		try {
			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("h001", request.getParameter("h001"));
			paramMap.put("begindate", request.getParameter("begindate"));
			paramMap.put("enddate", request.getParameter("enddate"));
			paramMap.put("pzsh", request.getParameter("pzsh"));
			paramMap.put("cxlb", request.getParameter("cxlb"));
			String items = request.getParameter("items");
			
			House house = byBuildingForC1Service.findByH001(request.getParameter("h001"));
			// 添加操作日志
			LogUtil.write(new Log("分户台账", "导出", "ByBuildingForC1Action.export",
					paramMap.toString()));
			List<ByBuildingForC1> resultList = byBuildingForC1Service
					.queryByBuildingForC1(paramMap);

			DataExport.exportByBuildingForC1(resultList, response, items, house);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}

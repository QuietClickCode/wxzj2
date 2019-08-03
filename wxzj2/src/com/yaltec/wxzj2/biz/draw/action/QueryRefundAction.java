package com.yaltec.wxzj2.biz.draw.action;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
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
import com.yaltec.comon.utils.JsonUtil;
import com.yaltec.comon.utils.ObjectUtil;
import com.yaltec.wxzj2.biz.compositeQuery.service.print.QueryBuildingCallPrint;
import com.yaltec.wxzj2.biz.draw.entity.Refund;
import com.yaltec.wxzj2.biz.draw.service.RefundService;
import com.yaltec.wxzj2.biz.draw.service.print.NormalPrintPDF;
import com.yaltec.wxzj2.biz.draw.service.print.QueryRefundPDF;
import com.yaltec.wxzj2.biz.draw.service.print.QueryRefundPrint;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 
 * @ClassName: QueryRefundAction
 * @Description: TODO 退款查询实现类
 * 
 * @author yangshanping
 * @date 2016-8-2 下午03:46:13
 */
@Controller
public class QueryRefundAction {

	@Autowired
	private RefundService refundService;
	/**
	 * 日志记录器.
	 */
	private static final Logger logger = Logger.getLogger("RefundPrint");

	/**
	 * 跳转到首页
	 */
	@RequestMapping("/queryRefund/index")
	public String index(Model model) {
		model.addAttribute("communitys", DataHolder.communityMap);
		return "/draw/queryrefund/index";
	}

	/**
	 * 查询退款信息
	 */
	@RequestMapping("/queryRefund/list")
	public void find(@RequestBody ReqPamars<Refund> req, HttpServletRequest request, HttpServletResponse response)
			throws IOException {
		// 添加操作日志
		LogUtil.write(new Log("退款查询", "查询", "QueryRefundAction.list", req.toString()));
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 获取页面传入的查询条件，并存入map集合
		Map<String, Object> paramMap = req.getParams();
		paramMap.put("result", "");

		Page<Refund> page = new Page<Refund>(req.getEntity(), req.getPageNo(), req.getPageSize());
		refundService.find(page, paramMap);
		// 返回结果
		pw.print(page.toJson());
	}

	/**
	 * 退款打印清册
	 */
	@RequestMapping("/queryRefund/printPdfQCRefund")
	public ModelAndView printPdfQCRefund(HttpServletRequest request, HttpServletResponse response,
			RedirectAttributes redirectAttributes) {
		// 获取页面传入的参数，并以逗号(,)分割，存入数组中
		String paras = request.getParameter("str");
		// 添加操作日志
		LogUtil.write(new Log("退款查询", "打印清册", "QueryRefundAction.printPdfQCRefund", paras));
		String[] strs = paras.split(",");
		List<Refund> resultList = null;
		try {
			// 获取页面传入的查询条件，并存入map集合
			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("xqbh", strs[0]);
			paramMap.put("lybh", strs[1]);
			paramMap.put("enddate", strs[3]);
			paramMap.put("begindate", strs[2]);
			paramMap.put("username", strs[4]);
			paramMap.put("sfsh", strs[5]);
			// 获取要打印信息
			resultList = refundService.find(paramMap);
			if (resultList.size() == 0) {
				redirectAttributes.addFlashAttribute("msg", "获取数据失败！");
				return null;
			}
			// 传参容器
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("list", resultList);
			QueryRefundPrint view = new QueryRefundPrint();
			// 设置参数
			view.setAttributesMap(map);
			// 返回视图
			return new ModelAndView(view);
		} catch (Exception e) {
			e.printStackTrace();
			redirectAttributes.addFlashAttribute("msg", "生成PDF文件发生错误！");
			return null;
		}
	}

	/**
	 * 业主退款打印
	 */
	@RequestMapping("/queryRefund/printPdfRefund")
	public ByteArrayOutputStream printPdfRefund(Refund refund, HttpServletRequest request, HttpServletResponse response,
			RedirectAttributes redirectAttributes) {
		ByteArrayOutputStream ops = null;
		List<Refund> result = null;
		String z008 = request.getParameter("z008");
		if (ObjectUtil.isEmpty(z008)) {
			redirectAttributes.addFlashAttribute("msg", "数据传输发生错误！");
		}
		refund.setZ008(z008);
		// 添加操作日志
		LogUtil.write(new Log("退款查询", "退款打印", "QueryRefundAction.printPdfRefund", z008));
		try {
			// 获取业主退款打印的信息
			result = refundService.pdfQueryRefund(refund);
			// 没有查询到数据则到历史表中查询
			if (result == null) {
				result = refundService.pdfQueryRefund_LS(refund);
			}
			QueryRefundPDF pdf = new QueryRefundPDF();
			String title = "物业专项维修资金退款通知书";
			if (result.size() > 1) {
				ops = pdf.creatPDFMany(result, title);
			} else {
				ops = pdf.creatPDF(result.get(0), title);
			}
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e.getMessage());
			redirectAttributes.addFlashAttribute("msg", "生成PDF文件发生错误！");
			return null;
		}
		if (ops != null) {
			refundService.output(ops, response);
		}
		return ops;
	}

	/**
	 * 删除业主退款
	 * 
	 * @throws Exception
	 */
	@RequestMapping("/queryRefund/delRefund")
	public String delete(String p004, String h001, HttpServletResponse response, RedirectAttributes redirectAttributes)
			throws Exception {
		// 添加操作日志
		LogUtil.write(new Log("退款查询", "删除", "QueryRefundAction.delRefund", p004 + "," + h001));
		String userid = TokenHolder.getUser().getUserid();
		String username = TokenHolder.getUser().getUsername();
		int result = Integer.valueOf(refundService.delRefund(p004, h001, userid, username));
		if (result >= 1) {
			redirectAttributes.addFlashAttribute("msg", "删除成功！");
		} else if (result == -5) {
			redirectAttributes.addFlashAttribute("msg", "操作员只能删除自己的业务，请检查！");
		} else if (result == -1) {
			redirectAttributes.addFlashAttribute("msg", "已经审核的业务不能删除！");
		} else {
			redirectAttributes.addFlashAttribute("msg", "删除失败，请稍候重试！");
		}
		return "redirect:/queryRefund/index";
	}

}

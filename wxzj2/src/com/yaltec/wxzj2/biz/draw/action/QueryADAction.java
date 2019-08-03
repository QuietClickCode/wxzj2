package com.yaltec.wxzj2.biz.draw.action;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

import com.yaltec.comon.auth.TokenHolder;
import com.yaltec.comon.core.entity.ReqPamars;
import com.yaltec.comon.log.LogUtil;
import com.yaltec.comon.log.entity.Log;
import com.yaltec.comon.utils.DateUtil;
import com.yaltec.comon.utils.JsonUtil;
import com.yaltec.comon.utils.Urlencryption;
import com.yaltec.wxzj2.biz.draw.entity.ApplyDraw;
import com.yaltec.wxzj2.biz.draw.service.DrawService;
import com.yaltec.wxzj2.biz.draw.service.QueryADService;
import com.yaltec.wxzj2.biz.draw.service.ShareADService;
import com.yaltec.wxzj2.biz.draw.service.TransferADService;
import com.yaltec.wxzj2.biz.draw.service.export.NormalExport;
import com.yaltec.wxzj2.biz.draw.service.print.NormalPrintPDF;
import com.yaltec.wxzj2.biz.draw.service.print.QueryADPDF;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 支取查询
 * 
 * @author 亚亮科技有限公司.YL
 * 
 * @version: 2016-9-9 上午09:13:43
 */
@Controller
public class QueryADAction {
	/**
	 * 日志记录器.
	 */
	private static final Logger logger = Logger.getLogger("QueryADAction");
	@Autowired
	private DrawService drawService;
	@Autowired
	private ShareADService shareADService;
	@Autowired
	private TransferADService transferADService;
	@Autowired
	private QueryADService queryADService;

	// 异常提示
	public void exeException(String message, HttpServletResponse response) {
		PrintWriter out = null;
		try {
			response.setContentType("text/html;charset=utf-8");
			out = response.getWriter();
			out.print("<script language='javaScript'>alert('" + message + "');"
					+ "self.close();</script>");
		} catch (Exception e) {
			logger.error(e.getMessage());
		} finally {
			out.flush();
			out.close();
		}
	}

	// 输出PDF
	public void output(ByteArrayOutputStream ops, HttpServletResponse response) {
		response.setContentType("application/pdf");

		// response.setHeader("Content-disposition","attachment; filename="+"report.pdf"
		// );
		response.setHeader("Cache-Control",
				"must-revalidate, post-check=0, pre-check=0");
		response.setHeader("Pragma", "public");
		response.setDateHeader("Expires", (System.currentTimeMillis() + 1000));

		response.setContentLength(ops.size());
		ServletOutputStream out = null;
		try {
			out = response.getOutputStream();
			ops.writeTo(out);
		} catch (IOException e) {
			logger.error(e.getMessage());
		} finally {
			try {
				out.flush();
				out.close();
			} catch (IOException e) {
				logger.error(e.getMessage());
			}
		}
	}

	/**
	 * 跳转到首页 支取查询
	 */
	@RequestMapping("/queryAD/index")
	public String index(Model model) {
		model.addAttribute("projects", DataHolder.dataMap.get("project"));
		model.addAttribute("communitys", DataHolder.communityMap);
		model.addAttribute("assignment", DataHolder.dataMap.get("assignment"));
		model.addAttribute("users", DataHolder.dataMap.get("user"));
		return "/draw/queryAD/index";
	}

	/**
	 * 查询支取申请列表(ajax调用)
	 * 
	 * @param req
	 *            从第几条数据库开始算(+每页显示的条数)
	 * @param limit
	 *            每页显示的条数，相当于pageSize
	 * @param ApplyDraw
	 *            查询条件
	 * @throws IOException
	 */
	@RequestMapping("/queryAD/list")
	public void list(@RequestBody ReqPamars<ApplyDraw> req,
			HttpServletRequest request, HttpServletResponse response)
			throws IOException {
		// 添加操作日志
		LogUtil.write(new Log("支取业务_支取查询", "模糊查询", "QueryADAction.list", req
				.toJson()));
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		try {
			List<Map<String, String>> list = queryADService.queryQueryAD(req
					.getParams());
			// 返回结果
			pw.print(JsonUtil.toJson(list));
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 支取查询(明细查询)(ajax调用)
	 * 
	 * @param req
	 *            从第几条数据库开始算(+每页显示的条数)
	 * @param limit
	 *            每页显示的条数，相当于pageSize
	 * @param ApplyDraw
	 *            查询条件
	 * @throws IOException
	 */
	@RequestMapping("/queryAD/list2")
	public void list2(@RequestBody ReqPamars<ApplyDraw> req,
			HttpServletRequest request, HttpServletResponse response)
			throws IOException {
		// 添加操作日志
		LogUtil.write(new Log("支取业务_支取查询", "明细查询", "QueryADAction.list2", req
				.toJson()));
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		try {
			List<Map<String, String>> list = queryADService.queryQueryADMX(req
					.getParams());
			// 返回结果
			pw.print(JsonUtil.toJson(list));
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 支取统计查询 (ajax调用)
	 * 
	 * @param req
	 *            从第几条数据库开始算(+每页显示的条数)
	 * @param limit
	 *            每页显示的条数，相当于pageSize
	 * @param ApplyDraw
	 *            查询条件
	 * @throws IOException
	 */
	@RequestMapping("/queryAD/list3")
	public void list3(@RequestBody ReqPamars<ApplyDraw> req,
			HttpServletRequest request, HttpServletResponse response)
			throws IOException {
		// 添加操作日志
		LogUtil.write(new Log("支取业务_支取查询", "统计查询", "QueryADAction.list3", req
				.toJson()));
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		try {
			List<Map<String, String>> list = queryADService.queryCountAD(req
					.getParams());
			// 返回结果
			pw.print(JsonUtil.toJson(list));
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 支取模糊查询导出
	 * 
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping("/queryAD/toExport1")
	public void toExport1(HttpServletRequest request,
			HttpServletResponse response) {
		response.setCharacterEncoding("utf-8");
		//获取参数
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("dateType",request.getParameter("dateType"));
		map.put("xmbm",request.getParameter("xmbm"));
		map.put("xqbh",request.getParameter("xqbh"));
		map.put("lybh",request.getParameter("lybh"));
		map.put("cxlb",request.getParameter("cxlb"));
		map.put("sqsja",request.getParameter("sqsja"));
		map.put("sqsjb",request.getParameter("sqsjb"));
		map.put("wxxm",Urlencryption.unescape(request.getParameter("wxxm")));
		// 添加操作日志
		LogUtil.write(new Log("支取业务_支取查询", "模糊查询导出", "QueryADAction.toExport1",
				map.toString()));
		String title = "物业专项维修资金使用情况表";
		String[] ZHT = { "划拨日期", "申请单位", "实际划拨金额", "小区名称", "楼宇名称", "维修项目",
				"经办人", "备注" };
		String[] ENT = { "hbrq", "sqdw", "sjhbje", "nbhdname", "bldgname",
				"wxxm", "jbr", "ApplyRemark" };
		List<Map<String, String>> list = null;
		try {
			list = queryADService.queryQueryAD(map);
			if (list.size() == 0) {
				exeException("获取数据失败！", response);
				return;
			}
			NormalExport.export(response, list, title, ZHT, ENT);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 支取模糊查询打印
	 * 
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping("/queryAD/toPrint1")
	public void toPrint1(HttpServletRequest request,
			HttpServletResponse response) {
		response.setCharacterEncoding("utf-8");
		ByteArrayOutputStream ops = null;
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("dateType",request.getParameter("dateType"));
		map.put("xmbm",request.getParameter("xmbm"));
		map.put("xqbh",request.getParameter("xqbh"));
		map.put("lybh",request.getParameter("lybh"));
		map.put("cxlb",request.getParameter("cxlb"));
		map.put("sqsja",request.getParameter("sqsja"));
		map.put("sqsjb",request.getParameter("sqsjb"));
		map.put("wxxm",Urlencryption.unescape(request.getParameter("wxxm")));
		
		// 添加操作日志
		LogUtil.write(new Log("支取业务_支取查询", "模糊查询打印", "QueryADAction.toPrint1",
				map.toString()));
		String title = "物业专项维修资金使用情况表";
		String[] ZHT = { "划拨日期", "申请单位", "实际划拨金额", "小区名称", "楼宇名称", "维修项目",
				"经办人", "备注" };
		String[] ENT = { "hbrq", "sqdw", "sjhbje", "nbhdname", "bldgname",
				"wxxm", "jbr", "ApplyRemark" };
		float[] widths = { 50f, 80f, 40f, 60f, 60f, 60f, 30f,
				50f };// 设置表格的列以及列宽
		List<Map<String, String>> list = null;
		try {
			list = queryADService.queryQueryAD(map);
			if (list.size() == 0) {
				exeException("获取数据失败！", response);
				return;
			}

			NormalPrintPDF pdf = new NormalPrintPDF();
			Map info = new HashMap();
			info.put("left", "");
			info.put("right", "日期：" + DateUtil.getDate() + "  共"
					+ (list.size() - 1) + "条记录");
			ops = pdf.creatPDFMAP(info, list, ZHT, ENT, widths, title);
		} catch (Exception e) {
			e.printStackTrace();
		}
		if (ops != null) {
			output(ops, response);
		}
	}

	/**
	 * 支取情况打印
	 * 
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping("/queryAD/printPdfQK")
	public void printPdfQK(HttpServletRequest request,
			HttpServletResponse response) {
		response.setCharacterEncoding("utf-8");
		ByteArrayOutputStream ops = null;
		Map<String, Object> map = new HashMap<String, Object>();
		if (request.getParameter("bm") == null
				|| request.getParameter("bm").equals("")) {
			exeException("获取传递的数据发生错误！", response);
			return;
		}
		map.put("dateType",request.getParameter("dateType"));
		map.put("xmbm",request.getParameter("xmbm"));
		map.put("xqbh",request.getParameter("xqbh"));
		map.put("lybh",request.getParameter("lybh"));
		map.put("cxlb",request.getParameter("cxlb"));
		map.put("sqsja",request.getParameter("sqsja"));
		map.put("sqsjb",request.getParameter("sqsjb"));
		map.put("bm",request.getParameter("bm"));
		
		// 添加操作日志
		LogUtil.write(new Log("支取业务_支取查询", "支取情况打印",
				"QueryADAction.printPdfQK", map.toString()));
		String title = "物业专项维修资金支取情况单";
		List<Map<String, String>> list = null;
		try {
			list = queryADService.queryQueryAD(map);
			if (list.size() == 0) {
				exeException("获取数据失败！", response);
				return;
			}

			QueryADPDF pdf = new QueryADPDF();

			ops = pdf.creatPDF(list.get(0),
					TokenHolder.getUser().getUsername(), title);
		} catch (Exception e) {
			e.printStackTrace();
		}
		if (ops != null) {
			output(ops, response);
		}
	}

	/**
	 * 支取明细查询导出
	 * 
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping("/queryAD/toExport2")
	public void toExport2(HttpServletRequest request,
			HttpServletResponse response) {
		response.setCharacterEncoding("utf-8");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("begindate",request.getParameter("begindate"));
		map.put("enddate",request.getParameter("enddate"));
		map.put("cxlb",request.getParameter("cxlb"));
		map.put("sfsh",request.getParameter("sfsh"));
		map.put("unitcode",request.getParameter("unitcode"));
		map.put("username",Urlencryption.unescape(request.getParameter("username")));
		map.put("z011",request.getParameter("z011"));
		map.put("xmbm",request.getParameter("xmbm"));
		map.put("xqbm",request.getParameter("xqbm"));
		map.put("lybh",request.getParameter("lybh"));
		map.put("result",request.getParameter("result"));
		
		// 添加操作日志
		LogUtil.write(new Log("支取业务_支取查询", "支取明细查询导出",
				"QueryADAction.toExport2", map.toString()));
		String title = "支取信息";
		String[] ZHT = { "房屋编号", "单元", "层", "房号", "业主姓名", "支取本金", "支取利息",
				"自筹金额", "项目名称", "小区名称", "楼宇名称", "操作员", "申请编号", "业务编号", "分摊日期" };
		String[] ENT = { "h001", "h002", "h003", "h005", "z012", "z004",
				"z005", "zcje", "xmmc", "xqmc", "lymc", "username", "z011",
				"z007", "z018" };// 输出例
		List<Map<String, String>> list = null;
		try {
			list = queryADService.queryQueryADMX(map);
			if (list.size() == 0) {
				exeException("获取数据失败！", response);
				return;
			}
			NormalExport.export(response, list, title, ZHT, ENT);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 支取明细查询打印
	 * 
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping("/queryAD/toPrint2")
	public void toPrint2(HttpServletRequest request,
			HttpServletResponse response) {
		response.setCharacterEncoding("utf-8");
		ByteArrayOutputStream ops = null;
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("begindate",request.getParameter("begindate"));
		map.put("enddate",request.getParameter("enddate"));
		map.put("cxlb",request.getParameter("cxlb"));
		map.put("sfsh",request.getParameter("sfsh"));
		map.put("unitcode",request.getParameter("unitcode"));
		map.put("username",Urlencryption.unescape(request.getParameter("username")));
		map.put("z011",request.getParameter("z011"));
		map.put("xmbm",request.getParameter("xmbm"));
		map.put("xqbm",request.getParameter("xqbm"));
		map.put("lybh",request.getParameter("lybh"));
		map.put("result",request.getParameter("result"));
		
		// 添加操作日志
		LogUtil.write(new Log("支取业务_支取查询", "支取明细查询打印",
				"QueryADAction.toPrint2", map.toString()));
		String title = "支取分摊明细";
		String[] ZHT = { "房屋编号", "单元", "层", "房号", "业主姓名", "支取本金", "支取利息",
				"自筹金额", "楼宇名称" };
		String[] ENT = { "h001", "h002", "h003", "h005", "z012", "z004",
				"z005", "zcje", "lymc" };
		float[] widths = { 80f, 30f, 30f, 40f, 80f, 60f, 60f, 60f, 80f };// 设置表格的列以及列宽
		List<Map<String, String>> list = null;
		try {
			list = queryADService.queryQueryADMX(map);
			if (list.size() == 0) {
				exeException("获取数据失败！", response);
				return;
			}

			NormalPrintPDF pdf = new NormalPrintPDF();
			Map info = new HashMap();
			info.put("left", "");
			info.put("right", "日期：" + DateUtil.getDate() + "  共"
					+ (list.size() - 1) + "条记录");
			ops = pdf.creatPDFMAP(info, list, ZHT, ENT, widths, title);
		} catch (Exception e) {
			e.printStackTrace();
		}
		if (ops != null) {
			output(ops, response);
		}
	}

	/**
	 * 支取统计查询导出
	 * 
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping("/queryAD/toExport3")
	public void toExport3(HttpServletRequest request,
			HttpServletResponse response) {
		response.setCharacterEncoding("utf-8");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("xqbh",request.getParameter("xqbh"));
		map.put("sfsh",request.getParameter("sfsh"));
		map.put("begindate",request.getParameter("begindate"));
		map.put("enddate",request.getParameter("enddate"));
		// 添加操作日志
		LogUtil.write(new Log("支取业务_支取查询", "支取统计查询导出",
				"QueryADAction.toExport3", map.toString()));
		String title = "支取统计信息";
		String[] ZHT = { "小区编号", "小区名称", "支取金额", "小区余额" };
		String[] ENT = { "xqbh", "xqmc", "zqje2", "kyje" };// 输出例
		List<Map<String, String>> list = null;
		try {
			list = queryADService.queryCountAD(map);
			if (list.size() == 0) {
				exeException("获取数据失败！", response);
				return;
			}
			NormalExport.export(response, list, title, ZHT, ENT);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 支取统计查询打印
	 * 
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping("/queryAD/toPrint3")
	public void toPrint3(HttpServletRequest request,
			HttpServletResponse response) {
		response.setCharacterEncoding("utf-8");
		ByteArrayOutputStream ops = null;
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("xqbh",request.getParameter("xqbh"));
		map.put("sfsh",request.getParameter("sfsh"));
		map.put("begindate",request.getParameter("begindate"));
		map.put("enddate",request.getParameter("enddate"));
		// 添加操作日志
		LogUtil.write(new Log("支取业务_支取查询", "支取统计查询打印",
				"QueryADAction.toPrint3", map.toString()));
		String title = "支取统计信息";

		String[] ZHT = { "小区编号", "小区名称", "支取金额", "小区余额" };
		String[] ENT = { "xqbh", "xqmc", "zqje2", "kyje" };// 输出例
		float[] widths = { 80f, 130f, 80f, 80f };// 设置表格的列以及列宽
		List<Map<String, String>> list = null;
		try {
			list = queryADService.queryCountAD(map);
			if (list.size() == 0) {
				exeException("获取数据失败！", response);
				return;
			}

			NormalPrintPDF pdf = new NormalPrintPDF();
			Map info = new HashMap();
			info.put("left", "");
			info.put("right", "日期：" + DateUtil.getDate() + "  共"
					+ (list.size() - 1) + "条记录");
			ops = pdf.creatPDFMAP(info, list, ZHT, ENT, widths, title);
		} catch (Exception e) {
			e.printStackTrace();
		}
		if (ops != null) {
			output(ops, response);
		}
	}
}

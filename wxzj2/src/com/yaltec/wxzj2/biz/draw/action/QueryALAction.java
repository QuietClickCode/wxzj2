package com.yaltec.wxzj2.biz.draw.action;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
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
import com.yaltec.comon.utils.Urlencryption;
import com.yaltec.wxzj2.biz.draw.entity.QueryAL;
import com.yaltec.wxzj2.biz.draw.entity.QueryAL1;
import com.yaltec.wxzj2.biz.draw.service.QueryALService;
import com.yaltec.wxzj2.biz.draw.service.export.QueryalExport;
import com.yaltec.wxzj2.biz.draw.service.print.QueryAL1PDF;
import com.yaltec.wxzj2.biz.draw.service.print.QueryALPDF;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 
 * @ClassName: QueryALAction
 * @Description: 查询销户实现类
 * 
 * @author yangshanping
 * @date 2016-8-19 上午09:57:24
 */
@Controller
public class QueryALAction {
	@Autowired
	private QueryALService queryALService;
	/**
	 * 日志记录器.
	 */
	private static final Logger logger = Logger.getLogger("QueryALPrint");

	/**
	 * 跳转到首页
	 */
	@RequestMapping("/queryal/index")
	public String index(Model model) {
		model.addAttribute("unitNames", DataHolder.dataMap.get("assignment"));
		model.addAttribute("communitys", DataHolder.communityMap);
		return "/draw/queryal/index";
	}

	/**
	 * 销户查询（模糊查询）显示
	 */
	@RequestMapping("/queryal/list")
	public void list(@RequestBody ReqPamars<QueryAL> req,
			HttpServletRequest request, HttpServletResponse response)
			throws IOException {
		// 添加操作日志
		LogUtil.write(new Log("销户查询", "模糊查询", "QueryALAction.list", req.toString()));
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 获取页面传入的查询条件，并存入map集合
		Map<String, Object> paramMap = req.getParams();

		Page<QueryAL> page = new Page<QueryAL>(req.getEntity(),req.getPageNo(), req.getPageSize());
		queryALService.find(page, paramMap);
		// 返回结果
		pw.print(page.toJson());
	}

	/**
	 * 销户查询（明细查询）显示
	 */
	@RequestMapping("/queryal1/list")
	public void queryal1List(@RequestBody ReqPamars<QueryAL1> req,
			HttpServletRequest request, HttpServletResponse response)
			throws IOException {
		// 添加操作日志
		LogUtil.write(new Log("销户查询", "明细查询", "QueryALAction.list", req.toString()));
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 获取页面传入的查询条件，并存入map集合
		Map<String, Object> paramMap = req.getParams();

		Page<QueryAL1> page = new Page<QueryAL1>(req.getEntity(), req.getPageNo(), req.getPageSize());
		queryALService.findQueryAL1(page, paramMap);
		// 返回结果
		pw.print(page.toJson());
	}

	/**
	 * 销户情况查询与打印
	 * */
	@RequestMapping("/queryal/printPdfQueryAL")
	public ByteArrayOutputStream printPdfQueryAL(String z011,
			HttpServletResponse response, RedirectAttributes redirectAttributes) {
		// 添加操作日志
		LogUtil.write(new Log("销户查询", "打印", "QueryALAction.printPdfQueryAL", z011));
		ByteArrayOutputStream ops = null;
		QueryAL1 result = null;
		Map<String, String> map = new HashMap<String, String>();
		map.put("z011", z011);
		map.put("h001", "");
		String userName = TokenHolder.getUser().getUsername();
		try {
			ArrayList<QueryAL1> list = (ArrayList<QueryAL1>) queryALService.queryQueryAL4_PrintPDF(map);
			result = list.get(0);
			QueryALPDF pdf = new QueryALPDF();
			String title = "物业专项维修资金销户通知书";
			if (list.size() > 1) {
				ops = pdf.creatPDF2(list, userName, title);
			} else {
				ops = pdf.creatPDF(result, userName, title);
			}
		} catch (Exception e) {
			logger.error(e.getMessage());
			redirectAttributes.addFlashAttribute("msg", "生成PDF文件发生错误！");
			return null;
		}
		if (ops != null) {
			queryALService.output(ops, response);
		}
		return ops;
	}

	/**
	 * 打印清册
	 */
	@RequestMapping("/queryal/printPdfAL")
	public ModelAndView listPrint(HttpServletRequest request,
			HttpServletResponse response, RedirectAttributes redirectAttributes) {
		// 获取页面传入的参数，并以逗号(,)分割，存入数组中
		String paras = request.getParameter("str");
		String[] strs = paras.split(",");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("xqbm", strs[0]);
		map.put("lybh", strs[1]);
		map.put("czy", Urlencryption.unescape(strs[2]));
		map.put("begindate", strs[3]);
		map.put("enddate", strs[4]);
		map.put("unitcode", strs[5]);
		map.put("z011", strs[6]);
		map.put("sfsh", strs[7]);
		map.put("result", "0");
		// 查询要打印的数据
		List<QueryAL1> resultList= queryALService.queryQueryAL4(map);
		// 传参容器
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("list", resultList);
		QueryAL1PDF view = new QueryAL1PDF();
		// 设置参数
		view.setAttributesMap(paramMap);
		// 返回视图
		return new ModelAndView(view);
	}
	
	/**
	 * 导出模糊查询销户信息
	 * @param request
	 * @param response
	 */
	@RequestMapping("/queryal/toExport")
	public void export(HttpServletRequest request, HttpServletResponse response) {
		// 获取页面传入的参数，并以逗号(,)分割，存入数组中
		String paras = request.getParameter("str");
		String[] strs = paras.split(",");
		try {
			String cxlb = strs[2];
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("begindate", strs[0]);
			map.put("enddate", strs[1]);
			map.put("cxlb", (Integer.valueOf(cxlb) + 9));
				
			List<QueryAL> resultList = null;
			if (cxlb.equals("10")) {//全部显示
				resultList = queryALService.queryQueryAL1_1(map);
			} else {
				resultList = queryALService.queryQueryAL1_2(map);
			}
			QueryalExport.exportQueryal(resultList, response);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * 导出明细查询销户信息
	 * @param request
	 * @param response
	 */
	@RequestMapping("/queryal1/toExport")
	public void toExport(HttpServletRequest request, HttpServletResponse response) {
		// 获取页面传入的参数，并以逗号(,)分割，存入数组中
		String paras = request.getParameter("str");
		String[] strs = paras.split(",");
		try {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("xqbm", strs[0]);
			map.put("lybh", strs[1]);
			map.put("czy", Urlencryption.unescape(strs[2]));
			map.put("begindate", strs[3]);
			map.put("enddate", strs[4]);
			map.put("unitcode", strs[5]);
			map.put("z011", strs[6]);
			map.put("sfsh", strs[7]);
			map.put("result", "0");
			List<QueryAL1> resultList= queryALService.queryQueryAL4(map);
			QueryalExport.exportQueryal1(resultList, response);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}

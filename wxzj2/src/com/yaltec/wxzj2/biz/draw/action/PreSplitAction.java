package com.yaltec.wxzj2.biz.draw.action;

import java.io.ByteArrayOutputStream;
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
import org.springframework.web.bind.annotation.RequestMapping;

import com.yaltec.comon.auth.TokenHolder;
import com.yaltec.comon.log.LogUtil;
import com.yaltec.comon.log.entity.Log;
import com.yaltec.comon.utils.JsonUtil;
import com.yaltec.comon.utils.Urlencryption;
import com.yaltec.wxzj2.biz.draw.entity.CodeName;
import com.yaltec.wxzj2.biz.draw.entity.ShareAD;
import com.yaltec.wxzj2.biz.draw.service.BatchRefundService;
import com.yaltec.wxzj2.biz.draw.service.PreSplitService;
import com.yaltec.wxzj2.biz.draw.service.export.ExportShareAD;
import com.yaltec.wxzj2.biz.draw.service.print.PreSplitPDF;
import com.yaltec.wxzj2.biz.payment.service.PaymentService;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 
 * @ClassName: PreSplitAction
 * @Description: 支取预分摊
 * 
 * @author yangshanping
 * @date 2016-9-8 上午09:21:38
 */
@Controller
public class PreSplitAction {
	@Autowired
	private BatchRefundService batchRefundService;
	@Autowired
	private PreSplitService preSplitService;
	@Autowired
	private PaymentService paymentService;
	/**
	 * 日志记录器.
	 */
	private static final Logger logger = Logger.getLogger("BatchRefund");
	/**
	 * 跳转到首页
	 */
	@RequestMapping("/presplit/index")
	public String index(Model model) {
		model.addAttribute("projects", DataHolder.dataMap.get("project"));
		model.addAttribute("communitys", DataHolder.communityMap);
		String w008="";
		String unitcode="";
		//根据业务编号获取归集中心编码
		if(!w008.equals("")){
			unitcode=paymentService.getUnitcodeByW008(w008);
		}
		model.addAttribute("unitcode",unitcode);
		model.addAttribute("assignment", DataHolder.dataMap.get("assignment"));
		// 判断是否荣昌
		int judgeRC = 0;
		if (DataHolder.customerInfo.isRC()) {
			judgeRC = 1;
		}
		model.addAttribute("judgeRC", judgeRC);//业委会
		return "/draw/presplit/index";
	}
	
	/**
	 * 导出预分摊明细数据
	 */
	@RequestMapping("/presplit/exportShareAD")
	public void export(HttpServletRequest request, HttpServletResponse response) {
		Map<String, String> map = new HashMap<String, String>();
		String paras = request.getParameter("str");
		String[] strs = paras.split(",");
		map.put("bm", strs[0]);
		map.put("lb", strs[1]);
//		map.put("xqmc", Urlencryption.unescape(strs[3]));
		map.put("xqmc", strs[3]);
		map.put("userid", TokenHolder.getUser().getUserid());
		// 添加操作日志
		LogUtil.write(new Log("支取预分摊", "导出预分摊明细", "PreSplitAction.exportShareAD", map.toString()));
		List<ShareAD> resultList = null;
		try {
			if (strs[2].equals("1")) {
				// 未进行资金分摊
				String h001s = strs[4];
				String bl = strs[1];
				String sqlstr = " select h001,lymc,lybh,h002,h003,h005,h013,convert(decimal(15,2),h006) h006,h015,0 ftje,0 zqbj,0 zqlx,(case when convert(decimal(18,2),(h030-(isnull(h021,0)*"
						+ map.get("bl")
						+ ")/100))<0 then 0 else convert(decimal(18,2),(h030-(isnull(h021,0)*"
						+ bl
						+ ")/100)) end) h030,"
						+ "convert(decimal(15,2),h031) h031,h030 bjye,h031 lxye,0 zcje from house where h001 in ("
						+ h001s
						+ ") and h035='正常'   "
						+ " union "
						+ "select '合计' h001,'' lymc,'' lybh,'' h002,'' h003,'' h005,'' h013,sum(convert(decimal(15,2),h006)) h006,'' h015,0 ftje,0 zqbj,0 zqlx,sum((case when convert(decimal(18,2),(h030-(isnull(h021,0)*"
						+ map.get("bl")
						+ ")/100))<0 then 0 else convert(decimal(18,2),(h030-(isnull(h021,0)*"
						+ bl
						+ ")/100)) end)) h030,"
						+ " sum(convert(decimal(15,2),h031)) h031,sum(convert(decimal(15,2),h030)) bjye,sum(convert(decimal(15,2),h031)) lxye,0 zcje from house where h001 in ("
						+ h001s + ") and h035='正常'   ";
				resultList = preSplitService.ExportFtFwInfo(sqlstr);
			} else {
				resultList = batchRefundService.QryExportShareAD(map);
				ExportShareAD.exportPreShareAD(resultList, response, map.get("xqmc").toString());
			}
		} catch (Exception e) {
			logger.error(e.getMessage());
			e.printStackTrace();
		}
	}
	
	/**
	 * 判断是否是铜梁
	 * @throws Exception 
	 */
	@RequestMapping("/presplit/queryIsTL")
	public void find(HttpServletResponse response) throws Exception {
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		boolean result = false;
		if (preSplitService.queryIsTL() != null) {
			result = true;
		}
		pw.print(JsonUtil.toJson(result));
	}
	
	/**
	 * 导出支取分摊明细数据(物业专项维修资金使用业主意见表)
	 */
	@RequestMapping("/presplit/exportShareAD2")
	public void exportShareAD2(HttpServletRequest request, HttpServletResponse response) {
		String paras = request.getParameter("str");
		String[] strs = paras.split(",");
		// 添加操作日志
		LogUtil.write(new Log("支取预分摊", "导出业主意见表", "PreSplitAction.exportShareAD2", paras));
		try {
//			String type = jonsObject.getString("type");
			Map<String, String> map = new HashMap<String, String>();
			map.put("bm", strs[0]);
			map.put("lb", strs[1]);
			map.put("xqmc", Urlencryption.unescape(strs[3]));
			map.put("userid", TokenHolder.getUser().getUserid());
			
			List<CodeName> lys = null;
			List<ArrayList> resultList = new ArrayList<ArrayList>();
			//获取支取分摊相关的楼宇 By 申请编号
			lys = preSplitService.QryExportShareADLYB(map);
			for (CodeName ly : lys) {
				ArrayList<ShareAD> list = null;
				map.put("lybh", ly.getBm());
				list = (ArrayList<ShareAD>) preSplitService.QryExportShareAD2(map);
				resultList.add(list);
			}
			
			ExportShareAD.exportShareADToExcel2(resultList, response, map.get("xqmc").toString());
		} catch (Exception e) {
			logger.error(e.getMessage());
			e.printStackTrace();
		}
	}
	

	/**
	 * 导出支取分摊明细数据(物业专项维修资金使用业主意见表)【铜梁专用】
	 */
	@RequestMapping("/presplit/exportShareAD3")
	public void exportShareAD3(HttpServletRequest request, HttpServletResponse response) {
		String paras = request.getParameter("str");
		String[] strs = paras.split(",");
		// 添加操作日志
		LogUtil.write(new Log("支取预分摊", "导出业主意见表【铜梁专用】", "PreSplitAction.exportShareAD3", paras));
		try {
//			String xqmc = Urlencryption.unescape(strs[3]);
			String xqmc = strs[3];
			//已进行资金分摊
			Map<String, String> map = new HashMap<String, String>();
			map.put("bm", strs[0]);
			map.put("lb", strs[1]);
			map.put("xqmc", xqmc);
			map.put("userid", TokenHolder.getUser().getUserid());
			map.put("lybh", "");

			List<ShareAD> resultList = preSplitService.QryExportShareAD3(map);
			
			ExportShareAD.exportShareADToExcel3(resultList, response, xqmc);
		} catch (Exception e) {
			logger.error(e.getMessage());
			e.printStackTrace();
		}
	}
	
	/**
	 * 打印支取分摊明细数据(物业专项维修资金使用业主意见表)【铜梁专用】
	 */
	@RequestMapping("/presplit/printOOForm_tl")
	public void printOOForm_tl(HttpServletRequest request, HttpServletResponse response) {
		response.setCharacterEncoding("utf-8");
		ByteArrayOutputStream ops = null;
		String paras = request.getParameter("str");
		String[] strs = paras.split(",");
		
		// 添加操作日志
		LogUtil.write(new Log("支取预分摊", "导出业主意见表【铜梁专用】", "PreSplitAction.exportShareAD3", paras));
		try {
//			String xqmc = Urlencryption.unescape(strs[3]);
			String xqmc = strs[3];
			//已进行资金分摊
			Map<String, String> map = new HashMap<String, String>();
			map.put("bm", strs[0]);
			map.put("lb", strs[1]);
			map.put("xqmc", xqmc);
			map.put("userid", TokenHolder.getUser().getUserid());
			map.put("lybh", "");

			List<ShareAD> resultList = preSplitService.QryExportShareAD3(map);
			
			PreSplitPDF psPdf = new PreSplitPDF();
			ops = psPdf.creatPDF_tl(resultList, xqmc);
		} catch (Exception e) {
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		if (ops != null) {
			PreSplitPDF.output(ops,response);
		}
	}
	/**
	 * 打印支取分摊明细数据(物业专项维修资金使用业主意见表)
	 */
	@RequestMapping("/presplit/printOOForm_Other")
	public void printOOForm_Other(HttpServletRequest request, HttpServletResponse response) {
		response.setCharacterEncoding("utf-8");
		ByteArrayOutputStream ops = null;
		String paras = request.getParameter("str");
		String[] strs = paras.split(",");
		
		// 添加操作日志
		LogUtil.write(new Log("支取预分摊", "导出业主意见表【铜梁专用】", "PreSplitAction.exportShareAD3", paras));
		try {
//			String xqmc = Urlencryption.unescape(strs[3]);
			String xqmc = strs[3];
			//已进行资金分摊
			Map<String, String> map = new HashMap<String, String>();
			map.put("bm", strs[0]);
			map.put("lb", strs[1]);
			map.put("xqmc", xqmc);
			map.put("userid", TokenHolder.getUser().getUserid());
			map.put("lybh", "");
			List<CodeName> lys = null;
			List<ArrayList> resultList = new ArrayList<ArrayList>();
			//获取支取分摊相关的楼宇 By 申请编号
			lys = preSplitService.QryExportShareADLYB(map);
			for (CodeName ly : lys) {
				ArrayList<ShareAD> list = null;
				map.put("lybh", ly.getBm());
				list = (ArrayList<ShareAD>) preSplitService.QryExportShareAD2(map);
				resultList.add(list);
			}
			//List<ShareAD> resultList = preSplitService.QryExportShareAD3(map);
			
			PreSplitPDF psPdf = new PreSplitPDF();
			ops = psPdf.creatPDF_Other(resultList, xqmc);
		} catch (Exception e) {
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		if (ops != null) {
			PreSplitPDF.output(ops,response);
		}
	}
	
}

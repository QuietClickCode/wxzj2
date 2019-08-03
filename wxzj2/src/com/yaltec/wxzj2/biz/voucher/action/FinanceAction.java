package com.yaltec.wxzj2.biz.voucher.action;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.yaltec.comon.auth.TokenHolder;
import com.yaltec.comon.log.LogUtil;
import com.yaltec.comon.log.entity.Log;
import com.yaltec.comon.utils.JsonUtil;
import com.yaltec.comon.utils.Urlencryption;
import com.yaltec.wxzj2.biz.voucher.entity.FinanceR;
import com.yaltec.wxzj2.biz.voucher.service.FinanceService;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * @ClassName: FinanceAction
 * @Description: 财务对账ACTION
 * 
 * @author hqx
 * @date 2016-7-7 上午10:04:38
 */
@Controller
public class FinanceAction {

	@Autowired
	private FinanceService financeservice;

	/**
	 * 跳转到首页
	 */
	@RequestMapping("/finance/index")
	public String index(Model model) {
		model.addAttribute("bank", DataHolder.dataMap.get("bank"));
		model.addAttribute("assignment", DataHolder.dataMap.get("assignment"));
		model.addAttribute("user", TokenHolder.getUser());
		return "/voucher/finance/index";
	}

	/**
	 * 财务对账-更新基本信息
	 * 
	 * @param paras
	 * @param response
	 * @param redirectAttributes
	 * @throws IOException
	 */
	@RequestMapping("/finance/update")
	public void update(String bankid, String begindate, String enddate, String flag, HttpServletResponse response,
			RedirectAttributes redirectAttributes) throws IOException {
		response.setCharacterEncoding("utf-8");
		Map<String, String> paramMap = new HashMap<String, String>();
		paramMap.put("bankid", bankid);
		paramMap.put("begindate", begindate);
		paramMap.put("enddate", enddate);
		paramMap.put("flag", flag);
		paramMap.put("userid", TokenHolder.getUser().getUserid());
		paramMap.put("username", TokenHolder.getUser().getUsername());
		try {
			financeservice.updateTail();
			financeservice.updateStatus(paramMap);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 查询单位日记账记录
	 * 
	 * @param paras
	 * @param response
	 * @param redirectAttributes
	 */
	@RequestMapping("/finance/searchDW")
	public void searchDW(String bankid, String begindate, String enddate, String flag, HttpServletResponse response,
			RedirectAttributes redirectAttributes) {
		response.setCharacterEncoding("utf-8");
		Map<String, String> paramMap = new HashMap<String, String>();
		paramMap.put("bankid", bankid);
		paramMap.put("begindate", begindate);
		paramMap.put("enddate", enddate);
		paramMap.put("flag", flag);
		paramMap.put("userid", TokenHolder.getUser().getUserid());
		paramMap.put("username", TokenHolder.getUser().getUsername());
		try {
			String sqlstr = "select  h001,wybh as p005,convert(varchar(19),h020,120) as p006,case type when '00'  then '房屋编号' when '01'  then '交款编号' "
					+ " when '02'  then '支取编号' when '03'  then 'pos机参考号' when '04'  then '撤单编号' end as type,"
					+ " case type when '02'  then h030 else '0' end as p008,case type when '00'  then h030 when '01'  "
					+ " then h030  else '0' end as p009,id as bm from webservice1 where status='"
					+ paramMap.get("flag")
					+ "' and "
					+ "convert(varchar(10),h020,120)>='"
					+ paramMap.get("begindate")
					+ "' and convert(varchar(10),h020,120)<=convert(varchar(10),'"
					+ paramMap.get("enddate")
					+ "',120)  "
					+ "and source='"
					+ paramMap.get("bankid")
					+ "'  order by convert(varchar(10),h020,120),h001 ";
			paramMap.put("sqlstr", sqlstr);
			List<FinanceR> list = financeservice.findFinance(paramMap);
			PrintWriter pw = response.getWriter();
			pw.print(JsonUtil.toJson(list));

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 查询银行日记账记录
	 * 
	 * @param paras
	 * @param response
	 * @param redirectAttributes
	 */
	@RequestMapping("/finance/searchYH")
	public void searchYH(String bankid, String begindate, String enddate, String flag, HttpServletResponse response,
			RedirectAttributes redirectAttributes) {
		response.setCharacterEncoding("utf-8");
		Map<String, String> paramMap = new HashMap<String, String>();
		paramMap.put("bankid", bankid);
		paramMap.put("begindate", begindate);
		paramMap.put("enddate", enddate);
		paramMap.put("flag", flag);
		paramMap.put("userid", TokenHolder.getUser().getUserid());
		paramMap.put("username", TokenHolder.getUser().getUsername());
		try {
			String sqlstr = "select  h001,wybh as p005,convert(varchar(10),h020,120) as p006, case type when '02'  "
					+ "then h030 else '0' end as p008, case type when '00' then h030 when '01'  then h030 else '0' end as p009,"
					+ "id as bm, '' as type  from webservice2 where status='" + paramMap.get("flag") + "'  and "
					+ "convert(varchar(10),h020,120)>='" + paramMap.get("begindate") + "' and "
					+ "convert(varchar(10),h020,120)<=convert(varchar(10),'" + paramMap.get("enddate") + "',120) "
					+ "and source='" + paramMap.get("bankid") + "' order by convert(varchar(10),h020,120),h001 ";
			paramMap.put("sqlstr", sqlstr);
			// 添加操作日志
			LogUtil.write(new Log("凭证管理_财务对账", "查询银行日记账记录", "FinanceAction.searchYH",paramMap.toString()));
			List<FinanceR> list = financeservice.findFinance(paramMap);
			PrintWriter pw = response.getWriter();
			pw.print(JsonUtil.toJson(list));

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 获取财务月度
	 * 
	 * @throws Exception
	 */
	@RequestMapping("/finance/initDate")
	public void initDate(HttpServletResponse response) {
		try {
			String str = financeservice.getReviewDate();
			PrintWriter pw = response.getWriter();
			pw.print(str);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	/**
	 * 财务对账-保存功能 更新状态、审核凭证
	 * 
	 * @throws Exception
	 */
	@RequestMapping("/finance/saveFinanceR")
	public void saveFinanceR(HttpServletResponse response, String begindate,String enddate, String yhbh, String dwbms, String ysbms) {
		Map<String, String> paramMap = new HashMap<String, String>();
		paramMap.put("begindate", begindate);
		paramMap.put("enddate", enddate);
		paramMap.put("yhbh", yhbh);
		paramMap.put("username", TokenHolder.getUser().getUsername());
		paramMap.put("dwbms", dwbms);
		paramMap.put("ysbms", ysbms);
		paramMap.put("result", "0");
		try {
			// 添加操作日志
			LogUtil.write(new Log("凭证管理_财务对账", "审核凭证", "FinanceAction.saveFinanceR",paramMap.toString()));
			financeservice.saveFinanceR(paramMap);
			PrintWriter pw= response.getWriter();
			pw.print(JsonUtil.toJson(paramMap));//多个的(如：list、map)需要转化为json
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}

	/**
	 * 财务对账数据打印
	 * 
	 * @param request
	 * @param response
	 * @throws IOException
	 */
	@RequestMapping("/finance/toPrint")
	public void toPrint(HttpServletRequest request, HttpServletResponse response) throws IOException {
		// 获取参数
		Map<String, String> paramMap = new HashMap<String, String>();
		paramMap.put("bankid", request.getParameter("bankid"));
		paramMap.put("bankmc", Urlencryption.unescape(request.getParameter("bankmc")));
		paramMap.put("flag", request.getParameter("flag"));
		paramMap.put("enddate", request.getParameter("enddate"));
		paramMap.put("begindate", request.getParameter("begindate"));
		// 添加操作日志
		LogUtil.write(new Log("凭证管理_财务对账", "数据打印", "FinanceAction.toPrint",paramMap.toString()));
		ByteArrayOutputStream ops = financeservice.toPrint(paramMap);
		if (ops != null) {
			financeservice.output(ops, response);
		}
	}

}

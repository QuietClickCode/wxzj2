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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.yaltec.comon.auth.TokenHolder;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.comon.core.entity.ReqPamars;
import com.yaltec.comon.log.LogUtil;
import com.yaltec.comon.log.entity.Log;
import com.yaltec.comon.utils.JsonUtil;
import com.yaltec.wxzj2.biz.draw.entity.ShareFacilities;
import com.yaltec.wxzj2.biz.draw.service.BankShareService;
import com.yaltec.wxzj2.biz.draw.service.ShareFacilitiesService;

/**
 * 
 * @ClassName: BankShareAction
 * @Description: 银行利息分摊实现类
 * 
 * @author yangshanping
 * @date 2016-9-7 下午02:14:03
 */
@Controller
public class BankShareAction {

	@Autowired
	private ShareFacilitiesService shareFacilitiesService;
	@Autowired
	private BankShareService bankShareService;
	/**
	 * 日志记录器.
	 */
	private static final Logger logger = Logger.getLogger("BankShareInterest");

	/**
	 * 跳转到首页
	 */
	@RequestMapping("/bankShareInterest/index")
	public String index(Model model) {
		return "/draw/bankShareInterest/index";
	}
	/**
	 * 查询银行利息收益分摊信息
	 */
	@RequestMapping("/bankShareInterest/list")
	public void list(@RequestBody ReqPamars<ShareFacilities> req, HttpServletRequest request,
			HttpServletResponse response)throws IOException{
		// 添加操作日志
		LogUtil.write(new Log("银行利息收益分摊", "查询", "ShareFacilitiesAction.list", req.toString()));
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 获取页面传入的查询条件，并存入map集合
		Map<String, Object> paramMap = req.getParams();
		
		Page<ShareFacilities> page = new Page<ShareFacilities>(req.getEntity(), req.getPageNo(), req.getPageSize());
		shareFacilitiesService.find(page, paramMap);
		// 返回结果
		pw.print(page.toJson());
	}
	
	/**
	 * 跳转到新增银行利息收益分摊页面
	 */
	@RequestMapping("/bankShareInterest/toAdd")
	public String add(Model model) {
		return "/draw/bankShareInterest/add";
	}
	
	/**
	 * 保存银行利息设施收益分摊信息
	 */
	@RequestMapping("/bankShareInterest/add")
	public String save(ShareFacilities shareFacilities, HttpServletRequest request,
			Model model, RedirectAttributes redirectAttributes) {
		Map<String , Object> paramMap = new HashMap<String, Object>();
		paramMap.put("nbhdcode", "");
		paramMap.put("nbhdname", "");
		paramMap.put("bldgcode", "");
		paramMap.put("bldgname", "");
		paramMap.put("handlingUser", "");
		paramMap.put("incomeItems", shareFacilities.getIncomeItems());
		paramMap.put("businessDate", shareFacilities.getBusinessDate());
		paramMap.put("incomeAmount", shareFacilities.getIncomeAmount());
		paramMap.put("bankCode", "");
		paramMap.put("bankName", "");
		paramMap.put("receiptNO", "");
		paramMap.put("userid", TokenHolder.getUser().getUserid());
		paramMap.put("username", TokenHolder.getUser().getUsername());
		paramMap.put("incomeType", "3");
		paramMap.put("result", "");
		// 添加操作日志
		LogUtil.write(new Log("银行利息收益分摊", "保存", "ShareFacilitiesAction.add", paramMap.toString()));
		shareFacilitiesService.saveFacilities(paramMap);
		int result = Integer.valueOf(paramMap.get("result").toString());
		if(result==0){
			redirectAttributes.addFlashAttribute("msg","新增银行利息收益分摊成功！");
			return "redirect:/bankShareInterest/index";
		}else{
			redirectAttributes.addFlashAttribute("msg","新增银行利息收益分摊失败！");
			return "redirect:/bankShareInterest/add";
		}
	}
	
	/**
	 * 删除银行利息收益分摊信息(可进行批量删除)
	 */
	@RequestMapping("/bankShareInterest/delshare")
	public String delshare(HttpServletRequest request, Model model,RedirectAttributes redirectAttributes) {
		// 通过request接收页面传递过来要删除的编码(bm)数据
		String paras=request.getParameter("bms");
		if(paras.isEmpty()){
			redirectAttributes.addFlashAttribute("msg","获取数据异常，请稍候重试！");
        	return  "redirect:/bankShareInterest/index";
		}
		// 添加操作日志
		LogUtil.write(new Log("银行利息收益分摊", "删除", "ShareFacilitiesAction.delshare", paras));
		// 将编码按逗号进行分割
		String[] bms = paras.split(",");
		// 创建一个map集合，作为调用删除销户申请方法的参数
		Map<String,String> paramMap=new HashMap<String,String>();
		paramMap.put("userid", TokenHolder.getUser().getUserid());
		paramMap.put("username", TokenHolder.getUser().getUsername());
		paramMap.put("flag", "20");
		paramMap.put("result", "");
		// 根据bm进行循环删除销户申请
		for (String bm : bms) {
			if (!bm.equals("")) {
				paramMap.put("bm", bm);
				shareFacilitiesService.delFacilities(paramMap);
				int result = Integer.valueOf(paramMap.get("result").toString());
				if (result == 0) {
		        	redirectAttributes.addFlashAttribute("msg","删除成功！");
                } else if(result == -5) {
                	redirectAttributes.addFlashAttribute("msg","操作员只能删除自己的业务，请检查！");
                } else if(result == 1) {
                	redirectAttributes.addFlashAttribute("msg","已经审核的业务不能删除！");
                } else {
                	redirectAttributes.addFlashAttribute("msg","删除失败，请稍候重试！");
                }
			}
		}
		return  "redirect:/bankShareInterest/index";
	}
	
	/**
	 * 银行利息分摊
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping("/bankShareInterest/getShare")
	public void getShare(String bm,String incomeAmount,HttpServletResponse response) throws Exception {
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		Map<String, String> map = new HashMap<String, String>();
		map.put("bm", bm);
		map.put("TotalInterest", incomeAmount);
		map.put("userid", TokenHolder.getUser().getUserid());
		map.put("username", TokenHolder.getUser().getUsername());
		map.put("result", "");
		// 添加操作日志
		LogUtil.write(new Log("银行利息收益分摊", "分摊", "ShareFacilitiesAction.getShare", map.toString()));
		int result = -1;
		try {
			bankShareService.shareBankShareInterestI(map);
			result = Integer.valueOf(map.get("result").toString());
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e.getMessage());
			throw e;
		}
		pw.print(JsonUtil.toJson(result));
	}
}

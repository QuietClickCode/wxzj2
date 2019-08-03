package com.yaltec.wxzj2.biz.draw.action;

import java.io.ByteArrayOutputStream;
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
import com.yaltec.wxzj2.biz.comon.service.CustomerInfoService;
import com.yaltec.wxzj2.biz.draw.entity.ShareFacilities;
import com.yaltec.wxzj2.biz.draw.service.ShareFacilitiesService;
import com.yaltec.wxzj2.biz.draw.service.print.ShareFacilitiesPDF;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 
 * @ClassName: ShareInterestAction
 * @Description: 业主利息收益分摊实现类
 * 
 * @author yangshanping
 * @date 2016-9-7 上午09:13:30
 */
@Controller
public class ShareInterestAction {
	@Autowired
	private ShareFacilitiesService shareFacilitiesService;
	@Autowired
	private CustomerInfoService customerInfoService;
	/**
	 * 日志记录器.
	 */
	private static final Logger logger = Logger.getLogger("ShareFacilities");

	/**
	 * 跳转到首页
	 */
	@RequestMapping("/shareInterest/index")
	public String index(Model model) {
		model.addAttribute("banks", DataHolder.dataMap.get("bank"));
		model.addAttribute("communitys", DataHolder.communityMap);
		return "/draw/shareInterest/index";
	}
	/**
	 * 查询业主利息收益分摊信息
	 */
	@RequestMapping("/shareInterest/list")
	public void list(@RequestBody ReqPamars<ShareFacilities> req, HttpServletRequest request,
			HttpServletResponse response)throws IOException{
		// 添加操作日志
		LogUtil.write(new Log("业主利息收益分摊", "查询", "ShareInterestAction.list", req.toString()));
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
	 * 跳转到新增业主利息收益分摊页面
	 */
	@RequestMapping("/shareInterest/toAdd")
	public String add(Model model) {
		model.addAttribute("banks", DataHolder.dataMap.get("bank"));
		model.addAttribute("communitys", DataHolder.communityMap);
		return "/draw/shareInterest/add";
	}
	
	/**
	 * 保存业主利息设施收益分摊信息
	 */
	@RequestMapping("/shareInterest/add")
	public String save(ShareFacilities shareFacilities, HttpServletRequest request,
			Model model, RedirectAttributes redirectAttributes) {
		// 添加操作日志
		LogUtil.write(new Log("业主利息收益分摊", "添加", "ShareInterestAction.add", shareFacilities.toString()));
		Map<String , Object> paramMap = new HashMap<String, Object>();
		paramMap.put("nbhdcode", shareFacilities.getNbhdcode());
		paramMap.put("nbhdname", shareFacilities.getNbhdname());
		paramMap.put("bldgcode", shareFacilities.getBldgcode());
		paramMap.put("bldgname", shareFacilities.getBldgname());
		paramMap.put("handlingUser", shareFacilities.getHandlingUser());
		paramMap.put("incomeItems", shareFacilities.getIncomeItems());
		paramMap.put("businessDate", shareFacilities.getBusinessDate());
		paramMap.put("incomeAmount", shareFacilities.getIncomeAmount());
		paramMap.put("bankCode", shareFacilities.getBankCode());
		paramMap.put("bankName", shareFacilities.getBankName());
		paramMap.put("receiptNO", shareFacilities.getReceiptNO());
		paramMap.put("userid", TokenHolder.getUser().getUserid());
		paramMap.put("username", TokenHolder.getUser().getUsername());
		paramMap.put("incomeType", "2");
		paramMap.put("result", "");
		
		shareFacilitiesService.saveFacilities(paramMap);
		int result = Integer.valueOf(paramMap.get("result").toString());
		if(result==0){
			redirectAttributes.addFlashAttribute("msg","新增业主利息收益分摊成功！");
			return "redirect:/shareInterest/index";
		}else{
			redirectAttributes.addFlashAttribute("msg","新增业主利息收益分摊失败！");
			return "redirect:/shareInterest/add";
		}
	}
	
	/**
	 * 删除业主利息收益分摊信息(可进行批量删除)
	 */
	@RequestMapping("/shareInterest/delshare")
	public String delshare(HttpServletRequest request, Model model,RedirectAttributes redirectAttributes) {
		// 通过request接收页面传递过来要删除的编码(bm)数据
		String paras=request.getParameter("bms");
		if(paras.isEmpty()){
			redirectAttributes.addFlashAttribute("msg","获取数据异常，请稍候重试！");
        	return  "redirect:/shareInterest/index";
		}
		// 添加操作日志
		LogUtil.write(new Log("业主利息收益分摊", "删除", "ShareInterestAction.delshare", paras));
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
		return  "redirect:/shareInterest/index";
	}
	
	/**
	 * 业主利息收益分摊打印
	 * */
	@RequestMapping("/shareInterest/print")
	public ByteArrayOutputStream pdfShareFacilities(HttpServletRequest request, HttpServletResponse response, Model model,
			RedirectAttributes redirectAttributes) {
		ByteArrayOutputStream ops = null;
		ShareFacilities result = null;
		String bm = request.getParameter("bm");
		// 添加操作日志
		LogUtil.write(new Log("业主利息收益分摊", "打印", "ShareInterestAction.print", bm));
		try {
			result = shareFacilitiesService.pdfShareFacilities(bm);
			ShareFacilitiesPDF pdf = new ShareFacilitiesPDF();
			String title = "物业专项维修资金业主利息收益分摊交款收据";
			// 判断是否江津
			if (customerInfoService.getCustomerName().contains("江津")) {
				// 江津
				title = "重庆市江津区" + title;
			}
			ops = pdf.creatPDF(result, title);
		} catch (Exception e) {
			e.printStackTrace();
			redirectAttributes.addFlashAttribute("msg", "生成PDF文件发生错误！");
			return null;
		}
		if (ops != null) {
			shareFacilitiesService.output(ops, response);
		}
		return ops;
	}
	
	/**
	 * 跳转到分摊页面
	 */
	@RequestMapping("/shareInterest/share")
	public String share(HttpServletRequest request,Model model) {
		String bm = request.getParameter("bm");
		// 根据编码bm获取公共设施分摊信息
		ShareFacilities shareFacilities = shareFacilitiesService.pdfShareFacilities(bm);
		model.addAttribute("shareFacilities", shareFacilities);
		return "/draw/shareInterest/share";
	}
	
}

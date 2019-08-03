package com.yaltec.wxzj2.biz.draw.action;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.yaltec.comon.auth.TokenHolder;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.comon.core.entity.ReqPamars;
import com.yaltec.comon.log.LogUtil;
import com.yaltec.comon.log.entity.Log;
import com.yaltec.comon.utils.JsonUtil;
import com.yaltec.wxzj2.biz.draw.entity.ShareAD;
import com.yaltec.wxzj2.biz.draw.entity.ShareFacilities;
import com.yaltec.wxzj2.biz.draw.entity.ShareInterest;
import com.yaltec.wxzj2.biz.draw.service.ShareFacilitiesService;
import com.yaltec.wxzj2.biz.draw.service.print.ShareFacilitiesPDF;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 
 * @ClassName: ShareFacilitiesAction
 * @Description: 公共设施收益分摊实现类
 * 
 * @author yangshanping
 * @date 2016-9-5 上午09:15:27
 */
@Controller
public class ShareFacilitiesAction {

	@Autowired
	private ShareFacilitiesService shareFacilitiesService;
	/**
	 * 日志记录器.
	 */
	private static final Logger logger = Logger.getLogger("ShareFacilities");

	/**
	 * 跳转到首页
	 */
	@RequestMapping("/sharefacilities/index")
	public String index(Model model) {
		model.addAttribute("banks", DataHolder.dataMap.get("bank"));
		model.addAttribute("communitys", DataHolder.communityMap);
		return "/draw/sharefacilities/index";
	}
	/**
	 * 查询公共设施收益分摊信息
	 */
	@RequestMapping("/sharefacilities/list")
	public void list(@RequestBody ReqPamars<ShareFacilities> req, HttpServletRequest request,
			HttpServletResponse response)throws IOException{
		// 添加操作日志
		LogUtil.write(new Log("公共设施收益分摊", "查询", "ShareFacilitiesAction.list", req.toString()));
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
	 * 跳转到新增公共设施收益分摊页面
	 */
	@RequestMapping("/sharefacilities/toAdd")
	public String add(Model model) {
		model.addAttribute("banks", DataHolder.dataMap.get("bank"));
		model.addAttribute("communitys", DataHolder.communityMap);
		return "/draw/sharefacilities/add";
	}
	
	/**
	 * 保存新增公共设施收益分摊页面
	 */
	@RequestMapping("/sharefacilities/add")
	public String save(ShareFacilities shareFacilities, HttpServletRequest request,
			Model model, RedirectAttributes redirectAttributes) {
		// 添加操作日志
		LogUtil.write(new Log("公共设施收益分摊", "添加", "ShareFacilitiesAction.add", shareFacilities.toString()));
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
		paramMap.put("incomeType", "1");
		paramMap.put("result", "");
		
		shareFacilitiesService.saveFacilities(paramMap);
		int result = Integer.valueOf(paramMap.get("result").toString());
		if(result==0){
			redirectAttributes.addFlashAttribute("msg","新增公共设施收益分摊成功！");
			return "redirect:/sharefacilities/index";
		}else{
			redirectAttributes.addFlashAttribute("msg","新增公共设施收益分摊失败！");
			return "redirect:/sharefacilities/add";
		}
	}
	
	/**
	 * 删除公共设施收益分摊信息(可进行批量删除)
	 */
	@RequestMapping("/sharefacilities/delshare")
	public String delshare(HttpServletRequest request, Model model,RedirectAttributes redirectAttributes) {
		// 通过request接收页面传递过来要删除的编码(bm)数据
		String paras=request.getParameter("bms");
		if(paras.isEmpty()){
			redirectAttributes.addFlashAttribute("msg","获取数据异常，请稍候重试！");
        	return  "redirect:/sharefacilities/index";
		}
		// 添加操作日志
		LogUtil.write(new Log("公共设施收益分摊", "删除", "ShareFacilitiesAction.delshare", paras));
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
		return  "redirect:/sharefacilities/index";
	}
	
	/**
	 * 公共设施收益分摊打印(业主利息收益分摊打印)
	 * */
	@RequestMapping("/sharefacilities/print")
	public ByteArrayOutputStream pdfShareFacilities(HttpServletRequest request, HttpServletResponse response, Model model,
			RedirectAttributes redirectAttributes) {
		ByteArrayOutputStream ops = null;
		ShareFacilities result = null;
		String bm = request.getParameter("bm");
		// 添加操作日志
		LogUtil.write(new Log("公共设施收益分摊", "打印", "ShareFacilitiesAction.print", bm));
		try {
			result = shareFacilitiesService.pdfShareFacilities(bm);
			ShareFacilitiesPDF pdf = new ShareFacilitiesPDF();
			String title = "物业专项维修资金公共设施收益分摊交款收据";
			// 判断是否江津
//			if (logicService.getobject("queryIsJJ") != null) {
//				// 江津
//				title = "重庆市江津区" + title;
//			}
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
	@RequestMapping("/sharefacilities/share")
	public String share(HttpServletRequest request,Model model) {
		String bm = request.getParameter("bm");
		// 根据编码bm获取公共设施分摊信息
		ShareFacilities shareFacilities = shareFacilitiesService.pdfShareFacilities(bm);
		model.addAttribute("shareFacilities", shareFacilities);
		return "/draw/sharefacilities/share";
	}
	/**
	 * 修改分摊金额
	 * @throws Exception
	 */
	@RequestMapping("/sharefacilities/update")
	public void update(String bm, String h001, String ftje) throws Exception {
		try {
			String userid = TokenHolder.getUser().getUserid();
			Map<String, String> map = new HashMap<String, String>();
			map.put("h001", h001);
			map.put("ftje", ftje);
			map.put("bm", bm);
			map.put("userid", userid);
			// 添加操作日志
			LogUtil.write(new Log("公共设施收益分摊", "修改分摊金额", "ShareFacilitiesAction.update", map.toString()));
			shareFacilitiesService.updateShareFacilities(map);
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e.getMessage());
			throw e;
		}
	}
	/**
	 * 将收益金额分摊到选中的房屋上
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping("/sharefacilities/shareFacilitiesI")
	public void shareFacilitiesI(String h001s, String bm, String sqje, String ftfs,
			String incomeAmount, String businessDate, String bankCode,String bankName,
			HttpServletResponse response) throws Exception {
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		Map<String, String> map = new HashMap<String, String>();
		map.put("h001s", h001s);
		map.put("bm", bm);
		map.put("ftfs", ftfs);
		map.put("sqje", sqje);
		map.put("incomeAmount", incomeAmount);
		map.put("businessDate", businessDate);
		map.put("bankCode", bankCode);
		map.put("bankName", bankName);
		map.put("userid", TokenHolder.getUser().getUserid());
		map.put("username", TokenHolder.getUser().getUsername());
		// 添加操作日志
		LogUtil.write(new Log("公共设施收益分摊", "分摊", "ShareFacilitiesAction.shareFacilitiesI", map.toString()));
		shareFacilitiesService.shareFacilitiesI1(map);
		List<ShareAD> list = shareFacilitiesService.shareFacilitiesI2(map);
		
		pw.print(JsonUtil.toJson(list));
	}
	
	/**
	 * 保存收益金额分摊
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping("/sharefacilities/save")
	public void save(String bm,HttpServletResponse response) throws Exception {
		int result=-1;
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		Map<String, String> map = new HashMap<String, String>();
		map.put("bm", bm);
		map.put("result", "");
		map.put("w008", "");
		map.put("userid", TokenHolder.getUser().getUserid());
		map.put("username", TokenHolder.getUser().getUsername());
		// 添加操作日志
		LogUtil.write(new Log("公共设施收益分摊", "保存分摊", "ShareFacilitiesAction.save", map.toString()));
		shareFacilitiesService.saveShareFacilitiesI(map);
		result = Integer.valueOf(map.get("result").toString());
		pw.print(JsonUtil.toJson(result));
	}

	/**
	 * 获取已分摊信息
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping("/sharefacilities/getShare")
	public void getShare(String businessNO, HttpServletResponse response) throws Exception {
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		Map<String, String> map = new HashMap<String, String>();
		map.put("BusinessNO", businessNO);
		map.put("result", "0");
		// 添加操作日志
		LogUtil.write(new Log("公共设施收益分摊", "获取已分摊信息", "ShareFacilitiesAction.getShare", map.toString()));
//		System.out.println("map="+map);
		List<ShareInterest> list = shareFacilitiesService.getShareInterest(map);
//		System.out.println("list="+list);
		pw.print(JsonUtil.toJson(list));
	}
}

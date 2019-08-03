package com.yaltec.wxzj2.biz.payment.action;

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
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.yaltec.comon.auth.TokenHolder;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.comon.core.entity.ReqPamars;
import com.yaltec.comon.log.LogUtil;
import com.yaltec.comon.log.entity.Log;
import com.yaltec.comon.utils.DateUtil;
import com.yaltec.comon.utils.JsonUtil;
import com.yaltec.wxzj2.biz.payment.entity.BatchPayment;
import com.yaltec.wxzj2.biz.payment.entity.HousedwImport;
import com.yaltec.wxzj2.biz.payment.entity.QryHouseUnit;
import com.yaltec.wxzj2.biz.payment.service.BatchPaymentService;
import com.yaltec.wxzj2.biz.property.entity.Building;
import com.yaltec.wxzj2.biz.property.service.BuildingService;
import com.yaltec.wxzj2.biz.property.service.HouseDwService;
import com.yaltec.wxzj2.biz.system.entity.User;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 批量交款实现类
 * @ClassName: BatchPaymentAction 
 * @author 重庆亚亮科技有限公司 txj 
 * @date 2016-8-25 下午02:45:05
 */
@Controller
public class BatchPaymentAction {
	@Autowired
	private BatchPaymentService batchPaymentService;
	@Autowired
	private HouseDwService houseDwService;
	@Autowired
	private BuildingService buildingService;
	
	
	/**
	 * 跳转到首页
	 */
	@RequestMapping("/batchpayment/index")
	public String index(Model model) {
		model.addAttribute("communitys", DataHolder.communityMap);
		return "/payment/batchpayment/index";
	}
	
	/**
	 * 查询交款列表
	 */
	@RequestMapping("/batchpayment/list")
	public void list(@RequestBody ReqPamars<QryHouseUnit> req, HttpServletRequest request,
			HttpServletResponse response) throws IOException {	
		//获取查询条件
		Map<String, Object> paramMap = req.getParams();
		//判断结束日期		
		if(paramMap.get("edate")==null || String.valueOf(paramMap.get("edate")).equals("")){
			paramMap.put("edate",DateUtil.getCurrTime("yyyy-MM-dd"));
		}
		// 根据用户获取归集中心
		paramMap.put("userid",TokenHolder.getUser().getUserid());
		paramMap.put("result", "-1");
		//查询分页
		Page<QryHouseUnit> page = new Page<QryHouseUnit>(req.getEntity(), req.getPageNo(), req.getPageSize());
		batchPaymentService.queryQryUnitSterilisation(page, paramMap);	
		LogUtil.write(new Log("批量交款", "查询", "BatchPaymentAction.list", paramMap.toString()));
		//返回数据
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 返回结果
		pw.print(page.toJson());
	}
	
	/**
	 * 跳转到添加界面
	 * @param model
	 * @return
	 */
	@RequestMapping("/batchpayment/toAdd")
	public String toAdd(HttpServletRequest request,Model model) {
		String w008=request.getParameter("w008");
		if(w008==null){
			w008="";
		}
		model.addAttribute("w008",w008);
		//开发公司
		model.addAttribute("kfgss", DataHolder.dataMap.get("developer"));
		//小区
		model.addAttribute("communitys", DataHolder.communityMap);
		//银行
		model.addAttribute("banks", DataHolder.dataMap.get("bank"));
		return "/payment/batchpayment/add";
	}
	
	/**
	 * 根据开发公司bm获取公司余额
	 * @param request
	 * @param model
	 * @param response
	 * @throws IOException
	 */
	@RequestMapping("/batchpayment/getDWYE")
	public void getDWYE(HttpServletRequest request,
			Model model,HttpServletResponse response)throws IOException {
		Map<String, Object> map=new HashMap<String, Object>();
		//获取参数
		String kfgs=request.getParameter("kfgsbm");
		String ye=batchPaymentService.getDWYE(kfgs);
		if(ye==null || ye.equals("")){
			ye="0.00";
		}
		List<Building> list=buildingService.findXqByKfgs(kfgs);
		LogUtil.write(new Log("批量交款", "获取开发公司的余额", "BatchPaymentAction.getDWYE", kfgs));
		map.put("ye",ye);
		map.put("list", list);
		//返回数据
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		pw.print(JsonUtil.toJson(map));
	}
	
	/**
	 * 清空连续业务编号
	 */
	@RequestMapping("/batchpayment/clear")
	public void clearBusinessContinuity(HttpServletRequest request,HttpServletResponse response)throws IOException {
		User user=TokenHolder.getUser();
		//清空用户缓存的业务编号
		PaymentAction.businessContinuityMap.put(user.getUserid(),"");
		//返回数据
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		pw.print("1");
	}	
	
	/**
	 * 读取验证文件数据【HouseUnitAction.saveToTemp】
	 * @param request
	 * @param model
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping("/batchpayment/savetotemp")
	public void saveToTemp(HttpServletRequest request,BatchPayment batchPayment,HttpServletResponse response)throws IOException {	
		
		if(batchPayment.getUnitcode()!=null && ! batchPayment.getUnitcode().equals("")){
			batchPayment.setUnitname(DataHolder.dataMap.get("assignment").get(batchPayment.getUnitcode()));
		}
		if(batchPayment.getYhbh()!=null && !batchPayment.getYhbh().equals("")){
			batchPayment.setYhmc(DataHolder.dataMap.get("bank").get(batchPayment.getYhbh()));
		}	
		if(batchPayment.getLybh()!=null && !batchPayment.getLybh().equals("")){
			//batchPayment.setLymc(DataHolder.dataMap.get("lybh").get(batchPayment.getLybh()));
			batchPayment.setLymc(request.getParameter("lymc"));
		}
		Map<String, Object> map= houseDwService.readImportHousedw(batchPayment);
		LogUtil.write(new Log("批量交款", "保存数据到临时表", "BatchPaymentAction.savetotemp",batchPayment.toString()));
		
		//返回数据
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		pw.print(JsonUtil.toJson(map));
	}
	
	/**
	 * 读取临时表数据【HouseUnitAction.readtemp】
	 * @param req
	 * @param request
	 * @param response
	 * @throws IOException
	 */
	@RequestMapping("/batchpayment/readtemp")
	public void readtemp(@RequestBody ReqPamars<HousedwImport> req, HttpServletRequest request,
			HttpServletResponse response) throws IOException {	
		//获取查询条件
		Map<String, Object> paramMap = req.getParams();
		//查询分页
		Page<HousedwImport> page = new Page<HousedwImport>(req.getEntity(), req.getPageNo(), req.getPageSize());
		LogUtil.write(new Log("批量交款", "读取临时表数据", "BatchPaymentAction.readtemp",paramMap.toString()));
		houseDwService.readTemp(page, paramMap);		
		//返回数据
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 返回结果
		pw.print(page.toJson());
	}
	
	
	/**
	 * 保存导入的数据
	 * @param request
	 * @param batchPayment
	 * @param model
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping("/batchpayment/add")
	public String add(HttpServletRequest request,BatchPayment batchPayment, Model model, 
			RedirectAttributes redirectAttributes) {	
		Map<String,String> map = batchPayment.toMap();		
		map.put("userid", TokenHolder.getUser().getUserid());		
		map.put("kfgsmc",  DataHolder.dataMap.get("developer").get(map.get("kfgsbm")));
		map.put("yhmc", DataHolder.dataMap.get("bank").get(map.get("yhbh")) );
		map.put("rNote", "");
		map.put("result", "");		
		int result = batchPaymentService.saveImportBatchPaymentExcel(map);
		LogUtil.write(new Log("批量交款", "临时表数据保存到交款库", "BatchPaymentAction.add",map.toString()));
		if (result == 0) {
			redirectAttributes.addFlashAttribute("msg", "保存成功！");
			return "redirect:/batchpayment/index";
		} else {
			if(result==1){
				model.addAttribute("msg", "此楼已存在单元层房号相同的房屋，请检查！");
			}else if(result==2){	
				model.addAttribute("msg", "同一房屋同一日期不能交两次款，请检查！");
			}else{
				model.addAttribute("msg", "保存失败！");
			}
			model.addAttribute("batchPayment", batchPayment);
			model.addAttribute("w008", batchPayment.getW008());
			model.addAttribute("assignment", DataHolder.dataMap.get("assignment"));
			model.addAttribute("communitys", DataHolder.communityMap);
			return "/payment/batchpayment/add";		
		}
	}	
	
	/**
	 * 删除批量交款
	 * @param request
	 * @param batchPayment
	 * @param model
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping("/batchpayment/toDel")
	public String del(HttpServletRequest request,BatchPayment batchPayment, Model model, 
			RedirectAttributes redirectAttributes) {	
		Map<String,String> map = batchPayment.toMap();
		map.put("bm",request.getParameter("p004"));		
		map.put("userid", TokenHolder.getUser().getUserid());		
		map.put("username",TokenHolder.getUser().getUsername());
		map.put("flag", "12");
		map.put("result", "-1");		
		int result = batchPaymentService.delBatchPayment(map);
		LogUtil.write(new Log("批量交款", "删除批量交款", "BatchPaymentAction.del",map.toString()));
		if (result == 0) {
			redirectAttributes.addFlashAttribute("msg", "删除成功！");
			return "redirect:/batchpayment/index";
		} else {
			model.addAttribute("msg", "删除失败！");
			redirectAttributes.addFlashAttribute("batchPayment", batchPayment);
			return "redirect:/batchpayment/index";			
		}
	}
	
}

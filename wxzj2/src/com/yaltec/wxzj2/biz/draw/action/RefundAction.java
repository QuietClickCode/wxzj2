package com.yaltec.wxzj2.biz.draw.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
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
import com.yaltec.comon.utils.JsonUtil;
import com.yaltec.comon.utils.Urlencryption;
import com.yaltec.wxzj2.biz.draw.entity.CodeName;
import com.yaltec.wxzj2.biz.draw.entity.Refund;
import com.yaltec.wxzj2.biz.draw.service.RefundService;
import com.yaltec.wxzj2.biz.property.entity.House;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 
 * @ClassName: RefundAction
 * @Description: TODO业主退款实现类
 * 
 * @author yangshanping
 * @date 2016-8-2 下午03:46:13
 */
@Controller
public class RefundAction {

	@Autowired
	private RefundService refundService;

	/**
	 * 跳转到首页
	 */
	@RequestMapping("/refund/index")
	public String index(Model model) {
		model.addAttribute("communitys", DataHolder.communityMap);
		return "/draw/refund/index";
	}
	/**
	 * 查询业主退款信息列表(ajax调用)
	 * @param req 从第几条数据库开始算(+每页显示的条数)
	 * @param limit 每页显示的条数，相当于pageSize
	 * @param user 查询条件
	 * @throws IOException
	 */
	@RequestMapping("/refund/list")
	public void find(@RequestBody ReqPamars<Refund> req, HttpServletRequest request,
			HttpServletResponse response)throws IOException {
		// 添加操作日志
		LogUtil.write(new Log("业主退款", "查询", "RefundAction.list", req.toString()));
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 获取页面传入的查询条件，并存入map集合
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("xqbh", req.getParams().get("xqbh") == null ? "" : req.getParams().get("xqbh"));
		paramMap.put("lybh",req.getParams().get("lybh") == null ? "" : req.getParams().get("lybh"));
		paramMap.put("enddate", req.getParams().get("z018") == null ? "" : req.getParams().get("z018"));
		paramMap.put("begindate", req.getParams().get("z018") == null ? "" : req.getParams().get("z018"));
		paramMap.put("username", TokenHolder.getUser().getUsername());
		paramMap.put("sfsh", req.getParams().get("sfsh") == null ? "2" : req.getParams().get("sfsh"));
		paramMap.put("result", "");
		
		
		Page<Refund> page = new Page<Refund>(req.getEntity(), req.getPageNo(), req.getPageSize());
		refundService.find(page, paramMap);
		// 返回结果
		pw.print(page.toJson());
	}

	/**
	 * 删除业主退款
	 * 
	 * @throws Exception
	 */
	@RequestMapping("/refund/delRefund")
	public String delete(String p004,String h001,
			HttpServletResponse response, RedirectAttributes redirectAttributes){
		// 添加操作日志
		LogUtil.write(new Log("业主退款", "删除", "RefundAction.delRefund", p004+","+h001));
		
		// 获取页面传值，并按逗号","分割
//		String queryString = request.getParameter("queryString");
//		String[] list = queryString.split("\\,");
//		String p004 = list[0];
//		String h001 = list[1];
		String userid = TokenHolder.getUser().getUserid();
		String username = TokenHolder.getUser().getUsername();
		int result = Integer.valueOf(refundService.delRefund(p004, h001,
				userid, username));
		if (result >= 1) {
			redirectAttributes.addFlashAttribute("msg", "删除成功！");
		} else if (result == -5) {
			redirectAttributes.addFlashAttribute("msg", "操作员只能删除自己的业务，请检查！");
		} else if (result == -1) {
			redirectAttributes.addFlashAttribute("msg", "已经审核的业务不能删除！");
		} else {
			redirectAttributes.addFlashAttribute("msg", "删除失败，请稍候重试！");
		}
		return "redirect:/refund/index";
	}

	/**
	 * 增加信息
	 */
	@RequestMapping("/refund/toAdd")
	public String toAdd(String z008, Model model,House house) {
		model.addAttribute("kfgss", DataHolder.dataMap.get("developer"));
		model.addAttribute("yhmcs", DataHolder.dataMap.get("bank"));
		model.addAttribute("house", house);
		model.addAttribute("communitys", DataHolder.communityMap);
		model.addAttribute("z008", z008);
		return "/draw/refund/add";
	}

	/**
	 * 保存业主退款
	 * @throws IOException 
	 * 
	 */
	@RequestMapping("/refund/saveRefund")
	public void save(HttpServletRequest request,HttpServletResponse response, Model model) throws IOException{
		// 添加操作日志
		// 将页面传递过来的参数，按逗号进行分割，存放在数组中
		Map<String,String> paramMap = JsonUtil.toObject(request.getParameter("data"), HashMap.class);
		paramMap.put("userid", TokenHolder.getUser().getUserid());
		paramMap.put("username", TokenHolder.getUser().getUsername());
		paramMap.put("result", "-1");
		LogUtil.write(new Log("业主退款", "添加", "RefundAction.saveRefund", paramMap.toString()));
		// 获取银行余额
		Double yhye = refundService.getYHYEForRefund(paramMap.get("yhbh"));
		String msg = "0";
		if (((yhye < Double.valueOf(paramMap.get("F_tkje")))) && paramMap.get("sftq")=="1" ) {
			msg = "银行余额不足，请重新选择银行！";
			return ;
    	}else{
			// 检查未入账业务
    		Map<String, String> map=new HashMap<String, String>();
    		map.put("h001", paramMap.get("h001"));
    		map.put("result", "");
    		// 查询
    		refundService.checkHouseForRefund(map);
    		int re = Integer.valueOf(map.get("result"));
    		if(re == 0){
    			int result=Integer.valueOf(refundService.saveRefund(paramMap));
    			if (result == 0) {
    	        } else if (result == 4) {
    	        	msg = "退款日期不能小于最后一次交款日期！";
    		    } else if (result == 5) {
    		    	msg = "此房屋不存在，请确定！";
    	        } else if (result == 6) {
    	        	msg = "此住房存在未入账业务，请入账后再来进行此项操作！";
    	        } else if (result == 7) {
    	        	msg = "此住房已退款，但尚未入账！";
    	        } else if (result == 8) {
    	        	msg = "退款日期不能小于该房屋最后一笔交款日期！";
    	        } else if (result == 9) {
    	        	msg = "该发票还未启用，请检查！";
    	        } else if (result == 10) {
    	        	msg = "该发票已用或者已作废，请检查！";
    	        } else {
    	        	msg = "保存失败，请稍候重试！";
    	        }
    		}
    		if (re == 1) {
    			msg = "此房屋存在交款和支取未入账，请在退款前处理完遗留事务！";
	        }
	        if (re == 2) {
	        	msg = "此房屋存在交款未入账，请在退款前处理完遗留事务！";
	        }
	        if (re == 3) {
	        	msg = "此房屋存在支取未入账，请在退款前处理完遗留事务！";
	        }
    	}

		PrintWriter pw = response.getWriter();
		// 返回结果
		pw.print(JsonUtil.toJson(msg));
	}

	/**
	 * 查询房屋信息
	 * @throws Exception 
	 */
	@RequestMapping("/refund/getHouseForRefund")
	public void getHouse(String h001,HttpServletResponse response) throws Exception {
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 查询
		House house = refundService.getHouseForRefund(h001);
		pw.print(JsonUtil.toJson(house));
	}
	
	/**
	 * 获取最后一次交款的银行
	 */
	@RequestMapping("/refund/getBankByH001")
	public void getBank(String h001,HttpServletResponse response) throws Exception {
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 查询
		CodeName codeName = refundService.GetBankByH001(h001);
		
		pw.print(JsonUtil.toJson(codeName));
	}

}

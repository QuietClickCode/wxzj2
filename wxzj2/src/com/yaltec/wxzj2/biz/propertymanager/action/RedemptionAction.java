package com.yaltec.wxzj2.biz.propertymanager.action;

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
import com.yaltec.wxzj2.biz.property.entity.House;
import com.yaltec.wxzj2.biz.propertymanager.entity.ChangeProperty;
import com.yaltec.wxzj2.biz.propertymanager.service.RedemptionService;
import com.yaltec.wxzj2.biz.propertymanager.service.export.ExportHousingFill;
import com.yaltec.wxzj2.comon.data.DataHolder;


/**
 * 房屋换购实现类
 * @ClassName: RedemptionAction 
 * @author 重庆亚亮科技有限公司 hqx 
 * @date 2016-8-8 下午03:26:20
 */
@Controller
public class RedemptionAction {
	
	@Autowired
	private RedemptionService redemptionservice;
	
	/**
	 * 房屋换购信息
	 * @param request
	 * @param model
	 * @param house
	 * @return
	 */
	@RequestMapping("/redemption/index")
	public String index(HttpServletRequest request,Model model,House house) {
		model.addAttribute("house", house);
		model.addAttribute("communitys", DataHolder.communityMap);
		model.addAttribute("h012", DataHolder.dataMap.get("houseproperty"));
		model.addAttribute("h023", DataHolder.dataMap.get("deposit"));
		return "/propertymanager/redemption/index";
	}
	
	/**
	 * 保存房屋换购信息
	 * @param request
	 * @param model
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping("/redemption/save")
	public String save(HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
		String paras = request.getParameter("str");
		if (paras.isEmpty()) {
			redirectAttributes.addFlashAttribute("msg", "获取数据异常，请请检查重试！");
			return "redirect:/redemption/index";
		}
		// 将编码按逗号进行分割
		String[] bms = paras.split(";");
		bms[1]=Urlencryption.unescape(bms[1]);
		bms[2]=Urlencryption.unescape(bms[2]);
		bms[5]=Urlencryption.unescape(bms[5]);
		bms[7]=Urlencryption.unescape(bms[7]);
		Map<String,String> paramMap=new HashMap<String,String>();
		paramMap.put("h001a",bms[0]);
		paramMap.put("h001b",bms[1]);
		paramMap.put("yhbh",bms[2]);//为空
		paramMap.put("yhmc",bms[3]);//为空
		paramMap.put("h011",bms[4]);
		paramMap.put("h012",bms[5]);
		paramMap.put("h022",bms[6]);
		paramMap.put("h023",bms[7]);
		paramMap.put("w003",bms[8]);
		paramMap.put("sbje",bms[9]);
		paramMap.put("h006",bms[10]);
		paramMap.put("h010",bms[11]);
		paramMap.put("h021",bms[12]);
		paramMap.put("userid", TokenHolder.getUser().getUserid());
		paramMap.put("username", TokenHolder.getUser().getUsername());
		int result = -1;
		try {
			// 添加操作日志
			LogUtil.write(new Log("产权管理_房屋换购", "保存房屋换购信息", "RedemptionAction.save",paramMap.toString()));
			String _result=redemptionservice.checkForsaveRedemption(paramMap);
			if(_result==""||_result==null){
				paramMap.put("result", "");
				result=redemptionservice.saveRedemption(paramMap);
				if (result == 0) {
					redirectAttributes.addFlashAttribute("msg", "保存成功!");
				} else if(result == 5) {
					redirectAttributes.addFlashAttribute("msg","原住房存在未入账业务，请入账后再来进行此项操作！");
		        } else if(result == 6) {
		        	redirectAttributes.addFlashAttribute("msg","房屋换购存在未入账业务，请入账后再来进行此项操作！");
				/*
				if (result == 0) {
					StringBuffer content = new StringBuffer("");
					content.append("保存房屋换购：保存了原房屋编号为：").append(map.get("h001a")).append("，新房屋编号为：").append(
							map.get("h001b")).append(" 的房屋换购业务");
					logicService.writeSyslog(map.get("userid").toString(), map.get("username").toString(), content
							.toString());
					content.setLength(0);
					}
				*/
		        }else{
		        	redirectAttributes.addFlashAttribute("msg","保存失败，请稍候重试！");
		        }
			}
		} catch (Exception e) {
			redirectAttributes.addFlashAttribute("msg", "换购日期不能小于原房屋交款日期！");
			e.printStackTrace();
		}
		return "redirect:/redemption/index";
	}
	
	/**
	 * 导出换购补交信息
	 * @param request
	 * @param changeProperty
	 * @param response
	 */
	@RequestMapping("/redemption/forHouseUnit")
	public void exportForHouseUnit(HttpServletRequest request,String yjje,String ybje,String h001,ChangeProperty changeProperty,HttpServletResponse response) {
		response.setCharacterEncoding("utf-8");
		Map<String, String> map= new HashMap<String, String>();
		map.put("h001",h001 );
		map.put("result", "");

		List<House> house = null;
		try {
			// 添加操作日志
			LogUtil.write(new Log("产权管理_房屋换购", "导出换购补交信息", "RedemptionAction.exportForHouseUnit",map.toString()));
			house = redemptionservice.exportForHouseUnit(map);
			ExportHousingFill.exportHouseUnit(house, response,ybje,yjje);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
}	

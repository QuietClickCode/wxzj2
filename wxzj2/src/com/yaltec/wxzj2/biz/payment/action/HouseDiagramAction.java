package com.yaltec.wxzj2.biz.payment.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.yaltec.comon.auth.TokenHolder;
import com.yaltec.comon.log.LogUtil;
import com.yaltec.comon.log.entity.Log;
import com.yaltec.comon.utils.JsonUtil;
import com.yaltec.wxzj2.biz.payment.entity.HouseDw;
import com.yaltec.wxzj2.biz.payment.entity.HouseUpdate;
import com.yaltec.wxzj2.biz.payment.service.HouseDiagramService;
import com.yaltec.wxzj2.biz.payment.service.impl.HouseDiagramServiceImpl;
import com.yaltec.wxzj2.biz.property.entity.House;
import com.yaltec.wxzj2.biz.property.service.HouseDwService;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 楼盘信息实现类
 * 
 * @ClassName: HouseDiagramAction
 * @author 重庆亚亮科技有限公司 txj
 * @date 2016-8-29 下午02:08:10
 */
@Controller
public class HouseDiagramAction {
	@Autowired
	private HouseDiagramService houseDiagramService;
	@Autowired
	private HouseDwService houseDwService;

	/**
	 * 跳转到首页
	 */
	@RequestMapping("/housediagram/index")
	public String index(Model model) {
		model.addAttribute("projects", DataHolder.dataMap.get("project"));
		model.addAttribute("role", TokenHolder.getUser().getRole().getBm());
		// 房屋类型
		model.addAttribute("housetype", DataHolder.dataMap.get("housetype"));
		// 交存标准
		model.addAttribute("deposit", DataHolder.dataMap.get("deposit"));
		// 归集中心
		model.addAttribute("assignment", DataHolder.dataMap.get("assignment"));
		model.addAttribute("communitys", DataHolder.communityMap);
		return "/payment/housediagram/index";
	}

	/**
	 * 楼盘显示信息
	 */
	@RequestMapping("/housediagram/showtable")
	public void showtable(HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		// 获取参数
		String xmbm = request.getParameter("xmbm");
		String xqbh = request.getParameter("xqbh");
		String lybh = request.getParameter("lybh");
		String status = request.getParameter("status");
		String pageSize = request.getParameter("pageSize");
		String pageNum = request.getParameter("pageNum");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("xmbm", xmbm);
		map.put("xqbh", xqbh);
		map.put("lybh", lybh);
		map.put("status", status);
		map.put("pageSize", pageSize);
		map.put("pageNum", pageNum);
		// 判断房屋数据来源
		map.put("isPropertyport", DataHolder.getParameter("27") ? "1" : "0");
		LogUtil.write(new Log("楼盘信息", "查询", "HouseDiagramAction.showtable", map.toString()));
		map = houseDiagramService.getShowTableByLR(map);

		// 返回数据
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		pw.print(JsonUtil.toJson(map));
		// 清空创建的所有list
		for (List<?> list : HouseDiagramServiceImpl.lists) {
			list.clear();
		}
		map.clear();
	}

	/**
	 * 楼盘显示合计信息
	 */
	@RequestMapping("/housediagram/showtableSum")
	public void showtableSum(HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		// 获取参数
		String xmbm = request.getParameter("xmbm");
		String xqbh = request.getParameter("xqbh");
		String lybh = request.getParameter("lybh");
		String status = request.getParameter("status");
		String pageSize = request.getParameter("pageSize");
		String pageNum = request.getParameter("pageNum");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("xmbm", xmbm);
		map.put("xqbh", xqbh);
		map.put("lybh", lybh);
		map.put("status", status);
		map.put("pageSize", pageSize);
		map.put("pageNum", pageNum);
		LogUtil.write(new Log("楼盘信息", "查询合计",
				"HouseDiagramAction.showtableSum", map.toString()));
		houseDiagramService.getShowTableSum(map);
		// 返回数据
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();

		pw.print(JsonUtil.toJson(map));
		map.clear();

	}

	/**
	 * 房屋改成不交费用
	 * 
	 * @param request
	 * @param response
	 * @throws IOException
	 */
	@RequestMapping("/housediagram/updateHouseDwBJ")
	public void updateHouseDwBJ(HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		// 获取参数
		List<String> paramList = new ArrayList<String>();
		String[] houseids = request.getParameter("houseids").split(",");
		for (String houseid : houseids) {
			if (!houseid.equals("")) {
				paramList.add(houseid);
			}
		}
		int result = houseDwService.updateHouseDwBJ(paramList);
		LogUtil.write(new Log("楼盘信息", "不交款",
				"HouseDiagramAction.updateHouseDwBJ", paramList.toString()));
		// 返回数据
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		pw.print(result);
	}

	/**
	 * 房屋改成要交款
	 * 
	 * @param request
	 * @param response
	 * @throws IOException
	 */
	@RequestMapping("/housediagram/updateHouseDwYJ")
	public void updateHouseDwYJ(HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		// 获取参数
		List<String> paramList = new ArrayList<String>();
		String[] houseids = request.getParameter("houseids").split(",");
		for (String houseid : houseids) {
			if (!houseid.equals("")) {
				paramList.add(houseid);
			}
		}
		int result = houseDwService.updateHouseDwYJ(paramList);
		LogUtil.write(new Log("楼盘信息", "交款",
				"HouseDiagramAction.updateHouseDwYJ", paramList.toString()));
		// 返回数据
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		pw.print(result);
	}

	/**
	 * 修改选中房屋的房屋类型及归集中心等
	 * 
	 * @param request
	 * @param response
	 * @throws IOException
	 */
	@RequestMapping("/housediagram/updateHouse")
	public void updateHouse(HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		// 获取参数
		Map<String, String> paramMap = new HashMap<String, String>();
		paramMap.put("h001s", request.getParameter("h001s"));
		paramMap.put("h017", request.getParameter("h017"));
		paramMap.put("h018", request.getParameter("h018"));
		paramMap.put("h022", request.getParameter("h022"));
		paramMap.put("h023", request.getParameter("h023"));
		paramMap.put("h049", request.getParameter("h049"));
		paramMap.put("h050", request.getParameter("h050"));
		paramMap.put("isupdate", request.getParameter("isupdate"));
		paramMap.put("result", "-1");
		HouseUpdate house = houseDwService.updateHouse(paramMap);
		LogUtil.write(new Log("楼盘信息", "修改房屋交存标准",
				"HouseDiagramAction.updateHouse", paramMap.toString()));
		// 返回数据
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		pw.print(JsonUtil.toJson(house));
	}

	/**
	 * 交款
	 * 
	 * @param request
	 * @param response
	 * @throws IOException
	 */
	@RequestMapping("/housediagram/savePaymentByJK")
	public void savePaymentByJK(HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		// 获取参数
		Map<String, String> paramMap = new HashMap<String, String>();
		paramMap.put("h001s", request.getParameter("h001s"));
		paramMap.put("w013", request.getParameter("w013"));
		paramMap.put("userid", TokenHolder.getUser().getUserid());
		paramMap.put("username", TokenHolder.getUser().getUsername());
		paramMap.put("w010", "GR");
		paramMap.put("w008", "");
		paramMap.put("unitcode", request.getParameter("unitcode"));
		paramMap.put("serialno", "");
		paramMap.put("result", "-1");
		int result = houseDiagramService.savePaymentByJK(paramMap);
		LogUtil.write(new Log("楼盘信息", "交款",
				"HouseDiagramAction.savePaymentByJK", paramMap.toString()));
		// 返回数据
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		pw.print(result);
	}

	/**
	 * 补交
	 * 
	 * @param request
	 * @param response
	 * @throws IOException
	 */
	@RequestMapping("/housediagram/savePaymentByBJ")
	public void savePaymentByBJ(HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		// 获取参数
		Map<String, String> paramMap = new HashMap<String, String>();
		paramMap.put("h001s", request.getParameter("h001s"));
		paramMap.put("h017", request.getParameter("h017"));
		paramMap.put("h018", request.getParameter("h018"));
		paramMap.put("h022", request.getParameter("h022"));
		paramMap.put("h023", request.getParameter("h023"));
		paramMap.put("h049", request.getParameter("h049"));
		paramMap.put("h050", request.getParameter("h050"));
		paramMap.put("w013", request.getParameter("w013"));
		paramMap.put("userid", TokenHolder.getUser().getUserid());
		paramMap.put("username", TokenHolder.getUser().getUsername());
		paramMap.put("w010", "GR");
		paramMap.put("w008", "");
		paramMap.put("serialno", "");
		paramMap.put("result", "-1");
		int result = houseDiagramService.savePaymentByBJ(paramMap);
		LogUtil.write(new Log("楼盘信息", "补交",
				"HouseDiagramAction.savePaymentByBJ", paramMap.toString()));
		// 返回数据
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		pw.print(result);
	}

	/**
	 * 显示房屋信息
	 */
	@RequestMapping("/housediagram/showHouseById")
	public String showHouseById(HttpServletRequest request, Model model) {
		String h001 = request.getParameter("h001");
		House house = houseDwService.findByH001(h001);
		if (DataHolder.customerInfo.isJLP()) {
			model.addAttribute("isjlp", "1");
		} else {
			model.addAttribute("isjlp", "0");
		}
		LogUtil.write(new Log("楼盘信息", "房屋信息",
				"HouseDiagramAction.showHouseById", h001));
		model.addAttribute("house", house);
		return "/payment/housediagram/showhouse";
	}

	/**
	 * 房屋变更信息
	 * 
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping("/housediagram/showHouseChangeById")
	public String showHouseChangeById(HttpServletRequest request, Model model) {
		return "/payment/housediagram/showhousechange";
	}

	@RequestMapping("/housediagram/getTopHouseByXq")
	public void getTopHouseByXq(HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		String xqbh = request.getParameter("xqbh");
		String xmbm = request.getParameter("xmbm");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("xqbh", xqbh);
		map.put("xmbm", xmbm);
		HouseDw houseDw = houseDwService.getTopHouseByXq(map);
		// 返回数据
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		pw.print(JsonUtil.toJson(houseDw));
	}

}

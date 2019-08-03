package com.yaltec.wxzj2.biz.payment.action;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
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
import com.yaltec.wxzj2.biz.payment.entity.HouseDw;
import com.yaltec.wxzj2.biz.payment.entity.HousedwImport;
import com.yaltec.wxzj2.biz.payment.entity.PayToStore;
import com.yaltec.wxzj2.biz.payment.entity.ResultPljk;
import com.yaltec.wxzj2.biz.payment.service.PaymentService;
import com.yaltec.wxzj2.biz.payment.service.export.HouseDwExport;
import com.yaltec.wxzj2.biz.property.entity.Building;
import com.yaltec.wxzj2.biz.property.entity.House;
import com.yaltec.wxzj2.biz.property.service.HouseDwService;
import com.yaltec.wxzj2.biz.property.service.HouseService;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 单位房屋上报实现类
 * 
 * @ClassName: HouseUnitAction
 * @author 重庆亚亮科技有限公司 txj
 * @date 2016-8-8 下午03:26:20
 */
@Controller
public class HouseUnitAction {
	/**
	 * 日志记录器.
	 */
	private static final Logger logger = Logger.getLogger("QueryADAction");
	@Autowired
	private HouseService houseService;
	@Autowired
	private HouseDwService houseDwService;
	@Autowired
	private PaymentService paymentService;

	/**
	 * 跳转到首页
	 */
	@RequestMapping("/houseunit/index")
	public String index(Model model) {
		model.addAttribute("assignment", DataHolder.dataMap.get("assignment"));
		model.addAttribute("communitys", DataHolder.communityMap);
		model.addAttribute("user", TokenHolder.getUser());
		return "/payment/houseunit/index";
	}

	/**
	 * 查询房屋列表
	 */
	@RequestMapping("/houseunit/list")
	public void list(@RequestBody ReqPamars<HouseDw> req,
			HttpServletRequest request, ModelMap model,
			HttpServletResponse response) throws IOException {
		HouseDw houseDw = req.getEntity();
		// 判断结束日期
		if (houseDw.getEnddate() == null || houseDw.getEnddate().equals("")) {
			houseDw.setBegindate("1900-01-01");
			houseDw.setEnddate(DateUtil.getCurrTime("yyyy-MM-dd"));
		}
		// 查询分页
		Page<HouseDw> page = new Page<HouseDw>(houseDw, req.getPageNo(), req
				.getPageSize());
		houseDwService.queryHouseUnit(page);
		LogUtil.write(new Log("单位房屋上报", "查询", "HouseUnitAction.list", houseDw
				.toString()));
		// 返回数据
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		model.put("req", req);
		request.getSession().setAttribute("req", req);
		// System.out.println(request.getSession().getAttribute("req"));
		// 返回结果
		pw.print(page.toJson());
	}

	/**
	 * 统计查询的房屋信息
	 * 
	 * @param request
	 * @param model
	 * @param response
	 * @throws IOException
	 */
	@RequestMapping("/houseunit/houseCountBySearch")
	public void queryHouseCountBySearch(HttpServletRequest request,
			HouseDw houseDw, Model model, HttpServletResponse response)
			throws IOException {
		// 获取参数
		String result = "0";
		if (houseDw.getEnddate() == null || houseDw.getEnddate().equals("")) {
			houseDw.setBegindate("1900-01-01");
			houseDw.setEnddate(DateUtil.getCurrTime("yyyy-MM-dd"));
		}
		LogUtil.write(new Log("单位房屋上报", "查询",
				"HouseUnitAction.queryHouseCountBySearch", houseDw.toString()));
		houseDw = houseDwService.queryHouseCountBySearch(houseDw);
		if (houseDw.getH001().equals("0")) {
			result = "【含物管房】总房屋：0户， 总计建筑面积：0 平方米， 总计应交资金：0 元，总计本金：0 元，总计利息：0元";
		} else {
			String h006 = houseDw.getH006() == null ? "" : houseDw.getH006();
			String h021 = houseDw.getH021() == null ? "" : houseDw.getH021();
			String h030 = houseDw.getH030() == null ? "" : houseDw.getH030();
			String h031 = houseDw.getH031() == null ? "" : houseDw.getH031();
			result = "【含物管房】总房屋：" + houseDw.getH001() + " 户， 总计建筑面积：" + h006
					+ " 平方米， 总计应交资金：" + h021 + " 元，总计本金：" + h030 + " 元，总计利息："
					+ h031 + "元";
		}
		// 返回数据 	
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		pw.print(JsonUtil.toJson(result));
	}

	/**
	 * 打开查询条件
	 * 
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping("/houseunit/tosearch")
	public String tosearch(HttpServletRequest request, Model model) {
		// 交存标准
		model.addAttribute("deposit", DataHolder.dataMap.get("deposit"));
		// 归集中心
		model.addAttribute("assignment", DataHolder.dataMap.get("assignment"));
		// 小区
		model.addAttribute("communitys", DataHolder.communityMap);
		// 房屋性质
		model.addAttribute("h012", DataHolder.dataMap.get("houseproperty"));
		return "/payment/houseunit/indexSearch";
	}

	/**
	 * 打印房屋交款通知书
	 * 
	 * @param request
	 * @param response
	 * @throws IOException
	 */
	@RequestMapping("/houseunit/toPrintHouseUnit")
	public void toPrintHouseUnit(HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		// 获取参数
		String h001s = request.getParameter("h001s");
		List<String> h001List = new ArrayList<String>();
		for (String h001 : h001s.split(",")) {
			if (!h001.equals("")) {
				h001List.add(h001);
			}
		}
		LogUtil.write(new Log("单位房屋上报", "打印缴款通知书",
				"HouseUnitAction.toPrintHouseUnit", h001List.toString()));
		ByteArrayOutputStream ops = houseDwService.toPrintHouseUnit(h001List);
		if (ops != null) {
			paymentService.output(ops, response);
		}
	}

	/**
	 * 打印房屋信息
	 * 
	 * @param request
	 * @param response
	 * @throws IOException
	 */
	@RequestMapping("/houseunit/printHouseInfo")
	public void printHouseInfo(HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		// 获取参数
		String h001s = request.getParameter("h001s");
		List<String> h001List = new ArrayList<String>();
		for (String h001 : h001s.split(",")) {
			if (!h001.equals("")) {
				h001List.add(h001);
			}
		}
		ByteArrayOutputStream ops = houseDwService.printHouseInfo(h001List);
		LogUtil.write(new Log("单位房屋上报", "打印房屋信息",
				"HouseUnitAction.printHouseInfo", h001List.toString()));
		if (ops != null) {
			paymentService.output(ops, response);
		}
	}

	/**
	 * 打印房屋清册
	 * 
	 * @param request
	 * @param response
	 * @throws IOException
	 */
	@RequestMapping("/houseunit/printHouseInfo2")
	public void printHouseInfo2(HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		// 获取参数
		HouseDw houseDw = new HouseDw();
		houseDw.setH049(request.getParameter("h049"));
		houseDw.setXqbh(request.getParameter("xqbh"));
		houseDw.setLybh(request.getParameter("lybh"));
		houseDw.setH001(request.getParameter("h001"));
		houseDw.setH002(request.getParameter("h002"));
		houseDw.setH003(request.getParameter("h003"));
		houseDw.setH005(request.getParameter("h005"));
		houseDw.setH013(request.getParameter("h013"));
		houseDw.setH015(request.getParameter("h015"));
		houseDw.setH047(request.getParameter("h047"));
		houseDw.setH022(request.getParameter("h022"));
		houseDw.setCxlb(request.getParameter("cxlb"));
		houseDw.setH011(request.getParameter("h011"));
		houseDw.setBegindate(request.getParameter("begindate"));
		houseDw.setEnddate(request.getParameter("enddate"));

		// 判断结束日期
		if (houseDw.getEnddate() == null || houseDw.getEnddate().equals("")) {
			houseDw.setBegindate("1900-01-01");
			houseDw.setEnddate(DateUtil.getCurrTime("yyyy-MM-dd"));
		}

		ByteArrayOutputStream ops = houseDwService.printHouseInfo2(houseDw);
		LogUtil.write(new Log("单位房屋上报", "打印房屋清册",
				"HouseUnitAction.printHouseInfo2", houseDw.toString()));
		if (ops != null) {
			paymentService.output(ops, response);
		}
	}

	/**
	 * 判断楼宇下所有房屋是否都交款
	 * 
	 * @param request
	 * @param model
	 * @param response
	 * @throws IOException
	 */
	@RequestMapping("/houseunit/queryCapturePutsStatusBylybh")
	public void queryCapturePutsStatusBylybh(HttpServletRequest request,
			Model model, HttpServletResponse response) throws IOException {
		// 获取参数
		int result = 1;
		String lybh = request.getParameter("lybh");
		LogUtil.write(new Log("单位房屋上报", "判断楼宇下房屋是否全部交款",
				"HouseUnitAction.queryCapturePutsStatusBylybh", lybh));
		int num = houseDwService.queryCapturePutsStatusBylybh(lybh);
		if (num > 0) {
			result = -1;
		} else {
			// 永川判断打印
			if (DataHolder.customerInfo.isYC()) {
				int num_w011 = paymentService.getNotPrintByLybh(lybh);
				if (num_w011 > 0) {
					result = -2;
				}
			}
		}

		// 返回数据
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		pw.print(result);
	}

	/**
	 * 批量判断楼宇下所有房屋是否都交款
	 * 
	 * @param request
	 * @param model
	 * @param response
	 * @throws IOException
	 */
	@RequestMapping("/houseunit/queryCapturePutsStatusBylybhs")
	public void queryCapturePutsStatusBylybhs(HttpServletRequest request,
			Model model, HttpServletResponse response) throws IOException {
		// 获取参数
		int result = 1;
		String lybhs = request.getParameter("lybhs");
		// String lybh = request.getParameter("lybh");
		LogUtil.write(new Log("楼宇信息", "判断楼宇下房屋是否全部交款",
				"HouseUnitAction.queryCapturePutsStatusBylybhs", lybhs
						.toString()));
		Map<String, String> rMap = new HashMap<String, String>();
		rMap.put("result", "0");
		String[] _lybhs = lybhs.split(",");
		for (String lybh : _lybhs) {
			rMap.put("lymc", DataHolder.buildingMap.get(lybh).getLymc());
			int num = houseDwService.queryCapturePutsStatusBylybh(lybh);
			int hs = houseDwService.isHousesBylybh(lybh);
			if(hs==0){
				result = -3;
				rMap.put("result", result + "");
				rMap.put("lymc", DataHolder.buildingMap.get(lybh).getLymc());
				break;
			}
			if (num > 0) {
				result = -1;
				rMap.put("result", result + "");
				rMap.put("lymc", DataHolder.buildingMap.get(lybh).getLymc());
				break;
			} else {
				// 永川判断打印
				if (DataHolder.customerInfo.isYC()) {
					int num_w011 = paymentService.getNotPrintByLybh(lybh);
					if (num_w011 > 0) {
						result = -2;
						rMap.put("result", result + "");
						rMap.put("lymc", DataHolder.buildingMap.get(lybh)
								.getLymc());
						break;
					}
				}
			}
		}
		// // 返回数据
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();

		pw.print(JsonUtil.toJson(rMap));
	}

	/**
	 * 打印交存证明
	 * 
	 * @param request
	 * @param response
	 * @throws IOException
	 */
	@RequestMapping("/houseunit/depositCertificate")
	public void depositCertificate(HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		// 获取参数
		String lybh = request.getParameter("lybh");
		ByteArrayOutputStream ops = houseDwService.depositCertificate(lybh);
		LogUtil.write(new Log("单位房屋上报", "打印交存证明",
				"HouseUnitAction.depositCertificate", lybh));
		if (ops != null) {
			paymentService.output(ops, response);
		}
	}

	/**
	 * 批量打印交存证明
	 * 
	 * @param request
	 * @param response
	 * @throws IOException
	 */
	@RequestMapping("/houseunit/depositCertificateMany")
	public void depositCertificateMany(HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		// 获取参数
		String lybhs = request.getParameter("lybhs");
		ByteArrayOutputStream ops = houseDwService
				.depositCertificateMany(lybhs);
		LogUtil.write(new Log("单位房屋上报", "打印交存证明",
				"HouseUnitAction.depositCertificateMany", lybhs));
		if (ops != null) {
			paymentService.output(ops, response);
		}
	}

	/**
	 * 增加房屋信息
	 */
	@RequestMapping("/houseunit/toAdd")
	public String toAdd(HttpServletRequest request, Model model) {
		model.addAttribute("lymc", DataHolder.buildingMap);
		model.addAttribute("h018", DataHolder.dataMap.get("housetype"));
		model.addAttribute("h012", DataHolder.dataMap.get("houseproperty"));
		model.addAttribute("h033", DataHolder.dataMap.get("housemodel"));
		model.addAttribute("h045", DataHolder.dataMap.get("houseuse"));
		model.addAttribute("h023", DataHolder.dataMap.get("deposit"));
		model.addAttribute("h050", DataHolder.dataMap.get("assignment"));
		return "/payment/houseunit/add";
	}

	/**
	 * 保存房屋信息
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/houseunit/add")
	public String add(House house, HttpServletRequest request, Model model,
			RedirectAttributes redirectAttributes) {
		// 根据楼宇、房屋类型、房屋性质、房屋用途、房屋户型、交存标准和归集中心编号获取相应的value
		house.setLymc(DataHolder.buildingMap.get(house.getLybh()).getLymc());
		house.setH018(DataHolder.dataMap.get("housetype").get(house.getH017()));
		house.setH012(DataHolder.dataMap.get("houseproperty").get(
				house.getH011()));
		house.setH045(DataHolder.dataMap.get("houseuse").get(house.getH044()));
		house
				.setH033(DataHolder.dataMap.get("housemodel").get(
						house.getH032()));
		house.setH023(DataHolder.dataMap.get("deposit").get(house.getH022()));
		house
				.setH050(DataHolder.dataMap.get("assignment").get(
						house.getH049()));
		Map<String, String> map = toMap(house);
		map.put("savetype", "1");
		houseService.save(map);
		LogUtil.write(new Log("单位房屋上报", "保存房屋", "HouseUnitAction.add", map
				.toString()));
		int result = Integer.valueOf(map.get("result"));
		if (result == 0) {
			redirectAttributes.addFlashAttribute("msg", "新增成功！");
			redirectAttributes.addFlashAttribute("returnUrl", "list");
			redirectAttributes.addFlashAttribute("h001", map.get("h001")
					.toString());
			return "redirect:/houseunit/index";
		} else if (result == 8) {
			redirectAttributes.addFlashAttribute("msg",
					"该房屋的单元、层、房号已存在，请检查后重试！");
			redirectAttributes.addFlashAttribute("house", house);
			return "redirect:/houseunit/toAdd";
		} else {
			request.setAttribute("msg", "新增失败！");
			return "redirect:/houseunit/toAdd";
		}
	}

	/**
	 * 编辑房屋信息页面
	 */
	@RequestMapping("/houseunit/toUpdate")
	public String toUpdate(House house, Model model,
			RedirectAttributes redirectAttributes) {
		house = houseDwService.findByH001(house.getH001());
		model.addAttribute("h018", DataHolder.dataMap.get("housetype"));
		model.addAttribute("h012", DataHolder.dataMap.get("houseproperty"));
		model.addAttribute("h033", DataHolder.dataMap.get("housemodel"));
		model.addAttribute("h045", DataHolder.dataMap.get("houseuse"));
		model.addAttribute("h023", DataHolder.dataMap.get("deposit").get(
				house.getH022()));
		model.addAttribute("h050", DataHolder.dataMap.get("assignment"));
		model.addAttribute("house", house);
		return "/payment/houseunit/update";
	}

	/**
	 * 修改房屋信息，成功：重定向到房屋信息列表页面；失败：返回房屋信息修改页面
	 * 
	 * @param message
	 * @param request
	 * @return
	 */
	@RequestMapping("/houseunit/update")
	public String update(House house, Model model,
			RedirectAttributes redirectAttributes) {
		// 根据楼宇、房屋类型、房屋性质、房屋用途、房屋户型、交存标准和归集中心编号获取相应的value
		house.setLymc(DataHolder.buildingMap.get(house.getLybh()).getLymc());
		house.setH018(DataHolder.dataMap.get("housetype").get(house.getH017()));
		house.setH012(DataHolder.dataMap.get("houseproperty").get(
				house.getH011()));
		house.setH045(DataHolder.dataMap.get("houseuse").get(house.getH044()));
		house
				.setH033(DataHolder.dataMap.get("housemodel").get(
						house.getH032()));
		house.setH023(DataHolder.dataMap.get("deposit").get(house.getH022()));
		house
				.setH050(DataHolder.dataMap.get("assignment").get(
						house.getH049()));
		Map<String, String> map = toMap(house);
		map.put("savetype", "2");
		houseService.update(map);
		int result = Integer.valueOf(map.get("result"));
		LogUtil.write(new Log("单位房屋上报", "保存房屋", "HouseUnitAction.update", map
				.toString()));
		if (result == 0) {
			redirectAttributes.addFlashAttribute("msg", "修改成功！");
			redirectAttributes.addFlashAttribute("returnUrl", "list");
			redirectAttributes.addFlashAttribute("h001", house.getH001());
			return "redirect:/houseunit/index";
		} else {
			model.addAttribute("msg", "修改失败！");
			return "/property/houseunit/update";
		}
	}

	/**
	 * 批量删除
	 * 
	 * @param bms
	 * @param request
	 * @param model
	 * @param redirectAttributes
	 * @return
	 * @throws IOException
	 * @throws Exception
	 */
	@RequestMapping("/houseunit/batchDelete")
	public void delete(HttpServletRequest request, HttpServletResponse response)
			throws IOException {
		String h001s = request.getParameter("h001s");
		PrintWriter pw = response.getWriter();
		Map<String, String> paramMap = new HashMap<String, String>();
		paramMap.put("userid", TokenHolder.getUser().getUserid());
		paramMap.put("username", TokenHolder.getUser().getUsername());
		paramMap.put("flag", "6");
		paramMap.put("bm", h001s);
		paramMap.put("result", "-1");
		LogUtil.write(new Log("单位房屋上报", "删除", "HouseUnitAction.delete",
				paramMap.toString()));
		try {
			houseService.delHouse(paramMap);
			pw.print("1");
		} catch (Exception e) {
			// e.printStackTrace();
			String msg = e.getMessage();
			pw.print(msg);
		}
		return;
	}

	/**
	 * 交款查询
	 * 
	 * @param pageNo
	 * @param pageSize
	 * @param house
	 * @param model
	 * @return
	 */
	@RequestMapping("/houseunit/findPaylist")
	public void findPaylist(@RequestBody ReqPamars<ResultPljk> req,
			HttpServletRequest request, HttpServletResponse response)
			throws IOException {
		// 获取查询条件
		Map<String, Object> paramMap = req.getParams();
		// 判断结束日期
		if (String.valueOf(paramMap.get("edate")).equals("")) {
			paramMap.put("edate", DateUtil.getCurrTime("yyyy-MM-dd"));
		}
		// 根据用户获取归集中心
		paramMap.put("userid", TokenHolder.getUser().getUserid());
		paramMap.put("result", "0");
		// 查询分页
		Page<ResultPljk> page = new Page<ResultPljk>(req.getEntity(), req
				.getPageNo(), req.getPageSize());
		paymentService.queryBankJinZhangChan(page, paramMap);
		LogUtil.write(new Log("单位房屋上报", "查询", "HouseUnitAction.findPaylist",
				paramMap.toString()));
		// 返回数据
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 返回结果
		pw.print(page.toJson());
	}

	/**
	 * 批量交款-跳转新增页面
	 * 
	 * @param house
	 * @param model
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping("/houseunit/toAddBusiness")
	public String toAddBusiness(HttpServletRequest request,
			PayToStore payToStore, Model model,
			RedirectAttributes redirectAttributes) {
		String w008 = request.getParameter("w008");
		String ywrq = request.getParameter("ywrq");
		if (w008 == null) {
			w008 = "";
		}
		String unitcode = "";
		// 根据业务编号获取归集中心编码
		if (!w008.equals("")) {
			unitcode = paymentService.getUnitcodeByW008(w008);
		}
		if (DataHolder.getParameter("25")) {
			model.addAttribute("isEdit", "1");
		} else {
			model.addAttribute("isEdit", "0");
		}
		model.addAttribute("unitcode", unitcode);
		model.addAttribute("w008", w008);
		model.addAttribute("ywrq", ywrq);
		model.addAttribute("assignment", DataHolder.dataMap.get("assignment"));
		model.addAttribute("communitys", DataHolder.communityMap);
		return "/payment/houseunit/addBusiness";
	}

	/**
	 * 保存导入数据到临时表【BatchPaymentAction.savetotemp】
	 * 
	 * @param request
	 * @param batchPayment
	 * @param response
	 * @throws IOException
	 */
	@RequestMapping("/houseunit/savetotemp")
	public void saveToTemp(HttpServletRequest request,
			BatchPayment batchPayment, HttpServletResponse response)
			throws IOException {
		if (batchPayment.getUnitcode() != null
				&& !batchPayment.getUnitcode().equals("")) {
			batchPayment.setUnitname(DataHolder.dataMap.get("assignment").get(
					batchPayment.getUnitcode()));
		}
		if (batchPayment.getYhbh() != null
				&& !batchPayment.getYhbh().equals("")) {
			batchPayment.setYhmc(DataHolder.dataMap.get("bank").get(
					batchPayment.getYhbh()));
		}
		Map<String, Object> map = houseDwService
				.readImportHousedw(batchPayment);
		LogUtil.write(new Log("单位房屋上报", "保存数据到临时表",
				"HouseUnitAction.saveToTemp", batchPayment.toString()));

		// 返回数据
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		pw.print(JsonUtil.toJson(map));
	}

	/**
	 * 读取临时表数据【BatchPaymentAction.readtemp】
	 * 
	 * @param req
	 * @param request
	 * @param response
	 * @throws IOException
	 */
	@RequestMapping("/houseunit/readtemp")
	public void readtemp(@RequestBody ReqPamars<HousedwImport> req,
			HttpServletRequest request, HttpServletResponse response)
			throws IOException {
		// 获取查询条件
		Map<String, Object> paramMap = req.getParams();
		// 查询分页
		Page<HousedwImport> page = new Page<HousedwImport>(req.getEntity(), req
				.getPageNo(), req.getPageSize());
		LogUtil.write(new Log("单位房屋上报", "读取临时表数据", "HouseUnitAction.readtemp",
				paramMap.toString()));
		houseDwService.readTemp(page, paramMap);
		// 返回数据
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 返回结果
		pw.print(page.toJson());
	}

	/**
	 * 保存导入的数据
	 * 
	 * @param rquest
	 * @param model
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping("/houseunit/addBusiness")
	public String addBusiness(HttpServletRequest request,
			BatchPayment batchPayment, String unitcode, Model model,
			RedirectAttributes redirectAttributes) {
		redirectAttributes.addFlashAttribute("showTab", "showTab2");
		Map<String, String> map = new HashMap<String, String>();
		map.put("tempCode", batchPayment.getTempCode());
		map.put("userid", TokenHolder.getUser().getUserid());
		map.put("w008", batchPayment.getW008());
		map.put("rNote", "");
		map.put("result", "");
		map.put("", "");
		int result = houseDwService.saveImportHouseUnit(map);
		LogUtil.write(new Log("单位房屋上报", "保存文件数据",
				"HouseUnitAction.addBusiness", map.toString()));
		if (result == 0) {
			// redirectAttributes.addFlashAttribute("succee", "保存成功！");
			// redirectAttributes.addFlashAttribute("showTab", "showTab2");
			model.addAttribute("succee", "保存成功！");
			model.addAttribute("showTab", "showTab2");
			model.addAttribute("batchPayment", batchPayment);
			model.addAttribute("w008", map.get("w008").toString());
			model.addAttribute("assignment", DataHolder.dataMap
					.get("assignment"));
			Map<String, String> map1 = new HashMap<String, String>();
			map1.put("unitcode", unitcode);
			model.addAttribute("unitcode1", JsonUtil.toJson(map1));
			model.addAttribute("communitys", DataHolder.communityMap);
			return "/payment/houseunit/addBusiness";
		} else {
			if (result == 1) {
				model.addAttribute("msg", "此楼已存在单元层房号相同的房屋，请检查！");
			} else if (result == 2) {
				model.addAttribute("msg", "同一房屋同一日期不能交两次款，请检查！");
			} else {
				model.addAttribute("msg", "保存失败！");
			}
			model.addAttribute("showTab", "showTab2");
			model.addAttribute("batchPayment", batchPayment);
			model.addAttribute("w008", batchPayment.getW008());
			model.addAttribute("assignment", DataHolder.dataMap
					.get("assignment"));
			model.addAttribute("communitys", DataHolder.communityMap);
			return "/payment/houseunit/addBusiness";
		}
	}

	/**
	 * 导出单位房屋上报信息
	 * 
	 * @param bm
	 * @param lb
	 * @param xqmc
	 * @param response
	 */
	@RequestMapping("/houseunit/toExportHouse")
	public void exportHouseDw(HttpServletRequest request, HouseDw houseDw,String h001s,
			HttpServletResponse response) {
		response.setCharacterEncoding("utf-8");
		List<HouseDw> list = null;
		HouseDw HouseDwSum = null;
		try {
			// 查询数据，和列表查询一样
			// 判断结束日期
			if (houseDw.getEnddate() == null || houseDw.getEnddate().equals("")) {
				houseDw.setBegindate("1900-01-01");
				houseDw.setEnddate(DateUtil.getCurrTime("yyyy-MM-dd"));
			}
			LogUtil.write(new Log("单位房屋上报", "导出单位房屋上报信息",
					"HouseUnitAction.exportHouseDw", houseDw.toString()));

			if(!houseDw.getLybh().equals("") && !"".equals(h001s)){
				List<HouseDw> resultList = houseDwService.queryHouseUnitByH001s(h001s);
				Building building = DataHolder.buildingMap.get(houseDw
						.getLybh());
				HouseDwSum = new HouseDw();
				int h001sum = 0;
				Double h006sum = 0.0;
				Double h030sum = 0.0;
				for (HouseDw houseDw2 : resultList) {
					h001sum = h001sum + 1;
					h006sum = h006sum + Double.valueOf(houseDw2.getH006());
					h030sum = h030sum + Double.valueOf(houseDw2.getH030());
				}
				HouseDwSum.setH001(String.valueOf(h001sum));
				HouseDwSum.setH006(String.valueOf(h006sum));
				HouseDwSum.setH030(String.valueOf(h030sum));
				HouseDwSum.setKfgsmc(building.getKfgsmc());
				HouseDwSum.setLybh(houseDw.getLybh());
				
				resultList.add(HouseDwSum);
				HouseDwExport.exportHouseDw(resultList, response);
			}else{
				Page<HouseDw> page = new Page<HouseDw>(houseDw, 1, 5000);
				houseDwService.queryHouseUnit(page);
				List<HouseDw> resultList = page.getData();
				
				if (houseDw.getLybh().equals("")) {
					
					// 楼宇、房屋组装集合
					LinkedHashMap<String, List<HouseDw>> mapList = new LinkedHashMap<String, List<HouseDw>>();
					// 记录上一个楼宇编号
					String key = "";
					Building building = null;
					
					// 合计信息
					int h001sum = 0;
					Double h006sum = 0.0;
					Double h030sum = 0.0;
					for (HouseDw _houseDw : resultList) {
						// 一个新的楼宇
						if (!key.equals(_houseDw.getLybh())) {
							// 1：记录上次楼宇合计信息
							if (null != HouseDwSum && null != list
									&& list.size() >= 1) {
								HouseDwSum.setH001(String.valueOf(h001sum));
								HouseDwSum.setH006(String.valueOf(h006sum));
								HouseDwSum.setH030(String.valueOf(h030sum));
								HouseDwSum.setKfgsmc(building.getKfgsmc());
								HouseDwSum.setLybh(key);
								list.add(HouseDwSum);
								// 重置合计信息
								h001sum = 0;
								h006sum = 0.0;
								h030sum = 0.0;
							}
							// 记录新的楼宇信息
							key = _houseDw.getLybh();
							list = new ArrayList<HouseDw>();
							building = DataHolder.buildingMap.get(key);
							HouseDwSum = new HouseDw();
							mapList.put(building.getLymc(), list);
						}
						h001sum = h001sum + 1;
						h006sum = h006sum + Double.valueOf(_houseDw.getH006());
						h030sum = h030sum + Double.valueOf(_houseDw.getH030());
						list.add(_houseDw);
					}
					// 存放最后一个楼宇的合计信息
					if (null != HouseDwSum && null != list && list.size() >= 1) {
						HouseDwSum.setH001(String.valueOf(h001sum));
						HouseDwSum.setH006(String.valueOf(h006sum));
						HouseDwSum.setH030(String.valueOf(h030sum));
						HouseDwSum.setKfgsmc(building.getKfgsmc());
						HouseDwSum.setLybh(key);
						list.add(HouseDwSum);
					}
					HouseDwExport.exportHouseDwByXq(mapList, response);
				} else {
					Building building = DataHolder.buildingMap.get(houseDw
							.getLybh());
					HouseDwSum = new HouseDw();
					int h001sum = 0;
					Double h006sum = 0.0;
					Double h030sum = 0.0;
					for (HouseDw houseDw2 : resultList) {
						h001sum = h001sum + 1;
						h006sum = h006sum + Double.valueOf(houseDw2.getH006());
						h030sum = h030sum + Double.valueOf(houseDw2.getH030());
					}
					HouseDwSum.setH001(String.valueOf(h001sum));
					HouseDwSum.setH006(String.valueOf(h006sum));
					HouseDwSum.setH030(String.valueOf(h030sum));
					HouseDwSum.setKfgsmc(building.getKfgsmc());
					HouseDwSum.setLybh(houseDw.getLybh());
					
					resultList.add(HouseDwSum);
					HouseDwExport.exportHouseDw(resultList, response);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * house转MAP
	 * 
	 * @param
	 * @return
	 */
	private Map<String, String> toMap(House house) {
		Map<String, String> map = new HashMap<String, String>();
		map.put("h001", house.getH001());
		map.put("lybh", house.getLybh());
		map.put("lymc", house.getLymc());
		map.put("h002", house.getH002());
		map.put("h003", house.getH003());
		map.put("h004", house.getH004() == null ? "" : house.getH004());
		map.put("h005", house.getH005());
		map.put("h006", house.getH006());
		map.put("h007", (house.getH007() == null || house.getH007().equals("")) ? "0" : house.getH007());
		map.put("h008", (house.getH008() == null || house.getH008().equals("")) ? "0" : house.getH008());
		map.put("h009", house.getH009());
		map.put("h010", house.getH010());
		map.put("h011", house.getH011());
		map.put("h012", house.getH012());
		map.put("h013", house.getH013());
		map.put("h014", house.getH014() == null ? "" : house.getH014());
		map.put("h015", house.getH015());
		map.put("h016", house.getH016());
		map.put("h017", house.getH017());
		map.put("h018", house.getH018());
		map.put("h019", house.getH019());
		map.put("h020", house.getH020());
		map.put("h021", house.getH021());
		map.put("h022", house.getH022());
		map.put("h023", house.getH023());
		map.put("h024", (house.getH024() == null || house.getH024().equals("")) ? "0" : house.getH024());
		map.put("h025", (house.getH025() == null || house.getH025().equals("")) ? "0" : house.getH025());
		map.put("h026", (house.getH026() == null || house.getH026().equals("")) ? "0" : house.getH026());
		map.put("h027", (house.getH027() == null || house.getH027().equals("")) ? "0" : house.getH027());
		map.put("h028", (house.getH028() == null || house.getH028().equals("")) ? "0" : house.getH028());
		map.put("h029", (house.getH029() == null || house.getH029().equals("")) ? "0" : house.getH029());
		map.put("h030", (house.getH030() == null || house.getH030().equals("")) ? "0" : house.getH030());
		map.put("h031", (house.getH031() == null || house.getH031().equals("")) ? "0" : house.getH031());
		map.put("h032", house.getH032());
		map.put("h033", house.getH033());
		map.put("h036", house.getH036() == null ? "" : house.getH036());
		map.put("h037", house.getH037() == null ? "" : house.getH037());
		map.put("h038", (house.getH038() == null || house.getH038().equals("")) ? "0" : house.getH038());
		map.put("h039", house.getH039() == null ? house.getH021() : house
				.getH039());
		map.put("h040", house.getH040());
		map.put("h041", (house.getH041() == null || house.getH041().equals("")) ? "0" : house.getH041());
		map.put("h042", (house.getH042() == null || house.getH042().equals("")) ? "0" : house.getH042());
		map.put("h043", (house.getH043() == null || house.getH043().equals("")) ? "0" : house.getH043());
		map.put("h044", house.getH044());
		map.put("h045", house.getH045());
		map.put("h046", (house.getH046() == null || house.getH046().equals("")) ? "0" : house.getH046());
		map.put("h047", house.getH047());
		map.put("h048", house.getH048() == null ? "" : house.getH048());
		map.put("h049", house.getH049());
		map.put("h050", house.getH050());
		map.put("h052", house.getH052());
		map.put("h053", house.getH053());
		map.put("userid", TokenHolder.getUser().getUserid());
		map.put("username", TokenHolder.getUser().getUsername());
		map.put("result", "-1");
		return map;
	}

	/**
	 * 导出批量交款查询
	 * 
	 * @param bm
	 * @param lb
	 * @param xqmc
	 * @param response
	 */
	@RequestMapping("/houseunit/exportPayment")
	public void exportPayment(HttpServletRequest request,
			HttpServletResponse response) {
		response.setCharacterEncoding("utf-8");
		Map<String, Object> map = null;
		List<Map<String, String>> list = null;
		// 添加操作日志
		String title = "批量交款信息";
		String[] ZHT = { "业务编号", "小区名称", "楼宇名称", "开发单位", "交款金额", "交款日期",
				"交款银行", "银行账号" };
		String[] ENT = { "p004", "xqmc", "lymc", "kfgsmc", "p008", "p024",
				"unitname", "bankno" };// 输出例
		try {			
			map = JsonUtil.toObject(request.getParameter("data"), HashMap.class);
			LogUtil.write(new Log("单位房屋上报_批量交款查询", "导出",
					"HouseUnitAction.exportPayment", map.toString()));
			// 根据用户获取归集中心
			map.put("userid", TokenHolder.getUser().getUserid());
			list = paymentService.queryBankJinZhangChanNonsort(map);

			if (list.size() == 0) {
				exeException("获取数据失败！", response);
				return;
			}
			HouseDwExport.export(response, list, title, ZHT, ENT);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// 异常提示
	public void exeException(String message, HttpServletResponse response) {
		PrintWriter out = null;
		try {
			response.setContentType("text/html;charset=utf-8");
			out = response.getWriter();
			out.print("<script language='javaScript'>alert('" + message + "');"
					+ "self.close();</script>");
		} catch (Exception e) {
			logger.error(e.getMessage());
		} finally {
			out.flush();
			out.close();
		}
	}
}

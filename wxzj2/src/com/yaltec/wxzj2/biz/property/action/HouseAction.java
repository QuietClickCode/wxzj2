package com.yaltec.wxzj2.biz.property.action;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.github.pagehelper.StringUtil;
import com.yaltec.comon.auth.TokenHolder;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.comon.core.entity.ReqPamars;
import com.yaltec.comon.log.LogUtil;
import com.yaltec.comon.log.entity.Log;
import com.yaltec.comon.utils.JsonUtil;
import com.yaltec.comon.utils.ObjectUtil;
import com.yaltec.wxzj2.biz.property.entity.CashPayment;
import com.yaltec.wxzj2.biz.property.entity.House;
import com.yaltec.wxzj2.biz.property.service.BuildingService;
import com.yaltec.wxzj2.biz.property.service.CashPaymentService;
import com.yaltec.wxzj2.biz.property.service.HouseDwService;
import com.yaltec.wxzj2.biz.property.service.HouseService;
import com.yaltec.wxzj2.biz.property.service.print.HousePrint;
import com.yaltec.wxzj2.biz.system.entity.Parameter;
import com.yaltec.wxzj2.biz.system.entity.User;
import com.yaltec.wxzj2.biz.system.service.ParameterService;
import com.yaltec.wxzj2.biz.system.service.PrintConfigService;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 
 * @ClassName: HouseAction
 * @Description: TODO 房屋信息实现类
 * 
 * @author yangshanping
 * @date 2016-7-13 上午10:12:48
 */
@Controller
@SessionAttributes("req")
public class HouseAction {

	@Autowired
	private HouseService houseService;
	@Autowired
	private HouseDwService houseDwService;
	@Autowired
	private CashPaymentService cashPaymentService;
	@Autowired
	private PrintConfigService printConfigService;
	@Autowired
	private BuildingService buildingService;
	@Autowired
	private ParameterService parameterService;

	/**
	 * 查询房屋信息【弹出界面】
	 */
	@RequestMapping("/house/open/list")
	public String openlist(Integer pageNo, Integer pageSize, House house,
			Model model) {
		pageNo = 1;
		pageSize = 5000;
		Page<House> page = new Page<House>(house, pageNo, pageSize);
		// 添加操作日志
		LogUtil.write(new Log("房屋快速查询", "查询", "HouseAction.openlist", page
				.toString()));
		houseService.findAll(page);
		model.addAttribute("page", page);
		model.addAttribute("house", house);
		return "/property/house/open/index";
	}

	/**
	 * 查询房屋信息【弹出界面】(针对销户模块，没有翻页效果)
	 */
	@RequestMapping("/house/open/findHouse")
	public String findHouse(Integer pageNo, Integer pageSize, House house,
			Model model) {
		// 添加操作日志
		// LogUtil.write(new Log("房屋快速查询", "查询", "HouseAction.findHouse",
		// house.toString()));
		// List<House> houseList=houseService.findForLogout(house);
		// model.addAttribute("houseList", houseList);
		// model.addAttribute("house", house);
		model.addAttribute("communitys", DataHolder.communityMap);
		return "/property/house/open/findHouse";
	}

	/**
	 * 房屋快速查询
	 * 
	 * @param req
	 * @param request
	 * @param response
	 * @param model
	 * @throws IOException
	 */
	@RequestMapping("/house/findList")
	public void findList(@RequestBody ReqPamars<House> req,
			HttpServletRequest request, HttpServletResponse response,
			ModelMap model) throws IOException {
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 添加操作日志
		LogUtil.write(new Log("房屋信息", "快速查询", "HouseAction.findList", req
				.toString()));

		String begindate = "1900-01-01";
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String enddate = sdf.format(new Date());

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("xqbh", req.getParams().get("xqbh") == null ? "" : req
				.getParams().get("xqbh"));
		map.put("lybh", req.getParams().get("lybh") == null ? "" : req
				.getParams().get("lybh"));
		map.put("h001", req.getParams().get("h001") == null ? "" : req
				.getParams().get("h001"));
		map.put("h013", req.getParams().get("h013") == null ? "" : req
				.getParams().get("h013"));
		map.put("h015", req.getParams().get("h015") == null ? "" : req
				.getParams().get("h015"));
		map.put("h022", "");
		map.put("h049", "");
		map.put("h047", req.getParams().get("h047") == null ? "" : req
				.getParams().get("h047"));
		map.put("cxlb", req.getParams().get("cxlb") == null ? "" : req
				.getParams().get("cxlb"));
		map.put("begindate", begindate);
		map.put("enddate", enddate);

		Page<House> page = new Page<House>(req.getEntity(), req.getPageNo(),
				req.getPageSize());
		houseService.findFast(page, map);
		model.put("req", req);
		request.getSession().setAttribute("req", req);
		// 返回结果
		pw.print(page.toJson());
	}

	/**
	 * 查询房屋信息【弹出界面】(针对销户模块，没有翻页效果)
	 */
	@RequestMapping("/house/open/forLogout")
	public String listForLogout(Integer pageNo, Integer pageSize, House house,
			Model model) {
		// 添加操作日志
		LogUtil.write(new Log("房屋快速查询", "查询", "HouseAction.openforLogout",
				house.toString()));
		List<House> houseList = houseService.findForLogout(house);
		model.addAttribute("houseList", houseList);
		model.addAttribute("house", house);
		return "/property/house/open/forLogout";
	}

	/**
	 * 跳转到首页
	 */
	@RequestMapping("/house/index")
	public String index(ModelMap model, HttpServletRequest request) {
		model.addAttribute("assignment", DataHolder.dataMap.get("assignment"));
		model.addAttribute("projects", DataHolder.dataMap.get("project"));
		model.addAttribute("communitys", DataHolder.communityMap);
		model.addAttribute("user", TokenHolder.getUser());
		model.addAttribute("h001", request.getParameter("h001"));
		model.put("req", new ReqPamars<House>());
		return "/property/house/index";
	}

	/**
	 * 查询房屋信息列表(ajax调用)
	 * 
	 * @param req
	 *            从第几条数据库开始算(+每页显示的条数)
	 * @param limit
	 *            每页显示的条数，相当于pageSize
	 * @param user
	 *            查询条件
	 * @throws IOException
	 */
	@RequestMapping("/house/list")
	public void list(@RequestBody ReqPamars<House> req,
			HttpServletRequest request, HttpServletResponse response,
			ModelMap model) throws IOException {
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();

		if (!ObjectUtil.isEmpty(req.getEntity())
				&& !ObjectUtil.isEmpty(req.getEntity().getH055())) {
			if (req.getEntity().getH054().equals("0")) {
				req.getEntity().setH001(req.getEntity().getH055());
			} else if (req.getEntity().getH054().equals("1")) {
				req.getEntity().setH013(req.getEntity().getH055());
			} else if (req.getEntity().getH054().equals("2")) {
				req.getEntity().setH015(req.getEntity().getH055());
			} else if (req.getEntity().getH054().equals("3")) {
				req.getEntity().setH040(req.getEntity().getH055());
			}
		}
		// 添加操作日志
		LogUtil
				.write(new Log("房屋信息", "查询", "HouseAction.list", req.toString()));
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("xqbh", req.getEntity().getXqbh());
		if (StringUtil.isEmpty(req.getEntity().getH001())) {
			map.put("h001", request.getParameter("h001"));
		} else {
			map.put("h001", req.getEntity().getH001());
		}
		map.put("lybh", req.getEntity().getLybh() == null ? "" : req
				.getEntity().getLybh());
		map.put("xmbm", req.getEntity().getXmbm() == null ? "" : req
				.getEntity().getXmbm());
		map.put("h013", req.getEntity().getH013() == null ? "" : req
				.getEntity().getH013());
		map.put("h015", req.getEntity().getH015() == null ? "" : req
				.getEntity().getH015());
		map.put("h040", req.getEntity().getH040() == null ? "" : req
				.getEntity().getH040());
		map.put("gjzx", req.getEntity().getH049() == null ? "" : req
				.getEntity().getH049());

		Page<House> page = new Page<House>(req.getEntity(), req.getPageNo(),
				req.getPageSize());
		houseService.find(page, map);
		model.put("req", req);
		request.getSession().setAttribute("req", req);
		// 返回结果
		pw.print(page.toJson());
	}

	/**
	 * 增加房屋信息
	 */
	@RequestMapping("/house/toAdd")
	public String toAdd(HttpServletRequest request, Model model) {
		// model.addAttribute("communitys", DataHolder.communityMap);
		model.addAttribute("lymc", DataHolder.buildingMap);
		model.addAttribute("h018", DataHolder.dataMap.get("housetype"));
		model.addAttribute("h012", DataHolder.dataMap.get("houseproperty"));
		model.addAttribute("h033", DataHolder.dataMap.get("housemodel"));
		model.addAttribute("h045", DataHolder.dataMap.get("houseuse"));
		model.addAttribute("h023", DataHolder.dataMap.get("deposit"));
		model.addAttribute("h050", DataHolder.dataMap.get("assignment"));
		return "/property/house/add";
	}

	/**
	 * 增加房屋信息(弹出框)
	 */
	@RequestMapping("/house/open/toAdd")
	public String toOpenAdd(HttpServletRequest request, Model model) {
		model.addAttribute("h018", DataHolder.dataMap.get("housetype"));
		model.addAttribute("h012", DataHolder.dataMap.get("houseproperty"));
		model.addAttribute("h033", DataHolder.dataMap.get("housemodel"));
		model.addAttribute("h045", DataHolder.dataMap.get("houseuse"));
		model.addAttribute("h023", DataHolder.dataMap.get("deposit"));
		model.addAttribute("h050", DataHolder.dataMap.get("assignment"));
		return "/property/house/open/add";
	}

	/**
	 * 快速增加房屋信息
	 */
	@RequestMapping("/house/addHouse")
	public String addCommunity(HttpServletRequest request, Model model) {
		model.addAttribute("h018", DataHolder.dataMap.get("housetype"));
		model.addAttribute("h012", DataHolder.dataMap.get("houseproperty"));
		model.addAttribute("h033", DataHolder.dataMap.get("housemodel"));
		model.addAttribute("h045", DataHolder.dataMap.get("houseuse"));
		model.addAttribute("h023", DataHolder.dataMap.get("deposit"));
		model.addAttribute("h050", DataHolder.dataMap.get("assignment"));
		return "/property/house/addHouse";
	}

	/**
	 * 保存房屋信息
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/house/addHouseSave")
	public void addCommunitySave(HttpServletRequest request,
			HttpServletResponse response) throws IOException {

		response.setCharacterEncoding("utf-8");
		Map<String, String> map = new HashMap<String, String>();
		map.put("userid", TokenHolder.getUser().getUserid());
		map.put("username", TokenHolder.getUser().getUsername());
		map.put("h001", "");
		map.put("lybh", request.getParameter("lybh"));
		map.put("lymc", request.getParameter("lymc"));
		map.put("h002", request.getParameter("h002"));
		map.put("h003", request.getParameter("h003"));
		map.put("h004", request.getParameter("h004"));
		map.put("h005", request.getParameter("h005"));
		map.put("h006", request.getParameter("h006"));
		map.put("h007", request.getParameter("h007"));
		map.put("h008", request.getParameter("h008"));
		map.put("h009", request.getParameter("h009"));
		map.put("h010", request.getParameter("h010"));
		map.put("h011", request.getParameter("h011"));
		map.put("h012", request.getParameter("h012"));
		map.put("h013", request.getParameter("h013"));
		map.put("h014", request.getParameter("h014"));
		map.put("h015", request.getParameter("h015"));
		map.put("h016", request.getParameter("h016"));
		map.put("h017", request.getParameter("h017"));
		map.put("h018", request.getParameter("h018"));
		map.put("h019", request.getParameter("h019"));
		map.put("h020", request.getParameter("h020"));
		map.put("h021", request.getParameter("h021"));
		map.put("h022", request.getParameter("h022"));
		map.put("h023", request.getParameter("h023"));
		map.put("h024", request.getParameter("h024"));
		map.put("h025", request.getParameter("h025"));
		map.put("h026", request.getParameter("h026"));
		map.put("h027", request.getParameter("h027"));
		map.put("h028", request.getParameter("h028"));
		map.put("h029", request.getParameter("h029"));
		map.put("h030", request.getParameter("h030"));
		map.put("h031", request.getParameter("h031"));
		map.put("h032", request.getParameter("h032"));
		map.put("h033", request.getParameter("h033"));
		map.put("h036", request.getParameter("h036"));
		map.put("h037", request.getParameter("h037"));
		map.put("h038", request.getParameter("h038"));
		map.put("h039", request.getParameter("h039"));
		map.put("h040", request.getParameter("h040"));
		map.put("h041", request.getParameter("h041"));
		map.put("h042", request.getParameter("h042"));
		map.put("h043", request.getParameter("h043"));
		map.put("h044", request.getParameter("h044"));
		map.put("h045", request.getParameter("h045"));
		map.put("h046", request.getParameter("h046"));
		map.put("h047", request.getParameter("h047"));
		map.put("h048", request.getParameter("h048"));
		map.put("h049", request.getParameter("h049"));
		map.put("h050", request.getParameter("h050"));
		map.put("h052", request.getParameter("h052"));
		map.put("h053", request.getParameter("h053"));
		map.put("savetype", "1");
		map.put("result", "-1");
		try {
			// 添加操作日志
			LogUtil.write(new Log("业主交款_单位房屋上报", "新增房屋",
					"HouseAction.addHouseSave", map.toString()));
			PrintWriter pw = response.getWriter();

			houseService.save(map);
			System.out.println("data:" + JsonUtil.toJson(map));
			// map.put("result", "0");
			// map.put("h001", map.get("h001"));
			// 返回结果
			pw.print(JsonUtil.toJson(map));
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	/**
	 * 保存房屋信息
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/house/add")
	public String add(House house, HttpServletRequest request, Model model,
			RedirectAttributes redirectAttributes) {
		// 根据楼宇、房屋类型、房屋性质、房屋用途、房屋户型、交存标准和归集中心编号获取相应的value
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
		// 添加操作日志
		LogUtil
				.write(new Log("房屋信息", "增加", "HouseAction.add", house
						.toString()));
		Map<String, String> map = toMap(house);
		map.put("savetype", "1");
		houseService.save(map);
		int result = Integer.valueOf(map.get("result"));
		if (result == 0) {
			redirectAttributes.addFlashAttribute("msg", "添加成功！");
			redirectAttributes.addFlashAttribute("retuenUrl", "add");
			return "redirect:/house/index?h001=" + map.get("h001").toString();
		} else if (result == 8) {
			redirectAttributes.addFlashAttribute("msg",
					"该房屋的单元、层、房号已存在，请检查后重试！");
			return "redirect:/house/toAdd";
		} else {
			request.setAttribute("msg", "添加失败！");
			return "redirect:/house/toAdd";
		}
	}

	/**
	 * 保存房屋信息(弹出框)
	 * 
	 * @param request
	 * @return
	 * @throws IOException
	 */
	@RequestMapping("/house/open/add")
	public void openAdd(HttpServletRequest request, HttpServletResponse response)
			throws IOException {

		Map<String, String> map = JsonUtil.toObject(request
				.getParameter("data"), HashMap.class);
		// 根据楼宇、房屋类型、房屋性质、房屋用途、房屋户型、交存标准和归集中心编号获取相应的value
		map.put("h018", DataHolder.dataMap.get("housetype")
				.get(map.get("h017")));
		map.put("h012", DataHolder.dataMap.get("houseproperty").get(
				map.get("h011")));
		map
				.put("h045", DataHolder.dataMap.get("houseuse").get(
						map.get("h044")));
		map.put("h033", DataHolder.dataMap.get("housemodel").get(
				map.get("h032")));
		map.put("h023", DataHolder.dataMap.get("deposit").get(map.get("h022")));
		map.put("h050", DataHolder.dataMap.get("assignment").get(
				map.get("h049")));
		// 添加操作日志
		LogUtil.write(new Log("房屋信息", "增加", "HouseAction.openAdd", map
				.toString()));
		map.put("savetype", "1");
		houseService.save(map);
		int result = Integer.valueOf(map.get("result"));
		PrintWriter pw = response.getWriter();

		// 返回结果
		pw.print(JsonUtil.toJson(result));
	}

	/**
	 * 删除房屋信息
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/house/delete")
	public String delete(String bm, HttpServletRequest request, Model model,
			RedirectAttributes redirectAttributes) {
		// 添加操作日志
		LogUtil.write(new Log("房屋信息", "删除", "HouseAction.delete", bm));
		Map<String, String> paramMap = new HashMap<String, String>();
		paramMap.put("userid", TokenHolder.getUser().getUserid());
		paramMap.put("username", TokenHolder.getUser().getUsername());
		paramMap.put("flag", "6");
		paramMap.put("result", "");
		paramMap.put("bm", bm);
		houseService.delete(paramMap);
		int result = Integer.valueOf(paramMap.get("result"));
		if (result == 0) {
			redirectAttributes.addFlashAttribute("msg", "删除成功！");
		} else if (result == 3) {
			redirectAttributes.addFlashAttribute("error", "删除失败，请检查该数据是否存在！");
		} else if (result == 5) {
			redirectAttributes
					.addFlashAttribute("error", "删除失败，本房屋已做业务，不允许删除！");
		} else {
			redirectAttributes.addFlashAttribute("error", "删除失败！");
		}
		return "redirect:/house/index";
	}

	/**
	 * 删除房屋信息后，跳转到房屋信息列表
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/house/batchDelete")
	public String batchDelete(String bms, HttpServletRequest request,
			Model model, RedirectAttributes redirectAttributes) {
		// 添加操作日志
		LogUtil.write(new Log("房屋信息", "批量删除", "HouseAction.batchDelete", bms));
		Map<String, String> paramMap = new HashMap<String, String>();
		paramMap.put("userid", TokenHolder.getUser().getUserid());
		paramMap.put("username", TokenHolder.getUser().getUsername());
		paramMap.put("flag", "6");
		paramMap.put("bm", bms);
		paramMap.put("result", "-1");
		try {
			houseService.delHouse(paramMap);
			redirectAttributes.addFlashAttribute("msg", "删除成功！");
			redirectAttributes.addFlashAttribute("retuenUrl", "delete");
		} catch (Exception e) {
			redirectAttributes.addFlashAttribute("error", e.getMessage());
		}
		return "redirect:/house/index";
	}

	/**
	 * 编辑房屋信息页面
	 */
	@RequestMapping("/house/toUpdate")
	public String toUpdate(Model model, HttpServletRequest request) {
		// 获取页面传入的房屋编号h001
		House house = houseDwService.findByH001(request.getParameter("h001"));
		model.addAttribute("h018", DataHolder.dataMap.get("housetype"));
		model.addAttribute("h012", DataHolder.dataMap.get("houseproperty"));
		model.addAttribute("h033", DataHolder.dataMap.get("housemodel"));
		model.addAttribute("h045", DataHolder.dataMap.get("houseuse"));
		model.addAttribute("h023", DataHolder.dataMap.get("deposit"));
		model.addAttribute("h050", DataHolder.dataMap.get("assignment"));
		model.addAttribute("house", house);
		return "/property/house/update";
	}

	/**
	 * 修改房屋信息，成功：重定向到房屋信息列表页面；失败：返回房屋信息修改页面
	 * 
	 * @param message
	 * @param request
	 * @return
	 */
	@RequestMapping("/house/update")
	public String update(House house, Model model,
			RedirectAttributes redirectAttributes, HttpServletRequest request) {
		// 根据楼宇、房屋类型、房屋性质、房屋用途、房屋户型、交存标准和归集中心编号获取相应的value
		house.setLymc(DataHolder.buildingMap.get(house.getLybh()).getLymc());
		house.setH018(DataHolder.dataMap.get("housetype").get(house.getH017()));
		house.setH012(DataHolder.dataMap.get("houseproperty").get(
				house.getH011()));
		house.setH045(DataHolder.dataMap.get("houseuse").get(house.getH044()));
		house.setH033(DataHolder.dataMap.get("housemodel").get(
						house.getH032()));
		house.setH023(DataHolder.dataMap.get("deposit").get(house.getH022()));
		house
				.setH050(DataHolder.dataMap.get("assignment").get(
						house.getH049()));
		// 添加操作日志
		LogUtil.write(new Log("房屋信息", "修改", "HouseAction.update", house
				.toString()));
		Map<String, String> map = toMap(house);
		map.put("savetype", "2");
		houseService.update(map);
		int result = Integer.valueOf(map.get("result"));
		if (result == 0) {
			redirectAttributes.addFlashAttribute("msg", "修改成功！");
			redirectAttributes.addFlashAttribute("retuenUrl", "update");
			String xqbh = DataHolder.buildingMap.get(house.getLybh()).getXqbh();
			redirectAttributes.addFlashAttribute("xmbm",
					DataHolder.communityMap.get(xqbh).getXmbm());
			redirectAttributes.addFlashAttribute("lybh", DataHolder.buildingMap
					.get(house.getLybh()).getLybh());
			redirectAttributes.addFlashAttribute("xqbh", xqbh);
			return "redirect:/house/index?h001=" + house.getH001();
		} else if (result == 8) {
			request.setAttribute("msg", "该房屋的单元、层、房号已存在，请检查后重试！");
			model.addAttribute("lymc", DataHolder.buildingMap);
			model.addAttribute("h018", DataHolder.dataMap.get("housetype"));
			model.addAttribute("h012", DataHolder.dataMap.get("houseproperty"));
			model.addAttribute("h033", DataHolder.dataMap.get("housemodel"));
			model.addAttribute("h045", DataHolder.dataMap.get("houseuse"));
			model.addAttribute("h023", DataHolder.dataMap.get("deposit"));
			model.addAttribute("h050", DataHolder.dataMap.get("assignment"));
			model.addAttribute("house", house);
			return "/property/house/update";
		} else {
			request.setAttribute("msg", "修改失败！");
			model.addAttribute("lymc", DataHolder.buildingMap);
			model.addAttribute("h018", DataHolder.dataMap.get("housetype"));
			model.addAttribute("h012", DataHolder.dataMap.get("houseproperty"));
			model.addAttribute("h033", DataHolder.dataMap.get("housemodel"));
			model.addAttribute("h045", DataHolder.dataMap.get("houseuse"));
			model.addAttribute("h023", DataHolder.dataMap.get("deposit"));
			model.addAttribute("h050", DataHolder.dataMap.get("assignment"));
			model.addAttribute("house", house);
			return "/property/house/update";
		}
	}

	/**
	 * 修改页面返回首页的方法，保留小区、楼宇查询条件
	 * 
	 * @return
	 */
	@RequestMapping("/house/return")
	public String retun(String lybh, Model model,
			RedirectAttributes redirectAttributes, HttpServletRequest request) {
		// 根据楼宇、房屋类型、房屋性质、房屋用途、房屋户型、交存标准和归集中心编号获取相应的value
		redirectAttributes.addFlashAttribute("retuenUrl", "update");
		String xqbh = DataHolder.buildingMap.get(lybh).getXqbh();
		redirectAttributes.addFlashAttribute("xmbm", DataHolder.communityMap
				.get(xqbh).getXmbm());
		redirectAttributes.addFlashAttribute("lybh", lybh);
		redirectAttributes.addFlashAttribute("xqbh", xqbh);
		return "redirect:/house/index?h001=";
	}

	/**
	 * 编辑房屋信息(弹出框)
	 */
	@RequestMapping("/house/open/toUpdate")
	public String toOpenUpdate(HttpServletRequest request, Model model) {
		House house = houseDwService.findByH001(request.getParameter("h001"));
		model.addAttribute("h018", DataHolder.dataMap.get("housetype"));
		model.addAttribute("h012", DataHolder.dataMap.get("houseproperty"));
		model.addAttribute("h033", DataHolder.dataMap.get("housemodel"));
		model.addAttribute("h045", DataHolder.dataMap.get("houseuse"));
		model.addAttribute("h023", DataHolder.dataMap.get("deposit"));
		model.addAttribute("h050", DataHolder.dataMap.get("assignment"));
		model.addAttribute("house", house);
		return "/property/house/open/update";
	}

	/**
	 * 
	 * @param request
	 * @param response
	 * @throws IOException
	 */
	@RequestMapping("/house/open/update")
	public void openUpdate(HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		Map<String, String> map = JsonUtil.toObject(request
				.getParameter("data"), HashMap.class);
		// 根据楼宇、房屋类型、房屋性质、房屋用途、房屋户型、交存标准和归集中心编号获取相应的value
		map.put("h018", DataHolder.dataMap.get("housetype")
				.get(map.get("h017")));
		map.put("h012", DataHolder.dataMap.get("houseproperty").get(
				map.get("h011")));
		if (map.get("h044").toString().equals("")) {
			map.put("h045", "");
		} else {
			map.put("h045", DataHolder.dataMap.get("houseuse").get(
					map.get("h044")));
		}
		if (map.get("h032").toString().equals("")) {
			map.put("h033", "");
		} else {
			map.put("h033", DataHolder.dataMap.get("houseuse").get(
					map.get("h032")));
		}
		map.put("h023", DataHolder.dataMap.get("deposit").get(map.get("h022")));
		map.put("h050", DataHolder.dataMap.get("assignment").get(
				map.get("h049")));
		// 添加操作日志
		LogUtil.write(new Log("房屋信息", "修改", "HouseAction.update", map
				.toString()));
		map.put("savetype", "2");
		houseService.update(map);
		int result = Integer.valueOf(map.get("result"));
		PrintWriter pw = response.getWriter();

		// 返回结果
		pw.print(JsonUtil.toJson(result));
	}

	/**
	 * 打印房屋凭证
	 */
	@RequestMapping("/house/print")
	public ByteArrayOutputStream print(HttpServletRequest request,
			HttpServletResponse response, Model model,
			RedirectAttributes redirectAttributes) {
		ByteArrayOutputStream ops = null;
		String h001 = request.getParameter("h001");
		if (h001 == null || h001.equals("")) {
			redirectAttributes.addFlashAttribute("msg", "获取传递的数据发生错误！");
			return null;
		}
		// 添加操作日志
		LogUtil.write(new Log("房屋信息", "打印房屋凭证", "HouseAction.print", h001));
		try {
			// 根据房屋号获取打印凭证信息
			CashPayment cp = cashPaymentService.findByH001(h001);
			HousePrint pdf = new HousePrint();
			// 获取当前操作用户
			User user = TokenHolder.getUser();
			// 获取用户对于的打印配置
			String printSetName = "";
			if (user.getPrintSet() != null) {
				printSetName = user.getPrintSet().getXmlname2();
			}
			ops = pdf.creatPDFDynamicDB(cp, "", "", printConfigService
					.get(printSetName));
		} catch (Exception e) {
			e.printStackTrace();
			redirectAttributes.addFlashAttribute("msg", "生成PDF文件发生错误！");
			return null;
		}
		if (ops != null) {
			houseService.output(ops, response);
		}
		return ops;
	}

	/**
	 * 根据楼宇编号获取房屋类型
	 */
	@RequestMapping("/house/getFwlxByBuilding")
	public void getFwlx(String lybh, HttpServletResponse response)
			throws Exception {
		// 添加操作日志
		LogUtil.write(new Log("房屋信息", "根据楼宇编号获取房屋类型",
				"HouseAction.getFwlxByBuilding", lybh));
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		String fwlx = buildingService.getFwlxByBuilding(lybh);
		pw.print(JsonUtil.toJson(fwlx));
	}

	/**
	 * 获取系统参数业务设置信息（根据编码）
	 * 
	 * @throws Exception
	 */
	@RequestMapping("/house/getSystemArg")
	public void getSystemArg(String bm, HttpServletResponse response)
			throws Exception {
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		if (bm.length() == 1) {
			bm = "0" + bm;
		}
		String result = "";
		Parameter sysParam = parameterService.findByBm(bm);
		if (sysParam == null) {
			// logger.error("获取编码：" + bm + "对应的系统参数配置失败，请检查！");
			result = "2";
		} else if (sysParam.getSf().equals("1")) {
			result = "1";
		} else {
			result = "0";
		}
		pw.print(JsonUtil.toJson(result));
	}

	/**
	 * 获取房屋查询统计信息
	 */
	@RequestMapping("/house/getHouseSumBySearch2")
	public void getHouseSum(String h049, String xmbm, String xqbh, String lybh,
			String h054, String h055, HttpServletResponse response)
			throws Exception {
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		String h001 = "";
		String h013 = "";
		String h015 = "";
		String h040 = "";

		if (h054.equals("0")) {
			h001 = h055;
		} else if (h054.equals("1")) {
			h013 = h055;
		} else if (h054.equals("2")) {
			h015 = h055;
		} else if (h054.equals("3")) {
			h040 = h055;
		}
		Map<String, String> map = new HashMap<String, String>();
		map.put("xmbm", xmbm);
		map.put("xqbh", xqbh);
		map.put("lybh", lybh);
		map.put("h001", h001);
		map.put("h013", h013);
		map.put("h015", h015);
		map.put("h040", h040);
		map.put("gjzx", h049);
		// 添加操作日志
		LogUtil.write(new Log("房屋信息", "房屋查询统计信息",
				"HouseAction.getHouseSumBySearch2", map.toString()));
		House house = houseService.queryHouseInfoCount(map);
		pw.print(JsonUtil.toJson(house));
	}

	/**
	 * 根据房屋编号获取房屋信息
	 */
	@RequestMapping("/house/getHouse")
	public void getHouse(String h001s, HttpServletResponse response, House house)
			throws Exception {
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		String[] h001 = h001s.split(",");
		try {
			house = houseService.getHouseByH001(h001[0]);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
		pw.print(JsonUtil.toJson(house));
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
}

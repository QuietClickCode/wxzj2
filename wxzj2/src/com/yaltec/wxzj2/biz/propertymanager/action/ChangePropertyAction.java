package com.yaltec.wxzj2.biz.propertymanager.action;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.yaltec.comon.auth.TokenHolder;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.comon.core.entity.ReqPamars;
import com.yaltec.comon.log.LogUtil;
import com.yaltec.comon.log.entity.Log;
import com.yaltec.comon.utils.JsonUtil;
import com.yaltec.comon.utils.StringUtil;
import com.yaltec.comon.utils.Urlencryption;
import com.yaltec.comon.utils.ValidateHouseUnit;
import com.yaltec.wxzj2.biz.payment.entity.BatchPayment;
import com.yaltec.wxzj2.biz.payment.entity.HousedwImport;
import com.yaltec.wxzj2.biz.property.entity.Building;
import com.yaltec.wxzj2.biz.property.entity.House;
import com.yaltec.wxzj2.biz.property.service.HouseService;
import com.yaltec.wxzj2.biz.propertymanager.entity.ChangeProperty;
import com.yaltec.wxzj2.biz.propertymanager.service.PropertyService;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 产权变更实现类
 * @ClassName: ChangePropertyAction 
 * @author 重庆亚亮科技有限公司 hqx 
 * @date 2016-8-8 下午03:26:20
 */
@Controller
@SessionAttributes("req")
public class ChangePropertyAction {
	@Autowired
	private HouseService houseService;
	
	@Autowired
	private PropertyService propertyService;
	
	@Value("${work.temppath}") //配置文件中定义的保存路径（临时保存）
	private String tempPath;
	
	/**
	 * 跳转到首页
	 */
	@RequestMapping("/changeproperty/index")
	public String changepropertyindex(Model model, String lybh) {
		String xqbh = "";
		if (!StringUtil.isEmpty(lybh) && DataHolder.buildingMap.containsKey(lybh)) {
			Building building = DataHolder.buildingMap.get(lybh);
			xqbh = building.getXqbh();
		}
		model.addAttribute("xqbh", xqbh);
		model.addAttribute("lybh", lybh == null? "" :lybh);
		model.addAttribute("communitys", DataHolder.communityMap);
		return "/propertymanager/changeproperty/index";
	}
	
	/**
	 * 查询产权变更列表
	 */
	@RequestMapping("/changeproperty/list")
	public void changepropertylist(@RequestBody ReqPamars<House> req, HttpServletRequest request,ModelMap model,
			HttpServletResponse response) throws IOException {	
		model.addAttribute("communitys", DataHolder.communityMap);
		//返回数据
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		//查询分页
		Page<House> page = new Page<House>(req.getEntity(), req.getPageNo(), req.getPageSize());
		House house=req.getEntity();
		String h013=house.getH013();
		// 添加操作日志
		LogUtil.write(new Log("产权管理_产权变更", "查询", "ChangePropertyAction.changepropertylist",req.toString()));
		//判断房屋编号是否为空
		if (h013==null || h013.equals("")) {
			houseService.changePropertyLybh(page);
		} else {
			houseService.changePropertyH013(page);
			//houseService.findChangeProperty3(h001);
		}
		request.getSession().setAttribute("req", req);
		//System.out.println(request.getSession().getAttribute("req"));
		model.put("req", req);
		// 返回结果
		pw.print(page.toJson());
		
	}
	
	/**
	 * 保存产权变更
	 */
	@RequestMapping("/changeproperty/saveChangeProperty")
	public String saveChangeProperty(HttpServletRequest request, Model model,RedirectAttributes redirectAttributes,House house,HttpServletResponse response){
		String h001=request.getParameter("h001");
		String h011=house.getH011();
		String h012=DataHolder.dataMap.get("houseproperty").get(h011);
		String h013=request.getParameter("cqr");
		String h015=request.getParameter("sfzh");
		String h016=house.getH016();		
		String h019=request.getParameter("lxfs");
		String lybh=house.getLybh();
		String bgrq=request.getParameter("bgsj");
		String OFileName=request.getParameter("oldName");		
		String NFileName=request.getParameter("tempfile");
		String unchange=house.getUnchange();
		String note=request.getParameter("note");
		String chgreason=request.getParameter("chgreason");		
		// 创建一个map集合，作为调用提交销户申请方法的参数
		Map<String,String> paramMap=new HashMap<String,String>();
		paramMap.put("h001",h001);
		paramMap.put("h013",h013);
		paramMap.put("h019",h019);
		paramMap.put("h015",h015);
		paramMap.put("h011",h011);
		paramMap.put("h012",h012);
		paramMap.put("h016",h016);
		paramMap.put("lybh",lybh);
		paramMap.put("bgrq",bgrq);
		paramMap.put("OFileName",OFileName);
		paramMap.put("NFileName",NFileName);
		paramMap.put("unchange",unchange);
		paramMap.put("note",note);
		paramMap.put("chgreason",chgreason);
		paramMap.put("userid", TokenHolder.getUser().getUserid());
		paramMap.put("result", "");
		// 添加操作日志
		LogUtil.write(new Log("产权管理_产权变更", "产权变更", "ChangePropertyAction.saveChangeProperty",paramMap.toString()));
		int result=propertyService.saveChangeProperty(paramMap);
		if (result == 0) {
			redirectAttributes.addFlashAttribute("msg", "保存成功！");
		} else if(result == 5) {
			redirectAttributes.addFlashAttribute("msg","房屋信息并未修改，请确定！");
		} else if(result == 7) {
			redirectAttributes.addFlashAttribute("msg","此房屋存在未入账业务，不允许变更！");
		 } else {	
			 redirectAttributes.addFlashAttribute("msg", "保存失败！");
		}
		redirectAttributes.addFlashAttribute("retuenUrl", "update");
		model.addAttribute("result", 1);
		return "redirect:/changeproperty/index?lybh="+lybh;
	}
	
	/**
	 * 跳转到变更批录
	 */
	@RequestMapping("/changeproperty/batchrecord")
	public String batchrecord(Model model, String lybh) {
		model.addAttribute("communitys", DataHolder.communityMap);
		model.addAttribute("lybh", lybh == null? "" :lybh);
		//String lybh = request.getParameter("lybh");
		return "/propertymanager/changeproperty/batchrecord";
	}
	
	/**
	 * 变更批录列表
	 */
	@RequestMapping("/batchrecord/list")
	public void batchrecordlist(@RequestBody ReqPamars<House> req, HttpServletRequest request,
			HttpServletResponse response) throws IOException {	
		//返回数据
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		//查询分页
		Page<House> page = new Page<House>(req.getEntity(), req.getPageNo(), req.getPageSize());
		// 添加操作日志
		LogUtil.write(new Log("产权管理_产权变更", "变更批录", "ChangePropertyAction.batchrecordlist",req.toString()));
		houseService.changePropertyLybh(page);
		// 返回结果
		pw.print(page.toJson());
	}
	
	/**
	 * 跳转到变更查询
	 */
	@RequestMapping("/changeproperty/changesearch")
	public String changesearch(Model model, String lybh) {
		model.addAttribute("communitys", DataHolder.communityMap);
		model.addAttribute("lybh", lybh == null? "" :lybh);
		return "/propertymanager/changeproperty/changesearch";
	}
	
	/**
	 * 变更查询列表
	 */
	@RequestMapping("/changesearch/list")
	public void changesearchlist(@RequestBody ReqPamars<ChangeProperty> req, HttpServletRequest request,
			HttpServletResponse response) throws IOException {	
		//获取查询条件
		Map<String, Object> paramMap = req.getParams();
		Page<ChangeProperty> page = new Page<ChangeProperty>(req.getEntity(), req.getPageNo(), req.getPageSize());
		// 添加操作日志
		LogUtil.write(new Log("产权管理_产权变更", "变更查询", "ChangePropertyAction.changesearchlist",req.toString()));
		propertyService.change(page, paramMap);
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 返回结果
		pw.print(page.toJson());
	}

	/**
	 * 跳转到添加变更编辑页面
	 */
	@RequestMapping("/changeproperty/change")
	public String changepropertychange(HttpServletRequest request, Model model) {
		String h001=request.getParameter("h001")==null?"":request.getParameter("h001");
		House house=houseService.changeProperty_h001(h001);
		model.addAttribute("house", house);
		model.addAttribute("h012", DataHolder.dataMap.get("houseproperty"));
		//model.addAttribute("istl",DataHolder.customerInfo.isTL());
		String district=DataHolder.customerInfo.getName();
		district=district.substring(3, 6);
		model.addAttribute( "district", district);
		return "/propertymanager/changeproperty/change";
	}
	
	/**
	 * 跳转到变更编辑页面
	 */
	@RequestMapping("/changeproperty/toUpdate")
	public String toProperty(HttpServletRequest request, Model model) {
		String h001=request.getParameter("h001")==null?"":request.getParameter("h001");
		// 添加操作日志
		LogUtil.write(new Log("产权管理_产权变更", "跳转到变更编辑页面", "ChangePropertyAction.toProperty",h001.toString()));
		House house=houseService.changeProperty_h001(h001);
		model.addAttribute("house", house);
		return "/propertymanager/changeproperty/update";
	}
	
	/**
	 * 保存产权变更编辑
	 */
	@RequestMapping("/changeproperty/save")
	public String propertySave(HttpServletRequest request, Model model,RedirectAttributes redirectAttributes,House house){
		String h001=house.getH001();
		//String h001=request.getParameter("h001");
		String h016=request.getParameter("h016");
		String unchange=request.getParameter("unchange");
		if(unchange==null||unchange==""){
			unchange="";
		}
		Map<String,String> paramMap=new HashMap<String,String>();
		paramMap.put("h001",h001);
		paramMap.put("h016",h016);
		paramMap.put("unchange",unchange);
		paramMap.put("result", "0");
		// 添加操作日志
		LogUtil.write(new Log("产权管理_产权变更", "变更编辑", "ChangePropertyAction.propertysave",paramMap.toString()));
		int result=propertyService.propertySave(paramMap);
		if (result>0) {
			model.addAttribute("msg", "保存成功！");
		} else {
			model.addAttribute("msg", "保存失败！");
		}
		model.addAttribute("result", result);
		return "/propertymanager/changeproperty/update";
	}
	
	/**
	 * 获取系统参数
	 * @param request
	 * @param response
	 * @throws IOException
	 */
	@RequestMapping("/changeproperty/print")
	public void getSystemArg(HttpServletRequest request,HttpServletResponse response)throws IOException{		
		//返回数据
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 返回结果
		pw.print(DataHolder.getParameter(request.getParameter("bm")));
	}
	
	/**
	 * 打印
	 * @param request
	 * @param response
	 * @throws IOException
	 */
	@RequestMapping("/changeproperty/toPrint")
	public void toPrint(HttpServletRequest request,HttpServletResponse response)throws IOException{
		//获取参数
		Map<String,String> paramMap = new HashMap<String, String>();
		paramMap.put("h001",request.getParameter("h001"));
		paramMap.put("o013",Urlencryption.unescape(request.getParameter("o013")));
		paramMap.put("n013",Urlencryption.unescape(request.getParameter("n013")));
		paramMap.put("o015",Urlencryption.unescape(request.getParameter("o015")));
		paramMap.put("n015",Urlencryption.unescape(request.getParameter("n015")));
		// 添加操作日志
		LogUtil.write(new Log("产权管理_产权变更", "打印", "ChangePropertyAction.toPrint",paramMap.toString()));
		ByteArrayOutputStream ops=propertyService.toPrint(paramMap);
		if(ops != null){
			propertyService.output(ops, response);
		}
	}
	
	/**
	 * 打印清册
	 * @param request
	 * @param response
	 * @throws IOException
	 */
	@RequestMapping("/changeproperty/inventory")
	public void inventory(HttpServletRequest request,HttpServletResponse response)throws IOException{
		//获取参数
		Map<String,String> paramMap = new HashMap<String, String>();
		paramMap.put("xqbh",request.getParameter("xqbh"));
		paramMap.put("lybh",request.getParameter("lybh"));
		paramMap.put("h001",request.getParameter("h001"));
		paramMap.put("begindate",request.getParameter("begindate"));
		paramMap.put("enddate",request.getParameter("enddate"));
		// 添加操作日志
		LogUtil.write(new Log("产权管理_产权变更", "打印清册", "ChangePropertyAction.inventory",paramMap.toString()));
		ByteArrayOutputStream ops=propertyService.inventory(paramMap);
		if(ops != null){
			propertyService.output(ops, response);
		}
//		out.clear();  
//		out = pageContext.pushBody(); 
	}
	
	/**
	 * 删除票据接收信息
	 * @param request
	 * @param model
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping("/changeproperty/delReceiveBill")
	public String delBuildingTransfer(HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
		String paras = request.getParameter("str");
		if (paras.isEmpty()) {
			redirectAttributes.addFlashAttribute("msg", "获取数据异常，请请检查重试！");
			return "redirect:/changeproperty/changesearch";
		}
		String[] str = paras.split(";");
		Map<String, String> paramMap = new HashMap<String, String>();
		paramMap.put("bm", str[0]);
		paramMap.put("flag", str[1]);
		paramMap.put("userid", TokenHolder.getUser().getUserid());
		paramMap.put("username", TokenHolder.getUser().getUsername());
		paramMap.put("result", "-1");
		try {
			// 添加操作日志
			LogUtil.write(new Log("产权管理_产权变更", "删除票据接收信息", "ChangePropertyAction.delBuildingTransfer",paramMap.toString()));
			propertyService.delReceiveBill(paramMap);
			int _result=Integer.valueOf(paramMap.get("result"));
			if(_result==0){
				redirectAttributes.addFlashAttribute("msg", "删除成功 ！");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "redirect:/changeproperty/changesearch";
	}
	
	/**
	 * 导入数据
	 * @param paras
	 * @param response
	 * @param redirectAttributes
	 * @throws Exception
	 */
	@RequestMapping("change/import")
	public void changeImport(String tempfile,String xqbh,String lybh,String lymc,String unitCode,String unitName,
			String w003,String sheetIndx,HttpServletResponse response,RedirectAttributes redirectAttributes) throws Exception {
		
		BatchPayment batchPayment = new BatchPayment();
		batchPayment.setXqbh(xqbh);
		batchPayment.setLybh(lybh);
		batchPayment.setLymc(lymc);
		batchPayment.setFilename(tempPath + tempfile);
		batchPayment.setUnitcode(unitCode);
		batchPayment.setUnitname(unitName);
		batchPayment.setSheet(sheetIndx);
		batchPayment.setYwrq(w003);
		
		Map<String, Object> map = null;
		try {
			List<HousedwImport> list = new ArrayList<HousedwImport>();
			
			// 获取临时编码最大值加1				
			String tempCode = propertyService.getMaxCodeHouse_dwBS().toString();
			tempCode = StringUtil.keepLen(tempCode, 8, false);
			batchPayment.setTempCode(tempCode);
			map = ValidateHouseUnit.convert(batchPayment, list);
			map.put("userid", TokenHolder.getUser().getUserid());
			
			if (map.containsKey("msg")) {
				String msg = map.get("msg").toString();
				if (msg.equals("")) {
					
					propertyService.deleteHouse_dwBSByUserid(map);
					
					map.put("result", "0");
					map.put("tempCode", tempCode);
					map.put("lybh", batchPayment.getLybh());
					
					propertyService.insertHouseUnit(list, map);
					int flag = Integer.valueOf(map.get("result").toString());
					map.put("flag", flag);
				} else {
					map.put("flag", -2);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			map.put("flag", -2);
		}
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		System.out.println(JsonUtil.toJson(map));
		pw.print( JsonUtil.toJson(map));
		
	}

	/**
	 * 保存变更批录
	 * @param paras
	 * @param response
	 * @param redirectAttributes
	 * @throws Exception
	 */
	@RequestMapping("change/submit")
	public void saveChangeProperty_PL(String tempCode,HttpServletResponse response,RedirectAttributes redirectAttributes) throws Exception {
		Map<String, Object> paramMap = new HashMap<String, Object>();
		Integer result = -1;
		paramMap.put("tempCode", tempCode);
		paramMap.put("userid", TokenHolder.getUser().getUserid());
		paramMap.put("result", result);
		try {
			// 添加操作日志
			LogUtil.write(new Log("产权管理_产权变更", "保存变更批录", "ChangePropertyAction.saveChangeProperty_PL",paramMap.toString()));
			result=propertyService.saveChangeProperty_PL(paramMap);
		} catch (Exception e) {
			e.printStackTrace();
		}
		PrintWriter pw = response.getWriter();
		pw.print( JsonUtil.toJson(paramMap));
	}
}

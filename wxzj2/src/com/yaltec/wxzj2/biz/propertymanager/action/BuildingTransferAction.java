package com.yaltec.wxzj2.biz.propertymanager.action;

import java.io.ByteArrayOutputStream;
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
import com.yaltec.wxzj2.biz.property.entity.House;
import com.yaltec.wxzj2.biz.propertymanager.entity.BuildingTransfer;
import com.yaltec.wxzj2.biz.propertymanager.service.BuildingTransferService;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 楼盘转移实现类
 * @ClassName: BuildingTransferAction 
 * @author 重庆亚亮科技有限公司 hqx 
 * @date 2016-8-8 下午03:26:20
 */
@Controller
public class BuildingTransferAction {

	@Autowired
	private BuildingTransferService buildingtransferservice;

	/**
	 * 跳转到首页
	 */
	@RequestMapping("/buildingtransfer/index")
	public String index(Model model) {
		model.addAttribute("communitys", DataHolder.communityMap);
		return "/propertymanager/buildingtransfer/index";
	}

	/**
	 * 查询楼盘转移列表
	 */
	@RequestMapping("/buildingtransfer/list")
	public void list(@RequestBody ReqPamars<BuildingTransfer> req, HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		// 添加操作日志
		LogUtil.write(new Log("产权管理_楼盘转移", "查询", "BuildingTransferAction.list",req.toString()));
		// 获取查询条件
		Map<String, Object> paramMap = req.getParams();
		paramMap.put("nret", "");
		Page<BuildingTransfer> page = new Page<BuildingTransfer>(req.getEntity(), req.getPageNo(), req.getPageSize());
		buildingtransferservice.findAll(page, paramMap);
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 返回结果
		pw.print(page.toJson());
	}

	/**
	 * 楼盘添加页面
	 * 
	 * @author hequanxin
	 */
	@RequestMapping("/buildingtransfer/toAdd")
	public String add(HttpServletRequest request, Model model, House house) {
		model.addAttribute("house", house);
		model.addAttribute("communitys", DataHolder.communityMap);
		String w008=request.getParameter("w008");
		model.addAttribute("w008",w008);
		return "/propertymanager/buildingtransfer/add";
	}

	/**
	 * 保存楼盘转移（整栋楼）
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/buildingtransfer/save")
	public String save(HttpServletRequest request, Model model, RedirectAttributes redirectAttributes,String lybha,String lybhb,String zyrq,String w008) {
		// 创建一个map集合，作为调用提交销户申请方法的参数

		Map<String, String> paramMap = new HashMap<String, String>();
		
		paramMap.put("lybha", lybha);
		paramMap.put("lybhb", lybhb);
		paramMap.put("zyrq", zyrq);
		if(w008==null||w008==""){
			w008="";
		}
		paramMap.put("w008", w008);
		paramMap.put("userid", TokenHolder.getUser().getUserid());
		paramMap.put("username", TokenHolder.getUser().getUsername());
		paramMap.put("result", "2");

		// 添加操作日志
		LogUtil.write(new Log("产权管理_楼盘转移", "保存", "BuildingTransferAction.save",paramMap.toString()));
		buildingtransferservice.save(paramMap);
		int _result=Integer.valueOf(paramMap.get("result")); 
		if (_result == 0) {
			redirectAttributes.addFlashAttribute("result", "0");
		} else {
			redirectAttributes.addFlashAttribute("result", "-1");
		}
		return "redirect:/buildingtransfer/index";
	}

	/**
	 * 保存楼盘转移（可选择）
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/buildingtransfer/saveh001")
	public String saveh001(HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
		String paras = request.getParameter("str");
		if (paras.isEmpty()) {
			redirectAttributes.addFlashAttribute("msg", "获取数据异常，请请检查重试！");
			return "redirect:/buildingtransfer/index";
		}
		String[] str = paras.split(";");
		String h001="";
		//将h001转换格式：     单个     ;00010001;     多个    ;00010001;,;00010001;
		if(!str[0].equals("")){
			for (int i = 0; i < str[0].split(",").length; i++) {
				if(!str[0].split(",")[i].equals("")){
					h001=h001+";"+str[0].split(",")[i]+";,";
				}
			}
			h001=h001.substring(0, h001.length()-1);
		}
		Map<String, String> paramMap = new HashMap<String, String>();
		paramMap.put("h001", h001);
		paramMap.put("lybha", str[1]);
		paramMap.put("lybhb", str[2]);
		paramMap.put("w008", str[3]);
		paramMap.put("ywrq", str[4]);
		paramMap.put("userid", TokenHolder.getUser().getUserid());
		paramMap.put("username", TokenHolder.getUser().getUsername());
		paramMap.put("result", "2");
		if(paramMap.get("w008")==null){
			paramMap.put("w008", "");
		}
		// 添加操作日志
		LogUtil.write(new Log("产权管理_楼盘转移", "保存", "BuildingTransferAction.saveh001",paramMap.toString()));
		buildingtransferservice.saveh001(paramMap);
		int _result=Integer.valueOf(paramMap.get("result")); 
		if (_result == 0) {
			redirectAttributes.addFlashAttribute("result", "0");
		} else {
			redirectAttributes.addFlashAttribute("result", "-1");
		}
		return "redirect:/buildingtransfer/index";
	}
	
	/**
	 * 删除楼盘转移
	 * 
	 * @throws Exception
	*/
	@RequestMapping("/buildingtransfer/delBuildingTransfer")
	public String delBuildingTransfer(HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
		String paras = request.getParameter("str");
		if (paras.isEmpty()) {
			redirectAttributes.addFlashAttribute("msg", "获取数据异常，请请检查重试！");
			return "redirect:/buildingtransfer/index";
		}
		//var str=h001+";"+w008+";"+h030+";"+userid+";"+escape(escape(username));
		String[] str = paras.split(";");
		Map<String, String> paramMap = new HashMap<String, String>();
		paramMap.put("h001", str[0]);
		paramMap.put("w008", str[1]);
		paramMap.put("h030", str[2]);
		paramMap.put("result", "3");
		//判断业务是否审核 
		buildingtransferservice.checkPZSFSH(paramMap);
		try {
			// 添加操作日志
			LogUtil.write(new Log("产权管理_楼盘转移", "删除", "BuildingTransferAction.delBuildingTransfer",paramMap.toString()));
			buildingtransferservice.delBuildingTransfer(paramMap);
			int _result=Integer.valueOf(paramMap.get("result"));
			if (_result==0) {
				redirectAttributes.addFlashAttribute("msg", "删除成功 ！");
			}else if(_result==3){
				redirectAttributes.addFlashAttribute("msg", "凭证已审核，不能删除！");
			}else{
				redirectAttributes.addFlashAttribute("msg", "删除失败，请稍候重试！");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "redirect:/buildingtransfer/index";
		
	}
	
	/**
	 * 打印清册
	 * @param request
	 * @param response
	 * @throws IOException
	 */
	@RequestMapping("/buildingtransfer/inventory")
	public void inventory(HttpServletRequest request,HttpServletResponse response)throws IOException{
		//获取参数
		Map<String,String> paramMap = new HashMap<String, String>();
		paramMap.put("w008",request.getParameter("w008"));
		paramMap.put("nbhdcode",request.getParameter("xqbh"));
		paramMap.put("bldgcode",request.getParameter("lybh"));
		paramMap.put("begindate",request.getParameter("begindate"));
		paramMap.put("enddate",request.getParameter("enddate"));
		paramMap.put("ifsh",request.getParameter("ifsh"));
		// 添加操作日志
		LogUtil.write(new Log("产权管理_楼盘转移", "打印 清册", "BuildingTransferAction.inventory",paramMap.toString()));
		ByteArrayOutputStream ops=buildingtransferservice.inventory(paramMap);
		if(ops != null){
			buildingtransferservice.output(ops, response);
		}
	}
	
}
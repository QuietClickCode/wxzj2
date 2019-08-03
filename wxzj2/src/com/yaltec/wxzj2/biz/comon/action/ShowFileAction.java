package com.yaltec.wxzj2.biz.comon.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.comon.core.entity.ReqPamars;
import com.yaltec.wxzj2.biz.file.entity.QueryResource;
import com.yaltec.wxzj2.biz.file.service.ResourceService;

/**
 * 根据文件类型和主键查看文件
 * @ClassName: ShowFileAction 
 * @author 重庆亚亮科技有限公司 txj 
 * @date 2016-9-19 上午10:30:32
 */
@Controller
public class ShowFileAction {
	@Autowired
	private ResourceService resourceService;
	/**
	 * 跳转到通用查看文件
	 * @param model
	 * @param request
	 * @return
	 */
	@RequestMapping("/showfile/index")
	public String index(Model model,HttpServletRequest request) {
		model.addAttribute("module", request.getParameter("module"));
		model.addAttribute("moduleid", request.getParameter("moduleid"));
		
		return "/comon/showfile/index";
	}
	
	
	/**
	 * 根据moduleid查找对应的文件信息
	 */
	@RequestMapping("/showfile/findByModuleid")
	public void findByModuleid(@RequestBody ReqPamars<QueryResource> req, HttpServletRequest request,
			HttpServletResponse response) throws IOException {	
		Map<String, Object> paramMap=req.getParams();
		//查询分页
		Page<QueryResource> page = new Page<QueryResource>(req.getEntity(),req.getPageNo(),req.getPageSize());
		resourceService.findByModuleid(page,paramMap);	
		//返回数据
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 返回结果
		pw.print(page.toJson());
	}
}

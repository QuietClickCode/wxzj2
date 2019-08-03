package com.yaltec.wxzj2.biz.file.action;

import java.io.ByteArrayInputStream;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.comon.core.entity.ReqPamars;
import com.yaltec.comon.log.LogUtil;
import com.yaltec.comon.log.entity.Log;
import com.yaltec.comon.utils.JsonUtil;
import com.yaltec.comon.utils.ServletUtils;
import com.yaltec.comon.utils.StringUtil;
import com.yaltec.wxzj2.biz.file.entity.QueryResource;
import com.yaltec.wxzj2.biz.file.entity.Resource;
import com.yaltec.wxzj2.biz.file.service.ResourceService;
import com.yaltec.wxzj2.biz.system.entity.User;
import com.yaltec.wxzj2.comon.data.DataHolder;
/**
 * 文件管理实现类
 * @ClassName: ResourceAction 
 * @author 重庆亚亮科技有限公司 txj 
 * @date 2016-9-8 上午08:53:28
 */
@Controller
public class ResourceAction {
	@Autowired
	private ResourceService resourceService;
	@Value("${work.path}") //配置文件中定义的保存路径（永久保存）
	private String path;
	
	/**
	 * 文件跳转到首页
	 */
	@RequestMapping("/resource/index")
	public String index2(Model model) {
		return "/file/resource/index";
	}
	
	/**
	 * 根据类型查询文件
	 * @param model
	 * @param request
	 * @param response
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping("/resource/showFileList")
	public String showFileList(Model model,HttpServletRequest request,HttpServletResponse response,RedirectAttributes redirectAttributes) {
		String module=request.getParameter("module")==null?"":request.getParameter("module");
		model.addAttribute("module",module);
		model.addAttribute("volumelibrary", DataHolder.volumelibraryMap);
		model.addAttribute("volumelibraryArchives",JsonUtil.toJson(DataHolder.volumelibraryArchivesMap));
		return "/file/resource/showFileList";
	}
	
	@RequestMapping("/file/list")
	public void list(@RequestBody ReqPamars<QueryResource> req, HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		response.setCharacterEncoding("utf-8");
		Map<String, Object> paramMap=new HashMap<String, Object>();
		
		PrintWriter pw = response.getWriter();
		// 添加操作日志
		LogUtil.write(new Log("文件管理——支取", "查询", "file.list", req.toString()));
		Page<QueryResource> page = new Page<QueryResource>(req.getEntity(), req.getPageNo(), req.getPageSize());
		resourceService.getResourceByModule(page);
		// 返回结果
		pw.print(page.toJson());
	}
	
	
	
	/**
	 * 打开选择案卷信息
	 * @param model
	 * @return
	 */
	@RequestMapping("/resource/showArchive")
	public String showArchive(Model model) {
		model.addAttribute("volumelibrary", DataHolder.volumelibraryMap);
		return "/file/resource/showArchive";
	}
	
	/**
	 * 修改案卷信息
	 * @param req
	 * @param request
	 * @param response
	 * @throws IOException
	 */
	@RequestMapping("/resource/updateArchive")
	public String updateArchive(Model model,HttpServletRequest request, RedirectAttributes redirectAttributes) throws IOException {
		String module=request.getParameter("module");
		Map<String, Object> paramMap=new HashMap<String, Object>();
		String ids=request.getParameter("ids");
		paramMap.put("ids",StringUtil.tokenize(ids, ","));
		paramMap.put("archive",request.getParameter("archive"));
		int result = resourceService.updateArchive(paramMap);
		if (result > 0) {
			redirectAttributes.addFlashAttribute("msg", "归卷成功！");
		} else {
			redirectAttributes.addFlashAttribute("errorMsg", "归卷失败！");
		}
		return "redirect:/resource/showFileList?module="+module;
	}
	
	/**
	 * 下载
	 * @param request
	 * @param response
	 * @throws IOException
	 */
	@RequestMapping("/resource/toDown")
	public void toDown(HttpServletRequest request,HttpServletResponse response) throws IOException {	
		String id = request.getParameter("id");
		String method = request.getParameter("method");
		Resource rs = resourceService.getResourceById(id);
		String filePath = path+"/"+rs.getUuid();

		InputStream input = null;
		if(rs.getStoreType().trim().equals("FILE")){
			try {
				input = new FileInputStream(filePath);
			} catch (FileNotFoundException e) {
				e.printStackTrace();
				//logger.error(rs.getName()+ "文件没找到或已被删除");
				return;
			}	
		}else{
			input = new ByteArrayInputStream(rs.getUploadfile());
		}
		if(method.trim().equals("DOWN")){
			//下载
			ServletUtils.setFileDownloadHeader(request, response, rs.getName());
		}
		IOUtils.copy(input, response.getOutputStream());
	}
	
	/**
	 * 删除文件
	 * @param model
	 * @param request
	 * @param redirectAttributes
	 * @return
	 * @throws IOException
	 */
	@RequestMapping("/resource/toDelete")
	public String toDelete(Model model,HttpServletRequest request, RedirectAttributes redirectAttributes) throws IOException {
		String id=request.getParameter("id");
		String module=request.getParameter("module");
		int result = resourceService.deleteById(id);
		if (result > 0) {
			redirectAttributes.addFlashAttribute("msg", "删除成功！");
		} else {
			redirectAttributes.addFlashAttribute("errorMsg", "删除失败！");
		}
		return "redirect:/resource/showFileList?module="+module;
	}
}

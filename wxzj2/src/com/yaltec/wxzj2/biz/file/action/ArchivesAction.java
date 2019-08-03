package com.yaltec.wxzj2.biz.file.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.LinkedHashMap;
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
import com.yaltec.comon.utils.StringUtil;
import com.yaltec.wxzj2.biz.file.entity.Archives;
import com.yaltec.wxzj2.biz.file.entity.Resource;
import com.yaltec.wxzj2.biz.file.service.ArchivesService;
import com.yaltec.wxzj2.biz.file.service.ResourceService;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 案卷实现类
 * @ClassName: Archives 
 * @author 重庆亚亮科技有限公司 txj 
 * @date 2016-9-6 下午02:18:15
 */
@Controller
public class ArchivesAction {
	@Autowired
	private ArchivesService archivesService;
	@Autowired
	private ResourceService resourceService;
	/**
	 * 跳转到首页
	 */
	@RequestMapping("/archives/index")
	public String index(Model model) {
		model.addAttribute("volumelibrary", DataHolder.volumelibraryMap);
		return "/file/archives/index";
	}
	
	/**
	 * 查询案卷信息
	 */
	@RequestMapping("/archives/list")
	public void list(@RequestBody ReqPamars<Archives> req, HttpServletRequest request,
			HttpServletResponse response) throws IOException {	
		//查询分页
		Page<Archives> page = new Page<Archives>(req.getEntity(), req.getPageNo(), req.getPageSize());
		archivesService.findAll(page);	
		//返回数据
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 返回结果
		pw.print(page.toJson());
	}
	
	/**
	 * 增加案卷页面
	 */
	@RequestMapping("/archives/toAdd")
	public String toAdd(HttpServletRequest request,Model model) {
		model.addAttribute("volumelibrary", DataHolder.volumelibraryMap);
		return "/file/archives/add";
	}

	/**
	 * 添加案卷信息
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/archives/add")
	public String add(Archives archives, HttpServletRequest request, Model model,
			RedirectAttributes redirectAttributes) {
		archives.setRecorder(TokenHolder.getUser().getUserid());
		archives.setDept("");
		Map<String, String> map = toMap(archives);
		archivesService.save(map);
		int result = Integer.valueOf(map.get("result"));
		if (result == 0) {
			//把案卷添加更新到案卷缓存中
			DataHolder.archivesMap.put(archives.getId(),archives);
			//把案卷添加更新到卷库-案卷关系缓存中
			LinkedHashMap<String, Archives> ArchivesMap= DataHolder.volumelibraryArchivesMap.get(archives.getVlid());
			//在卷库-案卷关系缓存中无该卷库的信息
			if(ArchivesMap == null){
				ArchivesMap=new LinkedHashMap<String, Archives>();
			}
			ArchivesMap.put(map.get("id"),archives);
			DataHolder.volumelibraryArchivesMap.put(archives.getVlid(),ArchivesMap);
			redirectAttributes.addFlashAttribute("msg", "添加成功！");
			return "redirect:/archives/index";
		} else {
			redirectAttributes.addFlashAttribute("archives",archives);
			request.setAttribute("errorMsg", "添加失败！");
			return "/file/archives/add";
		}
	}

	/**
	 * 跳转到案卷编辑界面
	 * @param request
	 * @return
	 */
	@RequestMapping("/archives/toUpdate")
	public String toUpdate(String id, Model model) {
		Archives archives = archivesService.findById(id);
		model.addAttribute("archives", archives);
		model.addAttribute("volumelibrary", DataHolder.volumelibraryMap);
		return "/file/archives/update";
	}

	/**
	 * 修改案卷信息
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/archives/update")
	public String update(Archives archives, HttpServletRequest request, Model model,
			RedirectAttributes redirectAttributes) {
		archives.setRecorder(TokenHolder.getUser().getUserid());
		archives.setDept("");
		Map<String, String> map =  toMap(archives);
		archivesService.save(map);
		int result = Integer.valueOf(map.get("result"));
		if (result == 0) {
			//更新数据到案卷缓存中
			DataHolder.archivesMap.put(archives.getId(),archives);
			String old_vlid=request.getParameter("old_vlid");
			//判断案卷所属卷库是否发生变化；存在变化，先从原来的关系缓存中删除
			if(!old_vlid.equals(archives.getVlid())){
				//先在原卷库下的案卷map里面删除该案卷
				LinkedHashMap<String, Archives> archivesMap=DataHolder.volumelibraryArchivesMap.get(old_vlid);
				archivesMap.remove(archives.getId());
				DataHolder.volumelibraryArchivesMap.put(old_vlid,archivesMap);
			}
			//把案卷添加更新到卷库-案卷关系缓存中
			LinkedHashMap<String, Archives> ArchivesMap= DataHolder.volumelibraryArchivesMap.get(archives.getVlid());
			//在卷库-案卷关系缓存中无该卷库的信息
			if(ArchivesMap == null){
				ArchivesMap=new LinkedHashMap<String, Archives>();
			}
			ArchivesMap.put(map.get("id"),archives);
			DataHolder.volumelibraryArchivesMap.put(archives.getVlid(),ArchivesMap);
			redirectAttributes.addFlashAttribute("msg", "修改成功！");
			return "redirect:/archives/index";
		} else {
			redirectAttributes.addFlashAttribute("archives",archives);
			request.setAttribute("errorMsg", "修改失败！");
			return "/file/archives/update";
		}
	}

	/**
	 * 删除案卷信息
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/archives/delete")
	public String delete(String id, HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
		//删除前判断是否有文件
		List<Resource> resourceList=resourceService.getResourceByArchive(id);
		if(resourceList ==null || resourceList.size()==0){
			int result = archivesService.delete(id);
			if (result > 0) {
				//从案卷缓存总获取卷库id
				String vlId=DataHolder.archivesMap.get(id).getVlid();
				//删除该案卷缓存
				DataHolder.archivesMap.remove(id);
				//删除对应的关联缓存
				LinkedHashMap<String, Archives> archivesMap=DataHolder.volumelibraryArchivesMap.get(vlId);
				archivesMap.remove(id);
				DataHolder.volumelibraryArchivesMap.put(vlId,archivesMap);
				//返回成功提示
				redirectAttributes.addFlashAttribute("msg", "删除成功！");
			} else {
				redirectAttributes.addFlashAttribute("errorMsg", "删除失败！");
			}
		}else{			
			redirectAttributes.addFlashAttribute("errorMsg", "该案卷下存在文件，请先转移文件！");
		}
		return "redirect:/archives/index";
	}

	/**
	 * 批量删除
	 * 
	 * @param ids
	 * @param request
	 * @param model
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping("/archives/batchDelete")
	public String batchDelete(String ids, HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
		// 按特定的分隔符把字符串转成List集合
		List<String> idList = StringUtil.tokenize(ids, ",");
		List<Resource> resourceList=resourceService.getResourceByArchiveList(idList);
		if(resourceList ==null || resourceList.size()==0){
			int result = archivesService.batchDelete(idList);
			if (result > 0) {
				String vlId="";
				for (String id : idList) {
					//从案卷缓存总获取卷库id
					vlId=DataHolder.archivesMap.get(id).getVlid();
					//删除该案卷缓存
					DataHolder.archivesMap.remove(id);
					//删除对应的关联缓存
					LinkedHashMap<String, Archives> archivesMap=DataHolder.volumelibraryArchivesMap.get(vlId);
					archivesMap.remove(id);
					DataHolder.volumelibraryArchivesMap.put(vlId,archivesMap);
				}
				redirectAttributes.addFlashAttribute("msg", "删除成功！");
			} else {
				redirectAttributes.addFlashAttribute("errorMsg", "删除失败！");
			}
		}else{
			redirectAttributes.addFlashAttribute("errorMsg", "选中案卷下存在文件，请先转移文件！");
		}
		return "redirect:/archives/index";
	}
	
	/**
	 * developer转MAP
	 * @param developer
	 * @return
	 */
	private Map<String, String> toMap(Archives archives) {
		Map<String, String> map = new HashMap<String, String>();
	    
	    map.put("id", archives.getId());
	    map.put("archiveid", archives.getArchiveid());
	    map.put("name", archives.getName());
	    map.put("vlid", archives.getVlid());
	    map.put("arc_date", archives.getArc_date());
	    
	    map.put("startdate", archives.getStartdate());
	    map.put("enddate", archives.getEnddate());
	    map.put("dept", archives.getDept());
	    map.put("deptname", archives.getDeptname());
	    map.put("dateType", archives.getDateType());
	    
	    map.put("organization", archives.getOrganization());
	    map.put("grade", archives.getGrade());
	    map.put("rgn", archives.getRgn());
	    map.put("cn", archives.getCn());
	    map.put("aid", archives.getAid());
	    
	    map.put("safeid", archives.getSafeid());
	    map.put("microid", archives.getMicroid());
	    map.put("vouchtype", archives.getVouchtype());
	    map.put("vouchstartid", archives.getVouchstartid());
	    map.put("vouchendid", archives.getVouchendid());
	    
	    map.put("page", archives.getPage());
	    map.put("recorder", archives.getRecorder());
	    map.put("record_date", archives.getRecord_date());
	    map.put("remarks", archives.getRemarks());
	    map.put("status", archives.getStatus());
	    
	    map.put("filecount", archives.getFilecount());	    
		map.put("result", "-1");
		return map;
	}
}

package com.yaltec.wxzj2.biz.file.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
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
import com.yaltec.wxzj2.biz.file.entity.Volumelibrary;
import com.yaltec.wxzj2.biz.file.service.VolumeLibraryService;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 卷库管理实现类
 * @ClassName: VolumeLibraryAction 
 * @author 重庆亚亮科技有限公司 txj 
 * @date 2016-9-6 上午09:50:56
 */
@Controller
public class VolumeLibraryAction {
	@Autowired
	private VolumeLibraryService volumeLibraryService;
	/**
	 * 跳转到首页
	 */
	@RequestMapping("/volumelibrary/index")
	public String index(Model model) {
		return "/file/volumelibrary/index";
	}
	
	/**
	 * 查询卷库信息
	 */
	@RequestMapping("/volumelibrary/list")
	public void list(@RequestBody ReqPamars<Volumelibrary> req, HttpServletRequest request,
			HttpServletResponse response) throws IOException {	
		//查询分页
		Page<Volumelibrary> page = new Page<Volumelibrary>(req.getEntity(), req.getPageNo(), req.getPageSize());
		volumeLibraryService.findAll(page);	
		//返回数据
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 返回结果
		pw.print(page.toJson());
	}
	
	/**
	 * 保存卷库页面
	 */
	@RequestMapping("/volumelibrary/toSave")
	public String toSave(HttpServletRequest request,String id, Model model) {
		if(id.equals("")){
			model.addAttribute("volumelibrary", null);
		}else{
			Volumelibrary volumelibrary = DataHolder.volumelibraryMap.get(id);
			model.addAttribute("volumelibrary", volumelibrary);
		}
		return "/file/volumelibrary/save";
	}

	/**
	 * 保存卷库信息
	 * @param request
	 * @return
	 */
	@RequestMapping("/volumelibrary/save")
	public String save(Volumelibrary volumelibrary, HttpServletRequest request, Model model,
			RedirectAttributes redirectAttributes) {
		//添加记录人
		volumelibrary.setRecorder(TokenHolder.getUser().getUserid());
		Map<String, String> map = toMap(volumelibrary);
		//新增时存储过程p_saveVolumelibrary中获取新的id
		volumeLibraryService.save(map);
		int result = Integer.valueOf(map.get("result"));
		if (result == 0) {
			//把数据更新存放到卷库缓存中
			if(volumelibrary.getId().equals("")){
				volumelibrary.setId(map.get("id"));
			}
			DataHolder.volumelibraryMap.put(map.get("id"), volumelibrary);
			redirectAttributes.addFlashAttribute("msg", "保存成功！");
			return "redirect:/volumelibrary/index";
		} else {
			request.setAttribute("msg", "保存失败！");
			model.addAttribute("volumelibrary", volumelibrary);
			return "/file/volumelibrary/save";
		}
	}
	/**
	 * 删除卷库信息
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/volumelibrary/delete")
	public String delete(String id, HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
		int result = volumeLibraryService.delete(id);
		if (result > 0) {
			DataHolder.volumelibraryMap.remove(id);
			DataHolder.volumelibraryArchivesMap.remove(id);
			redirectAttributes.addFlashAttribute("msg", "删除成功！");
		} else if(result == -1) {
			redirectAttributes.addFlashAttribute("errorMsg", "卷库下有案卷信息，请先删除案卷信息！");	
		} else {
			redirectAttributes.addFlashAttribute("errorMsg", "删除失败！");
		}
		return "redirect:/volumelibrary/index";
	}

	/**
	 * 批量删除
	 * 
	 * @param bm
	 * @param request
	 * @param model
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping("/volumelibrary/batchDelete")
	public String batchDelete(String ids, HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
		// 按特定的分隔符把字符串转成List集合
		List<String> idList = StringUtil.tokenize(ids, ",");
		int result = volumeLibraryService.batchDelete(idList);
		if (result > 0) {
			//删除成功删除缓存对应的数据
			for (String id : idList) {
				DataHolder.volumelibraryMap.remove(id);
				DataHolder.volumelibraryArchivesMap.remove(id);
			}
			redirectAttributes.addFlashAttribute("msg", "删除成功");
		} else if(result == -1) {
			redirectAttributes.addFlashAttribute("errorMsg", "选中卷库下有案卷信息，请先删除案卷信息！");		
		} else {
			redirectAttributes.addFlashAttribute("errorMsg", "删除失败");
		}
		return "redirect:/volumelibrary/index";
	}
	
	/**
	 * developer转MAP
	 * 
	 * @param developer
	 * @return
	 */
	private Map<String, String> toMap(Volumelibrary volumelibrary) {
		Map<String, String> map = new HashMap<String, String>();
		map.put("id", volumelibrary.getId());
		map.put("vlid", volumelibrary.getVlid());
		map.put("vlname", volumelibrary.getVlname());
		map.put("vldept", "");
		map.put("recorder", volumelibrary.getRecorder());
		map.put("recorder_date", volumelibrary.getRecorder_date());
		map.put("remarks", volumelibrary.getRemarks());
		map.put("result", "-1");
		return map;
	}
}

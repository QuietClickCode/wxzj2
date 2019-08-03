package com.yaltec.wxzj2.biz.system.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
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
import com.yaltec.comon.utils.ObjectUtil;
import com.yaltec.wxzj2.biz.comon.service.IdUtilService;
import com.yaltec.wxzj2.biz.system.entity.Permission;
import com.yaltec.wxzj2.biz.system.entity.Role;
import com.yaltec.wxzj2.biz.system.entity.ZTree;
import com.yaltec.wxzj2.biz.system.service.RoleService;
import com.yaltec.wxzj2.comon.data.DataHolder;
import com.yaltec.wxzj2.comon.data.service.RoleDataService;

/**
 * 
 * @ClassName: RoleAction
 * @Description: TODO 角色管理信息实现类
 * 
 * @author hequanxin
 * @date 2016-7-13 上午10:08:41
 */
@Controller
public class RoleAction {

	@Autowired
	private RoleService roleService;
	
	@Autowired
	private IdUtilService idUtilService;

	/**
	 * 跳转到首页
	 * @author hequanxin
	 */
	@RequestMapping("/role/index")
	public String index(Model model) {
		return "/system/role/index";
	}
	
	/**
	 * 角色列表
	 * @param req
	 * @param request
	 * @param response
	 * @throws IOException
	 */
	@RequestMapping("/role/list")
	public void list(@RequestBody ReqPamars<Role> req, HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		// 添加操作日志
		LogUtil.write(new Log("角色管理", "查询", "RoleAction.list", req.toString()));
		Page<Role> page = new Page<Role>(req.getEntity(), req.getPageNo(), req.getPageSize());
		roleService.findAll(page);
		// 返回结果
		pw.print(page.toJson());
	}

	/**
	 * 跳转到角色信息编辑界面
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/role/toUpdate")
	public String toUpdate(String bm, Model model) {
		Role role = roleService.findByBm(bm);
		model.addAttribute("role", role);
		return "/system/role/update";
	}
	
	/**
	 * 修改角色信息
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/role/update")
	public String update(Role role, HttpServletRequest request, Model model,
			RedirectAttributes redirectAttributes) {
		String _result=roleService.findByBmMc(role);
		if (_result ==null||_result=="") {
			// 添加操作日志
			LogUtil.write(new Log("角色管理", "修改", "RoleAction.update", role.toString()));
			int result = roleService.update(role);
			if (result > 0) {
				redirectAttributes.addFlashAttribute("msg", "修改成功");
				return "redirect:/role/index";
			} else {
				request.setAttribute("msg", "修改失败");
				return "/system/role/update";
			}
		} else {
			request.setAttribute("msg", "角色名称已存在！");
			return "/system/role/update";
			
		}
	}

	/**
	 * 角色添加页面
	 * @author hequanxin
	 */
	@RequestMapping("/role/toAdd")
	public String roleSave(HttpServletRequest request,Model model){
		String bm = "";
		try {
			bm = idUtilService.getNextBm("role");
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("bm", bm);
		return "/system/role/add";
	}
	
	/**
	 * 保存角色信息
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/role/add")
	public String add(Role role, HttpServletRequest request, Model model,
			RedirectAttributes redirectAttributes) {
		Role _role=roleService.findByMc(role.getMc());
		if (_role != null) {
			request.setAttribute("msg", "名称已存在");
			String bm = "";
			try {
				bm = idUtilService.getNextBm("role");
			} catch (Exception e) {
				e.printStackTrace();
			}
			model.addAttribute("bm", bm);
			return "/system/role/add";
		} else {
			// 添加操作日志
			LogUtil.write(new Log("角色管理", "添加", "RoleAction.add", role.toString()));
			int result = roleService.add(role);
			if (result > 0) {
				// 更新缓存
				DataHolder.updateDataMap(RoleDataService.KEY, role.getBm(), role.getMc());
				redirectAttributes.addFlashAttribute("msg", "添加成功");
				return "redirect:/role/index";
			} else {
				request.setAttribute("msg", "添加失败");
				return "/system/role/add";
			}
		}
	}
	
	/**
	 * 查询角色权限模块
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/role/right")
	public String right(HttpServletRequest request, Model model,String bm) {
			List<ZTree> list=roleService.findTree(bm);
			//List<ZTree> list=roleService.findTree(request.getParameter(arg0));//取参数
			String zNodes = JsonUtil.toJson(list);
			zNodes = zNodes.replaceAll("pid", "pId");
			model.addAttribute("zNodes2", zNodes);
			model.addAttribute("roleId", bm);
			return "/system/user/right/update";
		}
	
	/**
	 * 保存角色权限
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/role/doPermission")
	public String doPermission(Permission permission,HttpServletRequest request,
			RedirectAttributes redirectAttributes,String roleId,Model model){
		List<Permission> tempList=new ArrayList<Permission>();
		roleService.deletePermission(permission.getRoleid());	
		String[] ArrMdid=permission.getMdid().replace("undefined","").split(";");
		for(int i=0;i<ArrMdid.length;i++){
			Permission p = ObjectUtil.clone(permission);
			p.setMdid(ArrMdid[i]);
			tempList.add(p);
		}	
		int result = roleService.savePermission(tempList);
		if (result > 0) {
			redirectAttributes.addFlashAttribute("msg", "保存成功！");
			return "redirect:/role/index";
		} else {
			request.setAttribute("msg", "修改失败");
			return "/system/role/index";
		}
	}
}

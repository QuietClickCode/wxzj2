package com.yaltec.wxzj2.biz.system.entity;

import java.util.List;

import com.yaltec.comon.core.entity.Entity;

/**
 * 菜单实体
 * @ClassName: Menu 
 * @author 重庆亚亮科技有限公司 txj 
 * @date 2016-7-20 下午05:39:34
 */
public class Menu extends Entity {
	/**
	 * 序列化版本标示.
	 */
	private static final long serialVersionUID = 1L;
	/**
	 * 角色id
	 */
	private String roleId;
	/**
	 * 主键编码
	 */
	private String id;
	/**
	 * 父主键
	 */
	private String parentId;
	/**
	 * 菜单名称
	 */
	private String modl_name;
	/**
	 * 菜单地址
	 */
	private String modl_url;
	/**
	 * 菜单描述
	 */
	private String modl_remark;
	/**
	 * 菜单图片
	 */
	private String modl_pic;
	/**
	 * 工作台图片
	 */
	private String modl_workbench_pic;
	/**
	 * 工作台是否显示
	 */
	private String modl_workbench_type;

	/**
	 * 子菜单
	 */
	private List<Menu> children;
	
	
	public Menu() {
		super();
	}

	public Menu(String id,String modl_name,String modl_url,String modl_pic){
		this.id=id;
		this.modl_name=modl_name;
		this.modl_url=modl_url;
		this.modl_pic=modl_pic;
	}

	public String getRoleId() {
		return roleId;
	}

	public void setRoleId(String roleId) {
		this.roleId = roleId;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getParentId() {
		return parentId;
	}

	public void setParentId(String parentId) {
		this.parentId = parentId;
	}

	public String getModl_name() {
		return modl_name;
	}

	public void setModl_name(String modl_name) {
		this.modl_name = modl_name;
	}

	public String getModl_url() {
		return modl_url;
	}

	public void setModl_url(String modl_url) {
		this.modl_url = modl_url;
	}

	public String getModl_remark() {
		return modl_remark;
	}

	public void setModl_remark(String modl_remark) {
		this.modl_remark = modl_remark;
	}

	public String getModl_pic() {
		return modl_pic;
	}

	public void setModl_pic(String modl_pic) {
		this.modl_pic = modl_pic;
	}
	
	public String getModl_workbench_pic() {
		return modl_workbench_pic;
	}

	public void setModl_workbench_pic(String modl_workbench_pic) {
		this.modl_workbench_pic = modl_workbench_pic;
	}

	public String getModl_workbench_type() {
		return modl_workbench_type;
	}

	public void setModl_workbench_isshow(String modl_workbench_type) {
		this.modl_workbench_type = modl_workbench_type;
	}

	public List<Menu> getChildren() {
		return children;
	}

	public void setChildren(List<Menu> children) {
		this.children = children;
	}
}

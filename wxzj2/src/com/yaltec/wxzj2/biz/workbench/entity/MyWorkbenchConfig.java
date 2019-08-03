package com.yaltec.wxzj2.biz.workbench.entity;

import com.yaltec.comon.core.entity.Entity;
import com.yaltec.comon.utils.JsonUtil;
import com.yaltec.wxzj2.biz.system.entity.Menu;
public class MyWorkbenchConfig extends Entity {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String id;
	private String loginid;/*登录id*/
	private String mdid;/*菜单二级id*/
	private String isxs;/*是否显示(默认1显示；0隐藏)*/
	private String pic;/*图片*/
	private Menu menu;
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getLoginid() {
		return loginid;
	}
	public void setLoginid(String loginid) {
		this.loginid = loginid;
	}
	public String getMdid() {
		return mdid;
	}
	public void setMdid(String mdid) {
		this.mdid = mdid;
	}
	public String getIsxs() {
		return isxs;
	}
	public void setIsxs(String isxs) {
		this.isxs = isxs;
	}
	public String getPic() {
		return pic;
	}
	public void setPic(String pic) {
		this.pic = pic;
	}
	public Menu getMenu() {
		return menu;
	}
	public void setMenu(Menu menu) {
		this.menu = menu;
	}
	
	@Override
	public String toString() {
		// TODO Auto-generated method stub
		return JsonUtil.toJson(this);
	}
	
	
}

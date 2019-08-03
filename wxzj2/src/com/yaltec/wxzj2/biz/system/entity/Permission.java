package com.yaltec.wxzj2.biz.system.entity;

import com.yaltec.comon.core.entity.Entity;


public class Permission extends Entity{
	
	/**
	 * 序列化版本标示.
	 */
	private static final long serialVersionUID = 1L;
	
	/**
	 * 模块id
	 */
	private String mdid;
	
	/**
	 * 角色id
	 */
	private String roleid;
	
	public String getMdid() {
		return mdid;
	}

	public void setMdid(String mdid) {
		this.mdid = mdid;
	}

	public String getRoleid() {
		return roleid;
	}

	public void setRoleid(String roleid) {
		this.roleid = roleid;
	}

	@Override
	public String toString() {
		return "Permission [mdid=" + mdid + ", roleid=" + roleid + "]";
	}
	
}

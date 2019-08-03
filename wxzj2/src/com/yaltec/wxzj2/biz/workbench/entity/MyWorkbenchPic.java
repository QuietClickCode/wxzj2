package com.yaltec.wxzj2.biz.workbench.entity;

import com.yaltec.comon.core.entity.Entity;
import com.yaltec.comon.utils.JsonUtil;

public class MyWorkbenchPic extends Entity {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private int id;
	private String picUrl;
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getPicUrl() {
		return picUrl;
	}
	public void setPicUrl(String picUrl) {
		this.picUrl = picUrl;
	}
	@Override
	public String toString() {
		// TODO Auto-generated method stub
		return JsonUtil.toJson(this);
	}
}

package com.yaltec.wxzj2.biz.propertymanager.entity;

import com.yaltec.comon.core.entity.Entity;

/**
 * 楼宇转移实体类
 * @author hqx
 *
 */
public class BuildingTransfer extends Entity{
	/**
	 * 序列化版本标示.
	 */
	private static final long serialVersionUID = 1L;
	private String bldgcodea;
	private String bldgnamea;
	private String h001a;
	private String h013;
	private String h030;
	private String w008;
	private String bldgcodeb;
	private String bldgnameb;
	private String h001b;
	private String w013;
	
	public String getBldgcodea() {
		return bldgcodea;
	}
	public void setBldgcodea(String bldgcodea) {
		this.bldgcodea = bldgcodea;
	}
	public String getBldgnamea() {
		return bldgnamea;
	}
	public void setBldgnamea(String bldgnamea) {
		this.bldgnamea = bldgnamea;
	}
	public String getH001a() {
		return h001a;
	}
	public void setH001a(String h001a) {
		this.h001a = h001a;
	}
	public String getH013() {
		return h013;
	}
	public void setH013(String h013) {
		this.h013 = h013;
	}
	public String getH030() {
		return h030;
	}
	public void setH030(String h030) {
		this.h030 = h030;
	}
	public String getW008() {
		return w008;
	}
	public void setW008(String w008) {
		this.w008 = w008;
	}
	public String getBldgcodeb() {
		return bldgcodeb;
	}
	public void setBldgcodeb(String bldgcodeb) {
		this.bldgcodeb = bldgcodeb;
	}
	public String getBldgnameb() {
		return bldgnameb;
	}
	public void setBldgnameb(String bldgnameb) {
		this.bldgnameb = bldgnameb;
	}
	public String getH001b() {
		return h001b;
	}
	public void setH001b(String h001b) {
		this.h001b = h001b;
	}
	public String getW013() {
		return w013;
	}
	public void setW013(String w013) {
		this.w013 = w013;
	}
	
	@Override
	public String toString() {
		return "BuildingTransfer [bldgcodea=" + bldgcodea + ", bldgcodeb=" + bldgcodeb + ", bldgnamea=" + bldgnamea
				+ ", bldgnameb=" + bldgnameb + ", h001a=" + h001a + ", h001b=" + h001b + ", h013=" + h013 + ", h030="
				+ h030 + ", w008=" + w008 + ", w013=" + w013 + "]";
	}

}

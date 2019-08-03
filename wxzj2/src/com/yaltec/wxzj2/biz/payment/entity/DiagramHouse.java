package com.yaltec.wxzj2.biz.payment.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.yaltec.comon.core.entity.Entity;

/**
 * 楼盘信息-传到页面的房屋信息
 * 
 * @author Administrator
 * 
 */
public class DiagramHouse extends Entity {
	private static final long serialVersionUID = 1L;
	@JsonIgnore
	private String lybh;
	@JsonIgnore
	private String lymc;
	private String h001;
	@JsonIgnore
	private String h002;
	@JsonIgnore
	private String h003;
	private String h005;
	private String h013;
	private String h052;
	private String h053;
	private String status;

	public String getLybh() {
		return lybh;
	}

	public void setLybh(String lybh) {
		this.lybh = lybh;
	}

	public String getH001() {
		return h001;
	}

	public void setH001(String h001) {
		this.h001 = h001;
	}

	public String getH002() {
		return h002;
	}

	public void setH002(String h002) {
		this.h002 = h002;
	}

	public String getH003() {
		return h003;
	}

	public void setH003(String h003) {
		this.h003 = h003;
	}

	public String getH005() {
		return h005;
	}

	public void setH005(String h005) {
		this.h005 = h005;
	}

	public String getH013() {
		return h013;
	}

	public void setH013(String h013) {
		this.h013 = h013;
	}

	public String getH052() {
		return h052;
	}

	public void setH052(String h052) {
		this.h052 = h052;
	}

	public String getH053() {
		return h053;
	}

	public void setH053(String h053) {
		this.h053 = h053;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getLymc() {
		return lymc;
	}

	public void setLymc(String lymc) {
		this.lymc = lymc;
	}

}

package com.yaltec.wxzj2.biz.propertymanager.entity;

import com.yaltec.comon.core.entity.Entity;

/**
 * 交款转移实体类 
 * @author hqx
 *
 */
public class MoneyTransfer extends Entity{
	/**
	 * 序列化版本标示.
	 */
	private static final long serialVersionUID = 1L;
	private String w008;
	private String jflymc;
	private String lybha;
	private String lybhb;
	private String jfh001;
	private String dflymc;
	private String dfh001;
	private String w006;
	private String w013;
	private String username;
	private String userid;
	private String zyrq;
	private String zybj;
	private String zylx;
	
	
	public String getW008() {
		return w008;
	}
	public void setW008(String w008) {
		this.w008 = w008;
	}
	public String getJflymc() {
		return jflymc;
	}
	public void setJflymc(String jflymc) {
		this.jflymc = jflymc;
	}
	public String getJfh001() {
		return jfh001;
	}
	public void setJfh001(String jfh001) {
		this.jfh001 = jfh001;
	}
	public String getDflymc() {
		return dflymc;
	}
	public void setDflymc(String dflymc) {
		this.dflymc = dflymc;
	}
	public String getDfh001() {
		return dfh001;
	}
	public void setDfh001(String dfh001) {
		this.dfh001 = dfh001;
	}
	public String getW006() {
		return w006;
	}
	public void setW006(String w006) {
		this.w006 = w006;
	}
	public String getW013() {
		return w013;
	}
	public void setW013(String w013) {
		this.w013 = w013;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getLybha() {
		return lybha;
	}
	public void setLybha(String lybha) {
		this.lybha = lybha;
	}
	public String getLybhb() {
		return lybhb;
	}
	public void setLybhb(String lybhb) {
		this.lybhb = lybhb;
	}
	public String getUserid() {
		return userid;
	}
	public void setUserid(String userid) {
		this.userid = userid;
	}
	public String getZyrq() {
		return zyrq;
	}
	public void setZyrq(String zyrq) {
		this.zyrq = zyrq;
	}
	public String getZybj() {
		return zybj;
	}
	public void setZybj(String zybj) {
		this.zybj = zybj;
	}
	public String getZylx() {
		return zylx;
	}
	public void setZylx(String zylx) {
		this.zylx = zylx;
	}
	
	@Override
	public String toString() {
		return "MoneyTransfer [dfh001=" + dfh001 + ", dflymc=" + dflymc + ", jfh001=" + jfh001 + ", jflymc=" + jflymc
				+ ", lybha=" + lybha + ", lybhb=" + lybhb + ", userid=" + userid + ", username=" + username + ", w006="
				+ w006 + ", w008=" + w008 + ", w013=" + w013 + ", zybj=" + zybj + ", zylx=" + zylx + ", zyrq=" + zyrq
				+ "]";
	}
	
	
}
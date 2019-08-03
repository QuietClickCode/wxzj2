package com.yaltec.wxzj2.biz.payment.entity;

import com.yaltec.comon.core.entity.Entity;
/**
 *  交款信息查询接受对象
 * @ClassName: QryHouseUnit 
 * @author 重庆亚亮科技有限公司 txj 
 * @date 2016-8-25 下午02:50:54
 */
public class QryHouseUnit extends Entity {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private String xqmc;
	private String lymc;
	private String kfgsmc;
	private String p008;
	private String unitname;
	private String p024;
	private String p004;
	private String p005;
	private String bankno;
	public String getXqmc() {
		return xqmc;
	}
	public void setXqmc(String xqmc) {
		this.xqmc = xqmc;
	}
	public String getLymc() {
		return lymc;
	}
	public void setLymc(String lymc) {
		this.lymc = lymc;
	}
	public String getKfgsmc() {
		return kfgsmc;
	}
	public void setKfgsmc(String kfgsmc) {
		this.kfgsmc = kfgsmc;
	}
	public String getP008() {
		return p008;
	}
	public void setP008(String p008) {
		this.p008 = p008;
	}
	public String getUnitname() {
		return unitname;
	}
	public void setUnitname(String unitname) {
		this.unitname = unitname;
	}
	public String getP024() {
		return p024;
	}
	public void setP024(String p024) {
		this.p024 = p024;
	}
	public String getP004() {
		return p004;
	}
	public void setP004(String p004) {
		this.p004 = p004;
	}
	public String getP005() {
		return p005;
	}
	public void setP005(String p005) {
		this.p005 = p005;
	}
	public String getBankno() {
		return bankno;
	}
	public void setBankno(String bankno) {
		this.bankno = bankno;
	}
	
	@Override
	public String toString() {
		return "QryHouseUnit [bankno=" + bankno + ", kfgsmc=" + kfgsmc
				+ ", lymc=" + lymc + ", p004=" + p004 + ", p005=" + p005
				+ ", p008=" + p008 + ", p024=" + p024 + ", unitname="
				+ unitname + ", xqmc=" + xqmc + "]";
	}
}

package com.yaltec.wxzj2.biz.payment.entity;

import com.yaltec.comon.core.entity.Entity;

/**
 * 交款登记通知书打印（业务编号）
 * @ClassName: PaymentRegTZS 
 * @author 重庆亚亮科技有限公司 txj 
 * @date 2016-8-26 上午11:20:58
 */
public class PaymentRegTZS extends Entity {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String lybh;
	private String lymc;
	private String unitcode;
	private String unitname;
	private String bankno;
	private String w013;
	private String w006;
	private String ct;
	private String today;
	private String yhbh;
	private String yhmc;
	
	public String getToday() {
		return today;
	}
	public void setToday(String today) {
		this.today = today;
	}
	public String getLybh() {
		return lybh;
	}
	public void setLybh(String lybh) {
		this.lybh = lybh;
	}
	public String getLymc() {
		return lymc;
	}
	public void setLymc(String lymc) {
		this.lymc = lymc;
	}
	public String getUnitcode() {
		return unitcode;
	}
	public void setUnitcode(String unitcode) {
		this.unitcode = unitcode;
	}
	public String getUnitname() {
		return unitname;
	}
	public void setUnitname(String unitname) {
		this.unitname = unitname;
	}
	public String getBankno() {
		return bankno;
	}
	public void setBankno(String bankno) {
		this.bankno = bankno;
	}
	public String getW013() {
		return w013;
	}
	public void setW013(String w013) {
		this.w013 = w013;
	}
	public String getW006() {
		return w006;
	}
	public void setW006(String w006) {
		this.w006 = w006;
	}
	public String getCt() {
		return ct;
	}
	public void setCt(String ct) {
		this.ct = ct;
	}
	public String getYhbh() {
		return yhbh;
	}
	public void setYhbh(String yhbh) {
		this.yhbh = yhbh;
	}
	public String getYhmc() {
		return yhmc;
	}
	public void setYhmc(String yhmc) {
		this.yhmc = yhmc;
	}	
	@Override
	public String toString() {
		return "PaymentRegTZS [bankno=" + bankno + ", ct=" + ct + ", lybh="
				+ lybh + ", lymc=" + lymc + ", today=" + today + ", unitcode="
				+ unitcode + ", unitname=" + unitname + ", w006=" + w006
				+ ", w013=" + w013 + ", yhbh=" + yhbh + ", yhmc=" + yhmc + "]";
	}	
}

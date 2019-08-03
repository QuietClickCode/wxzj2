package com.yaltec.wxzj2.biz.payment.entity;

import com.yaltec.comon.core.entity.Entity;
/**
 * 现金交款凭证信息
 * @ClassName: CashPayment 
 * @author 重庆亚亮科技有限公司 txj 
 * @date 2016-8-26 上午10:44:52
 */
public class CashPayment extends Entity {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String skr;
	private String yhbh;
	private String yhmc;
	private String bankno;
	private String zjxm;
	private String bz;
	private String h021;
	private String h001;
	
	public String getSkr() {
		return skr;
	}
	public void setSkr(String skr) {
		this.skr = skr;
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
	public String getBankno() {
		return bankno;
	}
	public void setBankno(String bankno) {
		this.bankno = bankno;
	}
	public String getZjxm() {
		return zjxm;
	}
	public void setZjxm(String zjxm) {
		this.zjxm = zjxm;
	}
	public String getBz() {
		return bz;
	}
	public void setBz(String bz) {
		this.bz = bz;
	}
	public String getH021() {
		return h021;
	}
	public void setH021(String h021) {
		this.h021 = h021;
	}
	public String getH001() {
		return h001;
	}
	public void setH001(String h001) {
		this.h001 = h001;
	}
	@Override
	public String toString() {
		return "CashPayment [bankno=" + bankno + ", bz=" + bz + ", h001="
				+ h001 + ", h021=" + h021 + ", skr=" + skr + ", yhbh=" + yhbh
				+ ", yhmc=" + yhmc + ", zjxm=" + zjxm + "]";
	}
}

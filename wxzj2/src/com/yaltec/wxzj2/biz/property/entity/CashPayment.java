package com.yaltec.wxzj2.biz.property.entity;

import com.yaltec.comon.core.entity.Entity;

/**
 * 
 * @ClassName: CashPayment
 * @Description: TODO现金资金凭证信息
 * 
 * @author yangshanping
 * @date 2016-7-29 下午03:24:05
 */
public class CashPayment extends Entity{
	/**
	 * 序列化版本标示.
	 */
	private static final long serialVersionUID = 1L;
	/**
	 * 收款人全称
	 */
	private String skr;
	/**
	 * 银行编号
	 */
	private String yhbh;
	/**
	 * 银行名称
	 */
	private String yhmc;
	/**
	 * 银行账号
	 */
	private String bankno;
	/**
	 * 款项来源
	 */
	private String zjxm;
	/**
	 * 币种 
	 */
	private String bz;
	/**
	 * 应交资金
	 */
	private String h021;
	/**
	 * 房屋编码
	 */
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

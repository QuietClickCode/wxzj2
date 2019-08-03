package com.yaltec.wxzj2.biz.voucher.entity;

/**
 * 月末报告实体类
 * @author hqx
 *
 */
public class CheckoutEndOfMonth {
	private String p004;
	private String p005;
	private String p008;
	private String p009;
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
	public String getP008() {
		return p008;
	}
	public void setP008(String p008) {
		this.p008 = p008;
	}
	public String getP009() {
		return p009;
	}
	public void setP009(String p009) {
		this.p009 = p009;
	}
	
	public boolean getflag() {
		if (p008.equals(p009)) {
			return false;
		} else {
			return true;
		}
	}
	
	@Override
	public String toString() {
		return "CheckoutEndOfMonth [p004=" + p004 + ", p005=" + p005 + ", p008=" + p008 + ", p009=" + p009 + "]";
	}
}

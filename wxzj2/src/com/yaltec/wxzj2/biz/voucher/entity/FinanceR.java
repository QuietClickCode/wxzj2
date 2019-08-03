package com.yaltec.wxzj2.biz.voucher.entity;

/**
 *<p>文件名称: FinanceR.java</p>
 * <p>文件描述: </p>
 * <p>版权所有: 版权所有(C)2010</p>
 * <p>公   司: yaltec</p>
 * <p>内容摘要: 信息</p>
 * <p>其他说明: </p>
 * <p>完成日期：Oct 19, 2013</p>
 * <p>修改记录0：无</p>
 * @version 1.0
 * @author hqx
 */
public class FinanceR {
	private String h001;
	private String p005;
	private String p006;
	private String type;
	private String p008;
	private String p009;
	private String bm;
	
	public String getH001() {
		return h001;
	}
	public void setH001(String h001) {
		this.h001 = h001;
	}
	public String getP005() {
		return p005;
	}
	public void setP005(String p005) {
		this.p005 = p005;
	}
	public String getP006() {
		return p006;
	}
	public void setP006(String p006) {
		this.p006 = p006;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
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
	public String getBm() {
		return bm;
	}
	public void setBm(String bm) {
		this.bm = bm;
	}
	
	@Override
	public String toString() {
		return "FinanceR [bm=" + bm + ", h001=" + h001 + ", p005=" + p005 + ", p006=" + p006 + ", p008=" + p008
				+ ", p009=" + p009 + ", type=" + type + "]";
	}
}

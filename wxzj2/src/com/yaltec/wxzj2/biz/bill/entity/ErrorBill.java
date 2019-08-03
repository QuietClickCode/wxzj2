package com.yaltec.wxzj2.biz.bill.entity;

import com.yaltec.comon.core.entity.Entity;

/**
 * <p>
 * ClassName: ErrorBill
 * </p>
 * <p>
 * Description: 错误票据实体
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author moqian
 * @date 2016-8-1 上午08:36:58
 */

public class ErrorBill extends Entity {
	
	/**
	 * 序列化版本标示.
	 */
	private static final long serialVersionUID = 1L;

	private String pjh; //票据号
	private String h001; //房屋编号
	private String lymc; //楼宇名称
	private String w013; //业务日期
	private String w004; //票据金额
	private String yhmc; //银行名称
	private String gybh; //柜员编号
	private String w008; //业务编号
	private String serialno; //流水号
	private String reson; //错误情况
	
	public String getPjh() {
		return pjh;
	}
	public void setPjh(String pjh) {
		this.pjh = pjh;
	}
	public String getH001() {
		return h001;
	}
	public void setH001(String h001) {
		this.h001 = h001;
	}
	public String getLymc() {
		return lymc;
	}
	public void setLymc(String lymc) {
		this.lymc = lymc;
	}
	public String getW013() {
		return w013;
	}
	public void setW013(String w013) {
		this.w013 = w013;
	}
	public String getW004() {
		return w004;
	}
	public void setW004(String w004) {
		this.w004 = w004;
	}
	public String getYhmc() {
		return yhmc;
	}
	public void setYhmc(String yhmc) {
		this.yhmc = yhmc;
	}
	public String getGybh() {
		return gybh;
	}
	public void setGybh(String gybh) {
		this.gybh = gybh;
	}
	public String getW008() {
		return w008;
	}
	public void setW008(String w008) {
		this.w008 = w008;
	}
	public String getSerialno() {
		return serialno;
	}
	public void setSerialno(String serialno) {
		this.serialno = serialno;
	}
	public String getReson() {
		return reson;
	}
	public void setReson(String reson) {
		this.reson = reson;
	}
	
	@Override
	public String toString() {
		return "ErrorBill [gybh=" + gybh + ", h001=" + h001 + ", lymc=" + lymc + ", pjh=" + pjh + ", reson=" + reson
				+ ", serialno=" + serialno + ", w004=" + w004 + ", w008=" + w008 + ", w013=" + w013 + ", yhmc=" + yhmc
				+ "]";
	}
	
}

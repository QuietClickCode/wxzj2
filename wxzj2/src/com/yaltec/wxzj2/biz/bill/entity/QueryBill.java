package com.yaltec.wxzj2.biz.bill.entity;

import com.yaltec.comon.core.entity.Entity;

/**
 * <p>
 * ClassName: QueryBill
 * </p>
 * <p>
 * Description: 票据查询实体
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author moqian
 * @date 2016-7-28 上午11:36:58
 */

public class QueryBill extends Entity {
	
	/**
	 * 序列化版本标示.
	 */
	private static final long serialVersionUID = 1L;
	
	private String bm; //编码
	private String pjh; //票据号
	private String sfqy; //是否启用
	private String sfuse; //是否已用
	private String sfzf; //是否作废
	private String h001; //房屋编号
	private String w014; //业务日期
	private String w006; //票据金额
	private String lymc; //楼宇名称
	private String ct; 
	private String totalAmount; 
	private String zfzs; //作废张数
	private String yhbh; //银行编号
	private String yhmc; //银行名称
	private String regNo; //票据批次号
	
	public String getBm() {
		return bm;
	}
	public void setBm(String bm) {
		this.bm = bm;
	}
	public String getPjh() {
		return pjh;
	}
	public void setPjh(String pjh) {
		this.pjh = pjh;
	}
	public String getSfqy() {
		return sfqy;
	}
	public void setSfqy(String sfqy) {
		this.sfqy = sfqy;
	}
	public String getSfuse() {
		return sfuse;
	}
	public void setSfuse(String sfuse) {
		this.sfuse = sfuse;
	}
	public String getSfzf() {
		return sfzf;
	}
	public void setSfzf(String sfzf) {
		this.sfzf = sfzf;
	}
	public String getH001() {
		return h001 == null ? "" : h001;
	}
	public void setH001(String h001) {
		this.h001 = h001;
	}
	public String getW014() {
		return w014 == null ? "" : w014;
	}
	public void setW014(String w014) {
		this.w014 = w014;
	}
	public String getW006() {
		return w006 == null ? "" : w006;
	}
	public void setW006(String w006) {
		this.w006 = w006;
	}
	public String getLymc() {
		return lymc == null ? "" : lymc;
	}
	public void setLymc(String lymc) {
		this.lymc = lymc;
	}
	public String getCt() {
		return ct;
	}
	public void setCt(String ct) {
		this.ct = ct;
	}
	public String getTotalAmount() {
		return totalAmount;
	}
	public void setTotalAmount(String totalAmount) {
		this.totalAmount = totalAmount;
	}
	public String getZfzs() {
		return zfzs;
	}
	public void setZfzs(String zfzs) {
		this.zfzs = zfzs;
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
	public String getRegNo() {
		return regNo;
	}
	public void setRegNo(String regNo) {
		this.regNo = regNo;
	}
	
	@Override
	public String toString() {
		return "QueryBill [bm=" + bm + ", ct=" + ct + ", h001=" + h001 + ", lymc=" + lymc + ", pjh=" + pjh + ", regNo="
				+ regNo + ", sfqy=" + sfqy + ", sfuse=" + sfuse + ", sfzf=" + sfzf + ", totalAmount=" + totalAmount
				+ ", w006=" + w006 + ", w014=" + w014 + ", yhbh=" + yhbh + ", yhmc=" + yhmc + ", zfzs=" + zfzs + "]";
	}
}

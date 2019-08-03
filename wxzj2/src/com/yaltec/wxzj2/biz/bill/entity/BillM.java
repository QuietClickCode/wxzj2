package com.yaltec.wxzj2.biz.bill.entity;


import com.yaltec.comon.core.entity.Entity;

/**
 * <p>
 * ClassName: BillM
 * </p>
 * <p>
 * Description: 票据信息实体
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author moqian
 * @date 2016-7-19 下午02:36:58
 */

public class BillM extends Entity {
	
	/**
	 * 序列化版本标示.
	 */
	private static final long serialVersionUID = 1L;	
	
	private String bm; //主键编码
	private String pjdm; //票据代码
	private String pjmc; //票据名称
	private String qsh; //票据起始号
	private String zzh; //票据终止号
	private String pjlbbm; //票据类别编码
	private String pjlbmc; //票据类别名称
	private String pjzs; //票据张数
	private String pjls; //票据联数
	private String username; //购买人员
	private String czry; //领用人员
	private String gmrq; //领用日期
	private String yhbh; //银行编号
	private String yhmc; //银行名称
	private String regNo; //票据版本号
	
	private String sfqy;
	
	
	public String getBm() {
		return bm;
	}
	public void setBm(String bm) {
		this.bm = bm;
	}
	public String getPjdm() {
		return pjdm;
	}
	public void setPjdm(String pjdm) {
		this.pjdm = pjdm;
	}
	public String getPjmc() {
		return pjmc;
	}
	public void setPjmc(String pjmc) {
		this.pjmc = pjmc;
	}
	public String getQsh() {
		return qsh;
	}
	public void setQsh(String qsh) {
		this.qsh = qsh;
	}
	public String getZzh() {
		return zzh;
	}
	public void setZzh(String zzh) {
		this.zzh = zzh;
	}
	public String getPjlbbm() {
		return pjlbbm;
	}
	public void setPjlbbm(String pjlbbm) {
		this.pjlbbm = pjlbbm;
	}
	public String getPjlbmc() {
		return pjlbmc;
	}
	public void setPjlbmc(String pjlbmc) {
		this.pjlbmc = pjlbmc;
	}
	public String getPjzs() {
		return pjzs;
	}
	public void setPjzs(String pjzs) {
		this.pjzs = pjzs;
	}
	public String getPjls() {
		return pjls;
	}
	public void setPjls(String pjls) {
		this.pjls = pjls;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getCzry() {
		return czry;
	}
	public void setCzry(String czry) {
		this.czry = czry;
	}
	public String getGmrq() {
		return gmrq;
	}
	public void setGmrq(String gmrq) {
		this.gmrq = gmrq;
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
	
	
	public String getSfqy() {
		return sfqy == null ? "0" : sfqy;
	}
	public void setSfqy(String sfqy) {
		this.sfqy = sfqy;
	}
	@Override
	public String toString() {
		return "BillM [bm=" + bm + ", czry=" + czry + ", gmrq=" + gmrq + ", pjdm=" + pjdm + ", pjlbbm=" + pjlbbm
				+ ", pjlbmc=" + pjlbmc + ", pjls=" + pjls + ", pjmc=" + pjmc + ", pjzs=" + pjzs + ", qsh=" + qsh
				+ ", regNo=" + regNo + ", sfqy=" + sfqy + ", username=" + username + ", yhbh=" + yhbh + ", yhmc="
				+ yhmc + ", zzh=" + zzh + "]";
	}
	
}

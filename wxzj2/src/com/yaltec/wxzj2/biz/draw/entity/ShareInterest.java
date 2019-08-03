package com.yaltec.wxzj2.biz.draw.entity;

import com.yaltec.comon.core.entity.Entity;
/**
 * 
* @ClassName: ShareInterest
* @Description: 已分摊数据实体类

* @author yangshanping
* @date 2016-9-7 上午10:09:27
 */
public class ShareInterest extends Entity{
	/**
	 * 序列化版本标示.
	 */
	private static final long serialVersionUID = 1L;
	/**
	 * 楼宇名称
	 */
	private String lymc;
	/**
	 * 房屋编号
	 */
	private String h001;
	/**
	 * 单元
	 */
	private String h002;
	/**
	 * 层
	 */
	private String h003;
	/**
	 * 房号
	 */
	private String h005;
	/**
	 * 建筑面积
	 */
	private String h006;
	/**
	 * 房款
	 */
	private String h010;
	/**
	 * 业主姓名
	 */
	private String h013;
	/**
	 * 身份证号
	 */
	private String h015;
	/**
	 * 产权证号
	 */
	private String h016;
	/**
	 * 联系电话
	 */
	private String h019;
	/**
	 * 应交资金
	 */
	private String h021;
	/**
	 * 交存标准编号
	 */
	private String h022;
	/**
	 * 本金余额
	 */
	private String h030;
	/**
	 * 利息余额
	 */
	private String h031;
	/**
	 * 
	 */
	private String w004;
	/**
	 * 
	 */
	private String w005;
	/**
	 * 分摊金额
	 */
	private String ftje;
	/**
	 * 
	 */
	private String serialno;
	/**
	 * 首交日期
	 */
	private String h020;
	
	
	public String getLymc() {
		return lymc;
	}
	public void setLymc(String lymc) {
		this.lymc = lymc;
	}
	public String getH001() {
		return h001;
	}
	public void setH001(String h001) {
		this.h001 = h001;
	}
	public String getH002() {
		return h002;
	}
	public void setH002(String h002) {
		this.h002 = h002;
	}
	public String getH003() {
		return h003;
	}
	public void setH003(String h003) {
		this.h003 = h003;
	}
	public String getH005() {
		return h005;
	}
	public void setH005(String h005) {
		this.h005 = h005;
	}
	public String getH006() {
		return h006;
	}
	public void setH006(String h006) {
		this.h006 = h006;
	}
	public String getH010() {
		return h010;
	}
	public void setH010(String h010) {
		this.h010 = h010;
	}
	public String getH013() {
		return h013;
	}
	public void setH013(String h013) {
		this.h013 = h013;
	}
	public String getH015() {
		return h015;
	}
	public void setH015(String h015) {
		this.h015 = h015;
	}
	public String getH016() {
		return h016;
	}
	public void setH016(String h016) {
		this.h016 = h016;
	}
	public String getH019() {
		return h019;
	}
	public void setH019(String h019) {
		this.h019 = h019;
	}
	public String getH021() {
		return h021;
	}
	public void setH021(String h021) {
		this.h021 = h021;
	}
	public String getH022() {
		return h022;
	}
	public void setH022(String h022) {
		this.h022 = h022;
	}
	public String getH030() {
		return h030;
	}
	public void setH030(String h030) {
		this.h030 = h030;
	}
	public String getH031() {
		return h031;
	}
	public void setH031(String h031) {
		this.h031 = h031;
	}
	public String getW004() {
		return w004;
	}
	public void setW004(String w004) {
		this.w004 = w004;
	}
	public String getW005() {
		return w005;
	}
	public void setW005(String w005) {
		this.w005 = w005;
	}
	public String getFtje() {
		return ftje;
	}
	public void setFtje(String ftje) {
		this.ftje = ftje;
	}
	public String getSerialno() {
		return serialno;
	}
	public void setSerialno(String serialno) {
		this.serialno = serialno;
	}
	public String getH020() {
		return h020;
	}
	public void setH020(String h020) {
		this.h020 = h020;
	}
	
	@Override
	public String toString() {
		return "ShareInterest [ftje=" + ftje + ", h001=" + h001 + ", h002="
				+ h002 + ", h003=" + h003 + ", h005=" + h005 + ", h006=" + h006
				+ ", h010=" + h010 + ", h013=" + h013 + ", h015=" + h015
				+ ", h016=" + h016 + ", h019=" + h019 + ", h020=" + h020
				+ ", h021=" + h021 + ", h022=" + h022 + ", h030=" + h030
				+ ", h031=" + h031 + ", lymc=" + lymc + ", serialno="
				+ serialno + ", w004=" + w004 + ", w005=" + w005 + "]";
	}
	
	

}

package com.yaltec.wxzj2.biz.compositeQuery.entity;

import com.yaltec.comon.core.entity.Entity;

/**
 * <p>
 * ClassName: ByCommunityForB
 * </p>
 * <p>
 * Description: 小区余额查询实体
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author moqian
 * @date 2016-8-9 下午14:12:58
 */

public class ByCommunityForB extends Entity {
	
	/**
	 * 序列化版本标示.
	 */
	private static final long serialVersionUID = 1L;
	
	private String xmbh; 
	private String xmmc;
	private String xqbh; //小区编号
	private String xqmc; //小区名称
	private String lybh; //楼宇编号
	private String lymc; //楼宇名称
	private String jkje; //交款金额
	private String jklx; //交款类型
	private String zqje; //支取金额
	private String zqlx; //支取类型
	private String yz; //业主
	private String bj; //本金
	private String lx; //利息
	private String ye; //余额
	private String mdate; //截止日期
	
	public String getXmbh() {
		return xmbh;
	}
	public void setXmbh(String xmbh) {
		this.xmbh = xmbh;
	}
	public String getXmmc() {
		return xmmc;
	}
	public void setXmmc(String xmmc) {
		this.xmmc = xmmc;
	}
	public String getXqbh() {
		return xqbh;
	}
	public void setXqbh(String xqbh) {
		this.xqbh = xqbh;
	}
	public String getXqmc() {
		return xqmc;
	}
	public void setXqmc(String xqmc) {
		this.xqmc = xqmc;
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
	public String getJkje() {
		return jkje;
	}
	public void setJkje(String jkje) {
		this.jkje = jkje;
	}
	public String getJklx() {
		return jklx;
	}
	public void setJklx(String jklx) {
		this.jklx = jklx;
	}
	public String getZqje() {
		return zqje;
	}
	public void setZqje(String zqje) {
		this.zqje = zqje;
	}
	public String getZqlx() {
		return zqlx;
	}
	public void setZqlx(String zqlx) {
		this.zqlx = zqlx;
	}
	public String getYz() {
		return yz;
	}
	public void setYz(String yz) {
		this.yz = yz;
	}
	public String getBj() {
		return bj;
	}
	public void setBj(String bj) {
		this.bj = bj;
	}
	public String getLx() {
		return lx;
	}
	public void setLx(String lx) {
		this.lx = lx;
	}
	public String getYe() {
		return ye;
	}
	public void setYe(String ye) {
		this.ye = ye;
	}
	public String getMdate() {
		return mdate;
	}
	public void setMdate(String mdate) {
		this.mdate = mdate;
	}
	
	@Override
	public String toString() {
		return "ByCommunityForB [bj=" + bj + ", jkje=" + jkje + ", jklx=" + jklx + ", lx=" + lx + ", lybh=" + lybh
				+ ", lymc=" + lymc + ", mdate=" + mdate + ", xmbh=" + xmbh + ", xmmc=" + xmmc + ", xqbh=" + xqbh
				+ ", xqmc=" + xqmc + ", ye=" + ye + ", yz=" + yz + ", zqje=" + zqje + ", zqlx=" + zqlx + "]";
	} 
	
}

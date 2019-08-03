package com.yaltec.wxzj2.biz.compositeQuery.entity;

import com.yaltec.comon.core.entity.Entity;

/**
 * <p>
 * ClassName: BuildingCall
 * </p>
 * <p>
 * Description: 楼宇催交查询实体
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author moqian
 * @date 2016-8-26 下午14:12:58
 */

public class BuildingCall extends Entity {
	
	/**
	 * 序列化版本标示.
	 */
	private static final long serialVersionUID = 1L;
	
	private String xqbh;
	private String xqmc;
	private String lybh;
	private String lymc;
	private String yjje;//应交金额
	private String sjje;//实交金额
	private String zqje;//支取金额
	private String zqje2;//支取金额（某段时间的支取金额）
	private String kyje;//可用金额
	private String zjje;//征缴金额
	private String mdate;//截止日期
	
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
	public String getYjje() {
		return yjje;
	}
	public void setYjje(String yjje) {
		this.yjje = yjje;
	}
	public String getSjje() {
		return sjje;
	}
	public void setSjje(String sjje) {
		this.sjje = sjje;
	}
	public String getZqje() {
		return zqje;
	}
	public void setZqje(String zqje) {
		this.zqje = zqje;
	}
	public String getZqje2() {
		return zqje2;
	}
	public void setZqje2(String zqje2) {
		this.zqje2 = zqje2;
	}
	public String getKyje() {
		return kyje;
	}
	public void setKyje(String kyje) {
		this.kyje = kyje;
	}
	public String getZjje() {
		return zjje;
	}
	public void setZjje(String zjje) {
		this.zjje = zjje;
	}
	public String getMdate() {
		return mdate;
	}
	public void setMdate(String mdate) {
		this.mdate = mdate;
	}
	
	@Override
	public String toString() {
		return "BuildingCall [kyje=" + kyje + ", lybh=" + lybh + ", lymc=" + lymc + ", mdate=" + mdate + ", sjje="
				+ sjje + ", xqbh=" + xqbh + ", xqmc=" + xqmc + ", yjje=" + yjje + ", zjje=" + zjje + ", zqje=" + zqje
				+ ", zqje2=" + zqje2 + "]";
	}
}
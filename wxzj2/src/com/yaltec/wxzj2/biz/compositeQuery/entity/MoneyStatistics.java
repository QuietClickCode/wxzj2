package com.yaltec.wxzj2.biz.compositeQuery.entity;

import com.yaltec.comon.core.entity.Entity;

/**
 * <p>
 * ClassName: MoneyStatistics
 * </p>
 * <p>
 * Description: 资金统计报表
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author hequanxin
 * @date 2017-04-06 下午14:12:58
 */

public class MoneyStatistics extends Entity {
	
	/**
	 * 序列化版本标示.
	 */
	private static final long serialVersionUID = 1L;
	
	private String dwmc;//单位名称
	private String lybh;
	private String lymc;
	
	private String zmj;//总面积
	private String zhs;//总户数
	private String zjkje;//总应缴金额
	
	private String yjmj;//已缴面积
	private String yjhs;//已缴户数
	private String yjje;//已缴金额
	
	private String wjmj;//未缴面积
	private String wjhs;//未缴户数
	private String wjje;//未缴金额
	
	public String getDwmc() {
		return dwmc;
	}
	public void setDwmc(String dwmc) {
		this.dwmc = dwmc;
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
	public String getZmj() {
		return zmj;
	}
	public void setZmj(String zmj) {
		this.zmj = zmj;
	}
	public String getZhs() {
		return zhs;
	}
	public void setZhs(String zhs) {
		this.zhs = zhs;
	}
	public String getZjkje() {
		return zjkje;
	}
	public void setZjkje(String zjkje) {
		this.zjkje = zjkje;
	}
	public String getYjmj() {
		return yjmj;
	}
	public void setYjmj(String yjmj) {
		this.yjmj = yjmj;
	}
	public String getYjhs() {
		return yjhs;
	}
	public void setYjhs(String yjhs) {
		this.yjhs = yjhs;
	}
	public String getYjje() {
		return yjje;
	}
	public void setYjje(String yjje) {
		this.yjje = yjje;
	}
	public String getWjmj() {
		return wjmj;
	}
	public void setWjmj(String wjmj) {
		this.wjmj = wjmj;
	}
	public String getWjhs() {
		return wjhs;
	}
	public void setWjhs(String wjhs) {
		this.wjhs = wjhs;
	}
	public String getWjje() {
		return wjje;
	}
	public void setWjje(String wjje) {
		this.wjje = wjje;
	}
	
	@Override
	public String toString() {
		return "MoneyStatistics [dwmc=" + dwmc + ", lybh=" + lybh + ", lymc=" + lymc + ", wjhs=" + wjhs + ", wjje="
				+ wjje + ", wjmj=" + wjmj + ", yjhs=" + yjhs + ", yjje=" + yjje + ", yjmj=" + yjmj + ", zhs=" + zhs
				+ ", zjkje=" + zjkje + ", zmj=" + zmj + "]";
	}
	

}
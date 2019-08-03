package com.yaltec.wxzj2.biz.compositeQuery.entity;

import com.yaltec.comon.core.entity.Entity;

/**
 * <p>
 * ClassName: QueryUnitForB
 * </p>
 * <p>
 * Description: 单元余额查询实体
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author moqian
 * @date 2016-8-23 上午09:12:58
 */

public class QueryUnitForB extends Entity {	
	/**
	 * 序列化版本标示.
	 */
	private static final long serialVersionUID = 1L;
	
	private String lybh; //楼宇编号
	private String lymc; //楼宇名称
	private String h002; //单元名称
	private Double jkje; //交款金额
	private Double zqje; //支出金额
	private Double yz; //
	private Double bj; //剩余本金
	private Double lx; //剩余利息
	private Double ye; //余额 
	private String mdate; //截止日期
	
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
	public String getH002() {
		return h002;
	}
	public void setH002(String h002) {
		this.h002 = h002;
	}
	public Double getJkje() {
		return jkje;
	}
	public void setJkje(Double jkje) {
		this.jkje = jkje;
	}
	public Double getZqje() {
		return zqje;
	}
	public void setZqje(Double zqje) {
		this.zqje = zqje;
	}
	public Double getYz() {
		return yz;
	}
	public void setYz(Double yz) {
		this.yz = yz;
	}
	public Double getBj() {
		return bj;
	}
	public void setBj(Double bj) {
		this.bj = bj;
	}
	public Double getLx() {
		return lx;
	}
	public void setLx(Double lx) {
		this.lx = lx;
	}
	public Double getYe() {
		return ye;
	}
	public void setYe(Double ye) {
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
		return "QueryUnitForB [bj=" + bj + ", h002=" + h002 + ", jkje=" + jkje + ", lx=" + lx + ", lybh=" + lybh
				+ ", lymc=" + lymc + ", mdate=" + mdate + ", ye=" + ye + ", yz=" + yz + ", zqje=" + zqje + "]";
	}

}

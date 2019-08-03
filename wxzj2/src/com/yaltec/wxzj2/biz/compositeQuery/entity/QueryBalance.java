package com.yaltec.wxzj2.biz.compositeQuery.entity;

import com.yaltec.comon.core.entity.Entity;

/**
 * <p>
 * ClassName: QueryBalance
 * </p>
 * <p>
 * Description: 业主余额查询实体
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author moqian
 * @date 2016-8-9 下午16:12:58
 */

public class QueryBalance extends Entity {
	
	/**
	 * 序列化版本标示.
	 */
	private static final long serialVersionUID = 1L;
	
	private String h001; //房屋编号
	private String lymc; //楼宇名称
	private String h013; //业主姓名
	private String h002; //单元
	private String h003; //层
	private String h005; //房号
	private Double nc; //年初本金
 	private Double zj; //增加本金
	private Double js; //减少本金
	private Double lx; //利息余额
	private Double hj; //合计
	
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
	public String getH013() {
		return h013;
	}
	public void setH013(String h013) {
		this.h013 = h013;
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
	public Double getNc() {
		return nc;
	}
	public void setNc(Double nc) {
		this.nc = nc;
	}
	public Double getZj() {
		return zj;
	}
	public void setZj(Double zj) {
		this.zj = zj;
	}
	public Double getJs() {
		return js;
	}
	public void setJs(Double js) {
		this.js = js;
	}
	public Double getLx() {
		return lx;
	}
	public void setLx(Double lx) {
		this.lx = lx;
	}
	public Double getHj() {
		return hj;
	}
	public void setHj(Double hj) {
		this.hj = hj;
	}
	
	@Override
	public String toString() {
		return "QueryBalance [h001=" + h001 + ", h002=" + h002 + ", h003=" + h003 + ", h005=" + h005 + ", h013=" + h013
				+ ", hj=" + hj + ", js=" + js + ", lx=" + lx + ", lymc=" + lymc + ", nc=" + nc + ", zj=" + zj + "]";
	} 
	
}

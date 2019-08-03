package com.yaltec.wxzj2.biz.compositeQuery.entity;

import com.yaltec.comon.core.entity.Entity;

/**
 * <p>
 * ClassName: DetailBuildingI
 * </p>
 * <p>
 * Description: 楼宇利息明细查询实体
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author moqian
 * @date 2016-8-23 下午14:12:58
 */

public class DetailBuildingI extends Entity {
	
	/**
	 * 序列化版本标示.
	 */
	private static final long serialVersionUID = 1L;
	
	private String lymc; //楼宇名称
	private String qcje; //期初金额
	private String qclx; //期初利息
	private String zjje; //增加金额
	private String jsje; //减少金额
	private String bqje; //本期金额
	private String qmbj; //期末本金
	private String qmye; //期末余额
	
	public String getLymc() {
		return lymc;
	}
	public void setLymc(String lymc) {
		this.lymc = lymc;
	}
	public String getQcje() {
		return qcje;
	}
	public void setQcje(String qcje) {
		this.qcje = qcje;
	}
	public String getQclx() {
		return qclx;
	}
	public void setQclx(String qclx) {
		this.qclx = qclx;
	}
	public String getZjje() {
		return zjje;
	}
	public void setZjje(String zjje) {
		this.zjje = zjje;
	}
	public String getJsje() {
		return jsje;
	}
	public void setJsje(String jsje) {
		this.jsje = jsje;
	}
	public String getBqje() {
		return bqje;
	}
	public void setBqje(String bqje) {
		this.bqje = bqje;
	}
	public String getQmbj() {
		return qmbj;
	}
	public void setQmbj(String qmbj) {
		this.qmbj = qmbj;
	}
	public String getQmye() {
		return qmye;
	}
	public void setQmye(String qmye) {
		this.qmye = qmye;
	}
	
	@Override
	public String toString() {
		return "DetailBuildingI [bqje=" + bqje + ", jsje=" + jsje + ", lymc=" + lymc + ", qcje=" + qcje + ", qclx="
				+ qclx + ", qmbj=" + qmbj + ", qmye=" + qmye + ", zjje=" + zjje + "]";
	}

}

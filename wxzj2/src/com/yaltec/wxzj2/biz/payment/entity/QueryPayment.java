package com.yaltec.wxzj2.biz.payment.entity;

import com.yaltec.comon.core.entity.Entity;

/**
 * <p>
 * ClassName: QueryPayment
 * </p>
 * <p>
 * Description: 交款查询实体
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author jiangyong
 * @date 2016-8-18 下午05:14:42
 */
public class QueryPayment extends Entity {

	/**
	 * 序列化版本标示.
	 */
	private static final long serialVersionUID = 1L;

	/**
	 * 房屋编号
	 */
	private String h001;
	/**
	 * 业主姓名
	 */
	private String w012;
	/**
	 * 交款日期
	 */
	private String w014;
	/**
	 * 票据号
	 */
	private String w011;
	/**
	 * 交款金额
	 */
	private Double w006;
	/**
	 * 交款金额
	 */
	private double w005;
	/**
	 * 地址
	 */
	private String dz;
	/**
	 * 房屋面积
	 */
	private Double mj;
	/**
	 * 总房款
	 */
	private Double zj;
	/**
	 * 业务编号
	 */
	private String w008;
	/**
	 * 业主身份证号
	 */
	private String h015;
	/**
	 * 流水号(业务序号)
	 */
	private String serialno;
	/**
	 * 数据序号
	 */
	private String xh;
	/**
	 * 收款银行编号
	 */
	private String yhbh;
	/**
	 * 收款银行
	 */
	private String yhmc;

	public String getH001() {
		return h001;
	}

	public void setH001(String h001) {
		this.h001 = h001;
	}

	public String getW012() {
		return w012;
	}

	public void setW012(String w012) {
		this.w012 = w012;
	}

	public String getW014() {
		return w014;
	}

	public void setW014(String w014) {
		this.w014 = w014;
	}

	public String getW011() {
		return w011;
	}

	public void setW011(String w011) {
		this.w011 = w011;
	}

	public Double getW006() {
		return w006;
	}

	public void setW006(Double w006) {
		this.w006 = w006;
	}

	public String getDz() {
		return dz;
	}

	public void setDz(String dz) {
		this.dz = dz;
	}

	public Double getMj() {
		return mj;
	}

	public void setMj(Double mj) {
		this.mj = mj;
	}

	public Double getZj() {
		return zj;
	}

	public void setZj(Double zj) {
		this.zj = zj;
	}

	public String getW008() {
		return w008;
	}

	public void setW008(String w008) {
		this.w008 = w008;
	}

	public String getH015() {
		return h015;
	}

	public void setH015(String h015) {
		this.h015 = h015;
	}

	public String getSerialno() {
		return serialno;
	}

	public void setSerialno(String serialno) {
		this.serialno = serialno;
	}

	public String getXh() {
		return xh;
	}

	public void setXh(String xh) {
		this.xh = xh;
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

	public double getW005() {
		return w005;
	}

	public void setW005(double w005) {
		this.w005 = w005;
	}

	public String toString() {
		return "QueryPayment [h001: " + h001 + ", w012: " + w012 + ", w014: "
				+ w014 + ", w011: " + w011 + ", w006: " + w006 + ", dz: " + dz
				+ ", mj: " + mj + ", zj: " + zj + ", w008: " + w008
				+ ", h015: " + h015 + ", serialno: " + serialno + ", xh: " + xh
				+ ", yhbh: " + yhbh + ", yhmc: " + yhmc + ", ]";
	}
}

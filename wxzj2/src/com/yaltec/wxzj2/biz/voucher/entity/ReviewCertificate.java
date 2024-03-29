package com.yaltec.wxzj2.biz.voucher.entity;

import com.yaltec.comon.core.entity.Entity;

/**
 * <p>
 * ClassName: ReviewCertificate
 * </p>
 * <p>
 * Description: 凭证录入实体
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author jiangyong
 * @date 2016-8-24 下午05:32:56
 */
public class ReviewCertificate extends Entity {

	/**
	 * 序列化版本标示.
	 */
	private static final long serialVersionUID = 1L;

	private String p004;// 业务编号
	private String p005;
	private String p006;
	private String p007;// 摘要
	private Double p008;// 发生额
	private String p011;
	private String p012;
	private String p015;// 银行编号
	private String p016;// 银行名称
	private String p023;
	/**
	 * 历史年度
	 */
	private String lsnd; 

	public String getP023() {
		return p023;
	}

	public void setP023(String p023) {
		this.p023 = p023;
	}

	public String getP006() {
		return p006;
	}

	public void setP006(String p006) {
		this.p006 = p006;
	}

	public String getP004() {
		return p004;
	}

	public void setP004(String p004) {
		this.p004 = p004;
	}

	public String getP005() {
		return p005;
	}

	public void setP005(String p005) {
		this.p005 = p005;
	}

	public String getP007() {
		return p007;
	}

	public void setP007(String p007) {
		this.p007 = p007;
	}

	public Double getP008() {
		return p008;
	}

	public void setP008(Double p008) {
		this.p008 = p008;
	}

	public String getP011() {
		return p011;
	}

	public void setP011(String p011) {
		this.p011 = p011;
	}

	public String getP012() {
		return p012;
	}

	public void setP012(String p012) {
		this.p012 = p012;
	}

	public String getP015() {
		return p015;
	}

	public void setP015(String p015) {
		this.p015 = p015;
	}

	public String getP016() {
		return p016;
	}

	public void setP016(String p016) {
		this.p016 = p016;
	}

	public String getLsnd() {
		return lsnd;
	}

	public void setLsnd(String lsnd) {
		this.lsnd = lsnd;
	}

}

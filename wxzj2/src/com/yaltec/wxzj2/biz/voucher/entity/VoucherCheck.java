package com.yaltec.wxzj2.biz.voucher.entity;

import com.yaltec.comon.core.entity.Entity;

/**
 * <p>
 * ClassName: VoucherCheck
 * </p>
 * <p>
 * Description: 凭证审核实体类
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author jiangyong
 * @date 2016-8-26 下午02:11:17
 */
public class VoucherCheck extends Entity {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private String p005;// 凭证编号
	private String p006;// 日期
	private String p007;// 摘要
	private Double p008;// 借方金额
	private Double p009;// 贷方金额
	private String p011;// 审核人
	private String p018;// 科目编号1
	private String p019;// 科目名称1
	private String p021;// 登记人，制证人
	private String p022;// 附件数量
	private String dxhj;// 大写合计

	//private String p019_2;//科目名称2 
	//private String p018_2;//科目编号2 
	//private String p008_2;//合计借方金额
	//private String p009_2;//合计贷方金额

	public String getP005() {
		return p005;
	}

	public void setP005(String p005) {
		this.p005 = p005;
	}

	public String getP006() {
		return p006;
	}

	public void setP006(String p006) {
		this.p006 = p006;
	}

	public String getP007() {
		return p007;
	}

	public void setP007(String p007) {
		this.p007 = p007;
	}

	public String getP019() {
		return p019;
	}

	public void setP019(String p019) {
		this.p019 = p019;
	}

	public String getP018() {
		return p018;
	}

	public void setP018(String p018) {
		this.p018 = p018;
	}

	public Double getP008() {
		return p008;
	}

	public void setP008(Double p008) {
		this.p008 = p008;
	}

	public Double getP009() {
		return p009;
	}

	public void setP009(Double p009) {
		this.p009 = p009;
	}

	public String getP021() {
		return p021;
	}

	public void setP021(String p021) {
		this.p021 = p021;
	}

	public String getP011() {
		return p011;
	}

	public void setP011(String p011) {
		this.p011 = p011;
	}

	public String getP022() {
		return p022;
	}

	public void setP022(String p022) {
		this.p022 = p022;
	}

	public String getDxhj() {
		return dxhj == null?"": dxhj;
	}

	public void setDxhj(String dxhj) {
		this.dxhj = dxhj;
	}
	
	public String toString() {
		return "VoucherCheck [p005: " + p005 + ", p006: " + p006 + ", p007: " + p007 + ", p019: " + p019 + ", p018: "
				+ p018 + ", p008: " + p008 + ", p009: " + p009 + ", p021: " + p021 + ", p011: " + p011 + ", p022: "
				+ p022 + ", dxhj: " + dxhj + "]";
	}

}

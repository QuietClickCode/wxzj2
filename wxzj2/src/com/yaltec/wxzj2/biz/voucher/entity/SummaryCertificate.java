package com.yaltec.wxzj2.biz.voucher.entity;

import com.yaltec.comon.core.entity.Entity;

/**
 * <p>
 * ClassName: SummaryCertificate
 * </p>
 * <p>
 * Description: 凭证汇总实体
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author moqian
 * @date 2016-9-5 下午14:02:56
 */
public class SummaryCertificate extends Entity {

	/**
	 * 序列化版本标示.
	 */
	private static final long serialVersionUID = 1L;

	private String p018;
	private String p019;
	private Double p008;
	private Double p009;
	
	public String getP018() {
		return p018;
	}
	public void setP018(String p018) {
		this.p018 = p018;
	}
	public String getP019() {
		return p019;
	}
	public void setP019(String p019) {
		this.p019 = p019;
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
	
	@Override
	public String toString() {
		return "SummaryCertificate [p008=" + p008 + ", p009=" + p009 + ", p018=" + p018 + ", p019=" + p019 + "]";
	}
	
}

package com.yaltec.wxzj2.biz.voucher.entity;

import com.yaltec.comon.core.entity.Entity;

/**
 * 交款记录实体表
 * @ClassName: PaymentRecord 
 * @author hqx
 */
public class PaymentRecord extends Entity {

	private static final long serialVersionUID = 1L;
	private String w008;//业务编号
	private String h020;//首缴时间
	private String w005;
	
	public String getW008() {
		return w008;
	}
	public void setW008(String w008) {
		this.w008 = w008;
	}
	public String getH020() {
		return h020;
	}
	public void setH020(String h020) {
		this.h020 = h020;
	}
	public String getW005() {
		return w005;
	}
	public void setW005(String w005) {
		this.w005 = w005;
	}
	@Override
	public String toString() {
		return "PaymentRecord [h020=" + h020 + ", w005=" + w005 + ", w008=" + w008 + "]";
	}
}

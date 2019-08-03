package com.yaltec.wxzj2.biz.bill.entity;

/**
 * <p>
 * ClassName: ReceiptInfoMFS
 * </p>
 * <p>
 * Description: 票据详情实体(非税版)
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author jiangyong
 * @date 2016-8-31 上午10:39:34
 */
public class ReceiptInfoMFS extends ReceiptInfoM {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	/**
	 * 交款金额
	 */
	private String w006;
	/**
	 * 交款人
	 */
	private String w012;

	public String getW006() {
		return (w006 == null || w006.equals("")) ? "0.00" : w006;
	}

	public void setW006(String w006) {
		this.w006 = w006;
	}

	public String getW012() {
		return w012 == null ? "无名氏" : w012;
	}

	public void setW012(String w012) {
		this.w012 = w012;
	}

	@Override
	public String toString() {
		return "ReceiptInfoMFS [" + super.toString() + ", w006=" + w006 + ", w006=" + w006 + "]";
	}

}

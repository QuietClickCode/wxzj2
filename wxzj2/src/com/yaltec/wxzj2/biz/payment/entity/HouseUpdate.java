package com.yaltec.wxzj2.biz.payment.entity;

import com.yaltec.comon.core.entity.Entity;
/**
 * 修改房屋交存标准信息
 * @ClassName: HouseUpdate 
 * @author 重庆亚亮科技有限公司 txj 
 * @date 2016-9-1 上午08:50:04
 */
public class HouseUpdate extends Entity {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String h001;
	private String h006;
	private String h021;
	private String h047;
	private String result;
	public String getH001() {
		return h001;
	}
	public void setH001(String h001) {
		this.h001 = h001;
	}
	public String getH006() {
		return h006;
	}
	public void setH006(String h006) {
		this.h006 = h006;
	}
	public String getH021() {
		return h021;
	}
	public void setH021(String h021) {
		this.h021 = h021;
	}
	public String getH047() {
		return h047;
	}
	public void setH047(String h047) {
		this.h047 = h047;
	}
	public String getResult() {
		return result;
	}
	public void setResult(String result) {
		this.result = result;
	}
	@Override
	public String toString() {
		return "HouseUpdate [h001=" + h001 + ", h006=" + h006 + ", h021="
				+ h021 + ", h047=" + h047 + ", result=" + result + "]";
	}
	
}

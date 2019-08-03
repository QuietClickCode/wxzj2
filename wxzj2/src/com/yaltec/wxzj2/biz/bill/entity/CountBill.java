package com.yaltec.wxzj2.biz.bill.entity;

import com.yaltec.comon.core.entity.Entity;

/**
 * <p>
 * ClassName: CountBill
 * </p>
 * <p>
 * Description: 票据统计实体
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author moqian
 * @date 2016-7-30 下午02:36:58
 */

public class CountBill extends Entity {
	
	/**
	 * 序列化版本标示.
	 */
	private static final long serialVersionUID = 1L;
	
	private String zzs; //总张数
	private String yyzs; //已用张数
	private String pjze; //票据总额
	private String zfzs; //作废张数
	private String wyzs; //未用张数
	
	public String getZzs() {
		return zzs;
	}
	public void setZzs(String zzs) {
		this.zzs = zzs;
	}
	public String getYyzs() {
		return yyzs;
	}
	public void setYyzs(String yyzs) {
		this.yyzs = yyzs;
	}
	public String getPjze() {
		return pjze;
	}
	public void setPjze(String pjze) {
		this.pjze = pjze;
	}
	public String getZfzs() {
		return zfzs;
	}
	public void setZfzs(String zfzs) {
		this.zfzs = zfzs;
	}
	public String getWyzs() {
		return wyzs;
	}
	public void setWyzs(String wyzs) {
		this.wyzs = wyzs;
	}
	
	@Override
	public String toString() {
		return "CountBill [pjze=" + pjze + ", wyzs=" + wyzs + ", yyzs=" + yyzs + ", zfzs=" + zfzs + ", zzs=" + zzs
				+ "]";
	}
	
}

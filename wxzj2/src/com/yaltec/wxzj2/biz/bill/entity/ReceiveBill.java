package com.yaltec.wxzj2.biz.bill.entity;

import com.yaltec.comon.core.entity.Entity;

/**
 * <p>
 * ClassName: ReceiveBill
 * </p>
 * <p>
 * Description: 票据接收实体
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author moqian
 * @date 2016-7-27 下午02:36:58
 */

public class ReceiveBill extends Entity {
	
	/**
	 * 序列化版本标示.
	 */
	private static final long serialVersionUID = 1L;	
	
	private String bm; //主键编码
	private String qsh; //票据起始号
	private String zzh; //票据终止号
	private String yhbh; //银行编号
	private String yhmc; //银行名称
	private String zfzs; //作废张数
	private String yxzs; //有效张数
	
	public String getBm() {
		return bm;
	}
	public void setBm(String bm) {
		this.bm = bm;
	}
	public String getQsh() {
		return qsh;
	}
	public void setQsh(String qsh) {
		this.qsh = qsh;
	}
	public String getZzh() {
		return zzh;
	}
	public void setZzh(String zzh) {
		this.zzh = zzh;
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
	public String getZfzs() {
		return zfzs;
	}
	public void setZfzs(String zfzs) {
		this.zfzs = zfzs;
	}
	public String getYxzs() {
		return yxzs;
	}
	public void setYxzs(String yxzs) {
		this.yxzs = yxzs;
	}
	
	@Override
	public String toString() {
		return "ReceiveBill [bm=" + bm + ", qsh=" + qsh + ", yhbh=" + yhbh + ", yhmc=" + yhmc + ", yxzs=" + yxzs
				+ ", zfzs=" + zfzs + ", zzh=" + zzh + "]";
	}
	
}

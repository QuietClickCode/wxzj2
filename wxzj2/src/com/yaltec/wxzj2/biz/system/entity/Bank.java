package com.yaltec.wxzj2.biz.system.entity;

import com.yaltec.comon.core.entity.Entity;

/**
 * <p>
 * ClassName: Bank
 * </p>
 * <p>
 * Description: 银行实体类
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author hequanxin
 * @date 2016-7-19 下午02:36:58
 */
public class Bank extends Entity {
	
	/**
	 * 序列化版本标示.
	 */
	private static final long serialVersionUID = 1L;
	
	/**
	 * 银行编码
	 */
	private String bm;
	
	/**
	 * 银行名称
	 */
	private String mc;
	
	/**
	 * 描述
	 */
	private String ms;
	
	public String getBm() {
		return bm;
	}
	public void setBm(String bm) {
		this.bm = bm;
	}
	public String getMc() {
		return mc;
	}
	public void setMc(String mc) {
		this.mc = mc;
	}
	public String getMs() {
		return ms;
	}
	public void setMs(String ms) {
		this.ms = ms;
	}
	
	@Override
	public String toString() {
		return "Bank [bm=" + bm + ", mc=" + mc + ", ms=" + ms + "]";
	}
}

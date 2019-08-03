package com.yaltec.wxzj2.biz.system.entity;

import com.yaltec.comon.core.entity.Entity;

/**
 * <p>
 * ClassName: MySysCode
 * </p>
 * <p>
 * Description: 系统编码实体类(这里用一句话描述这个类的作用)
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author jiangyong
 * @date 2016-7-29 下午05:09:36
 */
public class MySysCode extends Entity {

	/**
	 * 序列化版本标示.
	 */
	private static final long serialVersionUID = 1L;

	/**
	 * 编码
	 */
	private String bm;

	/**
	 * 名称
	 */
	private String mc;

	/**
	 * 备注
	 */
	private String mycode_bm;

	/**
	 * 描述
	 */
	private String ms;

	/**
	 * 序号
	 */
	private String xh;

	/**
	 * 是否启用
	 */
	private String sfqy;
	
	private String mycode_mc;

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

	public String getSfqy() {
		return sfqy == null ? "0" : sfqy;
	}

	public void setSfqy(String sfqy) {
		this.sfqy = sfqy;
	}

	public String getMycode_bm() {
		return mycode_bm;
	}

	public void setMycode_bm(String mycodeBm) {
		mycode_bm = mycodeBm;
	}

	public String getMs() {
		return ms;
	}

	public void setMs(String ms) {
		this.ms = ms;
	}

	public String getXh() {
		return xh;
	}

	public void setXh(String xh) {
		this.xh = xh;
	}

	public String getMycode_mc() {
		return mycode_mc;
	}

	public void setMycode_mc(String mycodeMc) {
		mycode_mc = mycodeMc;
	}

	@Override
	public String toString() {
		return "MySysCode [bm=" + bm + ", mc=" + mc + ", ms=" + ms + ", mycode_bm=" + mycode_bm + ", mycode_mc="
				+ mycode_mc + ", sfqy=" + sfqy + ", xh=" + xh + "]";
	}


}

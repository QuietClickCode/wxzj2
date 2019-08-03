package com.yaltec.wxzj2.biz.system.entity;

import com.yaltec.comon.core.entity.Entity;

/**
 * <p>
 * ClassName: Deposit
 * </p>
 * <p>
 * Description: 交存标准实体(这里用一句话描述这个类的作用)
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author jiangyong
 * @date 2016-8-1 上午09:26:58
 */
public class Deposit extends Entity {

	/**
	 * 序列化版本标示.
	 */
	private static final long serialVersionUID = 1L;

	/**
	 * 主键编码
	 */
	private String bm;
	/**
	 * 名称
	 */
	private String mc;
	/**
	 * 项目
	 */
	private String xm;
	/**
	 * 系数
	 */
	private String xs;

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

	public String getXm() {
		return xm;
	}

	public void setXm(String xm) {
		this.xm = xm;
	}

	public String getXs() {
		return xs;
	}

	public void setXs(String xs) {
		this.xs = xs;
	}

	public String toString() {
		return "Deposit [ bm=" + bm + ", mc=" + mc + ", xm=" + xm + ", xs=" + xs + "]";
	}
}	

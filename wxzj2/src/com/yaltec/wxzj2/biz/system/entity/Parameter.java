package com.yaltec.wxzj2.biz.system.entity;

import com.yaltec.comon.core.entity.Entity;

/**
 * 
 * @ClassName: Parameter
 * @Description: TODO 系统参数实体类
 * 
 * @author yangshanping
 * @date 2016-8-5 上午10:07:46
 */
public class Parameter extends Entity{
	/**
	 * 序列化版本标示.
	 */
	private static final long serialVersionUID = 1L;
	
	/**
	 * 主键编码
	 */
	private String bm;
	/**
	 * 名称描述
	 */
	private String mc;
	/**
	 * 是否启用
	 */
	private String sf;
	
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
	public String getSf() {
		return sf;
	}
	public void setSf(String sf) {
		this.sf = sf;
	}
	@Override
	public String toString() {
		return "Parameter [bm=" + bm + ", mc=" + mc + ", sf=" + sf + "]";
	}
	
}

package com.yaltec.wxzj2.biz.draw.entity;

import com.yaltec.comon.core.entity.Entity;

/**
 * 
 * @ClassName: CodeName
 * @Description: TODO编码和名称实体类
 * 
 * @author yangshanping
 * @date 2016-8-8 下午02:35:50
 */
public class CodeName extends Entity{
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
	
	@Override
	public String toString() {
		return "CodeName [bm=" + bm + ", mc=" + mc + "]";
	}
}

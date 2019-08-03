package com.yaltec.wxzj2.biz.system.entity;

import com.yaltec.comon.core.entity.Entity;

/**
 *<p>文件名称: MyCode.java</p>
 * <p>文件描述: 系统编码类型</p>
 * <p>版权所有: 版权所有(C)2010</p>
 * <p>公   司: yaltec</p>
 * <p>内容摘要: </p>
 * <p>其他说明: </p>
 * <p>完成日期：Aug 23, 2010</p>
 * <p>修改记录0：无</p>
 * @version 1.0
 * @author hequanxin
 */
public class Enctype extends Entity {
	
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
		return "Enctype [bm=" + bm + ", mc=" + mc + ", ms=" + ms + "]";
	}
}

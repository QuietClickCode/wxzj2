package com.yaltec.wxzj2.biz.system.entity;

import com.yaltec.comon.core.entity.Entity;

/**
 *<p>文件名称: CodeName.java</p>
 * <p>文件描述: 编码和名称</p>
 * <p>版权所有: 版权所有(C)2010</p>
 * <p>公   司: yaltec</p>
 * <p>内容摘要: </p>
 * <p>其他说明: </p>
 * <p>完成日期：Apr 21, 2010</p>
 * <p>修改记录0：无</p>
 * @version 1.0
 * @author hequanxin
 */
public class CodeName extends Entity {
	
	/**
	 * 序列化版本标示.
	 */
	private static final long serialVersionUID = 1L;
	
	private String bm;
	private String mc;
	
	public CodeName() {
	}
	
	public CodeName(String bm, String mc) {
		this.bm = bm;
	}
	
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

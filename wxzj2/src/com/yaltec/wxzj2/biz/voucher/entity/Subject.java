package com.yaltec.wxzj2.biz.voucher.entity;

import com.yaltec.comon.core.entity.Entity;

/**
 * <p>ClassName: Subject</p>
 * <p>Description: 会计科目实体类</p>
 * <p>Company: YALTEC</p> 
 * @author jiangyong
 * @date 2016-8-26 上午11:00:13
 */
public class Subject extends Entity {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private String bm;
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

	public String toString() {
		return "Subject [bm: "+bm+", mc: "+mc+"]";
	}
}

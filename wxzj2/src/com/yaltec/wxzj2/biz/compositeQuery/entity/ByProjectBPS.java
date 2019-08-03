package com.yaltec.wxzj2.biz.compositeQuery.entity;

import com.yaltec.comon.core.entity.Entity;

/**
 * <p>
 * ClassName: ByProjectBPS
 * </p>
 * <p>
 * Description: 项目收支统计实体
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author moqian
 * @date 2016-8-26 下午16:12:58
 */

public class ByProjectBPS extends Entity {
	
	/**
	 * 序列化版本标示.
	 */
	private static final long serialVersionUID = 1L;
	
	private String bm;
	private String mc;
	private String qcbj;
	private String qclx;
	private String zjbj;
	private String zjlx;
	private String jsbj;
	private String jslx;
	private String bjye;
	private String lxye;
	private String bxhj;
	private String other;
	
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
	public String getQcbj() {
		return qcbj;
	}
	public void setQcbj(String qcbj) {
		this.qcbj = qcbj;
	}
	public String getQclx() {
		return qclx;
	}
	public void setQclx(String qclx) {
		this.qclx = qclx;
	}
	public String getZjbj() {
		return zjbj;
	}
	public void setZjbj(String zjbj) {
		this.zjbj = zjbj;
	}
	public String getZjlx() {
		return zjlx;
	}
	public void setZjlx(String zjlx) {
		this.zjlx = zjlx;
	}
	public String getJsbj() {
		return jsbj;
	}
	public void setJsbj(String jsbj) {
		this.jsbj = jsbj;
	}
	public String getJslx() {
		return jslx;
	}
	public void setJslx(String jslx) {
		this.jslx = jslx;
	}
	public String getBjye() {
		return bjye;
	}
	public void setBjye(String bjye) {
		this.bjye = bjye;
	}
	public String getLxye() {
		return lxye;
	}
	public void setLxye(String lxye) {
		this.lxye = lxye;
	}
	public String getBxhj() {
		return bxhj;
	}
	public void setBxhj(String bxhj) {
		this.bxhj = bxhj;
	}
	public String getOther() {
		return other;
	}
	public void setOther(String other) {
		this.other = other;
	}
	@Override
	public String toString() {
		return "ByProjectBPS [bjye=" + bjye + ", bm=" + bm + ", bxhj=" + bxhj + ", jsbj=" + jsbj + ", jslx=" + jslx
				+ ", lxye=" + lxye + ", mc=" + mc + ", other=" + other + ", qcbj=" + qcbj + ", qclx=" + qclx
				+ ", zjbj=" + zjbj + ", zjlx=" + zjlx + "]";
	}

}

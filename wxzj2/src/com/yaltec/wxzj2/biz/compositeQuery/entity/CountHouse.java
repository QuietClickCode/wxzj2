package com.yaltec.wxzj2.biz.compositeQuery.entity;

import com.yaltec.comon.core.entity.Entity;

/**
 * <p>
 * ClassName: CountHouse
 * </p>
 * <p>
 * Description: 户数统计查询实体
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author moqian
 * @date 2016-8-25 上午09:12:58
 */

public class CountHouse extends Entity {
	
	/**
	 * 序列化版本标示.
	 */
	private static final long serialVersionUID = 1L;
	
	private String xqmc; //项目名称
	private String qchs; //期初户数
	private String qcje; //期初金额
	private String byhs; //本期户数
	private String zjje; //增加金额
	private String zjlx; //增加利息
	private String jshs; //减少户数
	private String jsje; //减少金额
	private String jslx; //减少利息
	private String bqhs; //累计户数
	private String bjye; //累计本金
	private String lxye; //累计利息
	private String bqje; //累计金额
	
	public String getXqmc() {
		return xqmc;
	}
	public void setXqmc(String xqmc) {
		this.xqmc = xqmc;
	}
	public String getQchs() {
		return qchs;
	}
	public void setQchs(String qchs) {
		this.qchs = qchs;
	}
	public String getQcje() {
		return qcje;
	}
	public void setQcje(String qcje) {
		this.qcje = qcje;
	}
	public String getByhs() {
		return byhs;
	}
	public void setByhs(String byhs) {
		this.byhs = byhs;
	}
	public String getZjje() {
		return zjje;
	}
	public void setZjje(String zjje) {
		this.zjje = zjje;
	}
	public String getZjlx() {
		return zjlx;
	}
	public void setZjlx(String zjlx) {
		this.zjlx = zjlx;
	}
	public String getJshs() {
		return jshs;
	}
	public void setJshs(String jshs) {
		this.jshs = jshs;
	}
	public String getJsje() {
		return jsje;
	}
	public void setJsje(String jsje) {
		this.jsje = jsje;
	}
	public String getJslx() {
		return jslx;
	}
	public void setJslx(String jslx) {
		this.jslx = jslx;
	}
	public String getBqhs() {
		return bqhs;
	}
	public void setBqhs(String bqhs) {
		this.bqhs = bqhs;
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
	public String getBqje() {
		return bqje;
	}
	public void setBqje(String bqje) {
		this.bqje = bqje;
	}
	
	@Override
	public String toString() {
		return "CountHouse [bjye=" + bjye + ", bqhs=" + bqhs + ", bqje=" + bqje + ", byhs=" + byhs + ", jshs=" + jshs
				+ ", jsje=" + jsje + ", jslx=" + jslx + ", lxye=" + lxye + ", qchs=" + qchs + ", qcje=" + qcje
				+ ", xqmc=" + xqmc + ", zjje=" + zjje + ", zjlx=" + zjlx + "]";
	}

}

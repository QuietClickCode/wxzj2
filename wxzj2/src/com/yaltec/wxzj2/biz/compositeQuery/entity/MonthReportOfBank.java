package com.yaltec.wxzj2.biz.compositeQuery.entity;

import com.yaltec.comon.core.entity.Entity;

/**
 * <p>
 * ClassName: MonthReportOfBank
 * </p>
 * <p>
 * Description: 面积户数统计查询实体
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author moqian
 * @date 2016-8-25 上午10:12:58
 */

public class MonthReportOfBank extends Entity {
	
	/**
	 * 序列化版本标示.
	 */
	private static final long serialVersionUID = 1L;
	
	private String kfgsmc; //单位名称
	private String xqbh; //小区编号
	private String xqmc; //小区名称
	private String lybh; //楼宇编号
	private String lymc; //楼宇名称
	private String zmj; //
	private String qcmj; //期初面积
	private String qchs; //期初户数
	private String qcje; //期初金额
	private String bymj; //本期面积
	private String byhs; //本期户数
	private String byje; //本期金额
	private String bqmj; //本期面积
	private String bqhs; //本期户数
	private String bqje; //本期金额
	private String zjje; //增加金额
	private String zjlx; //增加利息
	private String lxye; //利息余额
	private String bjye; //本金余额
	private String yxfp; //有效发票
	private String yhbh; //银行编号
	private String yhmc; //银行名称
	private String yhjc; //银行简称
	private String jsje; //减少金额
	private String jslx; //减少利息
	private String jshs; //减少户数
	
	public String getKfgsmc() {
		return kfgsmc;
	}
	public void setKfgsmc(String kfgsmc) {
		this.kfgsmc = kfgsmc;
	}
	public String getXqbh() {
		return xqbh;
	}
	public void setXqbh(String xqbh) {
		this.xqbh = xqbh;
	}
	public String getXqmc() {
		return xqmc;
	}
	public void setXqmc(String xqmc) {
		this.xqmc = xqmc;
	}
	public String getLybh() {
		return lybh;
	}
	public void setLybh(String lybh) {
		this.lybh = lybh;
	}
	public String getLymc() {
		return lymc;
	}
	public void setLymc(String lymc) {
		this.lymc = lymc;
	}
	public String getZmj() {
		return zmj;
	}
	public void setZmj(String zmj) {
		this.zmj = zmj;
	}
	public String getQcmj() {
		return qcmj;
	}
	public void setQcmj(String qcmj) {
		this.qcmj = qcmj;
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
	public String getBymj() {
		return bymj;
	}
	public void setBymj(String bymj) {
		this.bymj = bymj;
	}
	public String getByhs() {
		return byhs;
	}
	public void setByhs(String byhs) {
		this.byhs = byhs;
	}
	public String getByje() {
		return byje;
	}
	public void setByje(String byje) {
		this.byje = byje;
	}
	public String getBqmj() {
		return bqmj;
	}
	public void setBqmj(String bqmj) {
		this.bqmj = bqmj;
	}
	public String getBqhs() {
		return bqhs;
	}
	public void setBqhs(String bqhs) {
		this.bqhs = bqhs;
	}
	public String getBqje() {
		return bqje;
	}
	public void setBqje(String bqje) {
		this.bqje = bqje;
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
	public String getLxye() {
		return lxye;
	}
	public void setLxye(String lxye) {
		this.lxye = lxye;
	}
	public String getBjye() {
		return bjye;
	}
	public void setBjye(String bjye) {
		this.bjye = bjye;
	}
	public String getYxfp() {
		return yxfp;
	}
	public void setYxfp(String yxfp) {
		this.yxfp = yxfp;
	}
	public String getYhbh() {
		return yhbh;
	}
	public void setYhbh(String yhbh) {
		this.yhbh = yhbh;
	}
	public String getYhmc() {
		return yhmc;
	}
	public void setYhmc(String yhmc) {
		this.yhmc = yhmc;
	}
	public String getYhjc() {
		return yhjc;
	}
	public void setYhjc(String yhjc) {
		this.yhjc = yhjc;
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
	public String getJshs() {
		return jshs;
	}
	public void setJshs(String jshs) {
		this.jshs = jshs;
	}
	
	@Override
	public String toString() {
		return "MonthReportOfBank [bjye=" + bjye + ", bqhs=" + bqhs + ", bqje=" + bqje + ", bqmj=" + bqmj + ", byhs="
				+ byhs + ", byje=" + byje + ", bymj=" + bymj + ", jshs=" + jshs + ", jsje=" + jsje + ", jslx=" + jslx
				+ ", kfgsmc=" + kfgsmc + ", lxye=" + lxye + ", lybh=" + lybh + ", lymc=" + lymc + ", qchs=" + qchs
				+ ", qcje=" + qcje + ", qcmj=" + qcmj + ", xqbh=" + xqbh + ", xqmc=" + xqmc + ", yhbh=" + yhbh
				+ ", yhjc=" + yhjc + ", yhmc=" + yhmc + ", yxfp=" + yxfp + ", zjje=" + zjje + ", zjlx=" + zjlx
				+ ", zmj=" + zmj + "]";
	}

}

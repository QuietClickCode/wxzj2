package com.yaltec.wxzj2.biz.draw.entity;

import com.yaltec.comon.core.entity.Entity;

/**
 * 
 * @ClassName: ApplyLogout
 * @Description: TODO销户申请实体类
 * 
 * @author yangshanping
 * @date 2016-8-8 上午10:07:29
 */
public class ApplyLogout extends Entity{
	/**
	 * 序列化版本标示.
	 */
	private static final long serialVersionUID = 1L;
	/**
	 * 业务编号
	 */
	private String businessNO;
	/**
	 * 申请编号
	 */
	private String bm;
	/**
	 * 小区名称
	 */
	private String nbhdname;
	/**
	 * 楼宇名称
	 */
	private String bldgname;
	/**
	 * 申请日期
	 */
	private String sqrq;
	/**
	 * 房屋编号
	 */
	private String h001;
	/**
	 * 业主姓名
	 */
	private String h013;
	/**
	 * 单元
	 */
	private String h002;
	/**
	 * 层
	 */
	private String h003;
	/**
	 * 房号
	 */
	private String h005;
	/**
	 * 可用本金
	 */
	private Double h030;
	/**
	 * 可用利息
	 */
	private Double h031;
	/**
	 * 本息合计(有利息结算操作，如没有利息结算操作，页面上显示的本息合计是h030+h031)
	 */
	private Double bxhj;
	/**
	 * 销户原因
	 */
	private String ApplyRemark;
	/**
	 * 文件原名
	 */
	private String OFileName;
	/**
	 * 服务器上保存名
	 */
	private String NFileName;
	
	public String getBusinessNO() {
		return businessNO;
	}
	public void setBusinessNO(String businessNO) {
		this.businessNO = businessNO;
	}
	public String getBm() {
		return bm;
	}
	public void setBm(String bm) {
		this.bm = bm;
	}
	public String getNbhdname() {
		return nbhdname;
	}
	public void setNbhdname(String nbhdname) {
		this.nbhdname = nbhdname;
	}
	public String getBldgname() {
		return bldgname;
	}
	public void setBldgname(String bldgname) {
		this.bldgname = bldgname;
	}
	public String getSqrq() {
		return sqrq;
	}
	public void setSqrq(String sqrq) {
		this.sqrq = sqrq;
	}
	public String getH001() {
		return h001;
	}
	public void setH001(String h001) {
		this.h001 = h001;
	}
	public String getH013() {
		return h013;
	}
	public void setH013(String h013) {
		this.h013 = h013;
	}
	public String getH002() {
		return h002;
	}
	public void setH002(String h002) {
		this.h002 = h002;
	}
	public String getH003() {
		return h003;
	}
	public void setH003(String h003) {
		this.h003 = h003;
	}
	public String getH005() {
		return h005;
	}
	public void setH005(String h005) {
		this.h005 = h005;
	}
	public Double getH030() {
		return h030;
	}
	public void setH030(Double h030) {
		this.h030 = h030;
	}
	public Double getH031() {
		return h031;
	}
	public void setH031(Double h031) {
		this.h031 = h031;
	}
	public Double getBxhj() {
		return bxhj;
	}
	public void setBxhj(Double bxhj) {
		this.bxhj = bxhj;
	}
	public String getApplyRemark() {
		return ApplyRemark;
	}
	public void setApplyRemark(String applyRemark) {
		ApplyRemark = applyRemark;
	}
	public String getOFileName() {
		return OFileName;
	}
	public void setOFileName(String oFileName) {
		OFileName = oFileName;
	}
	public String getNFileName() {
		return NFileName;
	}
	public void setNFileName(String nFileName) {
		NFileName = nFileName;
	}
	
	@Override
	public String toString() {
		return "ApplyLogout [ApplyRemark=" + ApplyRemark + ", businessNO="
				+ businessNO + ", NFileName=" + NFileName + ", OFileName="
				+ OFileName + ", bldgname=" + bldgname + ", bm=" + bm
				+ ", bxhj=" + bxhj + ", h001=" + h001 + ", h002=" + h002
				+ ", h003=" + h003 + ", h005=" + h005 + ", h013=" + h013
				+ ", h030=" + h030 + ", h031=" + h031 + ", nbhdname="
				+ nbhdname + ", sqrq=" + sqrq + "]";
	}
	
}

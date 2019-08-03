package com.yaltec.wxzj2.biz.draw.entity;

import com.yaltec.comon.core.entity.Entity;

/**
 * 
 * @ClassName: QueryAL
 * @Description: 支取情况查询(模糊查询、申请编号、经办人)
 * 
 * @author yangshanping
 * @date 2016-8-19 下午02:11:45
 */
public class QueryAL extends Entity{
	/**
	 * 序列化版本标示.
	 */
	private static final long serialVersionUID = 1L;
	/**
	 * 申请编号
	 */
	private String bm;
	/**
	 * 单位编号
	 */
	private String dwbm;
	/**
	 * 申请单位
	 */
	private String sqdw;
	/**
	 * 
	 */
	private Double sqje;
	/**
	 * 申请金额
	 */
	private String pzje;
	/**
	 * 经办人
	 */
	private String jbr;
	/**
	 * 
	 */
	private String xmmc;
	/**
	 * 小区名称
	 */
	private String nbhdname;
	/**
	 * 楼宇名称
	 */
	private String bldgname;
	/**
	 * 受理状态
	 */
	private String slzt;
	/**
	 * 操作员
	 */
	private String username;
	/**
	 * 
	 */
	private String sqrq1;
	/**
	 * 
	 */
	private String pzrq1;
	/**
	 * 
	 */
	private String wxxm;
	/**
	 * 
	 */
	private Double sjhbje;
	/**
	 * 
	 */
	private Double zcje;
	/**
	 * 
	 */
	private String clsm;
	/**
	 * 
	 */
	private String area;
	/**
	 * 
	 */
	private String households;
	/**
	 * 文件原名
	 */
	private String OFileName;
	/**
	 * 服务器上保存名
	 */
	private String NFileName;
	//销户情况查询
	/**
	 * 申请日期
	 */
	private String sqrq;
	/**
	 * 销户原因
	 */
	private String ApplyRemark;
	
	public String getBm() {
		return bm;
	}
	public void setBm(String bm) {
		this.bm = bm;
	}
	public String getDwbm() {
		return dwbm;
	}
	public void setDwbm(String dwbm) {
		this.dwbm = dwbm;
	}
	public String getSqdw() {
		return sqdw;
	}
	public void setSqdw(String sqdw) {
		this.sqdw = sqdw;
	}
	public Double getSqje() {
		return sqje;
	}
	public void setSqje(Double sqje) {
		this.sqje = sqje;
	}
	public String getPzje() {
		return pzje;
	}
	public void setPzje(String pzje) {
		this.pzje = pzje;
	}
	public String getJbr() {
		return jbr;
	}
	public void setJbr(String jbr) {
		this.jbr = jbr;
	}
	public String getXmmc() {
		return xmmc;
	}
	public void setXmmc(String xmmc) {
		this.xmmc = xmmc;
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
	public String getSlzt() {
		return slzt;
	}
	public void setSlzt(String slzt) {
		this.slzt = slzt;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getSqrq1() {
		return sqrq1;
	}
	public void setSqrq1(String sqrq1) {
		this.sqrq1 = sqrq1;
	}
	public String getPzrq1() {
		return pzrq1;
	}
	public void setPzrq1(String pzrq1) {
		this.pzrq1 = pzrq1;
	}
	public String getWxxm() {
		return wxxm;
	}
	public void setWxxm(String wxxm) {
		this.wxxm = wxxm;
	}
	public Double getSjhbje() {
		return sjhbje;
	}
	public void setSjhbje(Double sjhbje) {
		this.sjhbje = sjhbje;
	}
	public Double getZcje() {
		return zcje;
	}
	public void setZcje(Double zcje) {
		this.zcje = zcje;
	}
	public String getClsm() {
		return clsm;
	}
	public void setClsm(String clsm) {
		this.clsm = clsm;
	}
	public String getArea() {
		return area;
	}
	public void setArea(String area) {
		this.area = area;
	}
	public String getHouseholds() {
		return households;
	}
	public void setHouseholds(String households) {
		this.households = households;
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
	public String getSqrq() {
		return sqrq;
	}
	public void setSqrq(String sqrq) {
		this.sqrq = sqrq;
	}
	public String getApplyRemark() {
		return ApplyRemark;
	}
	public void setApplyRemark(String applyRemark) {
		ApplyRemark = applyRemark;
	}
	
	@Override
	public String toString() {
		return "QueryAL [ApplyRemark=" + ApplyRemark + ", NFileName="
				+ NFileName + ", OFileName=" + OFileName + ", area=" + area
				+ ", bldgname=" + bldgname + ", bm=" + bm + ", clsm=" + clsm
				+ ", dwbm=" + dwbm + ", households=" + households + ", jbr="
				+ jbr + ", nbhdname=" + nbhdname + ", pzje=" + pzje
				+ ", pzrq1=" + pzrq1 + ", sjhbje=" + sjhbje + ", slzt=" + slzt
				+ ", sqdw=" + sqdw + ", sqje=" + sqje + ", sqrq=" + sqrq
				+ ", sqrq1=" + sqrq1 + ", username=" + username + ", wxxm="
				+ wxxm + ", xmmc=" + xmmc + ", zcje=" + zcje + "]";
	}
	
}

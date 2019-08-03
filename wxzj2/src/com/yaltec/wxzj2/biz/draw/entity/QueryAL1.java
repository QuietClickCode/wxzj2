package com.yaltec.wxzj2.biz.draw.entity;

/**
 * 
 * @ClassName: QueryAL1
 * @Description: 支取情况查询(明细查询)
 * 
 * @author yangshanping
 * @date 2016-8-19 下午02:21:41
 */
public class QueryAL1 {
	/**
	 * 序列化版本标示.
	 */
	private static final long serialVersionUID = 1L;
	/**
	 * 房屋编号
	 */
	private String h001;
	/**
	 * 业主姓名
	 */
	private String z012;
	/**
	 * 支取本金
	 */
	private String z004;
	/**
	 * 支取利息
	 */
	private String z005;
	/**
	 * 
	 */
	private String xmmc;
	/**
	 * 小区名称
	 */
	private String xqmc;
	/**
	 * 楼宇名称
	 */
	private String lymc;
	/**
	 * 操作员
	 */
	private String username;
	/**
	 * 申请编号
	 */
	private String z011;
	/**
	 * 销户日期
	 */
	private String z018;
	/**
	 * 业务编号
	 */
	private String z007;
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
	 * 
	 */
	private String h040;
	/**
	 * 
	 */
	private String h006;
	/**
	 * 
	 */
	private String h010;
	/**
	 * 
	 */
	private String h039;
	/**
	 * 
	 */
	private String h020;
	/**
	 * 
	 */
	private String h028;
	/**
	 * 
	 */
	private String h029;
	/**
	 * 支取本金
	 */
	private String h030;
	/**
	 * 支取利息
	 */
	private String h031;
	/**
	 * 经办人
	 */
	private String jbr;
	/**
	 * 
	 */
	private String zcje;
	/**
	 * 销户原因
	 */
	private String ApplyRemark;
	
	public String getH001() {
		return h001;
	}
	public void setH001(String h001) {
		this.h001 = h001;
	}
	public String getZ012() {
		return z012;
	}
	public void setZ012(String z012) {
		this.z012 = z012;
	}
	public String getZ004() {
		return z004;
	}
	public void setZ004(String z004) {
		this.z004 = z004;
	}
	public String getZ005() {
		return z005;
	}
	public void setZ005(String z005) {
		this.z005 = z005;
	}
	public String getXmmc() {
		return xmmc;
	}
	public void setXmmc(String xmmc) {
		this.xmmc = xmmc;
	}
	public String getXqmc() {
		return xqmc;
	}
	public void setXqmc(String xqmc) {
		this.xqmc = xqmc;
	}
	public String getLymc() {
		return lymc;
	}
	public void setLymc(String lymc) {
		this.lymc = lymc;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getZ011() {
		return z011;
	}
	public void setZ011(String z011) {
		this.z011 = z011;
	}
	public String getZ018() {
		return z018;
	}
	public void setZ018(String z018) {
		this.z018 = z018;
	}
	public String getZ007() {
		return z007;
	}
	public void setZ007(String z007) {
		this.z007 = z007;
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
	public String getH040() {
		return h040;
	}
	public void setH040(String h040) {
		this.h040 = h040;
	}
	public String getH006() {
		return h006;
	}
	public void setH006(String h006) {
		this.h006 = h006;
	}
	public String getH010() {
		return h010;
	}
	public void setH010(String h010) {
		this.h010 = h010;
	}
	public String getH039() {
		return h039;
	}
	public void setH039(String h039) {
		this.h039 = h039;
	}
	public String getH020() {
		return h020;
	}
	public void setH020(String h020) {
		this.h020 = h020;
	}
	public String getH028() {
		return h028;
	}
	public void setH028(String h028) {
		this.h028 = h028;
	}
	public String getH029() {
		return h029;
	}
	public void setH029(String h029) {
		this.h029 = h029;
	}
	public String getH030() {
		return h030;
	}
	public void setH030(String h030) {
		this.h030 = h030;
	}
	public String getH031() {
		return h031;
	}
	public void setH031(String h031) {
		this.h031 = h031;
	}
	public String getJbr() {
		return jbr;
	}
	public void setJbr(String jbr) {
		this.jbr = jbr;
	}
	public String getZcje() {
		return zcje;
	}
	public void setZcje(String zcje) {
		this.zcje = zcje;
	}
	public String getApplyRemark() {
		return ApplyRemark;
	}
	public void setApplyRemark(String applyRemark) {
		ApplyRemark = applyRemark;
	}
	
	@Override
	public String toString() {
		return "QueryAL1 [ApplyRemark=" + ApplyRemark + ", h001=" + h001
				+ ", h002=" + h002 + ", h003=" + h003 + ", h005=" + h005
				+ ", h006=" + h006 + ", h010=" + h010 + ", h020=" + h020
				+ ", h028=" + h028 + ", h029=" + h029 + ", h030=" + h030
				+ ", h031=" + h031 + ", h039=" + h039 + ", h040=" + h040
				+ ", jbr=" + jbr + ", lymc=" + lymc + ", username=" + username
				+ ", xmmc=" + xmmc + ", xqmc=" + xqmc + ", z004=" + z004
				+ ", z005=" + z005 + ", z007=" + z007 + ", z011=" + z011
				+ ", z012=" + z012 + ", z018=" + z018 + ", zcje=" + zcje + "]";
	}
	
}

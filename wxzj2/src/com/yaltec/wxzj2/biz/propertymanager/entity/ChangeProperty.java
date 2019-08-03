package com.yaltec.wxzj2.biz.propertymanager.entity;

import com.yaltec.comon.core.entity.Entity;

/**
 * 产权变更实体类
 * @author hqx
 *
 */
public class ChangeProperty extends Entity{
	/**
	 * 序列化版本标示.
	 */
	private static final long serialVersionUID = 1L;

	/**
	 * 房屋编号
	 */
	private String h001;
	
	/**
	 * 
	 */
	private String h001_1;
	
	/**
	 * 小区编码
	 */
	private String xqbm;
	
	/**
	 * 
	 */
	private String xqbm_1;
	
	/**
	 * 小区名称
	 */
	private String xqmc;
	
	/**
	 * 
	 */
	private String xqmc_1;
	
	/**
	 * 楼宇编号
	 */
	private String lybh;
	
	/**
	 * 
	 */
	private String lybh_1;
	
	/**
	 * 楼宇名称
	 */
	private String lymc;
	
	/**
	 * 
	 */
	private String lymc_1;
	
	/**
	 * 单位编码
	 */
	private String unitcode;
	
	/**
	 * 单位名称
	 */
	private String unitname;
	
	/**
	 * 
	 */
	private String o013;
	
	/**
	 * 
	 */
	private String n013;
	private String o011;
	private String n011;
	private String o012;
	private String n012;
	private String o014;
	private String n014;
	private String o015;
	private String n015;
	private String h002;
	private String h003;
	private String h005;
	private String bgrq;
	private String bgyy;
	private String oFileName;/*文件原名*/
	private String nFileName;/*服务器上保存名*/
	private String tbid;
	private String h030;
	private String note;
	
	public String getH001() {
		return h001;
	}
	public void setH001(String h001) {
		this.h001 = h001;
	}
	public String getH001_1() {
		return h001_1;
	}
	public void setH001_1(String h001_1) {
		this.h001_1 = h001_1;
	}
	public String getXqbm() {
		return xqbm;
	}
	public void setXqbm(String xqbm) {
		this.xqbm = xqbm;
	}
	public String getXqbm_1() {
		return xqbm_1;
	}
	public void setXqbm_1(String xqbm_1) {
		this.xqbm_1 = xqbm_1;
	}
	public String getXqmc() {
		return xqmc;
	}
	public void setXqmc(String xqmc) {
		this.xqmc = xqmc;
	}
	public String getXqmc_1() {
		return xqmc_1;
	}
	public void setXqmc_1(String xqmc_1) {
		this.xqmc_1 = xqmc_1;
	}
	public String getLybh() {
		return lybh;
	}
	public void setLybh(String lybh) {
		this.lybh = lybh;
	}
	public String getLybh_1() {
		return lybh_1;
	}
	public void setLybh_1(String lybh_1) {
		this.lybh_1 = lybh_1;
	}
	public String getLymc() {
		return lymc;
	}
	public void setLymc(String lymc) {
		this.lymc = lymc;
	}
	public String getLymc_1() {
		return lymc_1;
	}
	public void setLymc_1(String lymc_1) {
		this.lymc_1 = lymc_1;
	}
	public String getUnitcode() {
		return unitcode;
	}
	public void setUnitcode(String unitcode) {
		this.unitcode = unitcode;
	}
	public String getUnitname() {
		return unitname;
	}
	public void setUnitname(String unitname) {
		this.unitname = unitname;
	}
	public String getO013() {
		return o013;
	}
	public void setO013(String o013) {
		this.o013 = o013;
	}
	public String getN013() {
		return n013;
	}
	public void setN013(String n013) {
		this.n013 = n013;
	}
	public String getO011() {
		return o011;
	}
	public void setO011(String o011) {
		this.o011 = o011;
	}
	public String getN011() {
		return n011;
	}
	public void setN011(String n011) {
		this.n011 = n011;
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
	public String getBgrq() {
		return bgrq;
	}
	public void setBgrq(String bgrq) {
		this.bgrq = bgrq;
	}
	public String getOFileName() {
		if(oFileName == null){
			oFileName = "";
		}
		return oFileName;
	}
	public void setOFileName(String fileName) {
		oFileName = fileName;
	}
	public String getNFileName() {
		if(nFileName == null){
			nFileName = "";
		}
		return nFileName;
	}
	public void setNFileName(String fileName) {
		nFileName = fileName;
	}
	public String getTbid() {
		return tbid;
	}
	public void setTbid(String tbid) {
		this.tbid = tbid;
	}
	public String getH030() {
		return h030;
	}
	public void setH030(String h030) {
		this.h030 = h030;
	}
	public String getNote() {
		return note == null ? "" : note;
	}
	public void setNote(String note) {
		this.note = note;
	}
	public String getBgyy() {
		return bgyy;
	}
	public void setBgyy(String bgyy) {
		this.bgyy = bgyy;
	}
	public String getO012() {
		return o012;
	}
	public void setO012(String o012) {
		this.o012 = o012;
	}
	public String getN012() {
		return n012;
	}
	public void setN012(String n012) {
		this.n012 = n012;
	}
	public String getO014() {
		return o014;
	}
	public void setO014(String o014) {
		this.o014 = o014;
	}
	public String getN014() {
		return n014;
	}
	public void setN014(String n014) {
		this.n014 = n014;
	}
	public String getO015() {
		return o015;
	}
	public void setO015(String o015) {
		this.o015 = o015;
	}
	public String getN015() {
		return n015;
	}
	public void setN015(String n015) {
		this.n015 = n015;
	}
	public String getoFileName() {
		return oFileName;
	}
	public void setoFileName(String oFileName) {
		this.oFileName = oFileName;
	}
	public String getnFileName() {
		return nFileName;
	}
	public void setnFileName(String nFileName) {
		this.nFileName = nFileName;
	}
	
	@Override
	public String toString() {
		return "ChangeProperty [bgrq=" + bgrq + ", bgyy=" + bgyy + ", h001=" + h001 + ", h001_1=" + h001_1 + ", h002="
				+ h002 + ", h003=" + h003 + ", h005=" + h005 + ", h030=" + h030 + ", lybh=" + lybh + ", lybh_1="
				+ lybh_1 + ", lymc=" + lymc + ", lymc_1=" + lymc_1 + ", n011=" + n011 + ", n012=" + n012 + ", n013="
				+ n013 + ", n014=" + n014 + ", n015=" + n015 + ", nFileName=" + nFileName + ", note=" + note
				+ ", o011=" + o011 + ", o012=" + o012 + ", o013=" + o013 + ", o014=" + o014 + ", o015=" + o015
				+ ", oFileName=" + oFileName + ", tbid=" + tbid + ", unitcode=" + unitcode + ", unitname=" + unitname
				+ ", xqbm=" + xqbm + ", xqbm_1=" + xqbm_1 + ", xqmc=" + xqmc + ", xqmc_1=" + xqmc_1 + "]";
	}
	
}

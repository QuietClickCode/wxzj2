package com.yaltec.wxzj2.biz.draw.entity;

import java.util.Date;

import com.yaltec.comon.core.entity.Entity;

/**
 * 
 * @ClassName: Refund
 * @Description: TODO业主退款实体类
 * 
 * @author yangshanping
 * @date 2016-8-2 下午03:46:24
 */
public class Refund extends Entity{
	/**
	 * 序列化版本标示.
	 */
	private static final long serialVersionUID = 1L;
	/**
	 * 文件上传标识
	 */
	private String tbid;
	/**
	 * 楼宇名称
	 */
	private String lymc;
	/**
	 * 房屋编号
	 */
	private String h001;
	/**
	 * 地址
	 */
	private String dz;
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
	 * 房款
	 */
	private String h010;
	/**
	 * 应退本金
	 */
	private String z004;
	/**
	 * 应退利息
	 */
	private String z005;
	/**
	 * 退款金额
	 */
	private String z006;
	/**
	 * 业务编号
	 */
	private String z008;
	/**
	 * 退款人
	 */
	private String z012;
	/**
	 * 票据号
	 */
	private String z013;
	/**
	 * 操作员
	 */
	private String username;
	/**
	 * 退款原因
	 */
	private String z017;
	/**
	 * 退款日期
	 */
	private String z018;
	/**
	 * 
	 */
	private String z021;
	/**
	 * 
	 */
	private String z022;
	
	
	public String getTbid() {
		return tbid;
	}
	public void setTbid(String tbid) {
		this.tbid = tbid;
	}
	public String getLymc() {
		return lymc;
	}
	public void setLymc(String lymc) {
		this.lymc = lymc;
	}
	public String getH001() {
		return h001;
	}
	public void setH001(String h001) {
		this.h001 = h001;
	}
	public String getDz() {
		return dz;
	}
	public void setDz(String dz) {
		this.dz = dz;
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
	public String getH010() {
		return h010;
	}
	public void setH010(String h010) {
		this.h010 = h010;
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
	public String getZ006() {
		return z006;
	}
	public void setZ006(String z006) {
		this.z006 = z006;
	}
	public String getZ008() {
		return z008;
	}
	public void setZ008(String z008) {
		this.z008 = z008;
	}
	public String getZ012() {
		return z012;
	}
	public void setZ012(String z012) {
		this.z012 = z012;
	}
	public String getZ013() {
		return z013;
	}
	public void setZ013(String z013) {
		this.z013 = z013;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getZ017() {
		return z017;
	}
	public void setZ017(String z017) {
		this.z017 = z017;
	}
	public String getZ018() {
		return z018;
	}
	public void setZ018(String z018) {
		this.z018 = z018;
	}
	public String getZ021() {
		return z021;
	}
	public void setZ021(String z021) {
		this.z021 = z021;
	}
	public String getZ022() {
		return z022;
	}
	public void setZ022(String z022) {
		this.z022 = z022;
	}
	
	@Override
	public String toString() {
		return "Refund [dz=" + dz + ", h001=" + h001 + ", h002=" + h002
				+ ", h003=" + h003 + ", h005=" + h005 + ", h010=" + h010
				+ ", lymc=" + lymc + ", tbid=" + tbid + ", username="
				+ username + ", z004=" + z004 + ", z005=" + z005 + ", z006="
				+ z006 + ", z008=" + z008 + ", z012=" + z012 + ", z013=" + z013
				+ ", z017=" + z017 + ", z018=" + z018 + ", z021=" + z021
				+ ", z022=" + z022 + "]";
	}
	
}

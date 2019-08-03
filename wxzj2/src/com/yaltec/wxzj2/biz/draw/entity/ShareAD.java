package com.yaltec.wxzj2.biz.draw.entity;

import com.yaltec.comon.core.entity.Entity;
import com.yaltec.comon.utils.JsonUtil;

/**
 * 
 * @ClassName: ShareAD
 * @Description: 维修支取资金分摊实体类
 * 
 * @author yangshanping
 * @date 2016-8-25 上午10:48:53
 */
public class ShareAD extends Entity{
	/**
	 * 序列化版本标示.
	 */
	private static final long serialVersionUID = 1L;
	/**
	 * 房屋编号
	 */
	private String h001;
	/**
	 * 楼宇名称
	 */
	private String lymc;
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
	 * 业主姓名
	 */
	private String h013;
	/**
	 * 建筑面积
	 */
	private String h006;
	/**
	 * 身份证号
	 */
	private String h015;
	/**
	 * 
	 */
	private Double ftje;
	/**
	 * 
	 */
	private Double zqbj;
	/**
	 * 
	 */
	private Double zqlx;
	/**
	 * 
	 */
	private Double zcje;
	/**
	 * 本金余额
	 */
	private String h030;
	/**
	 * 利息余额
	 */
	private String h031;
	/**
	 * 
	 */
	private String bjye;
	/**
	 * 
	 */
	private String lxye;
	/**
	 * 
	 */
	private String isred;
	/**
	 * 
	 */
	private String username;
	/**
	 * 
	 */
	private String z003;
	/**
	 * 
	 */
	private String z002;
	/**
	 * 楼宇地址
	 */
	private String lyaddress;
	/**
	 * 业委会名称
	 */
	private String ywhmc;
	/**
	 * 物业公司名称
	 */
	private String wygsmc;
	
	//公共设施收益分摊
	/**
	 * 
	 */
	private String h020;
	/**
	 * 产权证号
	 */
	private String h016;
	/**
	 * 房款
	 */
	private Double h010;
	/**
	 * 应交资金
	 */
	private String h021;
	/**
	 * 交存标准
	 */
	private String h023;
	/**
	 * 维修项目
	 */
	private String wxxm;
	
	public String getH001() {
		return h001;
	}
	public void setH001(String h001) {
		this.h001 = h001;
	}
	public String getLymc() {
		return lymc;
	}
	public void setLymc(String lymc) {
		this.lymc = lymc;
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
	public String getH013() {
		return h013;
	}
	public void setH013(String h013) {
		this.h013 = h013;
	}
	public String getH006() {
		return h006;
	}
	public void setH006(String h006) {
		this.h006 = h006;
	}
	public String getH015() {
		return h015;
	}
	public void setH015(String h015) {
		this.h015 = h015;
	}
	public Double getFtje() {
		return ftje;
	}
	public void setFtje(Double ftje) {
		this.ftje = ftje;
	}
	public Double getZqbj() {
		return zqbj;
	}
	public void setZqbj(Double zqbj) {
		this.zqbj = zqbj;
	}
	public Double getZqlx() {
		return zqlx;
	}
	public void setZqlx(Double zqlx) {
		this.zqlx = zqlx;
	}
	public Double getZcje() {
		return zcje;
	}
	public void setZcje(Double zcje) {
		this.zcje = zcje;
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
	public String getIsred() {
		return isred;
	}
	public void setIsred(String isred) {
		this.isred = isred;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getZ003() {
		return z003;
	}
	public void setZ003(String z003) {
		this.z003 = z003;
	}
	public String getZ002() {
		return z002;
	}
	public void setZ002(String z002) {
		this.z002 = z002;
	}
	public String getLyaddress() {
		return lyaddress;
	}
	public void setLyaddress(String lyaddress) {
		this.lyaddress = lyaddress;
	}
	public String getYwhmc() {
		return ywhmc;
	}
	public void setYwhmc(String ywhmc) {
		this.ywhmc = ywhmc;
	}
	public String getWygsmc() {
		return wygsmc;
	}
	public void setWygsmc(String wygsmc) {
		this.wygsmc = wygsmc;
	}
	public String getH020() {
		return h020;
	}
	public void setH020(String h020) {
		this.h020 = h020;
	}
	public String getH016() {
		return h016;
	}
	public void setH016(String h016) {
		this.h016 = h016;
	}
	public Double getH010() {
		return h010;
	}
	public void setH010(Double h010) {
		this.h010 = h010;
	}
	public String getH021() {
		return h021;
	}
	public void setH021(String h021) {
		this.h021 = h021;
	}
	public String getH023() {
		return h023;
	}
	public void setH023(String h023) {
		this.h023 = h023;
	}
	
	@Override
	public String toString() {
		return JsonUtil.toJson(this);
	}
	public String getWxxm() {
		return wxxm;
	}
	public void setWxxm(String wxxm) {
		this.wxxm = wxxm;
	}
	
}

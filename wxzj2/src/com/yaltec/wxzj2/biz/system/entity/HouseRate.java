package com.yaltec.wxzj2.biz.system.entity;

import com.yaltec.comon.core.entity.Entity;

/**
 * <p>
 * ClassName: HouseRate
 * </p>
 * <p>
 * Description: 房屋利率实体类
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author jiangyong
 * @date 2016-8-20 下午04:27:58
 */
public class HouseRate extends Entity {

	/**
	 * 序列化版本标示.
	 */
	private static final long serialVersionUID = 1L;
	/**
	 * 房屋编号
	 */
	private String h001;
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
	 * 业主姓名
	 */
	private String h013;
	/**
	 * 身份证号码
	 */
	private String h015;
	/**
	 * 应交金额
	 */
	private String h021;
	/**
	 * 本金余额
	 */
	private String h030;
	/**
	 * 利息余额
	 */
	private String h031;
	/**
	 * 本息合计
	 */
	private String bxhj;
	/**
	 * 楼宇编号
	 */
	private String lybh;
	/**
	 * 小区编号
	 */
	private String xqbh;
	/**
	 * 小区名称
	 */
	private String xqmc;
	/**
	 * 房屋类型
	 */
	private String fwlx;
	/**
	 * 房屋性质
	 */
	private String fwxz;
	/**
	 * 交存标准
	 */
	private String yzjcbz;
	/**
	 * 建筑面积
	 */
	private String h006;
	/**
	 * 设置类别
	 */
	private String szlb;
	/**
	 * 定期类型
	 */
	private String dqbm;
	/**
	 * 活期金额(金额单元)
	 */
	private String hqje;
	/**
	 * 年利率
	 */
	private String nll;
	/**
	 * 设置日期
	 */
	private String ywrq;
	/**
	 * 变更原因
	 */
	private String bgyy;
	/**
	 * 保存类别
	 */
	private String bclb;
	private String username;
	private String com1;
	private String com2;

	public String getH001() {
		return h001;
	}

	public void setH001(String h001) {
		this.h001 = h001;
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

	public String getH013() {
		return h013;
	}

	public void setH013(String h013) {
		this.h013 = h013;
	}

	public String getH015() {
		return h015;
	}

	public void setH015(String h015) {
		this.h015 = h015;
	}

	public String getH021() {
		return h021;
	}

	public void setH021(String h021) {
		this.h021 = h021;
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

	public String getBxhj() {
		return bxhj;
	}

	public void setBxhj(String bxhj) {
		this.bxhj = bxhj;
	}

	public String getLybh() {
		return lybh;
	}

	public void setLybh(String lybh) {
		this.lybh = lybh;
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

	public String getFwlx() {
		return fwlx;
	}

	public void setFwlx(String fwlx) {
		this.fwlx = fwlx;
	}

	public String getFwxz() {
		return fwxz;
	}

	public void setFwxz(String fwxz) {
		this.fwxz = fwxz;
	}

	public String getYzjcbz() {
		return yzjcbz;
	}

	public void setYzjcbz(String yzjcbz) {
		this.yzjcbz = yzjcbz;
	}
	
	public String getH006() {
		return h006;
	}

	public void setH006(String h006) {
		this.h006 = h006;
	}

	public String getSzlb() {
		return szlb;
	}

	public void setSzlb(String szlb) {
		this.szlb = szlb;
	}

	public String getDqbm() {
		return dqbm;
	}

	public void setDqbm(String dqbm) {
		this.dqbm = dqbm;
	}

	public String getHqje() {
		return hqje;
	}

	public void setHqje(String hqje) {
		this.hqje = hqje;
	}

	public String getNll() {
		return nll;
	}

	public void setNll(String nll) {
		this.nll = nll;
	}

	public String getYwrq() {
		return ywrq;
	}

	public void setYwrq(String ywrq) {
		this.ywrq = ywrq;
	}

	public String getBgyy() {
		return bgyy;
	}

	public void setBgyy(String bgyy) {
		this.bgyy = bgyy;
	}
	
	public String getBclb() {
		return bclb;
	}

	public void setBclb(String bclb) {
		this.bclb = bclb;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getCom1() {
		return com1;
	}

	public void setCom1(String com1) {
		this.com1 = com1;
	}

	public String getCom2() {
		return com2;
	}

	public void setCom2(String com2) {
		this.com2 = com2;
	}

	@Override
	public String toString() {
		return "HouseRate [h001=" + h001 + ",h002=" + h002 + ",h003=" + h003 + ",h005=" + h005 + ",h010="+ h010 
				+ ",h013=" + h013 + ",h015=" + h015 + ",h021=" + h021 + ",h030=" + h030 + ",h031=" + h031 
				+ ",bxhj=" + bxhj + ",lybh=" + lybh + ",xqbh=" + xqbh + ",xqmc=" + xqmc + ",fwlx=" + fwlx 
				+ ",fwxz=" + fwxz + ",yzjcbz=" + yzjcbz + ",h006="+ h006 + ",szlb=" + szlb + ",dqbm=" + dqbm 
				+ ",hqje=" + hqje + ",nll=" + nll + ",ywrq=" + ywrq + ",bgyy=" + bgyy + ",username=" + username 
				+ ",com1=" + com1 + ",com2=" + com2 + ",bclb="+ bclb + "]";
	}
}

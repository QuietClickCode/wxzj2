package com.yaltec.wxzj2.biz.compositeQuery.entity;

import com.yaltec.comon.core.entity.Entity;

/**
 * <p>
 * ClassName: QueryCommunityP
 * </p>
 * <p>
 * Description: 小区缴款情况实体类
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author jiangyong
 * @date 2018-8-3 上午10:39:48
 */
public class QueryCommunityP extends Entity {

	/**
	 * 序列化版本标示.
	 */
	private static final long serialVersionUID = 1L;

	/**
	 * 小区编号
	 */
	private String xqbh;
	/**
	 * 小区名称
	 */
	private String xqmc;
	/**
	 * 开发单位编号
	 */
	private String dwbm;
	/**
	 * 开发单位
	 */
	private String dwmc;
	/**
	 * 总户数
	 */
	private String shs;
	/**
	 * 总面积
	 */
	private String sh006;
	/**
	 * 应交资金
	 */
	private String sh021;
	/**
	 * 已交户数
	 */
	private String phs;
	/**
	 * 已交面积
	 */
	private String ph006;
	/**
	 * 已交金额
	 */
	private String ph021;
	/**
	 * 未交户数
	 */
	private String uhs;
	/**
	 * 未交面积
	 */
	private String uh006;
	/**
	 * 未交金额
	 */
	private String uh021;

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

	public String getDwbm() {
		return dwbm;
	}

	public void setDwbm(String dwbm) {
		this.dwbm = dwbm;
	}

	public String getDwmc() {
		return dwmc;
	}

	public void setDwmc(String dwmc) {
		this.dwmc = dwmc;
	}

	public String getShs() {
		return shs;
	}

	public void setShs(String shs) {
		this.shs = shs;
	}

	public String getSh006() {
		return sh006;
	}

	public void setSh006(String sh006) {
		this.sh006 = sh006;
	}

	public String getSh021() {
		return sh021;
	}

	public void setSh021(String sh021) {
		this.sh021 = sh021;
	}

	public String getPhs() {
		return phs;
	}

	public void setPhs(String phs) {
		this.phs = phs;
	}

	public String getPh006() {
		return ph006;
	}

	public void setPh006(String ph006) {
		this.ph006 = ph006;
	}

	public String getPh021() {
		return ph021;
	}

	public void setPh021(String ph021) {
		this.ph021 = ph021;
	}

	public String getUhs() {
		return uhs;
	}

	public void setUhs(String uhs) {
		this.uhs = uhs;
	}

	public String getUh006() {
		return uh006;
	}

	public void setUh006(String uh006) {
		this.uh006 = uh006;
	}

	public String getUh021() {
		return uh021;
	}

	public void setUh021(String uh021) {
		this.uh021 = uh021;
	}

}

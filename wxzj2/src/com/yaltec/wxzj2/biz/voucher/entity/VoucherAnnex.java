package com.yaltec.wxzj2.biz.voucher.entity;

import com.yaltec.comon.core.entity.Entity;

/**
 * <p>
 * ClassName: VoucherAnnex
 * </p>
 * <p>
 * Description: 凭证附件实体类
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author jiangyong
 * @date 2016-8-26 下午02:11:17
 */
public class VoucherAnnex extends Entity {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	/**
	 * 楼宇名称
	 */
	private String lymc;
	/**
	 * 房屋编号
	 */
	private String h001;
	/**
	 * 摘要
	 */
	private String w002;
	/**
	 * 发生额
	 */
	private String w006;
	/**
	 * 业主姓名
	 */
	private String w012;
	/**
	 * 业务日期
	 */
	private String w013;
	/**
	 * 操作员
	 */
	private String username;

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

	public String getW002() {
		return w002;
	}

	public void setW002(String w002) {
		this.w002 = w002;
	}

	public String getW006() {
		return w006;
	}

	public void setW006(String w006) {
		this.w006 = w006;
	}

	public String getW012() {
		return w012;
	}

	public void setW012(String w012) {
		this.w012 = w012;
	}

	public String getW013() {
		return w013;
	}

	public void setW013(String w013) {
		this.w013 = w013;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String toString() {
		return "VoucherAnnex [lymc: " + lymc + ", h001: " + h001 + ", w002: " + w002 + ", w006: " + w006 + ", w012: "
				+ w012 + ", w013: " + w013 + ", username: " + username + "]";
	}

}

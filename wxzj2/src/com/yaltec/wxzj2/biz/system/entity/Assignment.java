package com.yaltec.wxzj2.biz.system.entity;

/**
 * <p>
 * ClassName: Assignment
 * </p>
 * <p>
 * Description: 归集中心实体类
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author hequanxin
 * @date 2016-7-19 下午02:36:58
 */
public class Assignment {

	/**
	 * 归集中心编码
	 */
	private String bm;

	/**
	 * 归集中心名称
	 */
	private String mc;

	/**
	 * 开户银行
	 */
	private String bankid;

	/**
	 * 银行名称
	 */
	private String bankmc;

	/**
	 * 银行账号
	 */
	private String bankno;

	/**
	 * 负责人
	 */
	private String manager;

	/**
	 * 账务主管
	 */
	private String financeSupervisor;

	/**
	 * 账务记账
	 */
	private String financialACC;

	/**
	 * 账务审核
	 */
	private String review;

	/**
	 * 填制人员
	 */
	private String marker;

	/**
	 * 联系电话(语音电话)
	 */
	private String tel;

	/**
	 * 备用
	 */
	private String assignmtbak;

	/**
	 * 是否调用银行接口, 1: 走银行接口;0：不走银行接口，不检查是否到帐，直接打票收据。默认走银行接口
	 */
	private String invokeBI = "0";

	public String getBm() {
		return bm;
	}

	public void setBm(String bm) {
		this.bm = bm;
	}

	public String getMc() {
		return mc;
	}

	public void setMc(String mc) {
		this.mc = mc;
	}

	public String getBankid() {
		return bankid;
	}

	public void setBankid(String bankid) {
		this.bankid = bankid;
	}

	public String getBankmc() {
		return bankmc;
	}

	public void setBankmc(String bankmc) {
		this.bankmc = bankmc;
	}

	public String getBankno() {
		return bankno;
	}

	public void setBankno(String bankno) {
		this.bankno = bankno;
	}

	public String getManager() {
		return manager;
	}

	public void setManager(String manager) {
		this.manager = manager;
	}

	public String getFinanceSupervisor() {
		return financeSupervisor;
	}

	public void setFinanceSupervisor(String financeSupervisor) {
		this.financeSupervisor = financeSupervisor;
	}

	public String getFinancialACC() {
		return financialACC;
	}

	public void setFinancialACC(String financialACC) {
		this.financialACC = financialACC;
	}

	public String getReview() {
		return review;
	}

	public void setReview(String review) {
		this.review = review;
	}

	public String getMarker() {
		return marker;
	}

	public void setMarker(String marker) {
		this.marker = marker;
	}

	public String getTel() {
		return tel;
	}

	public void setTel(String tel) {
		this.tel = tel;
	}

	public String getAssignmtbak() {
		return assignmtbak;
	}

	public void setAssignmtbak(String assignmtbak) {
		this.assignmtbak = assignmtbak;
	}

	public String getInvokeBI() {
		return invokeBI;
	}

	public void setInvokeBI(String invokeBI) {
		this.invokeBI = invokeBI;
	}

	@Override
	public String toString() {
		return "Assignment [assignmtbak=" + assignmtbak + ", bankid=" + bankid + ", bankmc=" + bankmc + ", bankno="
				+ bankno + ", bm=" + bm + ", financeSupervisor=" + financeSupervisor + ", financialACC=" + financialACC
				+ ", manager=" + manager + ", marker=" + marker + ", mc=" + mc + ", review=" + review + ",invokeBI="
				+ invokeBI + ", tel=" + tel + "]";
	}

}

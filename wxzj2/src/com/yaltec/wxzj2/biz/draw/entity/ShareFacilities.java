package com.yaltec.wxzj2.biz.draw.entity;

import com.yaltec.comon.core.entity.Entity;
/**
 * 
* @ClassName: ShareFacilities
* @Description: 公共设施收益分摊实体类

* @author yangshanping
* @date 2016-9-3 下午04:23:22
 */
public class ShareFacilities extends Entity{
	/**
	 * 序列化版本标示.
	 */
	private static final long serialVersionUID = 1L;
	/**
	 * 编码
	 */
	private String bm;
	/**
	 * 经办人
	 */
	private String handlingUser;
	/**
	 * 楼宇编码
	 */
	private String bldgcode;
	/**
	 * 楼宇名称
	 */
	private String bldgname;
	/**
	 * 收益项目
	 */
	private String incomeItems;
	/**
	 * 交款日期
	 */
	private String businessDate;
	/**
	 * 交款金额
	 */
	private Double incomeAmount;
	/**
	 * 
	 */
	private String voucherNO;
	/**
	 * 业务编码
	 */
	private String businessNO;
	/**
	 * 
	 */
	private String accountDate;
	/**
	 * 银行编码
	 */
	private String bankCode;
	/**
	 * 银行名称
	 */
	private String bankName;
	/**
	 * 票据号
	 */
	private String receiptNO;
	/**
	 * 
	 */
	private String username;
	/**
	 * 小区编码
	 */
	private String nbhdcode;
	/**
	 * 小区名称
	 */
	private String nbhdname;
	
	public String getBm() {
		return bm;
	}
	public void setBm(String bm) {
		this.bm = bm;
	}
	public String getHandlingUser() {
		return handlingUser;
	}
	public void setHandlingUser(String handlingUser) {
		this.handlingUser = handlingUser;
	}
	public String getBldgcode() {
		return bldgcode;
	}
	public void setBldgcode(String bldgcode) {
		this.bldgcode = bldgcode;
	}
	public String getBldgname() {
		return bldgname;
	}
	public void setBldgname(String bldgname) {
		this.bldgname = bldgname;
	}
	public String getIncomeItems() {
		return incomeItems;
	}
	public void setIncomeItems(String incomeItems) {
		this.incomeItems = incomeItems;
	}
	public String getBusinessDate() {
		return businessDate;
	}
	public void setBusinessDate(String businessDate) {
		this.businessDate = businessDate;
	}
	public Double getIncomeAmount() {
		return incomeAmount;
	}
	public void setIncomeAmount(Double incomeAmount) {
		this.incomeAmount = incomeAmount;
	}
	public String getVoucherNO() {
		return voucherNO;
	}
	public void setVoucherNO(String voucherNO) {
		this.voucherNO = voucherNO;
	}
	public String getBusinessNO() {
		return businessNO;
	}
	public void setBusinessNO(String businessNO) {
		this.businessNO = businessNO;
	}
	public String getAccountDate() {
		return accountDate;
	}
	public void setAccountDate(String accountDate) {
		this.accountDate = accountDate;
	}
	public String getBankCode() {
		return bankCode;
	}
	public void setBankCode(String bankCode) {
		this.bankCode = bankCode;
	}
	public String getBankName() {
		return bankName;
	}
	public void setBankName(String bankName) {
		this.bankName = bankName;
	}
	public String getReceiptNO() {
		return receiptNO;
	}
	public void setReceiptNO(String receiptNO) {
		this.receiptNO = receiptNO;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getNbhdcode() {
		return nbhdcode;
	}
	public void setNbhdcode(String nbhdcode) {
		this.nbhdcode = nbhdcode;
	}
	public String getNbhdname() {
		return nbhdname;
	}
	public void setNbhdname(String nbhdname) {
		this.nbhdname = nbhdname;
	}
	
	@Override
	public String toString() {
		return "ShareFacilities [accountDate=" + accountDate + ", bankCode="
				+ bankCode + ", bankName=" + bankName + ", bldgcode="
				+ bldgcode + ", bldgname=" + bldgname + ", bm=" + bm
				+ ", businessDate=" + businessDate + ", businessNO="
				+ businessNO + ", handlingUser=" + handlingUser
				+ ", incomeAmount=" + incomeAmount + ", incomeItems="
				+ incomeItems + ", nbhdcode=" + nbhdcode + ", nbhdname="
				+ nbhdname + ", receiptNO=" + receiptNO + ", username="
				+ username + ", voucherNO=" + voucherNO + "]";
	}
	
}

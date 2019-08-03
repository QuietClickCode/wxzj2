package com.yaltec.wxzj2.biz.bill.entity;

import com.yaltec.comon.core.entity.Entity;

/**
 * <p>
 * ClassName: ReceiptInfoM
 * </p>
 * <p>
 * Description: 票据明细实体类
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author moqian
 * @date 2016-8-6 上午11:36:58
 */

public class ReceiptInfoM extends Entity {

	/**
	 * 序列化版本标示.
	 */
	private static final long serialVersionUID = 1L;
	/**
	 * 编码
	 */
	protected String bm;
	/**
	 * 票据号
	 */
	protected String pjh;
	/**
	 * 是否已用
	 */
	protected String sfuse;
	/**
	 * 是否作废
	 */
	protected String sfzf;
	/**
	 * 是否领用
	 */
	protected String sfqy;
	/**
	 * 银行编号
	 */
	private String yhbh; 
	/**
	 * 银行名称
	 */
	private String yhmc; 
	/**
	 * 使用部门
	 */
	protected String usepart;
	/**
	 * 使用人员
	 */
	protected String username;
	/**
	 * 业主
	 */
	protected String h013;
	/**
	 * 操作人员
	 */
	protected String czry;
	/**
	 * 业务日期
	 */
	protected String w013;
	/**
	 * 数字指纹
	 */
	protected String fingerprintData;
	/**
	 * 票据版本号
	 */
	protected String regNo;
	/**
	 * 非税导出编号
	 */
	protected String batchNo;
	/**
	 * 非税导出状态
	 */
	protected String status;

	public String getBm() {
		return bm;
	}

	public void setBm(String bm) {
		this.bm = bm;
	}

	public String getPjh() {
		return pjh;
	}

	public void setPjh(String pjh) {
		this.pjh = pjh;
	}

	public String getSfuse() {
		return sfuse == null ? "0" : sfuse;
	}

	public void setSfuse(String sfuse) {
		this.sfuse = sfuse;
	}

	public String getSfzf() {
		return sfzf == null ? "0" : sfzf;
	}

	public void setSfzf(String sfzf) {
		this.sfzf = sfzf;
	}

	public String getSfqy() {
		return sfqy == null ? "0" : sfqy;
	}

	public void setSfqy(String sfqy) {
		this.sfqy = sfqy;
	}

	public String getYhbh() {
		return yhbh;
	}

	public void setYhbh(String yhbh) {
		this.yhbh = yhbh;
	}

	public String getYhmc() {
		return yhmc;
	}

	public void setYhmc(String yhmc) {
		this.yhmc = yhmc;
	}

	public String getUsepart() {
		return usepart;
	}

	public void setUsepart(String usepart) {
		this.usepart = usepart;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getH013() {
		return h013;
	}

	public void setH013(String h013) {
		this.h013 = h013;
	}

	public String getCzry() {
		return czry;
	}

	public void setCzry(String czry) {
		this.czry = czry;
	}

	public String getW013() {
		return w013 == null? "": w013;
	}

	public void setW013(String w013) {
		this.w013 = w013;
	}

	public String getFingerprintData() {
		return fingerprintData;
	}

	public void setFingerprintData(String fingerprintData) {
		this.fingerprintData = fingerprintData;
	}

	public String getRegNo() {
		return regNo;
	}

	public void setRegNo(String regNo) {
		this.regNo = regNo;
	}

	public String getBatchNo() {
		return batchNo;
	}

	public void setBatchNo(String batchNo) {
		this.batchNo = batchNo;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	@Override
	public String toString() {
		return "ReceiptInfoM [batchNo=" + batchNo + ", bm=" + bm + ", czry="
				+ czry + ", fingerprintData=" + fingerprintData + ", h013="
				+ h013 + ", pjh=" + pjh + ", regNo=" + regNo + ", sfqy=" + sfqy
				+ ", sfuse=" + sfuse + ", sfzf=" + sfzf + ", status=" + status
				+ ", usepart=" + usepart + ", username=" + username + ", w013="
				+ w013 + ", yhbh=" + yhbh + ", yhmc=" + yhmc + "]";
	}

}

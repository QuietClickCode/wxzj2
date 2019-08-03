package com.yaltec.wxzj2.biz.property.entity;

import com.yaltec.comon.core.entity.Entity;

/**
 * <p>
 * ClassName: Developer
 * </p>
 * <p>
 * Description: 开发单位实体(这里用一句话描述这个类的作用)
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author jiangyong
 * @date 2016-7-19 下午02:36:58
 */
public class Developer extends Entity {

	/**
	 * 序列化版本标示.
	 */
	private static final long serialVersionUID = 1L;

	/**
	 * 主键编码
	 */
	private String bm;
	/**
	 * 单位名称
	 */
	private String mc;
	/**
	 * 联系人
	 */
	private String contactPerson;
	/**
	 * 联系电话
	 */
	private String tel;
	/**
	 * 地址
	 */
	private String address;
	/**
	 * 公司类型
	 */
	private String companyType;
	/**
	 * 资质等级
	 */
	private String qualificationGrade;
	/**
	 * 资质证书号
	 */
	private String qualificationNO;
	/**
	 * 证书发放日期
	 */
	private String certificateIssuingDate;
	/**
	 * 证书有效日期
	 */
	private String certificateValidityDate;
	/**
	 * 法人代表
	 */
	private String legalPerson;
	/**
	 * 注册资金
	 */
	private String registeredCapital;
	/**
	 * 年审日期
	 */
	private String inspectionDate;
	/**
	 * 开业日期
	 */
	private String openingDate;
	/**
	 * 年审情况
	 */
	private String annualReview;
	/**
	 * 是否批复
	 */
	private String ifReply;
	/**
	 * 批复文号
	 */
	private String approvalNumber;
	/**
	 * 批复日期
	 */
	private String approvalDate;
	/**
	 * 公司账号
	 */
	private String companyAccount;

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

	public String getContactPerson() {
		return contactPerson;
	}

	public void setContactPerson(String contactPerson) {
		this.contactPerson = contactPerson;
	}

	public String getTel() {
		return tel;
	}

	public void setTel(String tel) {
		this.tel = tel;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getCompanyType() {
		return companyType;
	}

	public void setCompanyType(String companyType) {
		this.companyType = companyType;
	}

	public String getQualificationGrade() {
		return qualificationGrade;
	}

	public void setQualificationGrade(String qualificationGrade) {
		this.qualificationGrade = qualificationGrade;
	}

	public String getQualificationNO() {
		return qualificationNO;
	}

	public void setQualificationNO(String qualificationNO) {
		this.qualificationNO = qualificationNO;
	}

	public String getCertificateIssuingDate() {
		return certificateIssuingDate;
	}

	public void setCertificateIssuingDate(String certificateIssuingDate) {
		this.certificateIssuingDate = certificateIssuingDate;
	}

	public String getCertificateValidityDate() {
		return certificateValidityDate;
	}

	public void setCertificateValidityDate(String certificateValidityDate) {
		this.certificateValidityDate = certificateValidityDate;
	}

	public String getLegalPerson() {
		return legalPerson;
	}

	public void setLegalPerson(String legalPerson) {
		this.legalPerson = legalPerson;
	}

	public String getRegisteredCapital() {
		return registeredCapital;
	}

	public void setRegisteredCapital(String registeredCapital) {
		this.registeredCapital = registeredCapital;
	}

	public String getInspectionDate() {
		return inspectionDate;
	}

	public void setInspectionDate(String inspectionDate) {
		this.inspectionDate = inspectionDate;
	}

	public String getOpeningDate() {
		return openingDate;
	}

	public void setOpeningDate(String openingDate) {
		this.openingDate = openingDate;
	}

	public String getAnnualReview() {
		return annualReview;
	}

	public void setAnnualReview(String annualReview) {
		this.annualReview = annualReview;
	}

	public String getIfReply() {
		return ifReply == null? "0": ifReply;
	}

	public void setIfReply(String ifReply) {
		this.ifReply = ifReply;
	}

	public String getApprovalNumber() {
		return approvalNumber;
	}

	public void setApprovalNumber(String approvalNumber) {
		this.approvalNumber = approvalNumber;
	}

	public String getApprovalDate() {
		return approvalDate;
	}

	public void setApprovalDate(String approvalDate) {
		this.approvalDate = approvalDate;
	}

	public String getCompanyAccount() {
		return companyAccount;
	}

	public void setCompanyAccount(String companyAccount) {
		this.companyAccount = companyAccount;
	}

	public String toString() {
		return "Developer [ bm=" + bm + ", mc=" + mc + ", contactPerson=" + contactPerson + ", tel=" + tel
				+ ", address=" + address + ", companyType=" + companyType + ", qualificationGrade="
				+ qualificationGrade + ", qualificationNO=" + qualificationNO + ", certificateIssuingDate="
				+ certificateIssuingDate + ", qualificationNO=" + qualificationNO + ", certificateIssuingDate="
				+ certificateIssuingDate + ", certificateValidityDate=" + certificateValidityDate + ", legalPerson="
				+ legalPerson + ", registeredCapital=" + registeredCapital + ", inspectionDate=" + inspectionDate
				+ ", openingDate=" + openingDate + ", annualReview=" + annualReview + ", ifReply=" + ifReply
				+ ", approvalNumber=" + approvalNumber + ", approvalDate=" + approvalDate + ", companyAccount="
				+ companyAccount + "]";
	}

}

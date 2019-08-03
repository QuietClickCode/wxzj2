package com.yaltec.wxzj2.biz.property.entity;

import com.yaltec.comon.core.entity.Entity;

/**
 * 物业公司实体类
 * @ClassName: PropertyCompany
 * @Description: TODO
 * 
 * @author yangshanping
 * @date 2016-7-18 上午10:10:01
 */
public class PropertyCompany extends Entity {
	/**
	 * 序列化版本标示.
	 */
	private static final long serialVersionUID = 1L;
	/**
	 * 主键编码
	 */
	private String bm;  
	/**
	 * 物业公司名称
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
	 * 公司地址
	 */
	private String address;
	/**
	 * 法人代表
	 */
	private String legalPerson;
	/**
	 * 资质等级
	 */
	private String qualificationGrade;
	/**
	 * 资质证书
	 */
	private String qualificationCertificate;
	/**
	 * 管理日期(开始日期)
	 */
	private String managementStartDate;
	/**
	 * 管理日期(结束日期)
	 */
	private String managementEndDate;
	
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
	public String getLegalPerson() {
		return legalPerson;
	}
	public void setLegalPerson(String legalPerson) {
		this.legalPerson = legalPerson;
	}
	public String getQualificationGrade() {
		return qualificationGrade;
	}
	public void setQualificationGrade(String qualificationGrade) {
		this.qualificationGrade = qualificationGrade;
	}
	public String getQualificationCertificate() {
		return qualificationCertificate;
	}
	public void setQualificationCertificate(String qualificationCertificate) {
		this.qualificationCertificate = qualificationCertificate;
	}
	
	public String getManagementStartDate() {
		return managementStartDate;
	}
	public void setManagementStartDate(String managementStartDate) {
		this.managementStartDate = managementStartDate;
	}
	public String getManagementEndDate() {
		return managementEndDate;
	}
	public void setManagementEndDate(String managementEndDate) {
		this.managementEndDate = managementEndDate;
	}
	@Override
	public String toString() {
		return "PropertyCompany [ bm=" + bm + ", mc=" + mc + ", contactPerson="
				+ contactPerson + ", tel=" + tel + ", address=" + address
				+ ", legalPerson=" + legalPerson + ", qualificationGrade="
				+ qualificationGrade + ", qualificationCertificate="
				+ qualificationCertificate + ", managementStartDate="
				+ managementStartDate + ", managementEndDate="
				+ managementEndDate + "]";
	}
	
	
}

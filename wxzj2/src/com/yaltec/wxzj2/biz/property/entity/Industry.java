package com.yaltec.wxzj2.biz.property.entity;


import com.yaltec.comon.core.entity.Entity;

/**
 * 
 * @ClassName: Industry
 * @Description: TODO业委会实体类
 * 
 * @author yangshanping
 * @date 2016-7-20 下午04:16:32
 */

public class Industry extends Entity{

	/**
	 * 序列化版本标示.
	 */
	private static final long serialVersionUID = 1L;
	/**
	 * 主键编号
	 */
	private String bm;
	/**
	 * 业委会名称
	 */
	private String mc;	
	/**
	 * 联系人
	 */
	private String contactPerson;
	/**
	 * 电话
	 */
	private String tel;
	/**
	 * 地址
	 */
	private String address;
	/**
	 * 成立日期
	 */
	private String seupDate;
	/**
	 * 批准日期
	 */
	private String approvalDate;
	/**
	 * 批准文号
	 */
	private String approvalNumber;
	/**
	 * 小区编码
	 */
	private String nbhdCode;
	/**
	 * 小区名称
	 */
	private String nbhdName;
	/**
	 * 归集中心编码
	 */
	private String unitCode;
	/**
	 * 归集中心
	 */
	private String unitName;
	/**
	 * 管理楼宇栋数
	 */
	private String managebldgno;
	/**
	 * 管理户数
	 */
	private String managehousno;
	/**
	 * 负责人
	 */
	private String manager;
	/**
	 * 备用字段
	 */
	private String commbak;
	
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
	
	public String getSeupDate() {
		return seupDate;
	}
	public void setSeupDate(String seupDate) {
		this.seupDate = seupDate;
	}
	public String getApprovalDate() {
		return approvalDate;
	}
	public void setApprovalDate(String approvalDate) {
		this.approvalDate = approvalDate;
	}
	public String getApprovalNumber() {
		return approvalNumber;
	}
	public void setApprovalNumber(String approvalNumber) {
		this.approvalNumber = approvalNumber;
	}
	public String getNbhdCode() {
		return nbhdCode;
	}
	public void setNbhdCode(String nbhdCode) {
		this.nbhdCode = nbhdCode;
	}
	public String getNbhdName() {
		return nbhdName;
	}
	public void setNbhdName(String nbhdName) {
		this.nbhdName = nbhdName;
	}
	public String getUnitCode() {
		return unitCode;
	}
	public void setUnitCode(String unitCode) {
		this.unitCode = unitCode;
	}
	public String getUnitName() {
		return unitName;
	}
	public void setUnitName(String unitName) {
		this.unitName = unitName;
	}
	public String getManagebldgno() {
		return managebldgno;
	}
	public void setManagebldgno(String managebldgno) {
		this.managebldgno = managebldgno;
	}
	public String getManagehousno() {
		return managehousno;
	}
	public void setManagehousno(String managehousno) {
		this.managehousno = managehousno;
	}
	public String getManager() {
		return manager;
	}
	public void setManager(String manager) {
		this.manager = manager;
	}
	public String getCommbak() {
		return commbak;
	}
	public void setCommbak(String commbak) {
		this.commbak = commbak;
	}
	
	@Override
	public String toString() {
		return "Industry [ bm=" + bm + ", mc=" + mc + ", contactPerson="
				+ contactPerson + ", tel=" + tel + ", address=" + address
				+ ", seupDate=" + seupDate + ", approvalDate=" + approvalDate
				+ ", approvalNumber=" + approvalNumber + ", nbhdCode="
				+ nbhdCode + ", nbhdName=" + nbhdName + ", unitCode="
				+ unitCode + ", unitName=" + unitName + ", managebldgno="
				+ managebldgno + ", managehousno=" + managehousno
				+ ", manager=" + manager + ", commbak=" + commbak + "]";
	}
}

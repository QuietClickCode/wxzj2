package com.yaltec.wxzj2.biz.property.entity;

import com.yaltec.comon.core.entity.Entity;

/**
 * 
 * @ClassName: Community
 * @Description: TODO小区信息实体类
 * 
 * @author yangshanping
 * @date 2016-7-21 下午02:06:42
 */

public class Community extends Entity {
	/**
	 * 序列化版本标示.
	 */
	private static final long serialVersionUID = 1L;
	/**
	 * 编号
	 */
	private String bm;
	/**
	 * 项目编码
	 */
	private String xmbm;
	/**
	 * 项目名称
	 */
	private String xmmc;
	/**
	 * 小区名称
	 */
	private String mc;
	/**
	 * 地址
	 */
	private String address;
	/**
	 * 物管经营用房
	 */
	private String propertyHouse;
	/**
	 * 物管经营用房面积
	 */
	private String propertyHouseArea;
	/**
	 * 物管办公用房
	 */
	private String propertyOfficeHouse;
	/**
	 * 物管办公用房面积
	 */
	private String propertyOfficeHouseArea;
	/**
	 * 公建用房
	 */
	private String publicHouse;
	/**
	 * 公建用房面积
	 */
	private String publicHouseArea;
	/**
	 * 楼宇数
	 */
	private String bldgNO;
	/**
	 * 区域编码
	 */
	private String districtID;
	/**
	 * 区域
	 */
	private String district;
	/**
	 * 归集中心编码
	 */
	private String unitCode;
	/**
	 * 归集中心
	 */
	private String unitName;
	/**
	 * 应交资金
	 */
	private String payableFunds;
	/**
	 * 实交资金
	 */
	private String paidFunds;
	/**
	 * 备案日期
	 */
	private String recordDate;
	/**
	 * 其他
	 */
	private String other;
	/**
	 * 备注
	 */
	private String remarks;
	/**
	 * 街道ID
	 */
	private String streetID;
	/**
	 * 街道名称
	 */
	private String street;
	/**
	 * 小区江津编码
	 */
	private String nbhCode;
	/**
	 * 附件服务器文件名
	 */
	private String nFileName;
	/**
	 * 附件原文件名
	 */
	private String oFileName;
	/**
	 * 开发公司编码
	 */
	private String kfgsbm;
	/**
	 * 开发公司
	 */
	private String kfgsmc;
	/**
	 * 物业公司编码
	 */
	private String wygsbm;
	/**
	 * 物业公司
	 */
	private String wygsmc;
	/**
	 * 备用字段
	 */
	private String nbhdbak;
	/**
	 * 合同管理起始日期
	 */
	private String managementStartDate;
	/**
	 * 合同管理截至日期
	 */
	private String managementEndDate;

	public Community() {
		super();
	}

	public Community(String bm, String mc) {
		super();
		this.bm = bm;
		this.mc = mc;
	}

	public String getBm() {
		return bm;
	}

	public void setBm(String bm) {
		this.bm = bm;
	}

	public String getXmbm() {
		return xmbm;
	}

	public void setXmbm(String xmbm) {
		this.xmbm = xmbm;
	}

	public String getXmmc() {
		return xmmc;
	}

	public void setXmmc(String xmmc) {
		this.xmmc = xmmc;
	}

	public String getMc() {
		return mc;
	}

	public void setMc(String mc) {
		this.mc = mc;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getPropertyHouse() {
		return propertyHouse;
	}

	public void setPropertyHouse(String propertyHouse) {
		this.propertyHouse = propertyHouse;
	}

	public String getPropertyHouseArea() {
		return propertyHouseArea;
	}

	public void setPropertyHouseArea(String propertyHouseArea) {
		this.propertyHouseArea = propertyHouseArea;
	}

	public String getPropertyOfficeHouse() {
		return propertyOfficeHouse;
	}

	public void setPropertyOfficeHouse(String propertyOfficeHouse) {
		this.propertyOfficeHouse = propertyOfficeHouse;
	}

	public String getPropertyOfficeHouseArea() {
		return propertyOfficeHouseArea;
	}

	public void setPropertyOfficeHouseArea(String propertyOfficeHouseArea) {
		this.propertyOfficeHouseArea = propertyOfficeHouseArea;
	}

	public String getPublicHouse() {
		return publicHouse;
	}

	public void setPublicHouse(String publicHouse) {
		this.publicHouse = publicHouse;
	}

	public String getPublicHouseArea() {
		return publicHouseArea;
	}

	public void setPublicHouseArea(String publicHouseArea) {
		this.publicHouseArea = publicHouseArea;
	}

	public String getBldgNO() {
		return bldgNO;
	}

	public void setBldgNO(String bldgNO) {
		this.bldgNO = bldgNO;
	}

	public String getDistrictID() {
		return districtID;
	}

	public void setDistrictID(String districtID) {
		this.districtID = districtID;
	}

	public String getDistrict() {
		return district;
	}

	public void setDistrict(String district) {
		this.district = district;
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

	public String getPayableFunds() {
		return payableFunds;
	}

	public void setPayableFunds(String payableFunds) {
		this.payableFunds = payableFunds;
	}

	public String getPaidFunds() {
		return paidFunds;
	}

	public void setPaidFunds(String paidFunds) {
		this.paidFunds = paidFunds;
	}

	public String getRecordDate() {
		return recordDate;
	}

	public void setRecordDate(String recordDate) {
		this.recordDate = recordDate;
	}

	public String getOther() {
		return other;
	}

	public void setOther(String other) {
		this.other = other;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	public String getStreetID() {
		return streetID;
	}

	public void setStreetID(String streetID) {
		this.streetID = streetID;
	}

	public String getStreet() {
		return street;
	}

	public void setStreet(String street) {
		this.street = street;
	}

	public String getNbhCode() {
		return nbhCode;
	}

	public void setNbhCode(String nbhCode) {
		this.nbhCode = nbhCode;
	}

	public String getnFileName() {
		return nFileName;
	}

	public void setnFileName(String nFileName) {
		this.nFileName = nFileName;
	}

	public String getoFileName() {
		return oFileName;
	}

	public void setoFileName(String oFileName) {
		this.oFileName = oFileName;
	}

	public String getKfgsbm() {
		return kfgsbm;
	}

	public void setKfgsbm(String kfgsbm) {
		this.kfgsbm = kfgsbm;
	}

	public String getKfgsmc() {
		return kfgsmc;
	}

	public void setKfgsmc(String kfgsmc) {
		this.kfgsmc = kfgsmc;
	}

	public String getWygsbm() {
		return wygsbm;
	}

	public void setWygsbm(String wygsbm) {
		this.wygsbm = wygsbm;
	}

	public String getWygsmc() {
		return wygsmc;
	}

	public void setWygsmc(String wygsmc) {
		this.wygsmc = wygsmc;
	}

	public String getNbhdbak() {
		return nbhdbak;
	}

	public void setNbhdbak(String nbhdbak) {
		this.nbhdbak = nbhdbak;
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
		return "Community [address=" + address + ", bldgNO=" + bldgNO + ", bm="
				+ bm + ", district=" + district + ", districtID=" + districtID
				+ ", kfgsbm=" + kfgsbm + ", kfgsmc=" + kfgsmc
				+ ", managementEndDate=" + managementEndDate
				+ ", managementStartDate=" + managementStartDate + ", mc=" + mc
				+ ", nFileName=" + nFileName + ", nbhCode=" + nbhCode
				+ ", nbhdbak=" + nbhdbak + ", oFileName=" + oFileName
				+ ", other=" + other + ", paidFunds=" + paidFunds
				+ ", payableFunds=" + payableFunds + ", propertyHouse="
				+ propertyHouse + ", propertyHouseArea=" + propertyHouseArea
				+ ", propertyOfficeHouse=" + propertyOfficeHouse
				+ ", propertyOfficeHouseArea=" + propertyOfficeHouseArea
				+ ", publicHouse=" + publicHouse + ", publicHouseArea="
				+ publicHouseArea + ", recordDate=" + recordDate + ", remarks="
				+ remarks + ", street=" + street + ", streetID=" + streetID
				+ ", unitCode=" + unitCode + ", unitName=" + unitName
				+ ", wygsbm=" + wygsbm + ", wygsmc=" + wygsmc + ", xmbm="
				+ xmbm + ", xmmc=" + xmmc + "]";
	}

	// 清除暂时不用的数据
	public void clear() {
		this.address = null;
		this.propertyHouse = null;
		this.propertyHouseArea = null;
		this.propertyOfficeHouse = null;
		this.propertyOfficeHouseArea = null;
		this.publicHouse = null;
		this.publicHouseArea = null;
		this.bldgNO = null;
		this.district = null;
		this.payableFunds = null;
		this.recordDate = null;
		this.other = null;
		this.remarks = null;
		this.street = null;
		this.nbhCode = null;
		this.nFileName = null;
		this.oFileName = null;
		this.kfgsmc = null;
		this.wygsmc = null;
		this.nbhdbak = null;
		this.managementStartDate = null;
		this.managementEndDate = null;
	}

}

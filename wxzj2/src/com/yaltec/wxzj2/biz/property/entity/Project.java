package com.yaltec.wxzj2.biz.property.entity;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.yaltec.comon.core.entity.Entity;

/**
 * 
 * @ClassName: Project
 * @Description: TODO项目信息实体类
 * 
 * @author yangshanping
 * @date 2016-7-22 上午09:00:52
 */
public class Project extends Entity {
	/**
	 * 序列化版本标示.
	 */
	private static final long serialVersionUID = 1L;
	/**
	 * 主键编号
	 */
	private String bm;
	/**
	 * 项目名称
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
	 * 楼宇数
	 */
	private String bldgNO;
	/**
	 * 应交资金
	 */
	private String payableFunds;
	/**
	 * 实交资金
	 */
	private String paidFunds;
	/**
	 * 其他(财务编码)
	 */
	private String other;
	/**
	 * 备注
	 */
	private String remarks;
	/**
	 * 备案日期
	 */
	@DateTimeFormat(pattern = "yyyy-MM-dd")
	private Date recordDate;
	/**
	 * 备用字段
	 */
	private String nbhdBak;
	/**
	 * 备用字段
	 */
	private String HBID;

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

	public String getBldgNO() {
		return bldgNO;
	}

	public void setBldgNO(String bldgNO) {
		this.bldgNO = bldgNO;
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

	@JsonFormat(pattern = "yyyy-MM-dd", timezone = "GMT+8")
	public Date getRecordDate() {
		return recordDate;
	}

	public void setRecordDate(Date recordDate) {
		this.recordDate = recordDate;
	}

	public String getNbhdBak() {
		return nbhdBak;
	}

	public void setNbhdBak(String nbhdBak) {
		this.nbhdBak = nbhdBak;
	}

	public String getHBID() {
		return HBID;
	}

	public void setHBID(String hBID) {
		HBID = hBID;
	}

	@Override
	public String toString() {
		return "Project [address=" + address + ", bldgNO=" + bldgNO + ", bm="
				+ bm + ", district=" + district + ", districtID=" + districtID
				+ ", mc=" + mc + ", nbhdBak=" + nbhdBak + ", other=" + other
				+ ", paidFunds=" + paidFunds + ", payableFunds=" + payableFunds
				+ ", propertyHouse=" + propertyHouse + ", propertyHouseArea="
				+ propertyHouseArea + ", propertyOfficeHouse="
				+ propertyOfficeHouse + ", propertyOfficeHouseArea="
				+ propertyOfficeHouseArea + ", publicHouse=" + publicHouse
				+ ", publicHouseArea=" + publicHouseArea + ", recordDate="
				+ recordDate + ", remarks=" + remarks + ", unitCode="
				+ unitCode + ", unitName=" + unitName + ", HBID=" + HBID + "]";
	}

}

package com.yaltec.wxzj2.biz.property.entity;

import com.yaltec.comon.core.entity.Entity;

/**
 * 
 * @ClassName: Building
 * @Description: TODO楼宇实体类
 * 
 * @author yangshanping
 * @date 2016-7-22 下午05:10:16
 */
public class Building extends Entity{
	/**
	 * 序列化版本标示.
	 */
	private static final long serialVersionUID = 1L;
	/**
	 * 楼宇编号
	 */
	private String lybh;
	/**
	 * 楼宇名称
	 */
	private String lymc;
	/**
	 * 小区编号
	 */
	private String xqbh;
	/**
	 * 小区名称
	 */
	private String xqmc;
	/**
	 * 项目编码
	 */
	private String xmbm;
	/**
	 * 开发公司编号
	 */
	private String kfgsbm;
	/**
	 * 开发公司名称
	 */
	private String kfgsmc;
	/**
	 * 物业公司编号
	 */
	private String wygsbm;
	/**
	 * 物业公司名称
	 */
	private String wygsmc;
	/**
	 * 业委会编号
	 */
	private String ywhbh;
	/**
	 * 业委会名称
	 */
	private String ywhmc;
	/**
	 * 楼宇地址
	 */
	private String address;
	/**
	 * 房屋类型编号
	 */
	private String fwlxbm;
	/**
	 * 房屋类型名称
	 */
	private String fwlx;
	/**
	 * 房屋性质编号
	 */
	private String fwxzbm;
	/**
	 * 房屋性质名称
	 */
	private String fwxz;
	/**
	 * 楼宇结构编号
	 */
	private String lyjgbm;
	/**
	 * 楼宇结构名称
	 */
	private String lyjg;
	/**
	 * 归集中心编码
	 */
	private String unitCode;
	/**
	 * 归集中心
	 */
	private String unitName;
	/**
	 * 总建筑面积
	 */
	private String totalArea;
	/**
	 * 总造价
	 */
	private String totalCost;
	/**
	 * 拟定单价
	 */
	private String protocolPrice;
	/**
	 * 单元数
	 */
	private String unitNumber;
	/**
	 * 层数
	 */
	private String layerNumber;
	/**
	 * 房屋套数
	 */
	private String houseNumber;
	/**
	 * 使用年限
	 */
	private String useFixedYear;
	/**
	 * 竣工日期
	 */
	private String completionDate;
	/**
	 * 备用字段
	 */
	private String bldgbak;
	/**
	 * 江津楼宇编码
	 */
	private String bldgCode;
	/**
	 * 附件服务器文件名
	 */
	private String nFileName;
	/**
	 * 附件原文件名
	 */
	private String oFileName;
	
	public Building() {
		super();
		// TODO Auto-generated constructor stub
	}
	public Building(String lybh, String lymc) {
		super();
		this.lybh = lybh;
		this.lymc = lymc;
	}
	public Building(String xqbh,String xqmc,String lybh, String lymc) {
		super();
		this.xqbh = xqbh;
		this.xqmc = xqmc;
		this.lybh = lybh;
		this.lymc = lymc;
	}

	public String getLybh() {
		return lybh;
	}
	public void setLybh(String lybh) {
		this.lybh = lybh;
	}
	public String getLymc() {
		return lymc;
	}
	public void setLymc(String lymc) {
		this.lymc = lymc;
	}
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
	public String getXmbm() {
		return xmbm;
	}
	public void setXmbm(String xmbm) {
		this.xmbm = xmbm;
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
	public String getYwhbh() {
		return ywhbh;
	}
	public void setYwhbh(String ywhbh) {
		this.ywhbh = ywhbh;
	}
	public String getYwhmc() {
		return ywhmc;
	}
	public void setYwhmc(String ywhmc) {
		this.ywhmc = ywhmc;
	}
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	public String getFwlxbm() {
		return fwlxbm;
	}
	public void setFwlxbm(String fwlxbm) {
		this.fwlxbm = fwlxbm;
	}
	public String getFwlx() {
		return fwlx;
	}
	public void setFwlx(String fwlx) {
		this.fwlx = fwlx;
	}
	public String getFwxzbm() {
		return fwxzbm;
	}
	public void setFwxzbm(String fwxzbm) {
		this.fwxzbm = fwxzbm;
	}
	public String getFwxz() {
		return fwxz;
	}
	public void setFwxz(String fwxz) {
		this.fwxz = fwxz;
	}
	public String getLyjgbm() {
		return lyjgbm;
	}
	public void setLyjgbm(String lyjgbm) {
		this.lyjgbm = lyjgbm;
	}
	public String getLyjg() {
		return lyjg;
	}
	public void setLyjg(String lyjg) {
		this.lyjg = lyjg;
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
	public String getTotalArea() {
		return totalArea;
	}
	public void setTotalArea(String totalArea) {
		this.totalArea = totalArea;
	}
	public String getTotalCost() {
		return totalCost;
	}
	public void setTotalCost(String totalCost) {
		this.totalCost = totalCost;
	}
	public String getProtocolPrice() {
		return protocolPrice;
	}
	public void setProtocolPrice(String protocolPrice) {
		this.protocolPrice = protocolPrice;
	}
	public String getUnitNumber() {
		return unitNumber;
	}
	public void setUnitNumber(String unitNumber) {
		this.unitNumber = unitNumber;
	}
	public String getLayerNumber() {
		return layerNumber;
	}
	public void setLayerNumber(String layerNumber) {
		this.layerNumber = layerNumber;
	}
	public String getHouseNumber() {
		return houseNumber;
	}
	public void setHouseNumber(String houseNumber) {
		this.houseNumber = houseNumber;
	}
	public String getUseFixedYear() {
		return useFixedYear;
	}
	public void setUseFixedYear(String useFixedYear) {
		this.useFixedYear = useFixedYear;
	}
	public String getCompletionDate() {
		return completionDate;
	}
	public void setCompletionDate(String completionDate) {
		this.completionDate = completionDate;
	}
	public String getBldgbak() {
		return bldgbak;
	}
	public void setBldgbak(String bldgbak) {
		this.bldgbak = bldgbak;
	}
	public String getBldgCode() {
		return bldgCode;
	}
	public void setBldgCode(String bldgCode) {
		this.bldgCode = bldgCode;
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
	
	@Override
	public String toString() {
		return "Building [address=" + address + ", bldgCode=" + bldgCode
				+ ", bldgbak=" + bldgbak + ", completionDate=" + completionDate
				+ ", fwlx=" + fwlx + ", fwlxbm=" + fwlxbm + ", fwxz=" + fwxz
				+ ", fwxzbm=" + fwxzbm + ", houseNumber=" + houseNumber
				+ ", kfgsbm=" + kfgsbm + ", kfgsmc=" + kfgsmc
				+ ", layerNumber=" + layerNumber + ", lybh=" + lybh + ", lyjg="
				+ lyjg + ", lyjgbm=" + lyjgbm + ", lymc=" + lymc
				+ ", nFileName=" + nFileName + ", oFileName=" + oFileName
				+ ", protocolPrice=" + protocolPrice + ", totalArea="
				+ totalArea + ", totalCost=" + totalCost + ", unitCode="
				+ unitCode + ", unitName=" + unitName + ", unitNumber="
				+ unitNumber + ", useFixedYear=" + useFixedYear + ", wygsbm="
				+ wygsbm + ", wygsmc=" + wygsmc + ", xmbm=" + xmbm + ", xqbh="
				+ xqbh + ", xqmc=" + xqmc + ", ywhbh=" + ywhbh + ", ywhmc="
				+ ywhmc + "]";
	}
	
	public void clear() {
		//this.fwlxbm = null;
		this.fwlx = null;
		this.fwxzbm = null;
		this.fwxz = null;
		this.lyjgbm = null;
		this.lyjg = null;
		this.totalArea = null;
		this.totalCost = null;
		this.protocolPrice = null;
		this.unitNumber = null;
		this.layerNumber = null;
		this.houseNumber = null;
		this.useFixedYear = null;
		this.completionDate = null;
		this.bldgbak = null;
		this.bldgCode = null;
		this.nFileName = null;
		this.oFileName = null;
	}
}

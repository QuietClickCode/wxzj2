package com.yaltec.wxzj2.biz.payment.entity;

import com.yaltec.comon.core.entity.Entity;

/**
 * 单位房屋上报导入
 * @ClassName: HousedwImport 
 * @author 重庆亚亮科技有限公司 txj 
 * @date 2016-8-26 上午11:20:13
 */
public class HousedwImport extends Entity {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;	
	private String h001;
	private String lymc;
	private String h013;
	private String h002;
	private String h003;
	private String h005;
	private String h006;
	private String h0231;
	private String h021;
	private String h030;
	private String h019;
	private String h015;
	private String h010;
	private String h011;
	private String h017;
	private String h020;
	private String h022;
	private String h031;
	private String h041;
	private String h044;
	
	private String w003;//业务日期
	private String unitCode;//归集中心
	private String unitName;
	private String tempCode;//临时编号
	private String xqbh;
	private String lybh;
	private String userid;
	private String username;
	private String lydz;
	private String w008;
	private String result;
	private String h009;/*单价-0*/ 
	private String h012;/*房屋性质-空*/
	private String h018;/*房屋类型-空*/
	private String h045;/*房屋用途-空*/
	private String h016;/*产权证号-空*/
	private String h023;/*交存标准-空*/
	private String sjje;
	private String ljje;/*累计金额*/
	private String zqje;/*支取金额*/
	private String status;
	private String kfgsbm;
	private String kfgsmc;
	private String lyaddress;

	private String zhs;//总户数
	private String zmj;//总面积
	private String zjk;//
	private Integer row;//
	private String h052;
	private String h053;
	private String color;//房屋重复：蓝色；交款重复：红色。
	
	public HousedwImport() {
		
	}
	
	public HousedwImport(int row) {
		this.row = row;
	}

	public String getColor() {
		return color;
	}
	public void setColor(String color) {
		this.color = color;
	}
	public String getH001() {
		return h001;
	}
	public void setH001(String h001) {
		this.h001 = h001;
	}
	public String getLymc() {
		return lymc;
	}
	public void setLymc(String lymc) {
		this.lymc = lymc;
	}
	public String getH013() {
		return h013;
	}
	public void setH013(String h013) {
		this.h013 = h013;
	}
	public String getH002() {
		return h002;
	}
	public void setH002(String h002) {
		this.h002 = h002;
	}
	public String getH003() {
		return h003;
	}
	public void setH003(String h003) {
		this.h003 = h003;
	}
	public String getH005() {
		return h005;
	}
	public void setH005(String h005) {
		this.h005 = h005;
	}
	public String getH006() {
		return h006;
	}
	public void setH006(String h006) {
		this.h006 = h006;
	}
	public String getH0231() {
		return h0231;
	}
	public void setH0231(String h0231) {
		this.h0231 = h0231;
	}
	public String getH021() {
		return h021;
	}
	public void setH021(String h021) {
		this.h021 = h021;
	}
	public String getH030() {
		return h030;
	}
	public void setH030(String h030) {
		this.h030 = h030;
	}
	public String getH019() {
		return h019;
	}
	public void setH019(String h019) {
		this.h019 = h019;
	}
	public String getH015() {
		return h015;
	}
	public void setH015(String h015) {
		this.h015 = h015;
	}
	public String getH010() {
		return h010;
	}
	public void setH010(String h010) {
		this.h010 = h010;
	}
	public String getH011() {
		return h011;
	}
	public void setH011(String h011) {
		this.h011 = h011;
	}
	public String getH017() {
		return h017;
	}
	public void setH017(String h017) {
		this.h017 = h017;
	}
	public String getH020() {
		return h020;
	}
	public void setH020(String h020) {
		this.h020 = h020;
	}
	public String getH022() {
		return h022;
	}
	public void setH022(String h022) {
		this.h022 = h022;
	}
	public String getH031() {
		return h031;
	}
	public void setH031(String h031) {
		this.h031 = h031;
	}
	public String getH041() {
		return h041;
	}
	public void setH041(String h041) {
		this.h041 = h041;
	}
	public String getH044() {
		return h044;
	}
	public void setH044(String h044) {
		this.h044 = h044;
	}
	public String getW003() {
		return w003;
	}
	public void setW003(String w003) {
		this.w003 = w003;
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
	public String getTempCode() {
		return tempCode;
	}
	public void setTempCode(String tempCode) {
		this.tempCode = tempCode;
	}
	public String getXqbh() {
		return xqbh;
	}
	public void setXqbh(String xqbh) {
		this.xqbh = xqbh;
	}
	public String getLybh() {
		return lybh;
	}
	public void setLybh(String lybh) {
		this.lybh = lybh;
	}
	public String getUserid() {
		return userid;
	}
	public void setUserid(String userid) {
		this.userid = userid;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getLydz() {
		return lydz;
	}
	public void setLydz(String lydz) {
		this.lydz = lydz;
	}
	public String getW008() {
		return w008;
	}
	public void setW008(String w008) {
		this.w008 = w008;
	}
	public String getResult() {
		return result;
	}
	public void setResult(String result) {
		this.result = result;
	}
	public String getH009() {
		return h009==null?"0":h009;
	}
	public void setH009(String h009) {
		this.h009 = h009;
	}
	public String getH012() {
		return h012==null?"":h012;
	}
	public void setH012(String h012) {
		this.h012 = h012;
	}
	public String getH018() {
		return h018==null?"":h018;
	}
	public void setH018(String h018) {
		this.h018 = h018;
	}
	public String getH045() {
		return h045==null?"":h045;
	}
	public void setH045(String h045) {
		this.h045 = h045;
	}
	public String getH016() {
		return h016==null?"":h016;
	}
	public void setH016(String h016) {
		this.h016 = h016;
	}
	public String getH023() {
		return h023==null?"":h023;
	}
	public void setH023(String h023) {
		this.h023 = h023;
	}
	public String getSjje() {
		return sjje;
	}
	public void setSjje(String sjje) {
		this.sjje = sjje;
	}
	public String getLjje() {
		return ljje;
	}
	public void setLjje(String ljje) {
		this.ljje = ljje;
	}
	public String getZqje() {
		return zqje;
	}
	public void setZqje(String zqje) {
		this.zqje = zqje;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
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
	public String getLyaddress() {
		return lyaddress;
	}
	public void setLyaddress(String lyaddress) {
		this.lyaddress = lyaddress;
	}
	public String getZhs() {
		return zhs;
	}
	public void setZhs(String zhs) {
		this.zhs = zhs;
	}
	public String getZmj() {
		return zmj;
	}
	public void setZmj(String zmj) {
		this.zmj = zmj;
	}
	public String getZjk() {
		return zjk;
	}
	public void setZjk(String zjk) {
		this.zjk = zjk;
	}
	public Integer getRow() {
		return row;
	}
	public void setRow(Integer row) {
		this.row = row;
	}
	public String getH052() {
		return h052;
	}
	public void setH052(String h052) {
		this.h052 = h052;
	}
	public String getH053() {
		return h053;
	}
	public void setH053(String h053) {
		this.h053 = h053;
	}
	@Override
	public String toString() {
		return "HousedwImport [color=" + color + ", h001=" + h001 + ", h002="
				+ h002 + ", h003=" + h003 + ", h005=" + h005 + ", h006=" + h006
				+ ", h009=" + h009 + ", h010=" + h010 + ", h011=" + h011
				+ ", h012=" + h012 + ", h013=" + h013 + ", h015=" + h015
				+ ", h016=" + h016 + ", h017=" + h017 + ", h018=" + h018
				+ ", h019=" + h019 + ", h020=" + h020 + ", h021=" + h021
				+ ", h022=" + h022 + ", h023=" + h023 + ", h0231=" + h0231
				+ ", h030=" + h030 + ", h031=" + h031 + ", h041=" + h041
				+ ", h044=" + h044 + ", h045=" + h045 + ", h052=" + h052
				+ ", h053=" + h053 + ", kfgsbm=" + kfgsbm + ", kfgsmc="
				+ kfgsmc + ", ljje=" + ljje + ", lyaddress=" + lyaddress
				+ ", lybh=" + lybh + ", lydz=" + lydz + ", lymc=" + lymc
				+ ", result=" + result + ", row=" + row + ", sjje=" + sjje
				+ ", status=" + status + ", tempCode=" + tempCode
				+ ", unitCode=" + unitCode + ", unitName=" + unitName
				+ ", userid=" + userid + ", username=" + username + ", w003="
				+ w003 + ", w008=" + w008 + ", xqbh=" + xqbh + ", zhs=" + zhs
				+ ", zjk=" + zjk + ", zmj=" + zmj + ", zqje=" + zqje + "]";
	}
	
}

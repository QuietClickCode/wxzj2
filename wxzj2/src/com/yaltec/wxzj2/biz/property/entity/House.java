package com.yaltec.wxzj2.biz.property.entity;

import com.yaltec.comon.core.entity.Entity;
import com.yaltec.comon.utils.JsonUtil;
import com.yaltec.comon.utils.StringUtil;

/**
 * 
 * @ClassName: House
 * @Description: TODO房屋实体类
 * 
 * @author yangshanping
 * @date 2016-7-25 上午09:11:43
 */
public class House extends Entity {
	/**
	 * 序列化版本标示.
	 */
	private static final long serialVersionUID = 1L;
	/**
	 * 房屋编号
	 */
	private String h001;
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
	 * 单元
	 */
	private String h002;
	/**
	 * 层
	 */
	private String h003;
	/**
	 * 是否开卡
	 */
	private String h004;
	/**
	 * 房号
	 */
	private String h005;
	/**
	 * 建筑面积
	 */
	private String h006;
	/**
	 * 使用面积
	 */
	private String h007;
	/**
	 * 公摊面积
	 */
	private String h008;
	/**
	 * 单价
	 */
	private String h009;
	/**
	 * 房款
	 */
	private String h010;
	/**
	 * 房屋性质编号
	 */
	private String h011;
	/**
	 * 房屋性质
	 */
	private String h012;
	/**
	 * 业主姓名
	 */
	private String h013;
	/**
	 * 产权单位
	 */
	private String h014;
	/**
	 * 身份证号
	 */
	private String h015;
	/**
	 * 产权证号
	 */
	private String h016;
	/**
	 * 房屋类型编号
	 */
	private String h017;
	/**
	 * 房屋类型
	 */
	private String h018;
	/**
	 * 联系电话
	 */
	private String h019;
	/**
	 * 首交日期
	 */
	private String h020;
	/**
	 * 应交资金
	 */
	private String h021;
	/**
	 * 交存标准编号
	 */
	private String h022;
	/**
	 * 交存标准
	 */
	private String h023;
	/**
	 * 年初本金
	 */
	private String h024;
	/**
	 * 年初利息
	 */
	private String h025;
	/**
	 * 本年发生额
	 */
	private String h026;
	/**
	 * 首次本金
	 */
	private String h027;
	/**
	 * 支取本金
	 */
	private String h028;
	/**
	 * 支取利息
	 */
	private String h029;
	/**
	 * 本金余额
	 */
	private String h030;
	/**
	 * 利息余额
	 */
	private String h031;
	/**
	 * 房屋户型编号
	 */
	private String h032;
	/**
	 * 房屋户型
	 */
	private String h033;
	/**
	 * 本年利息
	 */
	private String h034;
	/**
	 * 房屋状态
	 */
	private String h035;
	/**
	 * 备用编码
	 */
	private String h036;
	/**
	 * 备用名称
	 */
	private String h037;
	/**
	 * 备用金额
	 */
	private String h038;
	/**
	 * 应交额
	 */
	private String h039;
	/**
	 * 资金卡号
	 */
	private String h040;
	/**
	 * 累计本金
	 */
	private String h041;
	/**
	 * 累计利息
	 */
	private String h042;
	/**
	 * 业主利率
	 */
	private String h043;
	/**
	 * 房屋用途编号
	 */
	private String h044;
	/**
	 * 房屋用途
	 */
	private String h045;
	/**
	 * 最近利息
	 */
	private String h046;
	/**
	 * 用户名
	 */
	private String userid;
	/**
	 * 用户真实姓名
	 */
	private String userName;
	/**
	 * 备用字段
	 */
	private String h001cq;
	/**
	 * 江津房屋编号
	 */
	private String houseCode;
	/**
	 * 房屋地址
	 */
	private String h047;
	/**
	 * 备用字段
	 */
	private String h048;
	/**
	 * 归集中心编码
	 */
	private String h049;
	/**
	 * 归集中心
	 */
	private String h050;
	/**
	 * 备用字段
	 */
	private String h051;
	/**
	 * 备用字段
	 */
	private String h052;
	/**
	 * 备用字段
	 */
	private String h053;
	/**
	 * 备用字段
	 */
	private String h054;
	/**
	 * 备用字段
	 */
	private String h055;
	/**
	 * 房屋编号（对应house）
	 */
	private String h001_house;
	/**
	 * 交款状态
	 */
	private String status;
	/**
	 * 备用字段
	 */
	private String h099;

	/**
	 * 房屋地址
	 */
	private String address;

	private String sjje;
	private String qjje;
	private String h0301;

	/**
	 * 不动产权号
	 */
	private String unchange;

	public String getH001() {
		return h001;
	}

	public void setH001(String h001) {
		this.h001 = h001;
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

	public String getXmbm() {
		return xmbm;
	}

	public void setXmbm(String xmbm) {
		this.xmbm = xmbm;
	}

	public String getXqmc() {
		return xqmc;
	}

	public void setXqmc(String xqmc) {
		this.xqmc = xqmc;
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

	public String getH004() {
		return h004;
	}

	public void setH004(String h004) {
		this.h004 = h004;
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

	public String getH007() {
		return h007;
	}

	public void setH007(String h007) {
		this.h007 = h007;
	}

	public String getH008() {
		return h008;
	}

	public void setH008(String h008) {
		this.h008 = h008;
	}

	public String getH009() {
		return h009;
	}

	public void setH009(String h009) {
		this.h009 = h009;
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

	public String getH012() {
		return h012;
	}

	public void setH012(String h012) {
		this.h012 = h012;
	}

	public String getH013() {
		return h013;
	}

	public void setH013(String h013) {
		this.h013 = h013;
	}

	public String getH014() {
		return h014;
	}

	public void setH014(String h014) {
		this.h014 = h014;
	}

	public String getH015() {
		return h015;
	}

	public void setH015(String h015) {
		this.h015 = h015;
	}

	public String getH016() {
		return h016;
	}

	public void setH016(String h016) {
		this.h016 = h016;
	}

	public String getH017() {
		return h017;
	}

	public void setH017(String h017) {
		this.h017 = h017;
	}

	public String getH018() {
		return h018;
	}

	public void setH018(String h018) {
		this.h018 = h018;
	}

	public String getH019() {
		return h019;
	}

	public void setH019(String h019) {
		this.h019 = h019;
	}

	public String getH020() {
		return h020;
	}

	public void setH020(String h020) {
		this.h020 = h020;
	}

	public String getH021() {
		return h021;
	}

	public void setH021(String h021) {
		this.h021 = h021;
	}

	public String getH022() {
		return h022;
	}

	public void setH022(String h022) {
		this.h022 = h022;
	}

	public String getH023() {
		return h023;
	}

	public void setH023(String h023) {
		this.h023 = h023;
	}

	public String getH024() {
		return h024;
	}

	public void setH024(String h024) {
		this.h024 = h024;
	}

	public String getH025() {
		return h025;
	}

	public void setH025(String h025) {
		this.h025 = h025;
	}

	public String getH026() {
		return h026;
	}

	public void setH026(String h026) {
		this.h026 = h026;
	}

	public String getH027() {
		return h027;
	}

	public void setH027(String h027) {
		this.h027 = h027;
	}

	public String getH028() {
		return h028;
	}

	public void setH028(String h028) {
		this.h028 = h028;
	}

	public String getH029() {
		return h029;
	}

	public void setH029(String h029) {
		this.h029 = h029;
	}

	public String getH030() {
		return h030;
	}

	public void setH030(String h030) {
		this.h030 = h030;
	}

	public String getH031() {
		return h031;
	}

	public void setH031(String h031) {
		this.h031 = h031;
	}

	public String getH032() {
		return h032;
	}

	public void setH032(String h032) {
		this.h032 = h032;
	}

	public String getH033() {
		return h033;
	}

	public void setH033(String h033) {
		this.h033 = h033;
	}

	public String getH034() {
		return h034;
	}

	public void setH034(String h034) {
		this.h034 = h034;
	}

	public String getH035() {
		return h035;
	}

	public void setH035(String h035) {
		this.h035 = h035;
	}

	public String getH036() {
		return h036;
	}

	public void setH036(String h036) {
		this.h036 = h036;
	}

	public String getH037() {
		return h037;
	}

	public void setH037(String h037) {
		this.h037 = h037;
	}

	public String getH038() {
		return h038;
	}

	public void setH038(String h038) {
		this.h038 = h038;
	}

	public String getH039() {
		return h039;
	}

	public void setH039(String h039) {
		this.h039 = h039;
	}

	public String getH040() {
		return h040;
	}

	public void setH040(String h040) {
		this.h040 = h040;
	}

	public String getH041() {
		return h041;
	}

	public void setH041(String h041) {
		this.h041 = h041;
	}

	public String getH042() {
		return h042;
	}

	public void setH042(String h042) {
		this.h042 = h042;
	}

	public String getH043() {
		return h043;
	}

	public void setH043(String h043) {
		this.h043 = h043;
	}

	public String getH044() {
		return h044;
	}

	public void setH044(String h044) {
		this.h044 = h044;
	}

	public String getH045() {
		return h045;
	}

	public void setH045(String h045) {
		this.h045 = h045;
	}

	public String getH046() {
		return h046;
	}

	public void setH046(String h046) {
		this.h046 = h046;
	}

	public String getUserid() {
		return userid;
	}

	public void setUserid(String userid) {
		this.userid = userid;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getH001cq() {
		return h001cq;
	}

	public void setH001cq(String h001cq) {
		this.h001cq = h001cq;
	}

	public String getHouseCode() {
		return houseCode;
	}

	public void setHouseCode(String houseCode) {
		this.houseCode = houseCode;
	}

	public String getH047() {
		return h047;
	}

	public void setH047(String h047) {
		this.h047 = h047;
	}

	public String getH048() {
		return h048;
	}

	public void setH048(String h048) {
		this.h048 = h048;
	}

	public String getH049() {
		return h049;
	}

	public void setH049(String h049) {
		this.h049 = h049;
	}

	public String getH050() {
		return h050;
	}

	public void setH050(String h050) {
		this.h050 = h050;
	}

	public String getH051() {
		return h051;
	}

	public void setH051(String h051) {
		this.h051 = h051;
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

	public String getH054() {
		return h054;
	}

	public void setH054(String h054) {
		this.h054 = h054;
	}

	public String getH055() {
		return h055;
	}

	public void setH055(String h055) {
		this.h055 = h055;
	}

	public String getH001_house() {
		return h001_house;
	}

	public void setH001_house(String h001House) {
		h001_house = h001House;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getH099() {
		return h099;
	}

	public void setH099(String h099) {
		this.h099 = h099;
	}

	public String getAddress() {
		if (StringUtil.isBlank(address)) {
			return lymc + " " + h002 + "单元" + h003 + "层" + h005 + "房号";
		}
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getSjje() {
		return sjje;
	}

	public void setSjje(String sjje) {
		this.sjje = sjje;
	}

	public String getQjje() {
		return qjje;
	}

	public void setQjje(String qjje) {
		this.qjje = qjje;
	}

	public String getH0301() {
		return h0301;
	}

	public void setH0301(String h0301) {
		this.h0301 = h0301;
	}

	public String getUnchange() {
		return unchange;
	}

	public void setUnchange(String unchange) {
		this.unchange = unchange;
	}

	@Override
	public String toString() {
		return JsonUtil.toJson(this);
	}

}

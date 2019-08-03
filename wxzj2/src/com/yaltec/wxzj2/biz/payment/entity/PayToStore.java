package com.yaltec.wxzj2.biz.payment.entity;

import com.yaltec.comon.core.entity.Entity;
/**
 * 交款实体表
 * @ClassName: SordinePayToStore 
 * @author 重庆亚亮科技有限公司 txj 
 * @date 2016-7-22 下午04:08:14
 */
public class PayToStore extends Entity {
	/**
	 * 序列化版本标示.
	 */
	private static final long serialVersionUID = 1L;
	/**
	 * 实体编号
	 */
	private String tbid;
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
	 * 归集中心编码
	 */
	private String unitcode;
	/**
	 * 归集中心名称
	 */
	private String unitname;
	/**
	 * 银行编号
	 */
	private String yhbh;
	/**
	 * 银行名称
	 */
	private String yhmc;
	/**
	 * 业务流水号
	 */
	private String serialno;
	/**
	 * pos唯一号
	 */
	private String posno;
	/**
	 * 登记人id
	 */
	private String userid;
	/**
	 * 登记人
	 */
	private String username;
	/**
	 * 交款摘要编码
	 */
	private String w001;
	/**
	 * 交款摘要
	 */
	private String w002;
	/**
	 * 财务日期
	 */
	private String w003;
	/**
	 *  交款本金
	 */
	private String w004;
	/**
	 * 交款利息
	 */
	private String w005;
	/**
	 * 交款本息和
	 */
	private String w006;
	/**
	 * 凭证编号
	 */
	private String w007;
	/**
	 * 业务编号
	 */
	private String w008;
	/**
	 * 英文摘要编码
	 */
	private String w009;
	/**
	 * 英文摘要
	 */
	private String w010;
	/**
	 * 票据号
	 */
	private String w011;
	/**
	 * 业主名称
	 */
	private String w012;
	/**
	 * 业务日期
	 */
	private String w013;
	/**
	 * 到账日期
	 */
	private String w014;
	/**
	 * 起息日期
	 */
	private String w015;
	
	private String w016;
	private String w017;
	private String w018;
	private String w019;
	private String w020;
	private String flag;
	/**
	 * 年度
	 */
	private String regNo;	
	private String h040;
	private String result;
	
	
	public String getResult() {
		return result;
	}
	public void setResult(String result) {
		this.result = result;
	}
	public String getH040() {
		return h040;
	}
	public void setH040(String h040) {
		this.h040 = h040;
	}
	public String getTbid() {
		return tbid;
	}
	public void setTbid(String tbid) {
		this.tbid = tbid;
	}
	public String getH001() {
		return h001;
	}
	public void setH001(String h001) {
		this.h001 = h001==null?"":h001;
	}
	public String getLybh() {
		return lybh;
	}
	public void setLybh(String lybh) {
		this.lybh = lybh==null?"":lybh;
	}
	public String getLymc() {
		return lymc;
	}
	public void setLymc(String lymc) {
		this.lymc = lymc;
	}
	public String getUnitcode() {
		return unitcode;
	}
	public void setUnitcode(String unitcode) {
		this.unitcode = unitcode;
	}
	public String getUnitname() {
		return unitname;
	}
	public void setUnitname(String unitname) {
		this.unitname = unitname;
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
	public String getSerialno() {
		return serialno==null?"":serialno;
	}
	public void setSerialno(String serialno) {
		this.serialno = serialno;
	}
	public String getPosno() {
		return posno==null?"":posno;
	}
	public void setPosno(String posno) {
		this.posno = posno;
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
	public String getW001() {
		return w001;
	}
	public void setW001(String w001) {
		this.w001 = w001;
	}
	public String getW002() {
		return w002;
	}
	public void setW002(String w002) {
		this.w002 = w002;
	}
	public String getW003() {
		return w003;
	}
	public void setW003(String w003) {
		this.w003 = w003;
	}
	public String getW004() {
		return w004;
	}
	public void setW004(String w004) {
		this.w004 = w004;
	}
	public String getW005() {
		return w005;
	}
	public void setW005(String w005) {
		this.w005 = w005;
	}
	public String getW006() {
		return w006;
	}
	public void setW006(String w006) {
		this.w006 = w006;
	}
	public String getW007() {
		return w007;
	}
	public void setW007(String w007) {
		this.w007 = w007;
	}
	public String getW008() {
		return w008==null?"":w008;
	}
	public void setW008(String w008) {
		this.w008 = w008;
	}
	public String getW009() {
		return w009;
	}
	public void setW009(String w009) {
		this.w009 = w009;
	}
	public String getW010() {
		return w010;
	}
	public void setW010(String w010) {
		this.w010 = w010;
	}
	public String getW011() {
		return w011==null?"":w011;
	}
	public void setW011(String w011) {
		this.w011 = w011;
	}
	public String getW012() {
		return w012;
	}
	public void setW012(String w012) {
		this.w012 = w012;
	}
	public String getW013() {
		return w013;
	}
	public void setW013(String w013) {
		this.w013 = w013;
	}
	public String getW014() {
		return w014;
	}
	public void setW014(String w014) {
		this.w014 = w014;
	}
	public String getW015() {
		return w015;
	}
	public void setW015(String w015) {
		this.w015 = w015;
	}
	public String getW016() {
		return w016;
	}
	public void setW016(String w016) {
		this.w016 = w016;
	}
	public String getW017() {
		return w017;
	}
	public void setW017(String w017) {
		this.w017 = w017;
	}
	public String getW018() {
		return w018;
	}
	public void setW018(String w018) {
		this.w018 = w018;
	}
	public String getW019() {
		return w019;
	}
	public void setW019(String w019) {
		this.w019 = w019;
	}
	public String getW020() {
		return w020;
	}
	public void setW020(String w020) {
		this.w020 = w020;
	}
	public String getFlag() {
		return flag;
	}
	public void setFlag(String flag) {
		this.flag = flag;
	}
	public String getRegNo() {
		return regNo;
	}
	public void setRegNo(String regNo) {
		this.regNo = regNo;
	}
	@Override
	public String toString() {
		return "PayToStore [flag=" + flag + ", h001=" + h001 + ", h040=" + h040
				+ ", lybh=" + lybh + ", lymc=" + lymc + ", posno=" + posno
				+ ", regNo=" + regNo + ", result=" + result + ", serialno="
				+ serialno + ", tbid=" + tbid + ", unitcode=" + unitcode
				+ ", unitname=" + unitname + ", userid=" + userid
				+ ", username=" + username + ", w001=" + w001 + ", w002="
				+ w002 + ", w003=" + w003 + ", w004=" + w004 + ", w005=" + w005
				+ ", w006=" + w006 + ", w007=" + w007 + ", w008=" + w008
				+ ", w009=" + w009 + ", w010=" + w010 + ", w011=" + w011
				+ ", w012=" + w012 + ", w013=" + w013 + ", w014=" + w014
				+ ", w015=" + w015 + ", w016=" + w016 + ", w017=" + w017
				+ ", w018=" + w018 + ", w019=" + w019 + ", w020=" + w020
				+ ", yhbh=" + yhbh + ", yhmc=" + yhmc + "]";
	}
	
}

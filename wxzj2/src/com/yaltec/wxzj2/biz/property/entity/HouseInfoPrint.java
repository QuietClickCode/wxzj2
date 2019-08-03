package com.yaltec.wxzj2.biz.property.entity;

/**
 * <p>
 * 文件名称: HouseInfoPrint.java
 * </p>
 * <p>
 * 文件描述: 单位房屋上报打印房屋信息
 * </p>
 * <p>
 * 版权所有: 版权所有(C)2010
 * </p>
 * <p>
 * 公 司: yaltec
 * </p>
 * <p>
 * 内容摘要:
 * </p>
 * <p>
 * 其他说明:
 * </p>
 * <p>
 * 完成日期：Oct 23, 2012
 * </p>
 * <p>
 * 修改记录0：无
 * </p>
 * 
 * @version 1.0
 * @author jiangyong
 */
public class HouseInfoPrint {
	private String h001;
	private String h002;
	private String h003;
	private String h005;
	private String h006;
	private String h013;
	private String h015;
	private String h020;
	private String h021;
	private String h026;
	private Double h028;
	private Double h029;
	private String h030;
	private String h031;
	private String lymc;
	private Double h041;
	private Double h042;
	private String h050;
	private String h047;
	private String bankno;
	private String k022;
	private String xs;
	private String xm;
	private String today;
	private String yhmc;
	
	public String getH013() {
		return h013;
	}
	public void setH013(String h013) {
		this.h013 = h013;
	}
	public String getH015() {
		return h015;
	}
	public void setH015(String h015) {
		this.h015 = h015;
	}
	public String getLymc() {
		return lymc;
	}
	public void setLymc(String lymc) {
		this.lymc = lymc;
	}
	public String getH050() {
		return h050;
	}
	public void setH050(String h050) {
		this.h050 = h050;
	}
	public String getH047() {
		return h047;
	}
	public void setH047(String h047) {
		this.h047 = h047;
	}
	public String getH006() {
		return h006;
	}
	public void setH006(String h006) {
		this.h006 = h006;
	}
	public String getH021() {
		return h021;
	}
	public void setH021(String h021) {
		this.h021 = h021;
	}
	public String getBankno() {
		return bankno;
	}
	public void setBankno(String bankno) {
		this.bankno = bankno;
	}
	public String getK022() {
		return k022;
	}
	public void setK022(String k022) {
		this.k022 = k022;
	}
	public String getXs() {
		if (!xs.equals("")) {
			if (Double.valueOf(xs) < 0) {
				xs = Double.valueOf(xs).toString()+"%";
			}
		}
		return xs;
	}
	public void setXs(String xs) {
		this.xs = xs;
	}
	public String getXm() {
		return xm;
	}
	public void setXm(String xm) {
		this.xm = xm;
	}
	public String getToday() {
		return today;
	}
	public void setToday(String today) {
		this.today = today;
	}
	public String getH001() {
		return h001;
	}
	public void setH001(String h001) {
		this.h001 = h001;
	}
	public String getYhmc() {
		return yhmc;
	}
	public void setYhmc(String yhmc) {
		this.yhmc = yhmc;
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
	public String getH020() {
		return h020;
	}
	public void setH020(String h020) {
		this.h020 = h020;
	}
	public String getH026() {
		return h026;
	}
	public void setH026(String h026) {
		this.h026 = h026;
	}
	public String getH030() {
		return h030;
	}
	public void setH030(String h030) {
		this.h030 = h030;
	}
	public Double getH028() {
		return h028;
	}
	public void setH028(Double h028) {
		this.h028 = h028;
	}
	public Double getH029() {
		return h029;
	}
	public void setH029(Double h029) {
		this.h029 = h029;
	}
	public Double getH041() {
		return h041;
	}
	public void setH041(Double h041) {
		this.h041 = h041;
	}
	public Double getH042() {
		return h042;
	}
	public void setH042(Double h042) {
		this.h042 = h042;
	}
	public String getH031() {
		return h031;
	}
	public void setH031(String h031) {
		this.h031 = h031;
	}
	
}

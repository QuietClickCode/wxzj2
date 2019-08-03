package com.yaltec.wxzj2.biz.property.entity;

import com.yaltec.comon.core.entity.Entity;

/**
 * 单位房屋上报打印通知书
 * 
 * @ClassName: HouseUnitPrint
 * @author 重庆亚亮科技有限公司 txj
 * @date 2016-9-2 下午03:39:07
 */
public class HouseUnitPrint extends Entity {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String h001;
	private String h002;
	private String h003;
	private String h005;
	private String h013;
	private String h015;
	private String lymc;
	private String h050;
	private String h047;
	private String h006;
	private String h021;
	private String bankno;
	private String k022;
	private String xs;
	private String xm;
	private String today;
	private String yhmc;

	public String getH001() {
		return h001;
	}

	public void setH001(String h001) {
		this.h001 = h001;
	}

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
				xs = Double.valueOf(xs).toString() + "%";
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

	@Override
	public String toString() {
		return "HouseUnitPrint [bankno=" + bankno + ", h001=" + h001
				+ ", h006=" + h006 + ", h013=" + h013 + ", h015=" + h015
				+ ", h021=" + h021 + ", h047=" + h047 + ", h050=" + h050
				+ ", k022=" + k022 + ", lymc=" + lymc + ", today=" + today
				+ ", xm=" + xm + ", xs=" + xs + ", yhmc=" + yhmc + "]";
	}
}

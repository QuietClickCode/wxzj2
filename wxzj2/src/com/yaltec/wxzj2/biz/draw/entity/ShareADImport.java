package com.yaltec.wxzj2.biz.draw.entity;

/**
 * @author Administrator
 *
 */
public class ShareADImport {
	/**
	 * <p>
	 * 文件名称: shareAD.java
	 * </p>
	 * <p>
	 * 文件描述: 维修支取资金分摊
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
	 * 完成日期：Feb 17, 2011
	 * </p>
	 * <p>
	 * 修改记录0：无
	 * </p>
	 * 
	 * @version 1.0
	 * @author jiangyong
	 */
	private String h001;
	private String bm;
	private String lybh;
	private String lymc;
	private String xqbh;
	private String xqmc;
	private String xmbh;
	private String xmmc;
	private String h002;
	private String h003;
	private String h005;
	private String h013;
	private String h006;
	private String h015;
	private String ftje;
	private String zqbj;
	private String zqlx;
	private String zcje;
	private String h030;
	private String h031;
	private String bjye;
	private String lxye;
	private Double pzje;
	private Double bcpzje;
	private String ftsj;
	private String isred;
	private String userid;
	private String username;
	private String z003;
	
	//公共设施收益分摊
	private String h020;
	private String h016;
	private Double h010;
	private String h021;
	private String h023;
	private Integer row;
	private String bl;
	public String getH001() {
		return h001;
	}
	public void setH001(String h001) {
		this.h001 = h001;
	}
	public String getBm() {
		return bm;
	}
	public void setBm(String bm) {
		this.bm = bm;
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
	public String getXmbh() {
		return xmbh;
	}
	public void setXmbh(String xmbh) {
		this.xmbh = xmbh;
	}
	public String getXmmc() {
		return xmmc;
	}
	public void setXmmc(String xmmc) {
		this.xmmc = xmmc;
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
	public String getH013() {
		return h013;
	}
	public void setH013(String h013) {
		this.h013 = h013;
	}
	public String getH006() {
		return h006;
	}
	public void setH006(String h006) {
		this.h006 = h006;
	}
	public String getH015() {
		return h015;
	}
	public void setH015(String h015) {
		this.h015 = h015;
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
	
	public String getBjye() {
		return bjye;
	}
	public void setBjye(String bjye) {
		this.bjye = bjye;
	}
	public String getLxye() {
		return lxye;
	}
	public void setLxye(String lxye) {
		this.lxye = lxye;
	}
	public Double getPzje() {
		return pzje;
	}
	public void setPzje(Double pzje) {
		this.pzje = pzje;
	}
	public Double getBcpzje() {
		return bcpzje;
	}
	public void setBcpzje(Double bcpzje) {
		this.bcpzje = bcpzje;
	}
	public String getFtsj() {
		return ftsj;
	}
	public void setFtsj(String ftsj) {
		this.ftsj = ftsj;
	}
	public String getIsred() {
		return isred;
	}
	public void setIsred(String isred) {
		this.isred = isred;
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
	public String getZ003() {
		return z003;
	}
	public void setZ003(String z003) {
		this.z003 = z003;
	}
	public String getH020() {
		return h020;
	}
	public void setH020(String h020) {
		this.h020 = h020;
	}
	public String getH016() {
		return h016;
	}
	public void setH016(String h016) {
		this.h016 = h016;
	}
	public Double getH010() {
		return h010;
	}
	public void setH010(Double h010) {
		this.h010 = h010;
	}
	public String getH021() {
		return h021;
	}
	public void setH021(String h021) {
		if (h021 == null || h021.equals("")) {
			this.h021 = "0";
		} else {
			this.h021 = h021;
		}
	}
	public String getH023() {
		return h023;
	}
	public void setH023(String h023) {
		if (h023 == null) {
			this.h023 = "";
		} else {
			this.h023 = h023;
		}
	}
	public Integer getRow() {
		return row;
	}
	public void setRow(Integer row) {
		this.row = row;
	}
	public String getBl() {
		return bl;
	}
	public void setBl(String bl) {
		this.bl = bl;
	}
	public String getFtje() {
		return ftje;
	}
	public void setFtje(String ftje) {
		this.ftje = ftje;
	}
	public String getZqbj() {
		return zqbj;
	}
	public void setZqbj(String zqbj) {
		this.zqbj = zqbj;
	}
	public String getZqlx() {
		return zqlx;
	}
	public void setZqlx(String zqlx) {
		this.zqlx = zqlx;
	}
	public String getZcje() {
		return zcje;
	}
	public void setZcje(String zcje) {
		this.zcje = zcje;
	}
	@Override
	public String toString() {
		return "ShareADImport [bcpzje=" + bcpzje + ", bjye=" + bjye + ", bl="
				+ bl + ", bm=" + bm + ", ftje=" + ftje + ", ftsj=" + ftsj
				+ ", h001=" + h001 + ", h002=" + h002 + ", h003=" + h003
				+ ", h005=" + h005 + ", h006=" + h006 + ", h010=" + h010
				+ ", h013=" + h013 + ", h015=" + h015 + ", h016=" + h016
				+ ", h020=" + h020 + ", h021=" + h021 + ", h023=" + h023
				+ ", h030=" + h030 + ", h031=" + h031 + ", isred=" + isred
				+ ", lxye=" + lxye + ", lybh=" + lybh + ", lymc=" + lymc
				+ ", pzje=" + pzje + ", row=" + row + ", userid=" + userid
				+ ", username=" + username + ", xmbh=" + xmbh + ", xmmc="
				+ xmmc + ", xqbh=" + xqbh + ", xqmc=" + xqmc + ", z003=" + z003
				+ ", zcje=" + zcje + ", zqbj=" + zqbj + ", zqlx=" + zqlx + "]";
	}
	
}

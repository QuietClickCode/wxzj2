package com.yaltec.wxzj2.biz.draw.entity;

import java.util.HashMap;
import java.util.Map;

import com.yaltec.comon.core.entity.Entity;

/**
 * 单位退款
 */
public class UnitRefund extends Entity{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String bm;
	private String dwbm;
	private String dwmc;
	private String unitcode;
	private String unitname;
	private String ywbh;
	private String pzbh;
	private String zybm;
	private String zymc;
	private String ywrq;
	private String yhbh;
	private String yhmc;
	private String tkje;
	private String h013;
	private String w008;
	private String h001;

	private String ljje;// 累交金额
	private String lzje;// 累支金额

	public String getBm() {
		return bm;
	}

	public void setBm(String bm) {
		this.bm = bm;
	}

	public String getDwbm() {
		return dwbm;
	}

	public void setDwbm(String dwbm) {
		this.dwbm = dwbm;
	}

	public String getDwmc() {
		return dwmc;
	}

	public void setDwmc(String dwmc) {
		this.dwmc = dwmc;
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

	public String getYwbh() {
		return ywbh;
	}

	public void setYwbh(String ywbh) {
		this.ywbh = ywbh;
	}

	public String getPzbh() {
		return pzbh;
	}

	public void setPzbh(String pzbh) {
		this.pzbh = pzbh;
	}

	public String getZybm() {
		return zybm;
	}

	public void setZybm(String zybm) {
		this.zybm = zybm;
	}

	public String getZymc() {
		return zymc;
	}

	public void setZymc(String zymc) {
		this.zymc = zymc;
	}

	public String getYwrq() {
		return ywrq;
	}

	public void setYwrq(String ywrq) {
		this.ywrq = ywrq;
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

	public String getTkje() {
		return tkje;
	}

	public void setTkje(String tkje) {
		this.tkje = tkje;
	}

	public String getH013() {
		return h013;
	}

	public void setH013(String h013) {
		this.h013 = h013;
	}

	public String getW008() {
		return w008;
	}

	public void setW008(String w008) {
		this.w008 = w008;
	}

	public String getH001() {
		return h001;
	}

	public void setH001(String h001) {
		this.h001 = h001;
	}

	public String getLjje() {
		return ljje;
	}

	public void setLjje(String ljje) {
		this.ljje = ljje;
	}

	public String getLzje() {
		return lzje;
	}

	public void setLzje(String lzje) {
		this.lzje = lzje;
	}

	@Override
	public String toString() {
		return "UnitRefund [bm=" + bm + ", dwbm=" + dwbm + ", dwmc=" + dwmc
				+ ", h001=" + h001 + ", h013=" + h013 + ", ljje=" + ljje
				+ ", lzje=" + lzje + ", pzbh=" + pzbh + ", tkje=" + tkje
				+ ", unitcode=" + unitcode + ", unitname=" + unitname
				+ ", w008=" + w008 + ", yhbh=" + yhbh + ", yhmc=" + yhmc
				+ ", ywbh=" + ywbh + ", ywrq=" + ywrq + ", zybm=" + zybm
				+ ", zymc=" + zymc + "]";
	}
	
	/**
	 * 用map获取实体数据
	 * @return
	 */
	public Map<String, String> toMap(){
		Map<String, String> map =new HashMap<String, String>();
		map.put("bm", this.bm);
		map.put("dwbm", this.dwbm);
		map.put("dwmc", this.dwmc);
		map.put("h001", this.h001);
		map.put("h013", this.h013);
		map.put("ljje", this.ljje);
		map.put("lzje", this.lzje);
		map.put("pzbh", this.pzbh);
		map.put("tkje", this.tkje);
		map.put("unitcode", this.unitcode);
		map.put("unitname", this.unitname);
		map.put("w008", this.w008);
		map.put("yhbh", this.yhbh);
		map.put("yhmc", this.yhmc);
		map.put("ywbh", this.ywbh);
		map.put("ywrq", this.ywrq);
		map.put("zybm", this.zybm);
		map.put("zymc", this.zymc);
		return map;
	}

}

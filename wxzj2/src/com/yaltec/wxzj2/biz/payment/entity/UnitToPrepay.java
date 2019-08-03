package com.yaltec.wxzj2.biz.payment.entity;

import java.util.HashMap;
import java.util.Map;

import com.yaltec.comon.core.entity.Entity;
import com.yaltec.comon.utils.JsonUtil;

/**
 *<p>文件名称: UnitToPrepay.java</p>
 * <p>文件描述: </p>
 * <p>版权所有: 版权所有(C)2010</p>
 * <p>公   司: yaltec</p>
 * <p>内容摘要: 单位预交信息</p>
 * <p>其他说明: </p>
 * <p>完成日期：Jan 14, 2014</p>
 * <p>修改记录0：无</p>
 * @version 1.0
 * @author tangxunjian
 */
public class UnitToPrepay extends Entity {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	//编码
	private String bm;
	//单位编码
	private String dwbm;
	//单位名称
	private String dwmc;
	//归集中心
	private String unitcode;
	private String unitname;
	//业务编号
	private String ywbh;
	//凭证编号
	private String pzbh;
	//摘要编码
	private String zybm;
	private String zymc;
	//业务日期
	private String ywrq;
	//银行编码
	private String yhbh;
	//银行名称
	private String yhmc;
	//交款金额
	private String jkje;
	//票据号
	private String pjh;
	
	private String rq;
	private String jk;
	private String zq;
	private String ye;
	private String xqmc;
	
	
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
	public String getJkje() {
		return jkje;
	}
	public void setJkje(String jkje) {
		this.jkje = jkje;
	}
	public String getPjh() {
		return pjh;
	}
	public void setPjh(String pjh) {
		this.pjh = pjh;
	}
	public String getRq() {
		if(rq != null){
			if(rq.length()>=10)
				return rq.substring(0, 10);
		}
		return rq;
	}
	public void setRq(String rq) {
		this.rq = rq;
	}
	public String getJk() {
		return jk;
	}
	public void setJk(String jk) {
		this.jk = jk;
	}
	public String getZq() {
		return zq;
	}
	public void setZq(String zq) {
		this.zq = zq;
	}
	public String getYe() {
		return ye;
	}
	public void setYe(String ye) {
		this.ye = ye;
	}
	public String getXqmc() {
		return xqmc;
	}
	public void setXqmc(String xqmc) {
		this.xqmc = xqmc;
	}
	
	@Override
	public String toString() {
		return JsonUtil.toJson(this);
	}
	
	public Map<String, String> toMap(){
		Map<String, String> map=new HashMap<String, String>();
		map.put("bm", this.bm);
		map.put("dwbm", this.dwbm);
		map.put("dwmc", this.dwmc);
		map.put("unitcode", this.unitcode);
		map.put("unitname", this.unitname);
		map.put("ywbh", this.ywbh);
		map.put("pzbh", this.pzbh);
		map.put("zybm", this.zybm);
		map.put("zymc", this.zymc);
		map.put("ywrq", this.ywrq);
		map.put("yhbh", this.yhbh);
		map.put("yhmc", this.yhmc);
		map.put("jkje", this.jkje);
		map.put("pjh", this.pjh);
		map.put("rq", this.rq);
		map.put("jk", this.jk);
		map.put("zq", this.zq);
		map.put("ye", this.ye);
		map.put("xqmc", this.xqmc);
		return map;
	}
	
}

package com.yaltec.wxzj2.biz.payment.entity;

import java.util.HashMap;
import java.util.Map;

import com.yaltec.comon.core.entity.Entity;
/**
 * 批量交款
 * @ClassName: BatchPayment 
 * @author 重庆亚亮科技有限公司 txj 
 * @date 2016-8-26 上午11:26:00
 */
public class BatchPayment extends Entity {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private String tempCode;//保存到house_dwbs中的tempCode
	private String type;//交款方式
	private String kfgsbm;//开发公司编号
	private String kfgsmc;//开发公司名称
	private String xqbh;//小区编号
	private String xqmc;//小区名称
	private String lybh;//楼宇编号
	private String lymc;//楼宇名称
	private String yhbh;//银行编号
	private String yhmc;//银行名称
	private String ywrq;//业务日期
	private String w008;//业务编号
	private String zpje;//支票金额
	private String dwye;//单位余额
	private String ye;//余额
	private String mxze;//明细总额
	private String filename;//上传文件服务器名称	
	private String sheet;//xls文件中选中的工作表
	private String unitcode;//归集中心编码
	private String unitname;//归集中心名称
	public String getTempCode() {
		return tempCode;
	}
	public void setTempCode(String tempCode) {
		this.tempCode = tempCode;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
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
	public String getYwrq() {
		return ywrq;
	}
	public void setYwrq(String ywrq) {
		this.ywrq = ywrq;
	}
	public String getW008() {
		return w008;
	}
	public void setW008(String w008) {
		this.w008 = w008;
	}
	public String getZpje() {
		return zpje;
	}
	public void setZpje(String zpje) {
		this.zpje = zpje;
	}
	public String getDwye() {
		return dwye;
	}
	public void setDwye(String dwye) {
		this.dwye = dwye;
	}
	public String getYe() {
		return ye;
	}
	public void setYe(String ye) {
		this.ye = ye;
	}
	public String getMxze() {
		return mxze;
	}
	public void setMxze(String mxze) {
		this.mxze = mxze;
	}
	public String getFilename() {
		return filename;
	}
	public void setFilename(String filename) {
		this.filename = filename;
	}
	public String getSheet() {
		return sheet;
	}
	public void setSheet(String sheet) {
		this.sheet = sheet;
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
	@Override
	public String toString() {
		return "BatchPayment [dwye=" + dwye + ", filename=" + filename
				+ ", kfgsbm=" + kfgsbm + ", kfgsmc=" + kfgsmc + ", lybh="
				+ lybh + ", lymc=" + lymc + ", mxze=" + mxze + ", sheet="
				+ sheet + ", tempCode=" + tempCode + ", type=" + type
				+ ", unitcode=" + unitcode + ", unitname=" + unitname
				+ ", w008=" + w008 + ", xqbh=" + xqbh + ", xqmc=" + xqmc
				+ ", ye=" + ye + ", yhbh=" + yhbh + ", yhmc=" + yhmc
				+ ", ywrq=" + ywrq + ", zpje=" + zpje + "]";
	}
	
	public Map<String, String> toMap(){
		Map<String, String> map=new HashMap<String, String>();
		map.put("dwye", this.dwye);
		map.put("filename", this.filename);
		map.put("kfgsbm", this.kfgsbm);
		map.put("kfgsmc", this.kfgsmc);
		map.put("lybh", this.lybh);
		map.put("lymc", this.lymc);
		map.put("mxze", this.mxze);
		map.put("sheet", this.sheet);
		map.put("tempCode", this.tempCode);
		map.put("type", this.type);
		map.put("unitcode", this.unitcode);
		map.put("unitname", this.unitname);
		map.put("w008", this.w008);
		map.put("xqbh", this.xqbh);
		map.put("xqmc", this.xqmc);
		map.put("ye", this.ye);
		map.put("yhbh", this.yhbh);
		map.put("yhmc", this.yhmc);
		map.put("ywrq", this.ywrq);
		map.put("zpje", this.zpje);		
		return map;
	}
	
	
}



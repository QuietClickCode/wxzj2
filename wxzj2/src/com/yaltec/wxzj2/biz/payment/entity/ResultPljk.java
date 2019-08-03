package com.yaltec.wxzj2.biz.payment.entity;

import com.yaltec.comon.core.entity.Entity;

/**
 * 批量交款查询-返回数据实体
 * @ClassName: QueryBankJinZhang 
 * @author 重庆亚亮科技有限公司 txj 
 * @date 2016-8-10 下午03:08:51
 */
public class ResultPljk extends Entity{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	//小区名称
	private String xqmc;
	//楼宇名称
	private String lymc;
	//开发公司名称
	private String kfgsmc;
	//金额
	private String p008;
	//银行名称
	private String unitname;
	//交款日期
	private String p024;
	//业务编号
	private String p004;
	//凭证号码
	private String p005;
	//银行账号
	private String bankno;
	//银行
	private String unitcode;
	public String getXqmc() {
		return xqmc;
	}
	public void setXqmc(String xqmc) {
		this.xqmc = xqmc;
	}
	public String getLymc() {
		return lymc;
	}
	public void setLymc(String lymc) {
		this.lymc = lymc;
	}
	public String getKfgsmc() {
		return kfgsmc;
	}
	public void setKfgsmc(String kfgsmc) {
		this.kfgsmc = kfgsmc;
	}
	public String getP008() {
		return p008;
	}
	public void setP008(String p008) {
		this.p008 = p008;
	}
	public String getUnitname() {
		return unitname;
	}
	public void setUnitname(String unitname) {
		this.unitname = unitname;
	}
	public String getP024() {
		return p024;
	}
	public void setP024(String p024) {
		this.p024 = p024;
	}
	public String getP004() {
		return p004;
	}
	public void setP004(String p004) {
		this.p004 = p004;
	}
	public String getP005() {
		return p005;
	}
	public void setP005(String p005) {
		this.p005 = p005;
	}
	public String getBankno() {
		return bankno;
	}
	public void setBankno(String bankno) {
		this.bankno = bankno;
	}
	public String getUnitcode() {
		return unitcode;
	}
	public void setUnitcode(String unitcode) {
		this.unitcode = unitcode;
	}
	@Override
	public String toString() {
		return "QueryBankJinZhang [bankno=" + bankno + ", ksgsmc=" + kfgsmc
				+ ", lymc=" + lymc + ", p004=" + p004 + ", p005=" + p005
				+ ", p008=" + p008 + ", p024=" + p024 + ", unitcode="
				+ unitcode + ", unitname=" + unitname + ", xqmc=" + xqmc + "]";
	}

}

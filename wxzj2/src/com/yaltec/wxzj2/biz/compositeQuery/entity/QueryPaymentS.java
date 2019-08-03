package com.yaltec.wxzj2.biz.compositeQuery.entity;

import com.yaltec.comon.core.entity.Entity;

/**
 * <p>
 * ClassName: QueryPaymentS
 * </p>
 * <p>
 * Description: 汇缴清册实体
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author moqian
 * @date 2016-8-25 上午09:12:58
 */

public class QueryPaymentS extends Entity {
	
	/**
	 * 序列化版本标示.
	 */
	private static final long serialVersionUID = 1L;
	
	private String lymc; //楼宇名称
	private String cs; //层数
	private Double zjzmj; //建筑面积
	private String h002; //单元
	private String h003; //层
	private String h005; //房号
	private String h033; //户型
	private String h013; //业主姓名
	private String h016; //产权证号
	private Double h006; //建面
	private Double h007; //套面
	private Double h010; //购房总额
	private Double h030; //汇缴金额
	private String h018; //房屋类型
	private String h045; //房屋类别
	private String h012; //房屋性质
	private Double bl; //比例
	
	public String getLymc() {
		return lymc;
	}
	public void setLymc(String lymc) {
		this.lymc = lymc;
	}
	public String getCs() {
		return cs;
	}
	public void setCs(String cs) {
		this.cs = cs;
	}
	public Double getZjzmj() {
		return zjzmj;
	}
	public void setZjzmj(Double zjzmj) {
		this.zjzmj = zjzmj;
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
	public String getH033() {
		return h033;
	}
	public void setH033(String h033) {
		this.h033 = h033;
	}
	public String getH013() {
		return h013;
	}
	public void setH013(String h013) {
		this.h013 = h013;
	}
	public String getH016() {
		return h016;
	}
	public void setH016(String h016) {
		this.h016 = h016;
	}
	public Double getH006() {
		return h006;
	}
	public void setH006(Double h006) {
		this.h006 = h006;
	}
	public Double getH007() {
		return h007;
	}
	public void setH007(Double h007) {
		this.h007 = h007;
	}
	public Double getH010() {
		return h010;
	}
	public void setH010(Double h010) {
		this.h010 = h010;
	}
	public Double getH030() {
		return h030;
	}
	public void setH030(Double h030) {
		this.h030 = h030;
	}
	public String getH018() {
		return h018;
	}
	public void setH018(String h018) {
		this.h018 = h018;
	}
	public String getH045() {
		return h045;
	}
	public void setH045(String h045) {
		this.h045 = h045;
	}
	public String getH012() {
		return h012;
	}
	public void setH012(String h012) {
		this.h012 = h012;
	}
	public Double getBl() {
		return bl;
	}
	public void setBl(Double bl) {
		this.bl = bl;
	}
	
	@Override
	public String toString() {
		return "QueryPaymentS [bl=" + bl + ", cs=" + cs + ", h002=" + h002 + ", h003=" + h003 + ", h005=" + h005
				+ ", h006=" + h006 + ", h007=" + h007 + ", h010=" + h010 + ", h012=" + h012 + ", h013=" + h013
				+ ", h016=" + h016 + ", h018=" + h018 + ", h030=" + h030 + ", h033=" + h033 + ", h045=" + h045
				+ ", lymc=" + lymc + ", zjzmj=" + zjzmj + "]";
	}

}
